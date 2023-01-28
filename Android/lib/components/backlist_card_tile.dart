// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_cast

import 'dart:collection';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/provider/MessageProvider.dart';

import '../models/contact.dart';

class BlacklistCardTile extends StatefulWidget {
  final String number;
  final double prediction;
  const BlacklistCardTile(
      {super.key, required this.number, required this.prediction});
  @override
  State<BlacklistCardTile> createState() => _BlacklistCardTileState();
}

class _BlacklistCardTileState extends State<BlacklistCardTile> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> updateData(String statement) async {
    MessageProvider messageProvider = Provider.of<MessageProvider>(context, listen: false);
    if (statement == "both") {
      await const MethodChannel("Android").invokeMethod("removeMap", ["blackList", widget.number]);
      await const MethodChannel("Android").invokeMethod("setMap", ["whiteList", widget.number, 0.0]);
      messageProvider.updateBlackList(await Contacts.getBlackList());
      messageProvider.updateWhiteList(await Contacts.getWhiteList());
    } else {
      await const MethodChannel("Android").invokeMethod("removeMap", ["blackList", widget.number]);
      messageProvider.updateBlackList(await Contacts.getBlackList());
    }
  }

  Future<void> updateLogic(String statement) async {
    if (await const MethodChannel("Android").invokeMethod("getSettings", ["blackList-blocked", "true"]) == "true") {
      if ((await const MethodChannel("Android").invokeMethod("getBlockedNumbers")).toList().contains(widget.number)) {
        // send message to turn off blacklist blocked numbers to remove from blacklist
      } else {
        updateData(statement);
      }
    } else {
      updateData(statement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CircularProgressIndicator(
              color: Color(0xffFB7F6B),
            ))
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color:
                        Colors.redAccent.withOpacity(widget.prediction / 100),
                  ),
                ),
                Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  color: Color(0xfff4f4f4),
                  child: Text(
                    widget.number,
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 25,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: IconButton(
                    onPressed: () {
                      updateLogic("both");
                    },
                    icon: Icon(
                      FeatherIcons.refreshCcw,
                      color: Colors.grey,
                    )),
                ),
                Container(
                  child: IconButton(
                      onPressed: () {
                        updateLogic("blackList");
                      },
                      icon: Icon(
                        FeatherIcons.xCircle,
                        color: Colors.redAccent,
                      )),
                ),
              ],
            ),
          );
  }
}
