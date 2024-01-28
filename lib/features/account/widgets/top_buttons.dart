// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/features/account/widgets/account_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../services/event_logging/analytics_events.dart';
import '../../../services/event_logging/analytics_service.dart';
import '../../../services/get_it/locator.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({Key? key, required this.orders}) : super(key: key);
  final List<Order>? orders;

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {

  final AnalyticsService _analytics = locator<AnalyticsService>();

  // final List<String> buttonNames = [
  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    final authService = Provider.of<AuthService>(context);
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
                text: "Your Orders",
                onTap: () {
                  _analytics.track(eventName: AnalyticsEvents.yourOrders, properties: {
                    "Your Orders Page":"Your orders page has opened successfully"
                  });
                  String currentPath = getCurrentPathWithoutQuery(context);
                  context.go('$currentPath/orders');
                }),
            AccountButton(
                text: "Your Wishlist",
                onTap: () {
                  _analytics.track(eventName: AnalyticsEvents.yourOrders, properties: {
                    "Your wishlist Page":"Your wishlist page has opened successfully"
                  });
                  String currentPath = getCurrentPathWithoutQuery(context);
                  context.go('$currentPath/wishlist');
                }),
          ],
        ),
        SizedBox(height: mq.height * .01),
        Row(
          children: [
            AccountButton(
                text: "Cart",
                onTap: () {
                  _analytics.track(eventName: AnalyticsEvents.cart, properties: {
                    "Cart":"Cart has opened successfully"
                  });
                  tabProvider.setTab(2);
                  context.go('/cart');
                }),
            AccountButton(
                text: "Log out", onTap: () {
              _analytics.track(eventName: AnalyticsEvents.logOut, properties: {
                "LogOut":"User has logged out successfully"
              });
              authService.logOut(context);
            }),
          ],
        )
      ],
    );
  }
}




// Using GridView
/*
// import 'package:ecommerce_major_project/main.dart';
// import 'package:flutter/material.dart';

// class TopButtons extends StatefulWidget {
//   const TopButtons({super.key});

//   @override
//   State<TopButtons> createState() => _TopButtonsState();
// }

// class _TopButtonsState extends State<TopButtons> {
//   List<String> buttonNames = [
//     "Your Orders",
//     "Turn Seller",
//     "Log out",
//     "Your Wishlist"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: mq.width * .03),
//         child: GridView(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: mq.width * 0.04,
//             mainAxisSpacing: mq.width * 0.015,
//             childAspectRatio: 3.4,
//           ),
//           children: [
//             for (int index = 0; index < 4; index++)
//               InkWell(
//                 onTap: () {},
//                 child: Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Container(
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Colors.grey, width: 1),
//                     ),
//                     child: Text(
//                       buttonNames[index],
//                       style: const TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
*/

