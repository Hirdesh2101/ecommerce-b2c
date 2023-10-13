import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class DetailsWithICons extends StatelessWidget {
  const DetailsWithICons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconAndText(context, IconlyBold.swap, '7 Days Return',
            '7 days return of product in case of Defective item, physical damage, wrong item or missing item.',
            color: Colors.red),
        iconAndText(context, IconlyBold.shield_done, '1 Year Warranty',
            "1 Year warranty on the item in case of internal manufacturing issue.",
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
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close_rounded, size: 28),
                          ),
                        ],
                      ),
                      SizedBox(height: mq.width * .01),
                      const Divider(thickness: 2),
                      SizedBox(height: mq.width * .03),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
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
