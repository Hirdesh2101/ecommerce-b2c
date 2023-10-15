import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SimilarProducts extends StatelessWidget {
  SimilarProducts(
      {super.key, required this.product, required this.isProductOutOfStock});
  final Product product;
  final bool isProductOutOfStock;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Similar Products',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          // maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: mq.height * .32,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
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
                //height: mq.height * .70,
                width: mq.width * .5,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: product,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mq.width * .025,
                      vertical: mq.width * .012,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // navigate to product details screen
                        SizedBox(
                          height: mq.height * .2,
                          width: mq.width * .4,
                          child: Image.network(
                            product.images[0],
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: mq.height * .005),
                        Text(
                          product.brandName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: mq.height * .005),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(fontSize: 13),
                        ),
                        SizedBox(height: mq.height * .005),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: indianRupeesFormat.format(product.price),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              WidgetSpan(
                                child: SizedBox(width: mq.width * .02),
                              ),
                              TextSpan(
                                text: indianRupeesFormat.format(product.price),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              WidgetSpan(
                                child: SizedBox(width: mq.width * .02),
                              ),
                              const TextSpan(
                                text: "28% off",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   isProductOutOfStock
                            //       ? 'Out of Stock'
                            //       : productList![index]
                            //                   .quantity <
                            //               5
                            //           ? 'Only ${productList![index].quantity} left'
                            //           : '${productList![index].quantity} available',
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: GoogleFonts.lato(
                            //     fontSize: 13,
                            //     color: isProductOutOfStock
                            //         ? Colors.red
                            //         : productList![index]
                            //                     .quantity <
                            //                 5
                            //             ? Colors.amber
                            //             : Colors.green,
                            //   ),
                            // ),
                            InkWell(
                              onTap: () {
                                HomeServices().addToWishList(
                                    context: context, product: product);
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
                              child: const Icon(
                                Icons.favorite_border_rounded,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
