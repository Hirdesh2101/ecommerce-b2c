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

class ProductDetailServices {

 Future<Product?> getProductById(
      {required BuildContext context, required String productId}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    Product? product;
    String tokenValue = '$authToken';
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/get-product-by-id/$productId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenValue,
      });
      

      var data = jsonDecode(res.body);
      
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            product = Product.fromJson(data);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: "Following Error in fetching Product : $e");
      }
    }
    return product;
  }


   Future<List<Product>> fetchSimilarProducts(
      {required BuildContext context, required String category}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Product> productList = [];
    String tokenValue = '$authToken';
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/similar-products/?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenValue,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              // 
              productList.add(Product.fromJson(item));
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: "Following Error in fetching Simialar Products: $e");
      }
    }
    return productList;
  }


  Future<void> addToCart({
    required BuildContext context,
    required Product product,
    required String color,
    required String size
  }) async {
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      // var bodyData = {"id": "${product.id}"};
      http.Response res = await http.post(
        Uri.parse(
          '$uri/api/add-to-cart',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({'id': product.id!,'color':color,'size':size}),
      );

      // http.Response res = await http.post(
      //   Uri.parse("$uri/api/add-to-cart"),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //     'Authorization': '$authToken',
      //   },
      //   body: jsonEncode({'id': product.id!}),
      // );
      // debugPrint(
      //     "\n\nuser token after http post request: ===> ${'$authToken'} ");

      // 

      //use context ensuring the mounted property across async functions
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            
            User user =
                userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            userProvider.setUserFromModel(user);
            
          },
        );
      }
    } catch (e) {
      
      if (context.mounted)showSnackBar(context: context, text: e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
    required String review,
  }) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/rate-product"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
          'review': review
        }),
      );

      //use context ensuring the mounted property across async functions
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {},
        );
      }
    } catch (e) {
     if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }
}
