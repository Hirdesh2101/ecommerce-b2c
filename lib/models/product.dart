//use num if not sure between double and int
//ensure to mention proper type cast of the List

import 'dart:convert';

import 'package:ecommerce_major_project/models/rating.dart';

class Product {
  final String name;
  final String description;
  final List<dynamic> detailDescription;
  final String warranty;
  final String brandName;
  final int quantity;
  final List<String> images;
  final List<dynamic> varients;
  final List<dynamic> sizeQuantities;
  final String category;
  final num price;
  final num markedprice;
  final String? id;
  final String? color;
  final List<Rating>? rating;
  final List<dynamic>? ratinguser;

  bool isWishlisted = false;

  Product({
    required this.name,
    required this.description,
    required this.brandName,
    required this.images,
    required this.quantity,
    required this.price,
    required this.category,
    required this.detailDescription,
    required this.warranty,
    required this.varients,
    required this.sizeQuantities,
    required this.markedprice,
    this.id,
    this.color,
    this.rating,
    this.ratinguser,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'] ?? "",
        description = json['description'] ?? "",
        brandName = json['brandName'] ?? "",
        images = List<String>.from(json['images']),
        quantity = json['quantity'] ?? 0,
        price = json['price'] ?? 0.0,
        markedprice = json['markedprice'] ?? 0.0,
        category = json['category'] ?? "",
        rating = json['ratings'] != null
            ? List<Rating>.from(
                json['ratings']?.map(
                  (x) => Rating.fromMap(x),
                ),
              )
            : null,
        varients = json['varients'] ?? [],
        color= json['color'],
        warranty = json['warranty'] ?? '',
        detailDescription = json['detailDescription'] ?? [],
        ratinguser= json['ratinguser']??[],
        sizeQuantities = json['sizeQuantities']??[];
        

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'brandName': brandName,
        'images': images,
        'quantity': quantity,
        'price': price,
        'category': category,
        'rating': rating,
        'markedprice': markedprice,
        'color': color
      };
}






//
//
//
//
//
//
//
//
//
//
//
//
//
//



// class Ratings {
//   final String? userId;
//   final int? rating;
//   final String? id;

//   Ratings({
//     this.userId,
//     this.rating,
//     this.id,
//   });

//   Ratings.fromJson(Map<String, dynamic> json)
//       : userId = json['userId'] as String?,
//         rating = json['rating'] as int?,
//         id = json['_id'] as String?;

//   Map<String, dynamic> toJson() =>
//       {'userId': userId, 'rating': rating, 'id': id};
// }





//json to dart
// class Product {
//   String? sId;
//   String? name;
//   String? description;
//   List<String>? images;
//   int? quantity;
//   double? price;
//   String? category;
//   List<Ratings>? ratings;
//   int? iV;

//   Product(
//       {this.sId,
//       this.name,
//       this.description,
//       this.images,
//       this.quantity,
//       this.price,
//       this.category,
//       this.ratings,
//       this.iV});

//   Product.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     description = json['description'];
//     images = json['images'].cast<String>();
//     quantity = json['quantity'];
//     price = json['price'];
//     category = json['category'];
//     if (json['ratings'] != null) {
//       ratings = <Ratings>[];
//       json['ratings'].forEach((v) {
//         ratings!.add(Ratings.fromJson(v));
//       });
//     }
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['name'] = name;
//     data['description'] = description;
//     data['images'] = images;
//     data['quantity'] = quantity;
//     data['price'] = price;
//     data['category'] = category;
//     if (ratings != null) {
//       data['ratings'] = ratings!.map((v) => v.toJson()).toList();
//     }
//     data['__v'] = iV;
//     return data;
//   }
// }

// class Ratings {
//   String? userId;
//   int? rating;
//   String? sId;

//   Ratings({this.userId, this.rating, this.sId});

//   Ratings.fromJson(Map<String, dynamic> json) {
//     userId = json['userId'];
//     rating = json['rating'];
//     sId = json['_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['userId'] = userId;
//     data['rating'] = rating;
//     data['_id'] = sId;
//     return data;
//   }
// }



//
//
//
//
//
//

//old constructor
// class Product {
//   final String name;
//   final String description;
//   final List<String> images;
//   final String category;
//   final double quantity;
//   final double price;
//   final String? id;
//   final List<Rating>? rating;

//   Product({
//     required this.name,
//     required this.description,
//     required this.images,
//     required this.category,
//     required this.quantity,
//     required this.price,
//     this.id,
//     this.rating,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'description': description,
//       'images': images,
//       'category': category,
//       'quantity': quantity,
//       'price': price,
//       'id': id,
//       'rating': rating,
//     };
//   }

//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['_id'],
//       name: map['name'] as String,
//       description: map['description'] as String,
//       images: List<String>.from(map['images']),
//       category: map['category'] as String,
//       quantity: map['quantity'] as double,
//       price: map['price'] as double,
//       rating: map['ratings'] != null
//           ? List<Rating>.from(
//               map['ratings']?.map(
//                 (x) => Rating.fromMap(x),
//               ),
//             )
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Product.fromJson(String source) =>
//       Product.fromMap(json.decode(source) as Map<String, dynamic>);
// }



//with id constructor
/*
import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
  final String? userId;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'userId': userId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      quantity: map['quantity'] as double,
      images: List<String>.from((map['images'] as List<String>)),
      category: map['category'] as String,
      price: map['price'] as double,
      id: map['_id'] != null ? map['_id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

 */

