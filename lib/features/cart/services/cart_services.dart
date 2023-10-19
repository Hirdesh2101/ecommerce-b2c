import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:ecommerce_major_project/models/user.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';

class CartServices {
  Future<void> removeFromCart({
    required BuildContext context,
    required Product product,
    required String color,
    required String size,
  }) async {
    print("========> Inside the remove from cart function");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.delete(
        Uri.parse(
          '$uri/api/remove-from-cart',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'id': product.id!,
          'color': color,
          'size': size
        }),
      );

      //use context ensuring the mounted property across async functions
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print("\nInside on success method..");
            User user =
                userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            userProvider.setUserFromModel(user);
            print("\nUser cart now is ${user.cart}");
          },
        );
      }
    } catch (e) {
      print("\n========>Inside the catch block of remove from cart");
      showSnackBar(context: context, text: e.toString());
    }
  }
}
