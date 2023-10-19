import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';

class DetilsWidget extends StatelessWidget {
  const DetilsWidget({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          // maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Divider(thickness: 1),
        const Text(
          'Top Highlights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          // maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: mq.width * .01),
        Text(
          product.description,
          style: const TextStyle(color: Colors.black),
        ),
        SizedBox(height: mq.width * .02),
        const Text(
          'Other Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          // maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: mq.width * .01),
        for (int i = 0; i < product.detailDescription.length; i++)
          Container(
            width: mq.width,
            padding: EdgeInsets.symmetric(vertical: mq.height * 0.01,horizontal: mq.width*0.015),
            decoration: BoxDecoration(
                color: i % 2 != 0 ? Colors.blueGrey.shade50 : Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${product.detailDescription[i]['type']}",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  "${product.detailDescription[i]['value']}",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        SizedBox(height: mq.width * .02),
        const Text(
          'Warranty',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          // maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: mq.width * .01),
        Text(
          product.warranty,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
