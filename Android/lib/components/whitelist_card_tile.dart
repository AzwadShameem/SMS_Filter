// ignore_for_file: avoid_unnecessary_containers

import 'dart:collection';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../provider/MessageProvider.dart';

class WhitelistcardTile extends StatefulWidget {
  final dynamic number;
  final double prediction;
  const WhitelistcardTile(
      {super.key, required this.number, required this.prediction});

  @override
  State<WhitelistcardTile> createState() => _WhitelistcardTileState();
}

class _WhitelistcardTileState extends State<WhitelistcardTile> {
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
      await const MethodChannel("Android").invokeMethod("removeMap", ["whiteList", widget.number]);
      await const MethodChannel("Android").invokeMethod("setMap", ["blackList", widget.number, 100.0]);
      messageProvider.updateBlackList(await Contacts.getBlackList());
      messageProvider.updateWhiteList(await Contacts.getWhiteList());
    } else {
      await const MethodChannel("Android").invokeMethod("removeMap", ["whiteList", widget.number]);
      messageProvider.updateWhiteList(await Contacts.getWhiteList());
    }
  }

  Future<void> updateLogic(String statement) async {
    if (await const MethodChannel("Android").invokeMethod("getSettings", ["whiteList-contacts", "true"]) == "true") {
      if ((await Contacts.contactsNumbers()).contains(widget.number)) {
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const CircularProgressIndicator(
              color: Colors.teal,
            ))
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color:
                        Colors.blue.withOpacity(1 - (widget.prediction / 100)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 50,
                  color: const Color(0xfff4f4f4),
                  child: Text(
                    "${widget.number}",
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 25,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  child: IconButton(
                    onPressed: () {
                      updateLogic("both");
                    },
                    icon: const Icon(
                      FeatherIcons.refreshCcw,
                      color: Colors.teal,
                    )
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: ()  {
                      updateLogic("whiteList");
                    },
                    icon: const Icon(
                      FeatherIcons.xCircle,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
