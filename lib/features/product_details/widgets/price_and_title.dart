import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';

import 'package:flutter/material.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice(
      {super.key,
      required this.product,
      required this.avgRating,
      required this.isProductOutOfStock});
  final Product product;
  final double avgRating;
  final bool isProductOutOfStock;

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
                        text: "₹${product.price.toStringAsFixed(2)}",
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
                        text: "₹${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
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
}
