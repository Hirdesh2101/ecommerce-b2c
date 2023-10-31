import 'dart:convert';

import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/ads_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
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
        // 
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              // 
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
        // 
        // 
        // 
      }
    } catch (e) {
     if (context.mounted) {
       showSnackBar(
          context: context,
          text: "Following Error in fetching Products [home]: $e");
     }
    }
    return productList;
  }

  Future<void> fetchCategory(
      {required BuildContext context}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    String tokenValue = '$authToken';
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenValue,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            categoryProvider.setCategories(data);
            categoryProvider.setTab(data.length);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: "Following Error in fetching Products [home]: $e");
      }
    }
  }
  Future<void> fetchAdvertisement(
      {required BuildContext context}) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    String tokenValue = '$authToken';
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/advertisement'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenValue,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            adsProvider.setAds(data);
          },
        );
      }
    } catch (e) {
     if (context.mounted) {
       showSnackBar(
          context: context,
          text: "Following Error in fetching Products [home]: $e");
     }
    }
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
      category: '',
      detailDescription: [],
      varients: [],
      warranty: {},
      returnPolicy: {},
      totalQuantity: 0,
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
            //   // 
            //   // productList.add(Product.fromJson(item));
            //   product = Product.fromJson(item);
            // }

            // var data = jsonDecode(res.body);
            product = Product.fromJson(jsonDecode(res.body));
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: "Following Error in fetching deal-of-the-day : $e");
      }
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
              // 
              productNames.add(item);
            }
          },
        );
      }
    } catch (e) {
     if (context.mounted) showSnackBar(context: context, text: e.toString());
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
              // 
              productList.add(item['name']);
            }

            //searchProvider.addListToSuggestions(productList);
          },
        );
      }
    } catch (e) {
      if (context.mounted)showSnackBar(context: context, text: e.toString());
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
            
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context, text: "Error in addToHistory ${e.toString()}");
      }
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
      if (context.mounted) {
        showSnackBar(
          context: context,
          text: "Error in delete search history item ${e.toString()}");
      }
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
              // 
              searchHistoryList.add(item);
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted)showSnackBar(context: context, text: e.toString());
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
      

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // 
            
            User user = userProvider.user
                .copyWith(wishList: jsonDecode(res.body)['wishList']);
            userProvider.setUserFromModel(user);
            
          },
        );
      }
    } catch (e) {
      debugPrint("\n========>Inside the catch block");
      if (context.mounted)showSnackBar(context: context, text: e.toString());
    }
  }

  Future<void> removeFromWishList({
    required BuildContext context,
    required Product product,
  }) async {
    
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
            
            User user = userProvider.user
                .copyWith(wishList: jsonDecode(res.body)['wishList']);
            userProvider.setUserFromModel(user);
            
          },
        );
      }
    } catch (e) {
      
      if (context.mounted)showSnackBar(context: context, text: e.toString());
    }
  }

  Future<List<Product>?> fetchWishList(BuildContext context) async {
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Product>? wishList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/get-wishList'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i=0;i<data.length;i++) {
              wishList.add(Product.fromJson(data[i]));
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context, text: "Error in fetchWishList : ${e.toString()}");
      }
    }
    return wishList;
  }
  Future<List<Map<String,dynamic>>?> fetchCart(BuildContext context) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    List<Map<String,dynamic>>? cart = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/get-cart'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$authToken',
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            cart = List.from(data['data']);
            
            cartProvider.setCartFromDynamic(data['data']);

          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context, text: "Error in Cart : ${e.toString()}");
      }
    }
    return cart;
  }
}


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

//       // 
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
//               // 
//             }
//           },
//         );
//       }

//       // 
//     } catch (e) {
//       showSnackBar(
//           context: context,
//           text: "Following Error in fetching Products : ${e.toString()}");
//     }
//     return product;
//   }
// }
