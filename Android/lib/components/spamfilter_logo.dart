import 'package:flutter/material.dart';

import '../constants.dart';

class SpamFilterLogo extends StatelessWidget {
  const SpamFilterLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //   const Icon(
        //   FeatherIcons.alertCircle,
        //   color: kSecondaryColor,
        // ),

        RichText(
          text: TextSpan(
              style: const TextStyle(
                  fontFamily: "PassionOne",
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  fontStyle: FontStyle.italic),
              children: [
                const TextSpan(
                  text: "Spam",
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                ),
                const TextSpan(
                  text: "Fi",
                  style: TextStyle(color: kPrimaryColor),
                ),
                TextSpan(
                    text: "lt",
                    style: TextStyle(
                      color: kPrimaryColor.withOpacity(0.84),
                    )),
                TextSpan(
                    text: "er",
                    style: TextStyle(
                      color: kPrimaryColor.withOpacity(0.74),
                    ),),
              ]),
        ),
      ],
    );
  }
}
