//use num if not sure between double and int
//ensure to mention proper type cast of the List

import 'package:ecommerce_major_project/models/rating.dart';

class Product {
  final String name;
  final String description;
  final List<dynamic> detailDescription;
  final Map<String, dynamic> warranty;
  final Map<String, dynamic> returnPolicy;
  final String brandName;
  final List<String> images;
  final List<dynamic> varients;
  final String category;
  final String? id;
  final List<Rating>? rating;
  final List<dynamic>? ratinguser;
  int totalQuantity;

  bool isWishlisted = false;

  Product({
    required this.name,
    required this.description,
    required this.brandName,
    required this.images,
    required this.returnPolicy,
    required this.category,
    required this.detailDescription,
    required this.warranty,
    required this.varients,
    required this.totalQuantity,
    this.id,
    this.rating,
    this.ratinguser,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'] ?? "",
        description = json['description'] ?? "",
        brandName = json['brandName'] ?? "",
        images = List<String>.from(json['images']),
        category = json['category'] ?? "",
        rating = json['ratings'] != null
            ? List<Rating>.from(
                json['ratings']?.map(
                  (x) => Rating.fromMap(x),
                ),
              )
            : null,
        varients = json['varients'] ?? [],
        warranty = json['warranty'] ?? {},
        returnPolicy = json['returnPolicy'] ?? {},
        totalQuantity = json['varients'] != null
            ? json['varients'].fold(
                0,
                (sum, varient) =>
                    sum +
                    varient['sizes'].fold(
                      0,
                      (sumSizes, size) => sumSizes + size['quantity'],
                    ),
              )
            : 0,
        detailDescription = json['detailDescription'] ?? [],
        ratinguser = json['ratinguser'] ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'brandName': brandName,
        'images': images,
        'category': category,
        'rating': rating,
        'ratinguser': ratinguser,
        'varients': varients,
        'detailDescription': detailDescription,
        'warranty': warranty,
        'returnPolicy': returnPolicy,
        'totalQuantity': totalQuantity,
      };
}
