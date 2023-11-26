import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/account/services/account_services.dart';
import 'package:ecommerce_major_project/features/account/widgets/all_orders.dart';
import 'package:ecommerce_major_project/features/account/widgets/all_refunds.dart';
import 'package:ecommerce_major_project/models/returns.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/models/order.dart';

class AllOrdersScreen extends StatefulWidget {
  static const String routeName = '/all-orders-screen';
  const AllOrdersScreen({
    Key? key,
  }) : super(key: key);
  static final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final AccountServices accountServices = AccountServices();
  int activeTabIndex = 0;
  bool showLoader = false;
  List<Order>? orders = [];
  List<Return>? returns = [];
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
  void fetchReturns() async {
    setState(() {
      showLoader = true;
    });
    returns = await accountServices.fetchMyReturns(context: context);
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          title: "All Orders & Returns",
          context: context,
         // onClickSearchNavigateTo: const MySearchScreen()
          ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              onTap: (index) {
                setState(() {
                  activeTabIndex = index;
                });
                if (activeTabIndex == 1) {
                  fetchReturns();
                } else {
                  fetchOrders();
                }
              },
              physics: const BouncingScrollPhysics(),
              splashBorderRadius: BorderRadius.circular(15),
              indicatorWeight: 4,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              tabs: const [
                Tab(
                  child: Text(
                    'Orders',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Returns',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                  //physics: const NeverScrollableScrollPhysics(),
                  children: [
                    showLoader
                        ? const ColorLoader2()
                        : AllOrdersList(allOrders: orders),
                    showLoader
                        ? const ColorLoader2()
                        : AllReturnsList(allOrders: returns),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
