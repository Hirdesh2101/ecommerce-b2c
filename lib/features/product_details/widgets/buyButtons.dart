import 'package:flutter/material.dart';

class BuyButtons extends StatelessWidget {
  const BuyButtons(
      {super.key,
      required this.addToCart,
      required this.buyNow});
  final Function() addToCart;
  final Function() buyNow;

  @override
  Widget build(BuildContext context) {
late Size mq = MediaQuery.of(context).size;
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              addToCart();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade800,
                minimumSize: Size(mq.width * .95, mq.height * .06),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: mq.width * .02),
        Center(
          child: ElevatedButton(
            onPressed: () {
              buyNow();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                minimumSize: Size(mq.width * .95, mq.height * .06),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: const Text(
              "Buy Now",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
