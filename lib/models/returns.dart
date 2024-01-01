import 'dart:convert';

class Return {
  final String id;
  final List<dynamic> returnedProducts;
  final String refundStatus;
  final String returnStatus;
  final String returnedAt;
  final String orderId;

  Return({
    required this.id,
    required this.refundStatus,
    required this.returnedProducts,
    required this.returnStatus,
    required this.returnedAt,
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'refundStatus': refundStatus,
      'returnedProducts': returnedProducts,
      'returnStatus': returnStatus,
      'returnedAt': returnedAt,
      'orderId': orderId,
    };
  }

  factory Return.fromMap(Map<String, dynamic> map) {
    return Return(
      id: map['_id'] as String,
      returnedProducts: List<Map<String, dynamic>>.from(
        map['returnedProducts']?.map(
              (x) => Map<String, dynamic>.from(x),
            ) ??
            [],
      ),
      refundStatus: map['refundStatus'] as String,
      returnStatus: map['returnStatus'] as String,
      returnedAt: map['returnedAt'] as String,
      orderId: map['orderId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Return.fromJson(String source) =>
      Return.fromMap(json.decode(source) as Map<String, dynamic>);
}
