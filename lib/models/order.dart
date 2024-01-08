import 'dart:convert';

class Order {
  final String id;
  final List<dynamic> products;
  final String address;
  final String userId;
  final int orderedAt;
  String status;
  final int totalPrice;
  final String paymentStatus;
  int paymentAt = 0;
  final String razorPayOrder;
  final String paymentId;
  final List<dynamic> returnProducts;

  DateTime? orderedAtDateTime;

  ///This is the total of all the items which are ordered this also includes the
  ///quantity of returned products. Means it has all the total quantity.
  int orderedQuantity = 0;
  int returnedQuantity = 0;
  List<OrderHistoryModel> orderHistoryList = [];

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
    this.paymentAt = 0,
    this.razorPayOrder = '',
    this.paymentId = '',
  }) {
    updateTotalQuantities();
    orderedAtDateTime ??= DateTime.fromMillisecondsSinceEpoch(orderedAt);
  }

  ///Updates total quantity of all the products in the order
  void updateTotalQuantities() {
    orderedQuantity = 0;
    for (int i = 0; i < products.length; i++) {
      orderedQuantity += products[i]['quantity'] as int;
    }

    returnedQuantity = 0;
    for (int i = 0; i < returnProducts.length; i++) {
      returnedQuantity += products[i]['quantity'] as int;
    }
  }

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
      totalPrice: map['totalPrice'] as int,
      paymentAt: map['paymentAt'] as int,
      razorPayOrder: map['razorPayOrder'] as String,
      paymentId: map['paymentId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}

///This model is for fetching order history. Visit the link to get more details:
///https://lucid.app/lucidspark/6bc152d6-c265-4c69-a2a6-dd61bfad9bf8/edit?invitationId=inv_3a4d33da-1ab9-49b0-b929-c8b145e9b29a&page=0_0#
class OrderHistoryModel {
  ///Id = step name
  String id = "";
  String? orderId;
  String? userId;

  ///Step names are: RETURN_CANCELLED, ORDER_PACKING, REFUND_REQUESTED, etc
  final String stepName;

  ///Can be: Accepted by Seller, Declined by User, In-Progress, Success, Failed, Completed, etc
  String stepStatus = "Pending with Automatic";
  final String acceptActionName;
  final String declineActionName;

  ///This particular variable is local variable
  ///Can be: Teal - 0xFF009688 (accepted/success),
  ///Deep Orange - 0xFFFF5722 (Failed, etc),
  ///Amber - 0xFFFFC107 (Pending, Inprogress)
  Map<String, String> stepStatusColor = {"amber": "0xFFFFC107"};

  ///Can be: paymentId = "ID", deliveryId = "ID", "Quality Check"= "Passed/Failed", etc.
  Map<String, String>? trackingDetails = {};
  bool isTrackingDetailsRequired = false;
  String notes = "";

  ///Can be: User, Admin/Seller, None, Webhook, NodeJs, Backend, etc
  String actionRequiredBy = "Automatic";

  DateTime? stepRequestedAt;
  DateTime? stepCompletedAt;

  OrderHistoryModel({
    this.id = "",
    this.orderId,
    this.userId,
    required this.stepName,
    this.stepStatus = "",
    this.acceptActionName = "",
    this.declineActionName = "",
    this.stepStatusColor = const {"amber": "0xFFFFC107"},
    this.trackingDetails,
    this.isTrackingDetailsRequired = false,
    this.notes = "",
    this.actionRequiredBy = "Automatic",
    this.stepRequestedAt,
    this.stepCompletedAt,
  }) {
    if (id == "") {
      id = stepName;
    }

    if (stepStatus.isEmpty) {
      stepStatus = "Pending with $actionRequiredBy";
    }
    _setStepStatusColor(stepStatus);

    trackingDetails ??= {};
  }

  void setStepStatus(String stepStatus) {
    this.stepStatus = '$stepStatus by $actionRequiredBy';

    _setStepStatusColor(this.stepStatus);
  }

  void _setStepStatusColor(String stepStatus) {
    String tempStepStatus = stepStatus.toLowerCase();
    if (tempStepStatus.contains("accept") ||
        tempStepStatus.contains("success") ||
        tempStepStatus.contains("complete") ||
        tempStepStatus.contains("pass") ||
        tempStepStatus.contains("done") ||
        tempStepStatus.contains("start") ||
        tempStepStatus.contains("resolve")) {
      stepStatusColor = {"green": "0xFF009688"};
      stepCompletedAt ??= DateTime.now();
    } else if (tempStepStatus.contains("decline") ||
        tempStepStatus.contains("incomplete") ||
        tempStepStatus.contains("fail") ||
        tempStepStatus.contains("reject") ||
        tempStepStatus.contains("cancel")) {
      stepStatusColor = {"red": "0xFFFF5722"};
      stepCompletedAt ??= DateTime.now();
    } else {
      stepStatusColor = {"amber": "0xFFFFC107"};
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'orderId': orderId,
      'userId': userId,
      'stepName': stepName,
      'stepStatus': stepStatus,
      'acceptActionName': acceptActionName,
      'declineActionName': declineActionName,
      'trackingDetails': trackingDetails,
      'isTrackingDetailsRequired': isTrackingDetailsRequired,
      'notes': notes,
      'actionRequiredBy': actionRequiredBy,
      'stepRequestedAt': stepRequestedAt,
      'stepCompletedAt': stepCompletedAt,
    };
  }
}
