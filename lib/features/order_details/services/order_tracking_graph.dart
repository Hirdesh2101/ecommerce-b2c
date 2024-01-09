import 'package:ecommerce_major_project/models/order.dart';

///This is the format for the data structure used for the graph of the Order Tracking
///See for more details: https://lucid.app/lucidspark/6bc152d6-c265-4c69-a2a6-dd61bfad9bf8/edit?page=0_0&invitationId=inv_3a4d33da-1ab9-49b0-b929-c8b145e9b29a#
class OrderTrackingDataStructure {
  final String currentNode;
  OrderTrackingDataStructure? acceptedNode;
  OrderTrackingDataStructure? declinedNode;

  OrderTrackingDataStructure({
    required this.currentNode,
    this.acceptedNode,
    this.declinedNode,
  });
}

class OrderTrackingGraph {
  OrderTrackingGraph() {
    _createOrderGraph();
    _createReturnGraph();
  }

  ///Find the next step in the order tracking flow.
  Future<OrderHistoryModel?> nextStep(
      List<OrderHistoryModel> orderHistoryList) async {
    if (orderHistoryList.isEmpty) {
      print("Order history list is empty");
      return null;
    } else if (orderHistoryList[0].stepName == 'PAYMENT_STATUS_CHECK') {
      OrderTrackingDataStructure? orderTrackingDataStructure =
          _traverseOrderGraph(orderHistoryList, 0, paymentStatusCheckNode);

      if (orderTrackingDataStructure == null) {
        return null;
      } else if (orderHistoryList.last.stepStatusColor.keys.first
          .toLowerCase()
          .contains("amber")) {
        return null;
      }

      return orderPreTrackingDefinedModels[
          orderTrackingDataStructure.currentNode];
    } else if (orderHistoryList[0].stepName == 'RETURN_REQUESTED') {
      OrderTrackingDataStructure? orderTrackingDataStructure =
          _traverseReturnGraph(orderHistoryList, 0, returnRequestedNode);

      if (orderTrackingDataStructure == null) {
        return null;
      } else if (orderHistoryList.last.stepStatusColor.keys.first
          .toLowerCase()
          .contains("amber")) {
        return null;
      }

      return orderPreTrackingDefinedModels[
          orderTrackingDataStructure.currentNode];
    } else {
      print('Order History first step might be incorrect.');
      return null;
    }
  }

  OrderTrackingDataStructure? _traverseOrderGraph(
      List<OrderHistoryModel> orderHistoryList,
      int stepNumber,
      OrderTrackingDataStructure? currentNode) {
    if (currentNode == null ||
        stepNumber >= orderHistoryList.length ||
        orderHistoryList[stepNumber]
            .stepStatusColor
            .keys
            .first
            .contains("amber")) {
      return currentNode;
    }

    if (orderHistoryList[stepNumber]
        .stepStatusColor
        .keys
        .first
        .contains("green")) {
      return _traverseOrderGraph(
          orderHistoryList, stepNumber + 1, currentNode.acceptedNode);
    } else if (orderHistoryList[stepNumber]
        .stepStatusColor
        .keys
        .first
        .contains("red")) {
      return _traverseOrderGraph(
          orderHistoryList, stepNumber + 1, currentNode.declinedNode);
    } else {
      return currentNode;
    }
  }

  OrderTrackingDataStructure? _traverseReturnGraph(
      List<OrderHistoryModel> orderHistoryList,
      int stepNumber,
      OrderTrackingDataStructure? currentNode) {
    if (currentNode == null ||
        stepNumber >= orderHistoryList.length ||
        orderHistoryList[stepNumber]
            .stepStatusColor
            .keys
            .first
            .contains("amber")) {
      return currentNode;
    }

    if (orderHistoryList[stepNumber]
        .stepStatusColor
        .keys
        .first
        .contains("green")) {
      return _traverseOrderGraph(
          orderHistoryList, stepNumber + 1, currentNode.acceptedNode);
    } else if (orderHistoryList[stepNumber]
        .stepStatusColor
        .keys
        .first
        .contains("red")) {
      return _traverseOrderGraph(
          orderHistoryList, stepNumber + 1, currentNode.declinedNode);
    } else {
      return currentNode;
    }
  }

