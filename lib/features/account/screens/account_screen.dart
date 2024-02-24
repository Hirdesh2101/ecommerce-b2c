import 'package:ecommerce_major_project/features/account/services/account_services.dart';
import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/ads_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/search_provider.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/account/widgets/below_app_bar.dart';
import 'package:ecommerce_major_project/features/account/widgets/orders.dart';
import 'package:ecommerce_major_project/features/account/widgets/top_buttons.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();
  bool showLoader = false;
  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  void fetchOrders() async {
    setState(() {
      showLoader = true;
    });
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      ],
      child: Scaffold(
        appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
          title: "Your Account",
          //onClickSearchNavigateTo: const MySearchScreen()
        ),
        body: Column(
          children: [
            SizedBox(height: mq.width * .025),
            const BelowAppBar(),
            SizedBox(height: mq.width * .025),
            TopButtons(
              orders: orders,
            ),
            SizedBox(height: mq.width * .045),
            Orders(orders: orders, showLoader: showLoader),
          ],
        ),
      ),
    );
  }
}
