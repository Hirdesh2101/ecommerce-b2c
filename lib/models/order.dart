import 'dart:convert';

class Order {
  final String id;
  final List<dynamic> products;
  final String address;
  final String userId;
  final int orderedAt;
  final String status;
  final num totalPrice;
  final String paymentStatus;
  final List<dynamic> returnProducts;

  Order({
    required this.id,
    required this.products,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
    required this.paymentStatus,
    required this.returnProducts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'returnProducts': returnProducts
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      products: List<Map<String, dynamic>>.from(
        map['products']?.map(
              (x) => Map<String, dynamic>.from(x),
            ) ??
            [],
      ),
      returnProducts: List<Map<String, dynamic>>.from(
        map['returnProducts']?.map(
              (x) => Map<String, dynamic>.from(x),
            ) ??
            [],
      ),
      address: map['address'] as String,
      paymentStatus: map['paymentStatus'] as String,
      userId: map['userId'] as String,
      orderedAt: map['orderedAt'] as int,
      status: map['status'] as String,
      totalPrice: map['totalPrice'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
