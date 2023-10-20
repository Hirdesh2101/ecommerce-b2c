import 'package:ecommerce_major_project/models/cart.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cart = [];
  num _sum = 0;

  List<Cart>? get getCart => _cart;
  num get getSum => _sum;

  void setCart(List<Cart> item) {
    _cart = List.from(item);
    _updateSum();
    notifyListeners();
  }

  void setCartFromDynamic(List<dynamic> items) {
    List<Cart> myCart = [];
    for (var item in items) {
      Cart cart = Cart.fromMap(item);
      myCart.add(cart);
    }
    _cart = List.from(myCart);
    _updateSum();
    notifyListeners();
  }
  void _updateSum() {
    num newSum = 0;
    for (var cartItem in _cart) {
      List<dynamic> variants = cartItem.product.varients;
      for (var variant in variants) {
        if (variant['color'] == cartItem.color) {
          newSum += cartItem.quantity * variant['price'];
        }
      }
    }
    _sum = newSum;
  }
}
