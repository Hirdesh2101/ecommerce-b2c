import 'package:flutter/material.dart';
import '/models/user.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  User _user = User(
    id: '',
    name: '',
    email: '',
    address: '',
    type: '',
    token: '',
    imageUrl: '',
    uid: '',
    cart: [],
    wishList: [],
    searchHistory: [],
    returnList: [],
  );

  User get user => _user;
  bool get isLoading => _isLoading;

  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  // void addToHistory(String searchQuery) {
  //   _user.searchHistory!.add(searchQuery.trim());
  //   notifyListeners();
  // }
}
