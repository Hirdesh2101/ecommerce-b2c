import 'package:flutter/material.dart';

class TabProvider extends ChangeNotifier {
  int _tab = 0;

  int get tab => _tab;

  void setTab(int tab) {
    _tab = tab;
    notifyListeners();
  }
}
