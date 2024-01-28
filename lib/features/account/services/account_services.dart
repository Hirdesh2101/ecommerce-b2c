import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_major_project/models/returns.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';

class AccountServices {
  getAllOrders({required BuildContext context}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();

    http.Response res = await http.get(
      Uri.parse("$uri/api/order"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken'
      },
    );

    // var data = jsonDecode(res.body);

    if (context.mounted) {
      httpErrorHandle(response: res, context: context, onSuccess: () {});
    }
  }

//
//
//
//
//

  void addProfilePicture(
      {required BuildContext context, required File imagePicked}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();

    try {
      final cloudinary = CloudinaryPublic('dyqymg02u', 'ktdtolon');

      String imageUrl = "";
      CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePicked.path,
            folder: "User_Profile_Pictures/${user.email}/${user.name}"),
      );
      imageUrl = cloudinaryResponse.secureUrl;

      // Product product = Product(
      //   name: name,
      //   description: description,
      //   brandName: brandName,
      // quantity: quantity,
      //   images: imageUrls,
      //   category: category,
      //   price: price,
      // );

      //use jsonEncode before sending the body to POST request
      // var bodyPostReq = jsonEncode(user.toJson());

      http.Response res = await http.post(
        Uri.parse('$uri/api/add-profile-picture'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({'imageUrl': imageUrl}),
        // body: product.toJson(),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context: context,
                text: 'Profile picture updated successfully!');
          },
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }

//
//
//
//
//
//
//
//
  Future<List<Order>?> fetchMyOrders({required BuildContext context}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Order>? orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      if (context.mounted) {
        // print(
        //     "quantity : \n\n${jsonEncode(jsonDecode(res.body)[0]).runtimeType}");
        // print("response : \n\n${jsonDecode(res.body)[1]}");
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // for (Map<String, dynamic> item in data) {
            //   // print(item['name']);
            //   orderList.add(Order.fromJson(item));
            // }
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList.add(
                Order.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
        // print("response  : \n\n${orderList[0]}");
        // print("price type : \n\n${orderList[0].price.runtimeType}");
        // print("quantity type : \n\n${orderList[0].quantity.runtimeType}");
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: "Following Error in fetching Products [home]: $e");
      }
    }
    return orderList;
  }

  Future<List<Return>?> fetchMyReturns({required BuildContext context}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Return>? returnList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/returns/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      if (context.mounted) {
        // print(
        //     "quantity : \n\n${jsonEncode(jsonDecode(res.body)[0]).runtimeType}");
        // print("response : \n\n${jsonDecode(res.body)[1]}");
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // for (Map<String, dynamic> item in data) {
            //   // print(item['name']);
            //   orderList.add(Order.fromJson(item));
            // }
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              returnList.add(
                Return.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
        // print("response  : \n\n${orderList[0]}");
        // print("price type : \n\n${orderList[0].price.runtimeType}");
        // print("quantity type : \n\n${orderList[0].quantity.runtimeType}");
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            context: context,
            text: "Following Error in fetching Products [home]: $e");
      }
    }
    return returnList;
  }

}
