import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ecommerce_major_project/models/user.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';

class CheckoutServices {
  ///Checks the availability of products through backend, also shows snackbar of the info.
  Future<bool> checkProductsAvailability(
      BuildContext context, List cart) async {
    bool isProductAvailable = false;

    try {
      bool isInternetConnected = await checkNetworkConnectivity();

      if (isInternetConnected) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final String? authToken = await GlobalVariables.getFirebaseAuthToken();

        http.Response res = await http.post(
          Uri.parse('$uri/api/check-products-availability'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$authToken',
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
          }),
        );

        // var data = jsonDecode(res.body);
        if (context.mounted) {
          httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              // If products are available then it will return true
              print("Products are in stock. Proceeding...");
              isProductAvailable = true;
            },
          );
        }

        return isProductAvailable;
      } else {
        showSnackBar(
            context: context, text: "Please check your internet connection!");
        return false;
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
      return false;
    }
  }

  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'address': address,
        }),
        // body: product.toJson(),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(address: jsonDecode(res.body)['address']);
            userProvider.setUserFromModel(user);
            // Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  ///THis function creates a razor pay order and returns a razor pay order id.
  ///This order id needs to be passed when paying through razor pay to link the
  ///payment with the order.
  Future<http.Response> createRazorPayOrder(
      String orderId, int amount, String userId) async {
    amount = amount * 100;

    http.Response response = await http.post(
      Uri.parse(GlobalVariables.razorPayOrderApi),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Basic ${base64Encode(utf8.encode('${GlobalVariables.razorPayTestKey}:${GlobalVariables.razorPaySecretKey}'))} ",
      },
    );
  }

  // pdates the order with quantity and payment status after payment status
  void updateOrder({
    required BuildContext context,
    required String orderId,
    required String paymentId,
    required int paymentAt,
    String? signatureId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/update-order/$orderId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'orderId': orderId,
          'paymentId': paymentId,
          'orderedAt': paymentAt,
          'signatureId': signatureId,
        }),
      );

      // var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // success on the payment will redirect the user
            // to the payment successful dialog, order placed
            // clear the cart
            // and add the address as the current address if one didn't exist before
            // add the payment successful dialog here!
            // the gif and showDialog
            showSnackBar(context: context, text: "Your order has been placed");
            User user = userProvider.user.copyWith(
              cart: [],
            );
            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  /// Places order with pending status.
  Future<http.Response?> placeOrder({
    required BuildContext context,
    required String address,
    required num totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'address': address,
          'totalPrice': totalSum,
        }),
      );

      // var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // success on the payment will redirect the user
            // to the payment successful dialog, order placed
            // clear the cart
            // and add the address as the current address if one didn't exist before
            // add the payment successful dialog here!
            // the gif and showDialog
            // showSnackBar(context: context, text: "Your order has been placed");
            // User user = userProvider.user.copyWith(
            //   cart: [],
            // );
            // userProvider.setUserFromModel(user);
          },
        );

        if (res.statusCode == 200) {
          return res;
        }
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, text: e.toString());
      }
    }
    return null;
  }
}
