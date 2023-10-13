import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class DeliveyLocation extends StatelessWidget {
  const DeliveyLocation({super.key, required this.pincode});
  final String pincode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deliver to: $pincode',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'N-301, Cosmos Appartment, Magarpatta City, Pune',
                                style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //TODO: To add change address option
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                        ),
                      )
                    ],
                  ),

              SizedBox(height: mq.width * .02),
                   Row(
                children: [
                  const Icon(
                    Icons.delivery_dining_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                  SizedBox(width: mq.width * .03),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pincode == '395001' ? 'Free Delivery' : '₹120 '} | Delivery by 22 Oct, Sunday',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: (pincode == '395001'
                                  ? Colors.green
                                  : Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}