import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimilarProducts extends StatelessWidget {
  const SimilarProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
       const Text(
                'Similar Products',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                // maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: mq.height * .29,
                //width: mq.width,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: 10,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Card(
                    color: const Color.fromARGB(255, 254, 252, 255),
                    elevation: 2.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: mq.height * .20,
                      //width: mq.width * .5,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   ProductDetailScreen.routeName,
                          //   arguments: product,
                          // );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mq.width * .025,
                              vertical: mq.width * .02),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment:
                            //     CrossAxisAlignment.stretch,
                            children: [
                              // navigate to product details screen
                              SizedBox(
                                // color: Colors.redAccent,
                                // width: double.infinity,
                                height: mq.height * .15,
                               // width: mq.width * .4,
                                child: Image.network(
                                  // "https://rukminim1.flixcart.com/image/416/416/xif0q/computer/e/k/k/-original-imagg5jsxzthfd39.jpeg?q=70",
                                  //iphone
                                  // "https://rukminim1.flixcart.com/image/416/416/ktketu80/mobile/8/z/w/iphone-13-mlph3hn-a-apple-original-imag6vzzhrxgazsg.jpeg?q=70",
                                  //product.images[0],
                                  "https://res.cloudinary.com/dyqymg02u/image/upload/v1684299657/Fashion/Oratech%20Latest%207%20Pro%20Max/io5pohxwxngprro4dcfp.jpg",

                                  //TV
                                  // "https://rukminim1.flixcart.com/image/416/416/kiyw9e80-0/television/p/0/w/32path0011-thomson-original-imafynyvsmeuwtzr.jpeg?q=70",
                                  // width: mq.width * .2,
                                  // height: mq.height * .15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: mq.height * .005),
                              SizedBox(
                                //width: double.infinity,
                                child: Text(
                                  'hirdesh',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                //width: double.infinity,
                                // color: Colors.blueAccent,
                                child: Text(
                                  //  "₹ ${product.price.toStringAsFixed(2)}",
                                  "₹ 100",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: Colors.grey.shade200),
                                    onPressed: () {
                                      // homeServices.addToWishList(
                                      //     context: context, product: product);
                                      showSnackBar(
                                          context: context,
                                          text: "Added to WishList",
                                          onTapFunction: () {
                                            Navigator.of(context).push(
                                                GlobalVariables.createRoute(
                                                    const WishListScreen()));
                                          },
                                          actionLabel: "View");
                                    },
                                    icon: const Icon(CupertinoIcons.add,
                                        size: 18, color: Colors.black87),
                                    label: const Text("WishList",
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        // if (isProductOutOfStock) {
                                        //   showSnackBar(
                                        //       context: context,
                                        //       text: "Product is out of stock!");
                                        //   return;
                                        // } else {
                                        //   // addToCart(product.name, product);
                                        //   showSnackBar(
                                        //       context: context,
                                        //       text: "Added to Cart",
                                        //       onTapFunction: () {
                                        //         Navigator.pushNamed(context,
                                        //             CartScreen.routeName);
                                        //       },
                                        //       actionLabel: "View");
                                        // }
                                      },
                                      child: const Icon(
                                          CupertinoIcons.cart_badge_plus,
                                          size: 35)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    ],);
  }
}