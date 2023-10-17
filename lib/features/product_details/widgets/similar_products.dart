import 'dart:math';

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
      {super.key, required this.products, required this.isProductOutOfStock});
  final List<Product>? products;
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
            itemCount: min(products!.length, 5),
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
                    Navigator.pushReplacementNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: products![index].id,
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
                            products![index].images[0],
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: mq.height * .005),
                        Text(
                          products![index].brandName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: mq.height * .005),
                        Text(
                          products![index].name,
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
                                text: indianRupeesFormat
                                    .format(products![index].price),
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
                                text: indianRupeesFormat
                                    .format(products![index].markedprice),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              WidgetSpan(
                                child: SizedBox(width: mq.width * .02),
                              ),
                              TextSpan(
                                text: "${calculatePercentageDiscount(products![index].price,products![index].markedprice)}% off",
                                style: const TextStyle(
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
                            Text(
                              isProductOutOfStock
                                  ? 'Out of Stock'
                                  : products![index].quantity < 5
                                      ? 'Only ${products![index].quantity} left'
                                      : 'In Stock',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isProductOutOfStock
                                    ? Colors.red
                                    : products![index].quantity < 5
                                        ? Colors.amber
                                        : Colors.green,
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
  int calculatePercentageDiscount(num originalPrice, num discountedPrice) {
  if (originalPrice <= 0 || discountedPrice <= 0) {
    return 0;
  }
  double discount = (originalPrice - discountedPrice) / originalPrice * 100.0;

  return discount.toInt();
}
}
