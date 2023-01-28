import "package:flutter/material.dart";

import '../constants.dart';

class MessageTitleCard extends StatelessWidget {
  final String name, message, time;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  MessageTitleCard({
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
        // Expanded(
        //   child: SizedBox(
        //     height: 80,
        //     width: 80,
        //     child: TextAvatar(
        //       numberLetters: 2,
        //       shape: Shape.Rectangle,
        //       text: name,
        //     ),
        //   ),
        // ),
        const SizedBox(
          width: kDefaultPadding,
        ),
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
                style: const TextStyle(fontSize: 18),
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