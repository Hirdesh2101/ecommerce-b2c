import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Advertisement {
  final String redirectTo;
  final String redirectLink;
  final String image;
  Advertisement({
    required this.redirectTo,
    required this.redirectLink,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'redirectTo': redirectTo,
      'redirectLink': redirectLink,
      'image': image
    };
  }

  factory Advertisement.fromMap(Map<String, dynamic> map) {
    return Advertisement(
      redirectTo: map['redirectTo'] as String,
      redirectLink: map['redirectLink'] as String,
      image: map['image']as String
    );
  }

  String toJson() => json.encode(toMap());

  factory Advertisement.fromJson(String source) =>
      Advertisement.fromMap(json.decode(source) as Map<String, dynamic>);
}
