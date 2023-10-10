import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  int filterNumber = 0;

  int get getFilterNumber => filterNumber;

  void setFilterNumber(int filterNo) {
    filterNumber = filterNo;
    notifyListeners();
  }
}
