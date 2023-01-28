import 'package:flutter/cupertino.dart';

class StatusProvider with ChangeNotifier {
  int _whiteList = 0, _blackList = 0, _totalList = 0, _numPhoneNumbers = 0;
  double _ratio = 0.0;
  int get whiteList => _whiteList;
  int get blackList => _blackList;
  int get totalList => _totalList;
  double get ratio => _ratio;
  int get numPhoneNumbers => _numPhoneNumbers;

  void updateAll(phoneNum, whiteNum, blackNum, ratio) {
    _whiteList = whiteNum;
    _blackList = blackNum;
    _totalList = whiteNum + blackNum;
    _numPhoneNumbers = phoneNum;
    _ratio = ratio;
    notifyListeners();
  }
}
