import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProduct(
      {required BuildContext context, required String searchQuery}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/products/search/$searchQuery"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
      );
      var data = jsonDecode(res.body);

      // List listLength = jsonDecode(res.body);
      //jsonEncode => [object] to a JSON string.
      //jsonDecode => String to JSON object.
      if (context.mounted) {
        httpErrorHandle(
          //handling the http errors quiet efficiently
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              // print(item['name']);
              productList.add(Product.fromJson(item));
            }
          },
        );
      }

      // print("Products length : ${jsonDecode(res.body).length}");
    } catch (e) {
      showSnackBar(
          context: context,
          text:
              "Following Error in fetching Products [Search] : ${e.toString()}");
    }
    return productList;
  }
  Future<List<Product>> searchProducts(
      {required BuildContext context,required String query}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
          Uri.parse("$uri/api/search-products?key=$query"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$authToken',
          });
      var data = jsonDecode(res.body);
      print(data);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              // print(item['name']);
              productList.add(Product.fromJson(item));
            }
          },
        );
      }
    } catch (e) {
       showSnackBar(
          context: context,
          text:
              "Following Error in fetching Products [Search] : ${e.toString()}");
    }
     return productList;
  }
}
