import 'package:flutter/cupertino.dart';

class SettingProvider with ChangeNotifier {
  bool _notification = false;
  bool _autoBlock = false;
  bool _deleteSpamMessages = false;
  bool _whiteListContact = false;
  bool _blackListMessages = false;
  bool _displaySplashScreen = true;
  double _qualifier = 0.5;

  bool get notification => _notification;
  bool get autoBlock => _autoBlock;
  bool get deleteSpamMessages => _deleteSpamMessages;
  bool get whiteListContact => _whiteListContact;
  bool get blackListMessages => _blackListMessages;
  bool get displaySplashScreen => _displaySplashScreen;
  double get qualifier => _qualifier;

  void updateWhiteListContact(state) {
    _whiteListContact = state;
    notifyListeners();
  }

  void updateNotification(state) {
    _notification = state;
    notifyListeners();
  }

  void updateAutoBlock(state) {
    _autoBlock = state;
    notifyListeners();
  }

  void updateDeleteSpamMessages(state) {
    _deleteSpamMessages = state;
    notifyListeners();
  }

  void updateBlackListMessages(state) {
    _blackListMessages = state;
    notifyListeners();
  }

  void updateQualifier(num) {
    _qualifier = num;
    notifyListeners();
  }

  void updateSplashScreen() {
    _displaySplashScreen = false;
    notifyListeners();
  }
}
