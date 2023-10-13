import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/rating_summary.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/reviewSummary.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllRatings extends StatefulWidget {
  const AllRatings({super.key,required this.myRating,required this.product});
  final num myRating;
  final Product product;

  @override
  State<AllRatings> createState() => _AllRatingsState();
}

class _AllRatingsState extends State<AllRatings> {

  final ProductDetailServices productDetailServices = ProductDetailServices();
  bool isMore = false;
  @override
  Widget build(BuildContext context) {
    return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rating & Reviews',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                        // maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text("Rate the Product",
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return rateProductDialog();
                                });
                          }),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.02),
                    child: const RatingSummary(
                      counter: 13,
                      average: 3.846,
                      showAverage: true,
                      counterFiveStars: 5,
                      counterFourStars: 4,
                      counterThreeStars: 2,
                      counterTwoStars: 1,
                      counterOneStars: 1,
                    ),
                  ),
                  SizedBox(height: mq.width * .05),
                  Container(
                    width: mq.width,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black38)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Write a review',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                          // maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(
                          CupertinoIcons.right_chevron,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: mq.width * .04),
                  for (int i = 0; i < 4; i++)
                    ReviewUI(
                      image:
                          "https://res.cloudinary.com/dyqymg02u/image/upload/v1684299657/Fashion/Oratech%20Latest%207%20Pro%20Max/io5pohxwxngprro4dcfp.jpg",
                      name: 'Hirdesh',
                      date: '20-10-2022',
                      comment: 'nice product',
                      rating: 5,
                      onPressed: () => print("More Action "),
                      onTap: () => setState(() {
                        isMore = !isMore;
                      }),
                      isLess: isMore,
                    )
                ],
              );
  }

  AlertDialog rateProductDialog() {
    return AlertDialog(
      title: const Text(
        "Drag your finger to rate",
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
      ),
      content: RatingBar.builder(
        itemSize: 30,
        glow: true,
        glowColor: Colors.yellow.shade900,
        //rating given by user
        initialRating: double.parse(widget.myRating.toString()),
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemPadding: EdgeInsets.symmetric(horizontal: mq.width * .0125),
        itemCount: 5,
        itemBuilder: (context, _) {
          return const Icon(Icons.star, color: GlobalVariables.secondaryColor);
        },
        //changes here
        onRatingUpdate: (rating) {
          productDetailServices.rateProduct(
            context: context,
            product: widget.product,
            rating: rating,
          );
        },
      ),
      // contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Rate",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }
}