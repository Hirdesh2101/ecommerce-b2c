import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key,required this.sum});
  final num sum ;

  @override
  Widget build(BuildContext context) {
    final indianRupeesFormat = NumberFormat.currency(
           name: "INR",
           locale: 'en_IN',
           decimalDigits: 0,
           symbol: '₹ ',
        );


    return Container(
      margin: EdgeInsets.all(mq.width * .025),
      child: Row(
        children: [
          const Text(
            "Subtotal ",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            indianRupeesFormat.format(sum),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
