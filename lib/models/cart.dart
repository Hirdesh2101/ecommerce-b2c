// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ecommerce_major_project/models/product.dart';

class Cart {
  final Product product;
  final int quantity;
  final String color;
  final String size;

  Cart({
    required this.product,
    required this.quantity,
    required this.color,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product,
      'quantity': quantity,
      'color': color,
      'size': size,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      product: Product.fromJson(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      color: map['color'] as String,
      size: map['size'] as String,
     
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);
}
