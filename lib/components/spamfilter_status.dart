import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/models/filter_message.dart';
import 'package:spam_filter/provider/statusProvider.dart';

import '../constants.dart';
import '../models/contact.dart';
import '../provider/MessageProvider.dart';
import 'animated_circular_progress_indicator.dart';

class SpamFilterStatus extends StatefulWidget {
  const SpamFilterStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<SpamFilterStatus> createState() => _SpamFilterStatusState();
}

class _SpamFilterStatusState extends State<SpamFilterStatus> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.width * 0.08),
        const Text("Spam", style: TextStyle(fontFamily: 'Merriweather', fontSize: 20, color: Colors.grey)),
        const SizedBox(height: kDefaultPadding * 3 / 2),
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCircularProgressInicator(ratio: statusProvider.ratio),
            SizedBox(width: size.width * 0.08),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SpamStatusTile(title: "Total SMS", total: statusProvider.numPhoneNumbers),
                SpamStatusTile(title: "Safe SMS", total: statusProvider.whiteList),
                SpamStatusTile(title: "Spam SMS", total: statusProvider.blackList),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class SpamStatusTile extends StatelessWidget {
  final String title;
  final int total;
  // ignore: use_key_in_widget_constructors
  const SpamStatusTile({required this.title, required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: ksmallHeading.copyWith(
                color: Colors.grey,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.normal),
          ),
          Text("$total", style: ksmallHeading),
        ],
      ),
    );
  }
}