  ///This is the starting node of the graph.
  OrderTrackingDataStructure paymentStatusCheckNode =
      OrderTrackingDataStructure(
    currentNode: "PAYMENT_STATUS_CHECK",
  );
  OrderTrackingDataStructure orderReceivedNode = OrderTrackingDataStructure(
    currentNode: "ORDER_RECEIVED",
  );
  OrderTrackingDataStructure orderPackingNode = OrderTrackingDataStructure(
    currentNode: "ORDER_PACKING",
  );
  OrderTrackingDataStructure orderInTransitNode = OrderTrackingDataStructure(
    currentNode: "ORDER_IN_TRANSIT",
  );
  OrderTrackingDataStructure orderOutForDeliveryNode =
      OrderTrackingDataStructure(
    currentNode: "ORDER_OUT_FOR_DELIVERY",
  );
  OrderTrackingDataStructure orderDeliveredNode = OrderTrackingDataStructure(
    currentNode: "ORDER_DELIVERED",
  );
  OrderTrackingDataStructure refundRequestedNodeOrder =
      OrderTrackingDataStructure(
    currentNode: "REFUND_REQUESTED",
  );
  OrderTrackingDataStructure refundRequestedNodeReturn =
      OrderTrackingDataStructure(
    currentNode: "REFUND_REQUESTED",
  );
  OrderTrackingDataStructure manualRefundRequiredNodeOrder =
      OrderTrackingDataStructure(
    currentNode: "MANUAL_REFUND_REQUIRED",
  );
  OrderTrackingDataStructure manualRefundRequiredNodeReturn =
      OrderTrackingDataStructure(
    currentNode: "MANUAL_REFUND_REQUIRED",
  );
  OrderTrackingDataStructure orderCancelledNode = OrderTrackingDataStructure(
    currentNode: "ORDER_CANCELLED",
  );
  OrderTrackingDataStructure returnRequestedNode = OrderTrackingDataStructure(
    currentNode: "RETURN_REQUESTED",
  );
  OrderTrackingDataStructure returnPendingNode = OrderTrackingDataStructure(
    currentNode: "RETURN_PENDING",
  );
  OrderTrackingDataStructure returnInTransitNode = OrderTrackingDataStructure(
    currentNode: "RETURN_IN_TRANSIT",
  );
  OrderTrackingDataStructure returnReceivedNode = OrderTrackingDataStructure(
    currentNode: "RETURN_RECEIVED",
  );
  OrderTrackingDataStructure returnCompletedNode = OrderTrackingDataStructure(
    currentNode: "RETURN_COMPLETED",
  );
  OrderTrackingDataStructure contactCustomerNode = OrderTrackingDataStructure(
    currentNode: "CONTACT_CUSTOMER",
  );
  OrderTrackingDataStructure returnCancelledNode = OrderTrackingDataStructure(
    currentNode: "RETURN_CANCELLED",
  );

  ///Creates the graph of order tracking.
  ///You can visualize the graph here: https://lucid.app/lucidspark/6bc152d6-c265-4c69-a2a6-dd61bfad9bf8/edit?viewport_loc=-2901%2C-303%2C3677%2C1683%2C0_0&invitationId=inv_3a4d33da-1ab9-49b0-b929-c8b145e9b29a
  void _createOrderGraph() {
    paymentStatusCheckNode.acceptedNode = orderReceivedNode;
    paymentStatusCheckNode.declinedNode = orderCancelledNode;

    orderReceivedNode.acceptedNode = orderPackingNode;
    orderReceivedNode.declinedNode = refundRequestedNodeOrder;

    orderPackingNode.acceptedNode = orderInTransitNode;
    orderPackingNode.declinedNode = refundRequestedNodeOrder;

    orderInTransitNode.acceptedNode = orderOutForDeliveryNode;

    orderOutForDeliveryNode.acceptedNode = orderDeliveredNode;

    refundRequestedNodeOrder.acceptedNode = orderCancelledNode;
    refundRequestedNodeOrder.declinedNode = manualRefundRequiredNodeOrder;

    manualRefundRequiredNodeOrder.acceptedNode = orderCancelledNode;
  }

  ///Creates the graph of return tracking.
  ///You can visualize the graph here: https://lucid.app/lucidspark/6bc152d6-c265-4c69-a2a6-dd61bfad9bf8/edit?viewport_loc=-2901%2C-303%2C3677%2C1683%2C0_0&invitationId=inv_3a4d33da-1ab9-49b0-b929-c8b145e9b29a
  void _createReturnGraph() {
    returnRequestedNode.acceptedNode = returnPendingNode;
    returnRequestedNode.declinedNode = returnCancelledNode;

    returnPendingNode.acceptedNode = returnInTransitNode;
    returnPendingNode.declinedNode = returnCancelledNode;

    returnInTransitNode.acceptedNode = returnReceivedNode;

    returnReceivedNode.acceptedNode = refundRequestedNodeReturn;
    returnReceivedNode.declinedNode = contactCustomerNode;

    refundRequestedNodeReturn.acceptedNode = returnCompletedNode;
    refundRequestedNodeReturn.declinedNode = manualRefundRequiredNodeReturn;

    manualRefundRequiredNodeReturn.acceptedNode = returnCompletedNode;

    contactCustomerNode.acceptedNode = refundRequestedNodeReturn;
    contactCustomerNode.declinedNode = returnCancelledNode;
  }

