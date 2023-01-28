import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  String _trainScore = "";
  String _testScore = "";
  String get trainScore => _trainScore;
  String get testScore => _testScore;

  String _currentScreen = "";
  String get currentScreen => _currentScreen;

  void updateTrainScore(score) {
    _trainScore = score;
    notifyListeners();
  }

  void updateTestScore(score) {
    _testScore = score;
    notifyListeners();
  }

  void updateCurrentScreen(screen) {
    _currentScreen = screen;
    notifyListeners();
  }
}
