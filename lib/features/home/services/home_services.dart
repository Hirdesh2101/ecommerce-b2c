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

class HomeServices {
  // fetch products category wise

  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Product> productList = [];
    String tokenValue = '$authToken';
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenValue,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        // print(
        //     "quantity : \n\n${jsonEncode(jsonDecode(res.body)[0]).runtimeType}");
        // print("response : \n\n${jsonDecode(res.body)[1]}");
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              // print(item['name']);
              productList.add(Product.fromJson(item));
            }
            //    for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //   productList.add(
            //     Product.fromJson(
            //       jsonEncode(
            //         jsonDecode(res.body)[i],
            //       ),
            //     ),
            //   );
            // }
          },
        );
        // print("response  : \n\n${productList[0]}");
        // print("price type : \n\n${productList[0].price.runtimeType}");
        // print("quantity type : \n\n${productList[0].quantity.runtimeType}");
      }
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Following Error in fetching Products [home]: $e");
    }
    return productList;
  }

//
//
//

  // fetch deal of the day
  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    Product product = Product(
      name: '',
      description: '',
      brandName: '',
      images: [],
      quantity: 0,
      price: 0.0,
      category: '',
      detailDescription: [],
      varients: [],
      warranty: '',
      sizeQuantities: [],
      markedprice: 0.0,
      color: '',
    );

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // for (Map<String, dynamic> item in data) {
            //   // print(item['name']);
            //   // productList.add(Product.fromJson(item));
            //   product = Product.fromJson(item);
            // }

            // var data = jsonDecode(res.body);
            product = Product.fromJson(jsonDecode(res.body));
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Following Error in fetching deal-of-the-day : $e");
    }
    return product;
  }

//
//
//

  Future<List<String>> fetchAllProductsNames(BuildContext context) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<String> productNames = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/get-all-products-names'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //   productList.add(
            //     Product.fromJson(
            //       jsonEncode(
            //         jsonDecode(res.body)[i],
            //       ),
            //     ),
            //   );
            // }

            for (String item in data) {
              // print(item['name']);
              productNames.add(item);
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return productNames;
  }

  Future<List<String>?> searchProducts(
      BuildContext context, String query) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    //final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    List<String>? productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse("$uri/api/search-products?key=$query"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });
      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              // print(item['name']);
              productList.add(item['name']);
            }

            //searchProvider.addListToSuggestions(productList);
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return productList;
  }

//
//
//

  void addToHistory({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/search-history"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({'searchQuery': searchQuery}),
      );

      //use context ensuring the mounted property across async functions
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // type casting List<dynamic>? to List<String>?
            // by mapping each item from List<dynamic>? to String
            List<String>? searchHistoryFromDB =
                (jsonDecode(res.body)['searchHistory'] as List)
                    .map((item) => item as String)
                    .toList();
            User user =
                userProvider.user.copyWith(searchHistory: searchHistoryFromDB);
            userProvider.setUserFromModel(user);
            print("\nUser searchHistory now is ${user.searchHistory}");
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context, text: "Error in addToHistory ${e.toString()}");
    }
  }

//
//
//
//
//
//

  Future<void> deleteSearchHistoryItem({
    required BuildContext context,
    required String deleteQuery,
  }) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/delete-search-history-item"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({'deleteQuery': deleteQuery}),
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
      showSnackBar(
          context: context,
          text: "Error in delete search history item ${e.toString()}");
    }
  }

//
//
//
//
//
//

  Future<List<String>> fetchSearchHistory(BuildContext context) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<String> searchHistoryList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/get-search-history'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //   productList.add(
            //     Product.fromJson(
            //       jsonEncode(
            //         jsonDecode(res.body)[i],
            //       ),
            //     ),
            //   );
            // }

            for (String item in data) {
              // print(item['name']);
              searchHistoryList.add(item);
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return searchHistoryList;
  }

//
//
//
//

  void addToWishList({
    required BuildContext context,
    required Product product,
  }) async {
    print("========> Inside the add to /api/add-to-wishList function");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-wishList'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({'id': product.id}),
      );
      print("\nwishList   :  ${userProvider.user.wishList} ");

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // print("\nInside on success method..");
            User user = userProvider.user
                .copyWith(wishList: jsonDecode(res.body)['wishList']);
            userProvider.setUserFromModel(user);
            print("\nUser wishList now is ${user.wishList}");
          },
        );
      }
    } catch (e) {
      debugPrint("\n========>Inside the catch block");
      showSnackBar(context: context, text: e.toString());
    }
  }

  void removeFromWishList({
    required BuildContext context,
    required Product product,
  }) async {
    print("========> Inside the remove from wishlist function");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      http.Response res = await http.delete(
        Uri.parse(
          '$uri/api/remove-from-wishlist/${product.id}',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$authToken',
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      //use context ensuring the mounted property across async functions
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print("\nInside on success method..");
            User user = userProvider.user
                .copyWith(wishList: jsonDecode(res.body)['wishList']);
            userProvider.setUserFromModel(user);
            print("\nUser wishList now is ${user.wishList}");
          },
        );
      }
    } catch (e) {
      print("\n========>Inside the catch block of remove from wishlist");
      showSnackBar(context: context, text: e.toString());
    }
  }
}

//
//
//
//

// Future<List<Product>?> fetchWishList(BuildContext context) async {
//   final userProvider = Provider.of<UserProvider>(context, listen: false);
//   List<Product>? wishList = [];
//   try {
//     http.Response res =
//         await http.get(Uri.parse('$uri/api/get-wishList'), headers: {
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': '$authToken',
//     });

//     var data = jsonDecode(res.body);
//     if (context.mounted) {
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () {
//           for (Product item in data) {
//             // print(item['name']);
//             wishList.add(item);
//           }
//         },
//       );
//     }
//   } catch (e) {
//     showSnackBar(
//         context: context, text: "Error in fetchWishList : ${e.toString()}");
//   }
//   return wishList;
// }

//
//
//
//

// class HomeServices {
//   Future<List<Product>> fetchCategoryProducts(
//       {required BuildContext context, required String category}) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     List<Product> productList = [];

//     try {
//       http.Response res = await http.get(
//           Uri.parse("$uri/api/products?category=$category"),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization': '$authToken',
//           });

//       // print("res.body : ${res.body}");
//       // List listLength = jsonDecode(res.body);
//       //jsonEncode => [object] to a JSON string.
//       //jsonDecode => String to JSON object.
//       if (context.mounted) {
//         httpErrorHandle(
//           response: res,
//           context: context,
//           onSuccess: () {
//             for (int i = 0; i < jsonDecode(res.body).length; i++) {
//               productList.add(
//                 Product.fromJson(
//                   jsonEncode(
//                     jsonDecode(res.body)[i],
//                   ),
//                 ),
//               );
//               // print("\n\n\nreq.body JsonDecode${jsonDecode(res.body)}");
//             }
//           },
//         );
//       }

//       // print("Products length : ${jsonDecode(res.body).length.runtimeType}");
//     } catch (e) {
//       showSnackBar(
//           context: context,
//           text: "Following Error in fetching Products : ${e.toString()}");
//     }
//     return product;
//   }
// }
