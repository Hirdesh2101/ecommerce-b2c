import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  List<String>? suggestionList = [];

  List<String>? get getSuggetions => suggestionList;

  void addListToSuggestions(List<String> item) {
    suggestionList = List.from(item);
    notifyListeners();
  }

  // void addToSuggestions(String item) {
  //   suggestionList!.add(item);
  //   notifyListeners();
  // }

  // void removeFromSuggestions(String item) {
  //   suggestionList!.removeWhere((elem) => elem == item);
  //   notifyListeners();
  // }
}
