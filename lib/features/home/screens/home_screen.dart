import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/ads_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/search_provider.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/screens/top_categories.dart';
import 'package:provider/provider.dart';

class HomeScreenProvider extends StatelessWidget {
  const HomeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => FilterProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TabProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AdsProvider(),
          ),
        ], child: const HomeScreen(),);
  }
}
class HomeScreen extends StatelessWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
        ),
        body: const TopCategories(),
      ),
    );
  }
}
