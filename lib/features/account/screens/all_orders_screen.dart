import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/order_details/screens/order_details_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';

class AllOrdersScreen extends StatelessWidget {
  static const String routeName = '/all-orders-screen';
  final List<Order>? allOrders;
  const AllOrdersScreen({
    Key? key,
    this.allOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          title: "All Orders",
          context: context,
          onClickSearchNavigateTo: MySearchScreen()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const AddressBox(),
          // SizedBox(height: mq.width * .025),

          Expanded(
            child: allOrders != null && allOrders!.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/no-orderss.png",
                            height: mq.height * .15),
                
                        const Text("No Orders found"),
                        SizedBox(height: mq.height * 0.02),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, BottomBar.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.deepPurpleAccent),
                            child: const Text(
                              "Keep Exploring",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: allOrders!.length,
                    itemBuilder: (context, index) {
                      // print(
                      //     "\n -------------------> ALL ORDERS  : ${allOrders![index].products[index]}");
                      return Padding(
                        padding: EdgeInsets.only(
                          top: mq.height * .01,
                        ),
                        child: Card(
                          color: const Color.fromARGB(255, 245, 239, 255),
                          margin:
                              EdgeInsets.symmetric(horizontal: mq.width * .02),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(width: .2)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailsScreen.routeName,
                                arguments: allOrders![index],
                              );
                              // Navigator.pushNamed(
                              //     context, ProductDetailScreen.routeName,
                              //     arguments: allOrders![index]);
                              Navigator.pushNamed(
                                  context, OrderDetailsScreen.routeName);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    // color: Colors.deepOrange,
                                    margin: EdgeInsets.only(
                                        top: mq.height * .01,
                                        right: mq.height * .01),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.deepPurple.shade800,
                                              borderRadius:
                                                  BorderRadius.circular(10)),

                                          // elevation: 2,
                                          // alignment: Alignment.topRight,
                                          child: Text(
                                            "Order ID : ${allOrders![index].id}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                        SizedBox(width: mq.height * .01),
                                        InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              allOrders![index]
                                                                  .id))
                                                  .then((_) => showSnackBar(
                                                      context: context,
                                                      text: "Copied!"));
                                            },
                                            child: const Icon(Icons.copy,
                                                size: 17))
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      for (int j = 0;
                                          j < allOrders![index].products.length;
                                          j++)
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: mq.width * .025),
                                          child: Row(
                                            children: [
                                              // image
                                              Image.network(
                                                allOrders![index]
                                                    .products[j]
                                                    .images[0],
                                                // allOrders![index].products[index].images[0],
                                                fit: BoxFit.contain,
                                                height: mq.width * .25,
                                                width: mq.width * .25,
                                              ),
                                              // description
                                              Column(
                                                children: [
                                                  Container(
                                                    width: mq.width * .57,
                                                    padding: EdgeInsets.only(
                                                        left: mq.width * .025,
                                                        top: mq.width * .0125),
                                                    child: Text(
                                                      allOrders![index]
                                                          .products[j]
                                                          .name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   width: mq.width * .57,
                                                  //   padding: EdgeInsets.only(
                                                  //       left: mq.width * .025, top: mq.width * .0125),
                                                  //   //here is the static rating
                                                  //   child: Stars(rating: avgRating),
                                                  // ),
                                                  Container(
                                                    width: mq.width * .57,
                                                    padding: EdgeInsets.only(
                                                        left: mq.width * .025,
                                                        top: mq.width * .0125),
                                                    child: Text(
                                                        "Ordered At  : ${DateFormat('yMMMd').format(DateTime.fromMillisecondsSinceEpoch(allOrders![index].orderedAt))}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14)),
                                                  ),
                                                  // Container(
                                                  //   width: mq.width * .57,
                                                  //   padding: EdgeInsets.only(left: mq.width * .025),
                                                  //   child: Text("Eligible for free shipping"),
                                                  // ),
                                                  // Container(
                                                  //   width: mq.width * .57,
                                                  //   padding: EdgeInsets.only(
                                                  //       left: mq.width * .025, top: mq.width * .0125),
                                                  //   child: product.quantity == 0
                                                  //       ? const Text(
                                                  //           "Out of Stock",
                                                  //           style: TextStyle(color: Colors.redAccent),
                                                  //           maxLines: 2,
                                                  //         )
                                                  //       : const Text(
                                                  //           "In Stock",
                                                  //           style: TextStyle(color: Colors.teal),
                                                  //           maxLines: 2,
                                                  //         ),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: mq.height * .01,
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),

                                  // Divider(color: Colors.grey, thickness: mq.height * .001)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
