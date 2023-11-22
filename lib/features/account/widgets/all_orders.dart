import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllOrdersList extends StatelessWidget {
  const AllOrdersList({super.key,required this.allOrders});
  final List<Order>? allOrders;
  static final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    return Column(
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
                            tabProvider.setTab(0);
                            context.go('/home');
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
                            context.push('/orders',extra: allOrders![index]);
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
                                                        text:allOrders![index]
                                                            .id))
                                                .then((_) => showSnackBar(
                                                    context: context,
                                                    text: "Copied!"));
                                          },
                                          child:
                                              const Icon(Icons.copy, size: 17))
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    for (int j = 0;
                                        j <
                                            allOrders![index].products
                                                .length;
                                        j++)
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: mq.height * .01,
                                            horizontal: mq.width * .025),
                                        child: Row(
                                          children: [
                                            // image
                                            Image.network(
                                              allOrders![index]
                                                      .products[j]['product']
                                                  ['images'][0],
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
                                                        ['product']['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Container(
                                                  width: mq.width * .57,
                                                  padding: EdgeInsets.only(
                                                    left: mq.width * .025,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Color:",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 11),
                                                        maxLines: 2,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left:
                                                                mq.width * .01),
                                                        width: mq.width * .025,
                                                        height: mq.width * .025,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color(int.parse(
                                                             
                                                              '${allOrders![index].products[j]['color']}')),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      mq.width *
                                                                          .025),
                                                          child: Text(
                                                            "Size: ${allOrders![index].products[j]['size']}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 11),
                                                            maxLines: 2,
                                                          )),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      mq.width *
                                                                          .025),
                                                          child: Text(
                                                            "Quantity: x${allOrders![index].products[j]['quantity']}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 11),
                                                            maxLines: 2,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: mq.width * .57,
                                                  padding: EdgeInsets.only(
                                                      left: mq.width * .025,
                                                      top: mq.width * .0125),
                                                  child: Text(
                                                      "Item Value  : ${indianRupeesFormat.format(allOrders![index].products[j]['price'])}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14)),
                                                ),
                                                Container(
                                                  width: mq.width * .57,
                                                  padding: EdgeInsets.only(
                                                    left: mq.width * .025,
                                                  ),
                                                  child: Text(
                                                      "Ordered At  : ${DateFormat('yMMMd').format(DateTime.fromMillisecondsSinceEpoch(allOrders![index].orderedAt))}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14)),
                                                ),
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
    );
  }
}
