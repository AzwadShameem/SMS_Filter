import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/components/navbar.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/provider/SearchProvider.dart';
import 'package:spam_filter/screens/black_white_list_screen.dart';
import 'package:spam_filter/screens/home_page.dart';
import 'package:spam_filter/screens/inbox_screen.dart';

class SearchScreen extends StatefulWidget {
  static const id = "searching";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isActive = false;
  int _selectedIndex = 3;
  bool isSpam = false;
  late String trainScore = "", testScore = "";
  final TextEditingController _controller = TextEditingController();

  // Model prediction function call -> Android -> Python
  Future<String> prediction(String sms) async {
    return "${(await const MethodChannel("Android").invokeMethod("prediction", [sms]))[0].toString().substring(0, 5)}%";
  }

  // Model training function call -> Android -> Python
  Future<String> train(String sms, int label) async {
    return await const MethodChannel("Android").invokeMethod("train", [sms, label]);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SearchProvider searchProvider =
        Provider.of<SearchProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        // ignore: prefer_const_literals_to_create_immutables
        child: SingleChildScrollView(
          child: Column(children: [
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Navbar(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Test your own custom spam messages?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: kPrimaryColor,
                  fontFamily: "Merriweather",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
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
                          isActive = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: !isActive ? Color(0xffFB7F6B) : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text("Test",
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
                            color: !isActive ? Colors.white : Color(0xffFB7F6B),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Train",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color:
                                      !isActive ? Colors.grey : Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 15,
            ),
            Container(
              width: size.width * 0.9,
              child: TextField(
                maxLines: 15,
                minLines: 10,
                controller: _controller,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    hintText: "Type your message here...",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: kPrimaryColor,
                          width: 2,
                        ))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            isActive
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: isSpam,
                              activeColor: Colors.redAccent,
                              onChanged: ((value) {
                                setState(() {
                                  isSpam = !isSpam;
                                });
                              })),
                          const Text(
                            "Is Spam",
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Quicksand'),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                SearchProvider provider = Provider.of(context, listen: false);
                if (isActive) {
                  trainScore = await train(_controller.text, isSpam ? 1 : 0);
                  provider.updateTrainScore(trainScore);
                } else {
                  provider.updateTestScore(await prediction(_controller.text));
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Merriweather",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Result",
                    style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 20,
                        color: Colors.grey),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              isActive
                  ? searchProvider.trainScore == ""
                      ? ""
                      : searchProvider.trainScore
                  : searchProvider.testScore == ""
                      ? ""
                      : searchProvider.testScore,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 50,
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                // ignore: prefer_const_constructors
                GButton(
                  icon: FeatherIcons.home,
                  text: 'Inbox',
                  onPressed: () {
                    Navigator.pushNamed(context, InboxScreen.id);
                  },
                ),
                GButton(
                  icon: FeatherIcons.info,
                  text: 'Info',
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
                          builder: (context) => const BlackWhiteListScreen()),
                    );
                  },
                ),
                GButton(
                  icon: FeatherIcons.search,
                  text: 'Test',
                  onPressed: () {},
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
      ),
    );
  }
}
