import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/provider/InboxMessageProvider.dart';

class InboxMessagesScreen extends StatelessWidget {
  static const String id = "inbox messages screen";
  Map inboxMessages;
  InboxMessagesScreen({super.key, required this.inboxMessages});
  final TextEditingController _messageController = TextEditingController();

  void loadMessages(InboxMessageProvider inboxMessageProvider) async {
    Map<String, List> newMessages = {};
    for (var message in await const MethodChannel("Android").invokeMethod("loadMessages")) {
      if (!newMessages.keys.contains(message[0])) {
        newMessages[message[0]] = [{
          "number": message[0],
          "message": message[1],
          "date": DateTime.fromMillisecondsSinceEpoch(int.parse(message[2])).toString(),
          "time": DateFormat.jm().format(DateTime.parse(DateTime.fromMillisecondsSinceEpoch(int.parse(message[2])).toString())),
          "isRead": false,
          "isMe": message[3] == "true",
          "fullDate": int.parse(message[2])
        }];
      } else {
        newMessages[message[0]]!.add({
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
    inboxMessageProvider.updateContactMessages(newMessages);
    inboxMessageProvider.updateContactList(newMessages.keys.toList());
  }

  Future sendSMS(InboxMessageProvider inboxMessageProvider, String phoneNumber, TextEditingController messageController) async {
    await const MethodChannel("Android").invokeMethod("sendMessage", [phoneNumber, messageController.text]);
    await const MethodChannel("Android").invokeMethod("saveMessage", [phoneNumber, messageController.text, DateTime.now().millisecondsSinceEpoch.toString(), "true"]);
    messageController.clear();
    loadMessages(inboxMessageProvider);
  }

  @override
  Widget build(BuildContext context) {
    InboxMessageProvider inboxMessageProvider = Provider.of<InboxMessageProvider>(context, listen: true);
    List messages = inboxMessageProvider.contactMessages[inboxMessages['number']];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: size.width * 0.24),
                  Text(inboxMessages['number'], style: kdefaultNumberStyle),
                ],
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      ...List.generate(messages.length, (index) {
                        String message = messages[index]['message'];
                        bool isMe = messages[index]["isMe"];
                        return Align(
                          alignment:
                              isMe ? Alignment.topRight : Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isMe ? Colors.teal : Colors.blueGrey),
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  hintText: "Type your message here...",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 2)),
                  suffixIcon: IconButton(
                    icon: const Icon(FeatherIcons.send),
                    onPressed: () {
                      sendSMS(inboxMessageProvider, inboxMessages['number'], _messageController);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
