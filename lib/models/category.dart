import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  final String name;
  final String icon;
  final String image;
  Category({
    required this.name,
    required this.icon,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'icon': icon,
      'image': image
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
      icon: map['icon'] as String,
      image: map['image']as String
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
