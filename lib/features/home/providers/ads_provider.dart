import 'package:ecommerce_major_project/models/ads.dart';
import 'package:flutter/material.dart';

class AdsProvider extends ChangeNotifier {
  List<Advertisement> _ads = [];

  List<Advertisement> get ads => _ads;

  void setAds(List<dynamic> ads) {
    List<Advertisement> myAds = [];
    for (var item in ads) {
      Advertisement ad = Advertisement.fromMap(item);
      myAds.add(ad);
    }
    _ads = List.from(myAds);
    notifyListeners();
  }
}
