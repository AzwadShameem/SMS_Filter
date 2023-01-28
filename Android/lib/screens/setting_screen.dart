import "package:flutter/material.dart";
import 'package:spam_filter/models/filter_message.dart';
import '../components/settings_info.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "setting";
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  IconButton(
                      onPressed: () async {
                        FilterMessage.filterMessages(context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SettingsInfo()
                ]),
          ),
        ),
      ),
    );
  }
}
