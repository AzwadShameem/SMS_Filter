// ignore_for_file: use_key_in_widget_constructors

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:spam_filter/components/spam_card_title.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/provider/MessageProvider.dart';

import '../components/message_card_tile.dart';

class MessagesSection extends StatefulWidget {
  @override
  State<MessagesSection> createState() => _MessagesSectionState();
}

class _MessagesSectionState extends State<MessagesSection> {
  bool isActive = true;
  bool isChatActive = true;
  bool isSpamActive = false;
  bool isSpam = false;
  String prediction = "";
  @override
  Widget build(BuildContext context) {
    var messageProvder = Provider.of<MessageProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          "Messages",
          style: ksmallHeading.copyWith(color: Colors.grey),
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 236, 232, 232).withOpacity(0.75),
              borderRadius: BorderRadius.circular(100)),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    isActive = true;
                    isChatActive = true;
                    isSpamActive = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: isActive
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white)
                      : const BoxDecoration(),
                  alignment: Alignment.center,
                  child: Text(
                    "Safe",
                    style: TextStyle(
                        fontSize: 22,
                        color: isActive ? kPrimaryColor : Colors.grey,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isActive = false;
                      isChatActive = false;
                      isSpamActive = true;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.center,
                    decoration: !isActive
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white)
                        : const BoxDecoration(),
                    child: Text(
                      "Spam",
                      style: TextStyle(
                          fontSize: 22,
                          color: !isActive ? kSecondaryColor : Colors.grey,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: kDefaultPadding * 2 / 3,
        ),
        isChatActive
            ? Column(
                children: [
                  ...List.generate(
                    messageProvder.safeMessages.length,
                    (index) => GestureDetector(
                      onTap: () {
                        String message =
                            messageProvder.safeMessages[index]["message"];
                        String number =
                            messageProvder.safeMessages[index]["number"];
                        _dialogBuilder(context, message, number, false);
                      },
                      child: MessageTitleCard(
                        name: messageProvder.safeMessages[index]["number"],
                        message: messageProvder.safeMessages[index]["message"],
                        time: messageProvder.safeMessages[index]["time"],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: List.generate(
                    messageProvder.spamMessages.length,
                    (index) => GestureDetector(
                          onTap: () {
                            String message =
                                messageProvder.spamMessages[index]["message"];
                            String number =
                                messageProvder.spamMessages[index]["number"];
                            _dialogBuilder(context, message, number, true);
                          },
                          child: SpamMessageCard(
                            message: messageProvder.spamMessages[index]
                                ["message"],
                            name: messageProvder.spamMessages[index]["number"]
                                .toString(),
                            time: messageProvder.spamMessages[index]["time"],
                          ),
                        )),
              )
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context, message, number, isSpam) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Center(child: Text(number)),
            content: Text(message),
            actions: <Widget>[
              Row(
                children: [
                  prediction != ""
                      ? Container()
                      : Checkbox(
                          activeColor: Colors.redAccent,
                          value: isSpam,
                          onChanged: (val) {
                            setState(() {
                              isSpam = !isSpam;
                            });
                          }),
                  prediction != ""
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(prediction))
                      : const Text("Is Spam"),
                  const Spacer(),
                  OutlinedButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Train'),
                    onPressed: () async {
                      prediction = await const MethodChannel("Android")
                          .invokeMethod("train", [message, isSpam ? 1 : 0]);
                      setState(() {
                        prediction = prediction;
                      });
                    },
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    prediction = "";
                    isSpam = false;
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }
}
