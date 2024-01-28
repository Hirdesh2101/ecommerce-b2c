import 'package:ecommerce_major_project/models/category.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _category = [];
  int _categorytab = 0;

  int get tab => _categorytab;

  List<Category> get category => _category;

  void setCategories(List<dynamic> category) {
    List<Category> mycategory = [];
    for (var item in category) {
      Category cat = Category.fromMap(item);
      mycategory.add(cat);
    }
    _category = List.from(mycategory);
    notifyListeners();
  }
  void setTab(int tab) {
    _categorytab = tab;
    notifyListeners();
  }
}
