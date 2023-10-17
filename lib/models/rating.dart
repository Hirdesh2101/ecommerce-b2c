import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Rating {
  final String userId;
  final num rating;
  final String? review;
  final String? createdAt;
  Rating({
    required this.userId,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rating': rating,
      'review': review,
      'createdAt': createdAt
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] as String,
      rating: map['rating'] as num,
      review: map['review']??'',
      createdAt: map['createdAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);
}
