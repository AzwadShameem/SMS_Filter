// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, use_build_context_synchronously
import 'package:feather_icons/feather_icons.dart';
import "package:flutter/material.dart";
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/models/filter_message.dart';
import 'package:spam_filter/provider/MessageProvider.dart';
import 'package:spam_filter/screens/black_white_list_screen.dart';
import 'package:spam_filter/screens/search_screen.dart';
import '../components/navbar.dart';
import '../components/spamfilter_status.dart';
import '../models/contact.dart';
import '../section/messages_section.dart';
import 'inbox_screen.dart';

class HomePage extends StatefulWidget {
  static const String id = "HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    setState(() {
      filterMessages();
    });
  }

  // Filter the messages
  Future filterMessages() async {
    if (await Contacts.permission()) {
        FilterMessage.filterMessages(context);
        FilterMessage.onIncomingSMS(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool homepageState = Provider.of<MessageProvider>(context, listen: true).homepageLoaded;
    return Scaffold(
        body: SafeArea(
          // ignore: prefer_const_literals_to_create_immutables
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: const Navbar(),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SpamFilterStatus(),
                          MessagesSection(),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
        bottomNavigationBar: Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: GNav(
                rippleColor: Colors.teal[300]!,
                hoverColor: Colors.teal[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.teal[100]!,
                color: Colors.teal,
                // ignore: prefer_const_literals_to_create_immutables
                tabs: [
                  GButton(
                    icon: FeatherIcons.home,
                    text: "Inbox",
                    onPressed: () {
                      Navigator.pushNamed(context, InboxScreen.id);
                    },
                  ),
                  GButton(
                    icon: FeatherIcons.info,
                    text: 'Info',
                  ),
                  GButton(
                    icon: FeatherIcons.crosshair,
                    text: 'Track',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlackWhiteListScreen()),
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
                              builder: (context) => SearchScreen()));
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