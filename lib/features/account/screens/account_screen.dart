import 'package:ecommerce_major_project/features/account/services/account_services.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/account/widgets/below_app_bar.dart';
import 'package:ecommerce_major_project/features/account/widgets/orders.dart';
import 'package:ecommerce_major_project/features/account/widgets/top_buttons.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';

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
    super.initState();
    fetchOrders();
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
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
          title: "Your Account",
          onClickSearchNavigateTo: MySearchScreen()),
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
    );
  }
}
