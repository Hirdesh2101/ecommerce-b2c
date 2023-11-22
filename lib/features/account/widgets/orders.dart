import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/account/widgets/single_product.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key, required this.orders, required this.showLoader});
  final List<Order>? orders;
  final bool showLoader;

  @override
  State<Orders> createState() => _OrdersState();
}

// status == 0 Pending
// status == 1 Completed
// status == 2 Received
// status == 3 Delivered
// status == 4 Product returned back

class _OrdersState extends State<Orders> {
  // List list = [
  //   "https://images.unsplash.com/photo-1681239063386-fc4a373c927b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
  //   "https://images.unsplash.com/photo-1682006289331-19e4e0327d6d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
  //   "https://images.unsplash.com/photo-1647891940243-77a6483a152e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
  //   "https://images.unsplash.com/photo-1681926946700-73c10c72ef15?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyN3x8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60"
  // ];

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: mq.width * 0.04),
              child: const Text("Recent Orders",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            if (widget.orders != null && widget.orders!.isNotEmpty)
              InkWell(
                onTap: widget.orders == null || widget.orders!.isEmpty
                    ? null
                    : () async {
                        context.push('/orders');
                      },
                child: Container(
                  padding: EdgeInsets.only(right: mq.width * 0.04),
                  child: Text(
                    "See all",
                    style: TextStyle(
                        // fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: GlobalVariables.selectedNavBarColor),
                  ),
                ),
              ),
          ],
        ),
        widget.showLoader
            ? const ColorLoader2()
            : widget.orders!.isEmpty
                ? Column(
                    children: [
                      Image.asset("assets/images/no-orderss.png",
                          height: mq.height * .15),

                      const Text("No Orders found"),
                      SizedBox(height: mq.height * 0.02),
                      ElevatedButton(
                          onPressed: () {
                            tabProvider.setTab(0);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.deepPurpleAccent),
                          child: const Text(
                            "Keep Exploring",
                            style: TextStyle(color: Colors.white),
                          )),
                      // TextButton(
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, HomeScreen.routeName);
                      //     },
                      //     child: Text(
                      //       "Explore ",
                      //       style: TextStyle(fontSize: 20),
                      //     ))
                    ],
                  )
                : Container(
                    height: mq.height * .2,
                    padding: EdgeInsets.only(
                        left: mq.width * .025, top: mq.width * .05, right: 0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.orders!.length,
                      itemBuilder: (context, index) {
                        // debugPrint(
                        //     " $index value of container width =======> ${mq.height * 0.025}");
                        return GestureDetector(
                          onTap: () {
                            context.push('/orders',extra: widget.orders![index]);
                          },
                          child: SingleProduct(
                              image: widget.orders![index].products[0]
                                  ['product']['images'][0]),
                        );
                      },
                    ),
                  )
      ],
    );
  }
}
