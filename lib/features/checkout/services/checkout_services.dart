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
  Future<bool> checkProductsAvailability(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isProductAvailable = false;

    try {
      bool isInternetConnected = await checkNetworkConnectivity();

      if (isInternetConnected) {
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
              
              isProductAvailable = true;
            },
          );
        }

        return isProductAvailable;
      } else {
        if (context.mounted) {
          showSnackBar(
            context: context, text: "Please check your internet connection!");
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, text: e.toString());
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
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }

  Future<dynamic> getDeliveryCharges(
      BuildContext context, String pincode) async {
    try {
      bool isInternetConnected = await checkNetworkConnectivity();
      dynamic charges;
      if (isInternetConnected) {
        final String? authToken = await GlobalVariables.getFirebaseAuthToken();

        http.Response res = await http.get(
          Uri.parse('$uri/api/check-free-delivery'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$authToken',
            'pincode': pincode,
          },
        );

        // var data = jsonDecode(res.body);
        if (context.mounted) {
          httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              charges = jsonDecode(res.body);
            },
          );
        }
        return charges;
      } else {
       if (context.mounted) {
         showSnackBar(
            context: context, text: "Please check your internet connection!");
       }
        return "Please check your internet connection!";
      }
    } catch (e) {
     if (context.mounted) showSnackBar(context: context, text: e.toString());
      return "Error: $e";
    }
  }

  Future<dynamic> checkPaymentStatus(
      BuildContext context, String orderId) async {
    try {
      bool isInternetConnected = await checkNetworkConnectivity();
      dynamic status;
      if (isInternetConnected) {
        final String? authToken = await GlobalVariables.getFirebaseAuthToken();

        http.Response res = await http.get(
          Uri.parse('$uri/api/check-payment-status'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$authToken',
            'orderid': orderId,
          },
        );

        // var data = jsonDecode(res.body);
        if (context.mounted) {
          
          httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              status = jsonDecode(res.body);
            },
          );
        }
        return status;
      } else {
        if (context.mounted) {
          showSnackBar(
            context: context, text: "Please check your internet connection!");
        }
        return "Please check your internet connection!";
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, text: e.toString());
      return "Error: $e";
    }
  }

  // pdates the order with quantity and payment status after payment status
  Future<void> updateOrder({
    required BuildContext context,
    required String orderId,
    required String status,
    required String paymentStatus,
  }) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/update-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'orderId': orderId,
          'status': status,
          'payment_status': paymentStatus
        }),
      );

      // var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            //TODO ADD SOMETHING MAYBEs
          },
        );
      }
    } catch (e) {
      
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }

  /// Places order with pending status in our DB, first checks for stock availablity,
  /// then also places order in razor pay and return the options map
  Future<http.Response?> placeOrder({
    required BuildContext context,
    required String address,
    required num totalSum,
    required List<dynamic> cart,
  }) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'cart': cart,
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
