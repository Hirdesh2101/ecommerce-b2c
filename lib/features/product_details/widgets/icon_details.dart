import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class DetailsWithICons extends StatelessWidget {
  const DetailsWithICons({super.key,required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconAndText(context, IconlyBold.swap, product.returnPolicy['title'],
            product.returnPolicy['details'],
            color: Colors.red),
        iconAndText(context, IconlyBold.shield_done, product.warranty['title'],
            product.warranty['details'],
            color: Colors.green),
        iconAndText(context, IconlyBold.star, 'Popular',
            'Popular item in this category.',
            color: Colors.amber),
      ],
    );
  }

  Widget iconAndText(
      BuildContext context, IconData iconData, String title, String description,
      {Color color = Colors.black}) {
    return Flexible(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (bottomSheetContext) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            iconData,
                            color: color,
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: const Icon(Icons.close_rounded, size: 28),
                          ),
                        ],
                      ),
                      SizedBox(height: mq.width * .01),
                      const Divider(thickness: 2),
                      SizedBox(height: mq.width * .03),
                      SizedBox(
                        height: mq.height * .1,
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Column(
          children: [
            Icon(iconData, size: 30, color: color),
            SizedBox(height: mq.width * .01),
            Text(
              title,
              style: TextStyle(
                  fontSize: 10,
                  overflow: TextOverflow.ellipsis,
                  color: color,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
