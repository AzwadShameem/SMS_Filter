// ignore_for_file: file_names

import 'dart:collection';

import 'package:flutter/cupertino.dart';

class MessageProvider with ChangeNotifier {
  bool _homepageLoaded = false;
  List _spamMessages = [];
  List _safeMessages = [];
  HashMap _blackList = HashMap(), _whiteList = HashMap();
  bool get homepageLoaded => _homepageLoaded;
  HashMap get whiteList => _whiteList;
  HashMap get blackList => _blackList;
  List get spamMessages => _spamMessages;
  List get safeMessages => _safeMessages;

  void updateSpamMessages(messages) {
    _spamMessages = messages;
    notifyListeners();
  }

  void updateSafemessages(messages) {
    _safeMessages = messages;
    notifyListeners();
  }

  void updateBlackList(blackContacts) {
    _blackList = blackContacts;
    notifyListeners();
  }

  void updateWhiteList(whiteContacts) {
    _whiteList = (whiteContacts);
    notifyListeners();
  }

  void updateHomePageLoaded() {
    _homepageLoaded = true;
  }
}
