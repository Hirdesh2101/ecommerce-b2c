import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/models/order.dart' as order_model;
import 'package:ecommerce_major_project/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderServices {
  final _firestore = FirebaseFirestore.instance;

  ///Updates the order status in orders
  Future<bool> updateOrderStatus(
      BuildContext context, OrderHistoryModel orderHistoryModel,
      {required order_model.Order orderModel}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    debugPrint("Updating Order Status via NodeJS");

    try {
      bool isSuccess = false;

      bool isInternetConnected = await checkNetworkConnectivity();
      if (!isInternetConnected) {
        debugPrint("No internet connection");
        if (context.mounted) {
          showSnackBar(
            context: context,
            text: 'Please check your internet connection!',
          );
        }
        return isSuccess;
      }

      http.Response res = await http.put(
        Uri.parse('$uri/admin/update-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': authToken!,
        },
        body: jsonEncode({
          'id': orderHistoryModel.orderId,
          'status': orderHistoryModel.stepName,
        }),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            isSuccess = true;
            orderModel.status = orderHistoryModel.stepName;
          },
        );
      }

      return isSuccess;
    } catch (e) {
      print("Error updating order status in mongo: $e");

      if (context.mounted) {
        showSnackBar(
          context: context,
          text: 'Error updating status. Please refresh!',
        );
      }
      return false;
    }
  }

  ///Updates the order history status in firestore and also in order model in mongo
  Future<bool> updateOrderHistory(
      BuildContext context, OrderHistoryModel orderHistoryModel,
      {required order_model.Order orderModel}) async {
    print(
        "Updating order history in firestore for: order - ${orderHistoryModel.orderId} & history - ${orderHistoryModel.id}");

    try {
      bool isSuccess = false;

      bool isInternetConnected = await checkNetworkConnectivity();
      if (!isInternetConnected) {
        debugPrint("No internet connection");
        if (context.mounted) {
          showSnackBar(
            context: context,
            text: 'Please check your internet connection!',
          );
        }
        return isSuccess;
      }

      if (orderHistoryModel.orderId == null) {
        if (context.mounted) {
          showSnackBar(context: context, text: "Unknown error occurred!");
        }
        return isSuccess;
      }

      await _firestore
          .collection('orders')
          .doc(orderHistoryModel.orderId)
          .collection('history')
          .doc(orderHistoryModel.id)
          .set(orderHistoryModel.toMap());

      isSuccess =
          // ignore: use_build_context_synchronously
          await updateOrderStatus(context, orderHistoryModel,
              orderModel: orderModel);

      return isSuccess;
    } catch (e) {
      debugPrint('Error updating order history: $e');
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: 'Error updating status. Try again!',
        );
      }
      return false;
    }
  }

  Future<bool> fetchOrder(
      BuildContext context, order_model.Order orderModel) async {
    debugPrint("Fetching order with ID: ${orderModel.id}");
    bool isSuccess = false;

    bool isInternetConnected = await checkNetworkConnectivity();
    if (!isInternetConnected) {
      debugPrint("No internet connection");
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: 'Please check your internet connection!',
        );
      }
      return isSuccess;
    }

    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/fetch-order-details'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'orderId': orderModel.id,
        }),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            isSuccess = true;
            order_model.Order newOrderModel =
                order_model.Order.fromJson(res.body);
            orderModel.status = newOrderModel.status;
            orderModel.razorPayOrder = newOrderModel.razorPayOrder;
            orderModel.paymentAt = newOrderModel.paymentAt;
            orderModel.paymentId = newOrderModel.paymentId;
            orderModel.paymentStatus = newOrderModel.paymentStatus;
          },
        );
      }
    } catch (e) {
      debugPrint('Error fetching order: $e');
      if (context.mounted) {
        showSnackBar(
            context: context, text: "Error fetching order details: $e");
      }
      isSuccess = false;
    }

    return isSuccess;
  }

  ///Fetches the order history of a patricular order model from firebase add to
  ///order model's list
  Future<bool> fetchOrderHistory(
    BuildContext context,
    order_model.Order orderModel,
  ) async {
    debugPrint('Fetching order history');
    bool isSuccess = false;

    bool isInternetConnected = await checkNetworkConnectivity();
    if (!isInternetConnected) {
      debugPrint("No internet connection");
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: 'Please check your internet connection!',
        );
      }
      return isSuccess;
    }

    orderModel.orderHistoryList.clear();
    QuerySnapshot orderHistories;

    try {
      orderHistories = await _firestore
          .collection('orders')
          .doc(orderModel.id)
          .collection('history')
          .orderBy("stepRequestedAt")
          .get();
    } catch (e) {
      debugPrint('Error fetching order history: $e');
      if (context.mounted) {
        showSnackBar(
            context: context, text: "Error fetching order history: $e");
      }
      return false;
    }
    if (context.mounted) {
      isSuccess = await _readFetchedOrderHistory(context, orderHistories,
          orderModel.orderHistoryList, orderModel.id, orderModel.userId);
    }
    return isSuccess;
  }

  Future<bool> _readFetchedOrderHistory(
    BuildContext context,
    QuerySnapshot orderHistories,
    List<order_model.OrderHistoryModel> listToAdd,
    String orderId,
    String userId,
  ) async {
    try {
      for (var orderHistory in orderHistories.docs) {
        Map<String, dynamic> mapData =
            orderHistory.data() as Map<String, dynamic>;
        order_model.OrderHistoryModel orderHistoryModel =
            order_model.OrderHistoryModel(
          id: mapData['id'],
          orderId: mapData['orderId'] ?? orderId,
          userId: mapData['userId'] ?? userId,
          stepName: mapData['stepName'],
          stepStatus: mapData['stepStatus'],
          acceptActionName: mapData['acceptActionName'],
          declineActionName: mapData['declineActionName'],
          trackingDetails: mapData['trackingDetails'] != null
              ? Map<String, String>.from(mapData['trackingDetails'])
              : {},
          isTrackingDetailsRequired: mapData['isTrackingDetailsRequired'],
          notes: mapData['notes'],
          actionRequiredBy: mapData['actionRequiredBy'],
          stepRequestedAt: DateTime.fromMillisecondsSinceEpoch(
              mapData['stepRequestedAt'] != null
                  ? mapData['stepRequestedAt'].millisecondsSinceEpoch
                  : DateTime.now().millisecondsSinceEpoch),
          stepCompletedAt: mapData['stepCompletedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  mapData['stepCompletedAt'].millisecondsSinceEpoch)
              : null,
        );
        listToAdd.add(orderHistoryModel);
      }

      return true;
    } catch (e) {
      debugPrint('Error reading fetched order histories: $e');
      if (context.mounted) {
        showSnackBar(context: context, text: "Error reading order history: $e");
      }
      return false;
    }
  }
}
