import 'package:feather_icons/feather_icons.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/components/navbar.dart';
import 'package:spam_filter/provider/InboxMessageProvider.dart';
import 'package:spam_filter/provider/settingProvider.dart';
import 'package:spam_filter/screens/flash_screen.dart';
import 'package:spam_filter/screens/home_page.dart';
import 'package:spam_filter/screens/search_screen.dart';
import 'package:telephony/telephony.dart' as telephony;
import '../components/inbox_message_tile.dart';
import '../models/contact.dart';
import '../provider/MessageProvider.dart';
import 'black_white_list_screen.dart';
import 'inbox_messages_screen.dart';

class InboxScreen extends StatefulWidget {
  static const String id = "inbox-screen";
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  Map<String, List<dynamic>> inboxMessages = {};

  @override
  void initState() {
    super.initState();
    SettingProvider settingProvider = Provider.of(context, listen: false);
    if (settingProvider.displaySplashScreen) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          getPermission();
          settingProvider.updateSplashScreen();
        });
      });
    } else {
      setState(() {
        _isLoading = false;
        getPermission();
      });
    }
  }

  Future getPermission() async {
    if (await Contacts.permission()) {
      if (await firstLaunch()) {
        loadMessages();
        await const MethodChannel("Android").invokeMethod("getAssets");
        onIncomingSMS();
      }
    }
  }

  Future<bool> firstLaunch() async {
    if (await const MethodChannel("Android").invokeMethod("getSettings", ["firstLaunch", "true"]) == "true") {
      updateMessage(await SmsQuery().querySms(kinds: [SmsQueryKind.inbox]), false);
      updateMessage(await SmsQuery().querySms(kinds: [SmsQueryKind.sent]), true);
      for (var i in inboxMessages.keys) {
        inboxMessages[i]!.sort((a, b) => a["date"].compareTo(b["date"]));
      }
    }
    for (var messages in inboxMessages.values) {
      for (var message in messages) {
        await const MethodChannel("Android").invokeMethod("saveMessage", [message["number"], message["message"], (message["date"].millisecondsSinceEpoch).toString(), message["isMe"].toString()]);
      }
    }
    await const MethodChannel("Android").invokeMethod("setSettings", ["firstLaunch", "false"]);
    return true;
  }

  void updateMessage(messages, isMe) {
    for (var message in messages) {
      if (!inboxMessages.keys.contains(message.address)) {
        inboxMessages[message.address] = [{
          "number": message.sender,
          "message": message.body,
          "date": message.date,
          "time": DateFormat.jm().format(DateTime.parse(message.date.toString())),
          "isRead": message.isRead,
          "isMe": isMe}
        ];
      } else {
        inboxMessages[message.address]!.add({
          "number": message.sender,
          "message": message.body,
          "date": message.date,
          "time": DateFormat.jm().format(DateTime.parse(message.date.toString())),
          "isRead": message.isRead,
          "isMe": isMe
        });
      }
    }
  }

  Future loadMessages() async {
    inboxMessages = {};
    for (var message in await const MethodChannel("Android").invokeMethod("loadMessages")) {
      if (!inboxMessages.keys.contains(message[0])) {
        inboxMessages[message[0]] = [{
          "number": message[0],
          "message": message[1],
          "date": DateTime.fromMillisecondsSinceEpoch(int.parse(message[2])).toString(),
          "time": DateFormat.jm().format(DateTime.parse(DateTime.fromMillisecondsSinceEpoch(int.parse(message[2])).toString())),
          "isRead": false,
          "isMe": message[3] == "true",
          "fullDate": int.parse(message[2])
        }];
      } else {
        inboxMessages[message[0]]!.add({
          "number": message[0],
          "message": message[1],
          "date": DateTime.fromMillisecondsSinceEpoch(int.parse(message[2])).toString(),
          "time": DateFormat.jm().format(DateTime.parse(DateTime.fromMillisecondsSinceEpoch(int.parse(message[2])).toString())),
          "isRead": false,
          "isMe": message[3] == "true",
          "fullDate": int.parse(message[2])
        });
      }
    }
    InboxMessageProvider provider = Provider.of<InboxMessageProvider>(context, listen: false);
    provider.updateContactMessages(inboxMessages);
    provider.updateContactList(inboxMessages.keys.toList());
  }

  Future onIncomingSMS() async {
    telephony.Telephony.instance.listenIncomingSms(
        onNewMessage: (telephony.SmsMessage message) {
          Future.delayed(const Duration(milliseconds: 750), () {
            loadMessages();
          });
        }, listenInBackground: false
    );
  }

  @override
  Widget build(BuildContext context) {
    bool homepageState = Provider.of<MessageProvider>(context, listen: true).homepageLoaded;
    InboxMessageProvider inboxMessageProv = Provider.of<InboxMessageProvider>(context, listen: true);
    SettingProvider settingProvider = Provider.of(context, listen: true);
    return Scaffold(
        body: _isLoading && settingProvider.displaySplashScreen == true
            ? const FlashingScreen()
            : SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Navbar(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(inboxMessages.keys.length, (index) {
                                var inboxNumber = inboxMessages[inboxMessages.keys.toList()[index]]!.last;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(5),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return InboxMessagesScreen(inboxMessages: inboxNumber);
                                    })).then((value) => loadMessages());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InboxMessageTile(
                                      date: inboxNumber['date'].toString(),
                                      message: inboxNumber['message'],
                                      number: inboxMessageProv.contactList[index],
                                      time: inboxNumber['time'],
                                      isRead: inboxNumber['isRead'],
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: _isLoading && homepageState == false
            ? Container(height: 10)
            : Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(.1),
                    )
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: GNav(
                      rippleColor: Colors.teal[300]!,
                      hoverColor: Colors.teal[100]!,
                      gap: 8,
                      activeColor: Colors.black,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: Colors.teal[100]!,
                      color: Colors.teal,
                      // ignore: prefer_const_literals_to_create_immutables
                      tabs: [
                        const GButton(
                          icon: FeatherIcons.home,
                          text: 'Inbox',
                        ),
                        GButton(
                          icon: FeatherIcons.info,
                          text: "Info",
                          onPressed: () {
                            Navigator.pushNamed(context, HomePage.id);
                          },
                        ),
                        GButton(
                          icon: FeatherIcons.crosshair,
                          text: 'Track',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BlackWhiteListScreen()),
                            );
                          },
                        ),
                        GButton(
                          icon: FeatherIcons.search,
                          text: 'Test',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchScreen()));
                          },
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ));
  }
}