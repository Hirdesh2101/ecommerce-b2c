import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';
import '../../../services/event_logging/analytics_events.dart';
import '../../../services/event_logging/analytics_service.dart';
import '../../../services/get_it/locator.dart';

class BuyButtons extends StatelessWidget {

  final AnalyticsService _analytics = locator<AnalyticsService>();

  final Product product;

   BuyButtons(
      {super.key,
      required this.addToCart,
      required this.buyNow, required this.product});
  final Function() addToCart;
  final Function() buyNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              _analytics.track(eventName: AnalyticsEvents.addToCart, properties: {
                "Item id":product.id
              });
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
              _analytics.track(eventName: AnalyticsEvents.buyProduct, properties: {
                "Item id":product.id
              });
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
