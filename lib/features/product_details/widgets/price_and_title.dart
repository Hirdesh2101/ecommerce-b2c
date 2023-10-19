import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleAndPrice extends StatelessWidget {
  TitleAndPrice(
      {super.key,
      required this.product,
      required this.avgRating,
      required this.colorVarient,
      required this.isProductOutOfStock});
  final Product product;
  final double avgRating;
  final bool isProductOutOfStock;
  final int colorVarient;
  final indianRupeesFormat = NumberFormat.currency(
           name: "INR",
           locale: 'en_IN',
           decimalDigits: 0,
           symbol: '₹ ',
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                product.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: mq.height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("${avgRating.toStringAsFixed(2)} ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.star, color: Colors.yellow.shade600),
                // SizedBox(width: mq.width * .01),
                Text(
                  "(${product.rating!.length} Reviews)",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            isProductOutOfStock
                ? const Text(
                    "Out of Stock",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.w600),
                  )
                : const Text("In Stock", style: TextStyle(color: Colors.teal)),
          ],
        ),
        SizedBox(height: mq.height * .02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: indianRupeesFormat.format(product.varients[colorVarient]['price']),
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: mq.width * .02),
                      ),
                      TextSpan(
                        text: indianRupeesFormat.format(product.varients[colorVarient]['markedprice']),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: mq.width * .02),
                      ),
                      TextSpan(
                        text: "${calculatePercentageDiscount(product.varients[colorVarient]['price'],product.varients[colorVarient]['markedprice'])}% off",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: mq.width * .05),
          ],
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
