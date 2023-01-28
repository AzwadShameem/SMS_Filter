import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class Contacts {
  static Future permission() async {
    if (await Permission.sms.request().isGranted) {
      if (await FlutterContacts.requestPermission()) {
        return true;
      } else {
        // request again
      }
    } else {
      return false;
    }
  }

  // Get all contactNumbers
  static Future<List<String>> contactsNumbers() async {
    List<String> contactNumbers = [];
    for (var contact in await FlutterContacts.getContacts(withProperties: true)) {
      contactNumbers.add(contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), ''));
    }
    return contactNumbers;
  }

  static Future<int> getNumMessages() async {
    int numMessages = 0;
    for (var message in (await const MethodChannel("Android").invokeMethod("loadMessages"))) {
      if (message[3] == "false") {
        numMessages++;
      }
    }
    return numMessages;
  }

  // Get latest 15 messages
  static Future<List<List<String>>> latestMessages(int maxCount) async {
    List<String> phoneNumbers = [], messages = [], date = [];
    for (var message in (await const MethodChannel("Android").invokeMethod("loadMessages")).reversed) {
      if (message[3] == "false" && !phoneNumbers.contains(message[0])) {
        phoneNumbers.add(message[0]);
        messages.add(message[1]);
        date.add(message[2]);
      }
      if (phoneNumbers.length == maxCount) {
        return [phoneNumbers, messages, date];
      }
    }
    return [phoneNumbers, messages, date];
  }

  static Future<HashMap<String, double>> getWhiteList() async {
    HashMap<String, double> whiteList = HashMap<String, double>.from(await const MethodChannel('Android').invokeMethod('getMap', 'whiteList'));
    if (await const MethodChannel("Android").invokeMethod("getSettings", ["whiteList-contacts", "true"]) == "true") {
      // Automatically updating whitelist when retrieving whiteList
      for (var contact in await FlutterContacts.getContacts(withProperties: true)) {
        String contactNumber = contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), '');
        if (!(await getBlackList()).containsKey(contactNumber)) {
          if (!whiteList.keys.contains(contactNumber)) {
              await const MethodChannel("Android").invokeMethod("setMap", ["whiteList", contactNumber, 0.0]);
            }
        }
      }
    }
    return HashMap<String, double>.from(await const MethodChannel('Android').invokeMethod('getMap', 'whiteList'));;
  }

  static Future<HashMap<String, double>> getBlackList() async {
    HashMap<String, double> blackList = HashMap<String, double>.from(await const MethodChannel('Android').invokeMethod('getMap', 'blackList'));
    if (await const MethodChannel("Android").invokeMethod("getSettings", ["blackList-blocked", "true"]) == "true") {
      for (var phoneNumber in await const MethodChannel("Android").invokeMethod("getBlockedNumbers")) {
        if (!blackList.containsKey(phoneNumber)) {
          await const MethodChannel("Android").invokeMethod("setMap", ["blackList", phoneNumber, 100.0]);
        }
      }
    }
    return HashMap<String, double>.from(await const MethodChannel('Android').invokeMethod('getMap', 'blackList'));;
  }
}
