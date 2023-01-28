import 'dart:collection';
import 'package:telephony/telephony.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/MessageProvider.dart';
import '../provider/statusProvider.dart';
import 'contact.dart';

class FilterMessage {
  // Filtering Messages with Model
  static Future filterMessages(context) async {
    List safeMessages = [], spamMessages = [];

    // Predict on latest 25 messages
    List<List<String>> latestMessages = await Contacts.latestMessages(25);
    List<String> phoneNumbers = latestMessages[0],
        messages = latestMessages[1],
        date = latestMessages[2];
    List<dynamic> predictions = await const MethodChannel("Android")
        .invokeMethod("prediction", messages);

    // Ensures numbers are protected
    HashMap<String, double> whiteList = await Contacts.getWhiteList();

    // Add predicted messages to UI and cache
    for (int i = 0; i < phoneNumbers.length; i++) {
      if (whiteList.keys.contains(phoneNumbers[i])) {
        // If message's phone number is whiteListed then ONLY update prediction value
        await const MethodChannel("Android").invokeMethod(
            "setMap", ["whiteList", phoneNumbers[i], predictions[i]]);
      } else if (predictions[i] < double.parse(await const MethodChannel("Android").invokeMethod("getSettings", ["qualifier", "50"]))) {
        // Put all messages predicted as non spam into safe messages category
        safeMessages.add({
          "number": phoneNumbers[i],
          "message": messages[i],
          "time": DateFormat.jm().format(DateTime.parse(
              DateTime.fromMillisecondsSinceEpoch(int.parse(date[i]))
                  .toString()))
        });
      } else {
        // Put all messages predicted as spam in spam messages category + update blacklist
        spamMessages.add({
          "number": phoneNumbers[i],
          "message": messages[i],
          "time": DateFormat.jm().format(DateTime.parse(
              DateTime.fromMillisecondsSinceEpoch(int.parse(date[i]))
                  .toString()))
        });
        await const MethodChannel("Android").invokeMethod(
            "setMap", ["blackList", phoneNumbers[i], predictions[i]]);
      }
    }

    // Updates the UI with spam or not spam sms
    var messageProvider = Provider.of<MessageProvider>(context, listen: false);
    messageProvider.updateSafemessages(safeMessages);
    messageProvider.updateSpamMessages(spamMessages);

    // Update Ratio UI
    int numPhoneNumbers = await Contacts.getNumMessages();
    int safeLength = safeMessages.length;
    int spamLength = spamMessages.length;
    double ratio = 0;
    if (safeLength != 0 || spamLength != 0) {
      ratio = spamLength/(safeLength+spamLength);
    }
    StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
    statusProvider.updateAll(numPhoneNumbers, safeLength, spamLength, ratio);
  }

  // Rerun when receiving new sms
  static Future onIncomingSMS(context) async {
    Telephony.instance.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          Future.delayed(const Duration(milliseconds: 750), () {
            filterMessages(context);
          });
        }, listenInBackground: false
    );
  }
}
