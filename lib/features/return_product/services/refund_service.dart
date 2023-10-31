import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';

class RefundServices {
  Future<void> requestRefund({
    required BuildContext context,
    required Order order,
    required String reason,
    required dynamic productArray,
    required dynamic images,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      var url = Uri.parse('$uri/api/request-refund');
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': '$authToken',
      });

      String productArrayJson = jsonEncode(productArray);

      request.fields['orderId'] = order.id.toString();
      request.fields['reason'] = reason;
      request.fields['productArray'] = productArrayJson;

      for (File image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
          filename: image.path.split('/').last,
        ));
      }
      var streamedResponse = await request.send();
      var res = await http.Response.fromStream(streamedResponse);
      //use context ensuring the mounted property across async functions
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            
            showSnackBar(context: context, text: 'Return requested Successfully');
            final tabProvider =
                Provider.of<TabProvider>(context, listen: false);
            final AuthService authService = AuthService();
            authService.getUserData(context);
            tabProvider.setTab(0);
            
            Navigator.of(context).popUntil((route) => route.isFirst);
            // User user =
            //     userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            // userProvider.setUserFromModel(user);

            //
          },
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }
  Future<void> requestCancel({
    required BuildContext context,
    required Order order,
  }) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.post(
        Uri.parse(
          '$uri/api/cancel-order',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'orderId': order.id,
        }),
      );
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () { 
            showSnackBar(context: context, text: 'Order cancelled Successfully');
            final tabProvider =
                Provider.of<TabProvider>(context, listen: false);
            
            tabProvider.setTab(0);
            
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      }
    } catch (e) {
      
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }
}
