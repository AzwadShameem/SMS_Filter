import 'package:flutter/foundation.dart';

class InboxMessageProvider with ChangeNotifier {
  List _contactList = [];
  Map<String, List> _contactMessages = {};

  List get contactList => _contactList;
  Map get contactMessages => _contactMessages;

  void updateContactMessages(messages) {
    _contactMessages = messages;
    notifyListeners();
  }

  void updateContactList(contacts) {
    _contactList = contacts;
    notifyListeners();
  }
}
