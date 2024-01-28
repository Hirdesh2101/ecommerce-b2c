import 'dart:convert';

class Return {
  final String id;
  final List<dynamic> returnProducts;
  final String refundStatus;
  final String returnStatus;
  final String createdAt;
  final String orderId;

  Return({
    required this.id,
    required this.refundStatus,
    required this.returnProducts,
    required this.returnStatus,
    required this.createdAt,
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'refundStatus': refundStatus,
      'returnProducts': returnProducts,
      'returnStatus': returnStatus,
      'createdAt': createdAt,
      'orderId': orderId,
    };
  }

  factory Return.fromMap(Map<String, dynamic> map) {
    return Return(
      id: map['_id'] as String,
      returnProducts: List<Map<String, dynamic>>.from(
        map['returnProducts']?.map(
              (x) => Map<String, dynamic>.from(x),
            ) ??
            [],
      ),
      refundStatus: map['refundStatus'] as String,
      returnStatus: map['returnStatus'] as String,
      createdAt: map['createdAt'] as String,
      orderId: map['orderId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Return.fromJson(String source) =>
      Return.fromMap(json.decode(source) as Map<String, dynamic>);
}
