import 'package:ecommerce_major_project/features/account/screens/all_orders_screen.dart';
import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/order_details/screens/return_details_screen.dart';
import 'package:ecommerce_major_project/models/returns.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/features/home/screens/home_screen.dart';
import 'package:ecommerce_major_project/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/checkout/screens/checkout_screen.dart';
import 'package:ecommerce_major_project/features/admin/screens/add_product_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/category_deals_screen.dart';
import 'package:ecommerce_major_project/features/order_details/screens/order_details_screen.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';

//all routes of the application
Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // AuthScreen
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());

    // HomeScreen
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());

    // BottomBar
    case BottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BottomBar());

    // AddProductScreen
    case AddProductScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddProductScreen());

    // CategoryDealsScreen
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CategoryDealsScreen(category: category));

    // SearchScreen
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SearchScreen(searchQuery: searchQuery));

    // ProductDetailScreen
    case ProductDetailScreen.routeName:
      var productId = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ProductDetailScreen(productId: productId));

    // CartScreen
    case CartScreen.routeName:
      // var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CartScreen());

    // AllOrdersScreen
    case AllOrdersScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AllOrdersScreen());

    // AddressScreen
    case CheckoutScreen.routeName:
      var myArguments = routeSettings.arguments as List;
      var totalAmount = myArguments[0];
      var cart = myArguments[1];
      var userProviderCart = myArguments[2];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CheckoutScreen(
          totalAmount: totalAmount,
          mycart: cart,
          userProviderCart: userProviderCart,
        ),
      );

    // OrderDetailsScreen
    case OrderDetailsScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => OrderDetailsScreen(order: order));
     case ReturnDetailsScreen.routeName:
      var returns = routeSettings.arguments as Return;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ReturnDetailsScreen(returns: returns));
    // Screen does not exist
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(child: Text("Screen does not exist!")),
        ),
      );
  }
}