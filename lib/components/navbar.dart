import 'package:feather_icons/feather_icons.dart';
import "package:flutter/material.dart";
import 'package:spam_filter/components/spamfilter_logo.dart';
import 'package:spam_filter/screens/setting_screen.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const SpamFilterLogo(),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SettingScreen.id);
            },
            icon: const Icon(
              FeatherIcons.settings,
              color: Colors.black,
            ))
      ],
    );
  }
}