  //It has all the models created for the order tracking. This will be used in graph.
  final Map<String, OrderHistoryModel> orderPreTrackingDefinedModels = {
    "PAYMENT_STATUS_CHECK": OrderHistoryModel(
      stepName: "PAYMENT_STATUS_CHECK",
      stepStatus: "Automatic check",
      actionRequiredBy: "Automatic",
      acceptActionName: "Successful",
      declineActionName: "Failed",
      trackingDetails: {"Payment ID": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "ORDER_RECEIVED": OrderHistoryModel(
      stepName: "ORDER_RECEIVED",
      stepStatus: "Waiting for Seller to respond",
      actionRequiredBy: "Seller",
      acceptActionName: "Accepted",
      declineActionName: "Declined",
      stepRequestedAt: DateTime.now(),
    ),
    "ORDER_PACKING": OrderHistoryModel(
      stepName: "ORDER_PACKING",
      stepStatus: "Waiting for Packing & Quality check",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      declineActionName: "Cancelled",
      trackingDetails: {"Quality Check": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "ORDER_IN_TRANSIT": OrderHistoryModel(
      stepName: "ORDER_IN_TRANSIT",
      stepStatus: "On the way",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      trackingDetails: {"Tracking Link/ID": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "ORDER_OUT_FOR_DELIVERY": OrderHistoryModel(
      stepName: "ORDER_OUT_FOR_DELIVERY",
      stepStatus: "Order out for delivery",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      trackingDetails: {"Tracking Link/ID": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "ORDER_DELIVERED": OrderHistoryModel(
      stepName: "ORDER_DELIVERED",
      stepStatus: "Order delivered successfully",
      actionRequiredBy: "None",
      stepRequestedAt: DateTime.now(),
      stepCompletedAt: DateTime.now(),
    ),
    "REFUND_REQUESTED": OrderHistoryModel(
      stepName: "REFUND_REQUESTED",
      stepStatus: "Requesting automatic refund from RazorPay",
      actionRequiredBy: "Automatic",
      acceptActionName: "Successful",
      declineActionName: "Failed",
      trackingDetails: {"Refund Payment ID": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "MANUAL_REFUND_REQUIRED": OrderHistoryModel(
      stepName: "MANUAL_REFUND_REQUIRED",
      stepStatus: "Seller initiating refund manually",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      trackingDetails: {"Refund Payment ID": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "ORDER_CANCELLED": OrderHistoryModel(
      stepName: "ORDER_CANCELLED",
      stepStatus: "Order is cancelled",
      actionRequiredBy: "None",
      stepRequestedAt: DateTime.now(),
      stepCompletedAt: DateTime.now(),
    ),
    //Return related models
    "RETURN_REQUESTED": OrderHistoryModel(
      stepName: "RETURN_REQUESTED",
      stepStatus: "Waiting for Seller to respond",
      actionRequiredBy: "Seller",
      acceptActionName: "Accepted",
      declineActionName: "Declined",
      stepRequestedAt: DateTime.now(),
    ),
    "RETURN_PENDING": OrderHistoryModel(
      stepName: "RETURN_PENDING",
      stepStatus: "Waiting for delivery person to collect",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      declineActionName: "Cancelled",
      stepRequestedAt: DateTime.now(),
    ),
    "RETURN_IN_TRANSIT": OrderHistoryModel(
      stepName: "RETURN_IN_TRANSIT",
      stepStatus: "On the way",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      trackingDetails: {"Tracking ID": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "RETURN_RECEIVED": OrderHistoryModel(
      stepName: "RETURN_RECEIVED",
      stepStatus: "Under quality check with seller",
      actionRequiredBy: "Seller",
      acceptActionName: "Passed",
      declineActionName: "Failed",
      trackingDetails: {"Quality Check": ""},
      isTrackingDetailsRequired: true,
      stepRequestedAt: DateTime.now(),
    ),
    "RETURN_COMPLETED": OrderHistoryModel(
      stepName: "RETURN_COMPLETED",
      stepStatus: "Return completed successfully",
      actionRequiredBy: "None",
      stepRequestedAt: DateTime.now(),
      stepCompletedAt: DateTime.now(),
    ),
    "CONTACT_CUSTOMER": OrderHistoryModel(
      stepName: "CONTACT_CUSTOMER",
      stepStatus: "Contacting customer for more details",
      actionRequiredBy: "Seller",
      acceptActionName: "Completed",
      declineActionName: "Failed",
      stepRequestedAt: DateTime.now(),
    ),
    "RETURN_CANCELLED": OrderHistoryModel(
      stepName: "RETURN_CANCELLED",
      stepStatus: "Return is cancelled",
      actionRequiredBy: "None",
      stepRequestedAt: DateTime.now(),
      stepCompletedAt: DateTime.now(),
    ),
  };
}
