import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants.dart';

class InboxMessageTile extends StatelessWidget {
  final String message, date, number, time;
  final bool isRead;

  const InboxMessageTile(
      {Key? key,
      required this.message,
      required this.date,
      required this.number,
      required this.time,
      required this.isRead})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(math.Random().nextInt(250),
                  math.Random().nextInt(250), math.Random().nextInt(250), 1),
            ),
          ),
          SizedBox(
            width: size.width * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: ksmallHeading.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Montserrat"),
                ),
                Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: isRead
                          ? Colors.black.withOpacity(0.65)
                          : Colors.black),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(date.split(" ")[0]), Text(time)],
          )
        ],
      ),
    );
  }
}
