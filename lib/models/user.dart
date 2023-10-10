// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//user model
class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final String type;
  final String token;
  final String? imageUrl;
  final List<dynamic> cart;
  final List<dynamic>? wishList;
  final List<String>? searchHistory;
  final List<dynamic>? returnList;
  final String uid;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.type,
    required this.token,
    required this.imageUrl,
    required this.cart,
    this.wishList,
    this.searchHistory,
    this.returnList,
    required this.uid
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'type': type,
      'token': token,
      'imageUrl': imageUrl,
      'cart': cart,
      'wishList': wishList,
      'searchHistory': searchHistory,
      'returnList': returnList,
      'uid': uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      //ensure id is _id
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      uid: map['uid']??'',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
              (x) => Map<String, dynamic>.from(x),
            ) ??
            [],
      ),
      wishList: map['wishList'] != null
          ? List<Map<String, dynamic>>.from(
              map['wishList']?.map(
                    (x) => Map<String, dynamic>.from(x),
                  ) ??
                  [],
            )
          : null,
      searchHistory: map['searchHistory'] != null
          ? List<String>.from(map['searchHistory'])
          : null,

      returnList: map['returnList'] != null
          ? List<Map<String, dynamic>>.from(
              map['returnList']?.map(
                    (x) => Map<String, dynamic>.from(x),
                  ) ??
                  [],
            )
          : null,
      // searchHistory: List<String>.from(map['searchHistory']?.map((x)=>))
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? type,
    String? token,
    String? imageUrl,
    String? uid,
    List<dynamic>? cart,
    List<dynamic>? wishList,
    List<String>? searchHistory,
    List<dynamic>? returnList,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      imageUrl: imageUrl ?? this.imageUrl,
      cart: cart ?? this.cart,
      wishList: wishList ?? this.wishList,
      searchHistory: searchHistory ?? this.searchHistory,
      returnList: returnList ?? this.returnList,
      uid: uid ?? this.uid
    );
  }
}
