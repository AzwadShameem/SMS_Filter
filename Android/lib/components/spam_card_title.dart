import "package:flutter/material.dart";

import '../constants.dart';

class SpamMessageCard extends StatelessWidget {
  final String name, message, time;
  // ignore: use_key_in_widget_constructors
  const SpamMessageCard({
    required this.message,
    required this.name,
    required this.time,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 2, vertical: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 3))),
      height: 75,
      width: double.infinity,
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: ksmallHeading.copyWith(
                  fontSize: 18, color: Colors.black, fontFamily: "Quicksand"),
            ),
            SizedBox(
              width: size.width * 0.41,
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, color: kSecondaryColor),
              ),
            )
          ],
        ),
        const Spacer(),
        Text(
          time,
        )
      ]),
    );
  }
}