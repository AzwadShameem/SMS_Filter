// ignore_for_file: avoid_print, prefer_const_constructors, unused_local_variable, use_build_context_synchronously
import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import "package:flutter/material.dart";
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/components/backlist_card_tile.dart';
import 'package:spam_filter/components/navbar.dart';
import 'package:spam_filter/components/whitelist_card_tile.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/models/contact.dart';
import 'package:spam_filter/provider/MessageProvider.dart';
import 'package:spam_filter/screens/inbox_screen.dart';
import 'package:spam_filter/screens/search_screen.dart';
import 'home_page.dart';

class BlackWhiteListScreen extends StatefulWidget {
  static const String id = "black-white-list";
  const BlackWhiteListScreen({Key? key}) : super(key: key);

  @override
  State<BlackWhiteListScreen> createState() => _BlackWhiteListScreenState();
}

class _BlackWhiteListScreenState extends State<BlackWhiteListScreen> {
  bool? permissionGranted;
  bool isActive = true;
  bool isLoading = true;
  int _seletedIndex = 2;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        loadData();
        isLoading = false;
      });
    });
  }

  // Loads blacklist & whitelist and updates data to UI
  Future loadData() async {
    MessageProvider messageProvider = Provider.of(context, listen: false);
    messageProvider.updateBlackList(await Contacts.getBlackList());
    messageProvider.updateWhiteList(await Contacts.getWhiteList());
  }

  Widget buildButtomSheet(BuildContext context) {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(color: kPrimaryColor),
    )
        : Container(
      color: const Color(0xff757575),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Add Number",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Merriweather',
                    color: Colors.teal),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xfff5f5f5),
                ),
                child: TextFormField(
                  autofocus: true,
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: kTextField.copyWith(
                      labelText: "Phone Number", suffixText: "required"),
                  onFieldSubmitted: (_) async {
                    if (isActive) {
                      await const MethodChannel("Android").invokeMethod(
                          "setMap",
                          ["whiteList", _phoneController.text, 0.0]);
                    } else {
                      await const MethodChannel("Android").invokeMethod(
                          "setMap",
                          ["blackList", _phoneController.text, 100.0]);
                    }
                    _phoneController.clear();
                    loadData();
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isActive) {
                    await const MethodChannel("Android").invokeMethod(
                        "setMap",
                        ["whiteList", _phoneController.text, 0.0]);
                  } else {
                    await const MethodChannel("Android").invokeMethod(
                        "setMap",
                        ["blackList", _phoneController.text, 100.0]);
                  }
                  _phoneController.clear();
                  loadData();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 13),
                  child: const Text(
                    "Add Number",
                    style:
                    TextStyle(fontSize: 20, fontFamily: "Montserrat"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MessageProvider messageProvider =
    Provider.of<MessageProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Navbar(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(maxWidth: size.width * 0.8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isActive = true;
                              });
                            },
                            onHover: (val) {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: !isActive
                                      ? Colors.white
                                      : Color(0xffFB7F6B),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Whitelist",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                    color: !isActive
                                        ? Colors.grey
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isActive = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: !isActive
                                    ? Color(0xffFB7F6B)
                                    : Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Text("Blacklist",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                      color: !isActive
                                          ? Colors.white
                                          : Colors.grey)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: List.generate(
                    isActive
                        ? messageProvider.whiteList.keys.length
                        : messageProvider.blackList.keys.length,
                        (index) => isActive
                        ? WhitelistcardTile(
                      number:
                      messageProvider.whiteList.keys.toList()[index],
                      prediction: messageProvider.whiteList[
                      messageProvider.whiteList.keys.toList()[index]],
                    )
                        : BlacklistCardTile(
                        number:
                        messageProvider.blackList.keys.toList()[index],
                        prediction: messageProvider.blackList[
                        messageProvider.blackList.keys
                            .toList()[index]]),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(context: context, builder: buildButtomSheet);
          },
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav(
                rippleColor: Colors.teal[300]!,
                hoverColor: Colors.   teal[100]!,
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
                    text: 'Home',
                    onPressed: () {
                      Navigator.pushNamed(context, InboxScreen.id);
                    },
                  ),
                  GButton(
                    icon: FeatherIcons.info,
                    text: 'Details',
                    onPressed: () {
                      Navigator.pushNamed(context, HomePage.id);
                    },
                  ),
                  GButton(
                    icon: FeatherIcons.crosshair,
                    text: 'Safe',
                    onPressed: () {},
                  ),
                  GButton(
                    icon: FeatherIcons.search,
                    text: 'Search',
                    onPressed: () {
                      Navigator.pushNamed(context, SearchScreen.id);
                    },
                  ),
                ],
                selectedIndex: _seletedIndex,
                onTabChange: (index) {
                  setState(() {
                    _seletedIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
