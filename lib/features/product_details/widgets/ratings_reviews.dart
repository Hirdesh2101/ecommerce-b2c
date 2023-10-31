import 'dart:math';

import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/rating_summary.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/reviewsummary.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllRatings extends StatefulWidget {
  const AllRatings({
    super.key,
    required this.myRating,
    required this.product,
    required this.avgRating,
    this.counterFiveStars = 0,
    this.counterFourStars = 0,
    this.counterThreeStars = 0,
    this.counterTwoStars = 0,
    this.counterOneStars = 0,
  });
  final num myRating;
  final Product product;
  final double avgRating;
  final int counterFiveStars;
  final int counterFourStars;
  final int counterThreeStars;
  final int counterTwoStars;
  final int counterOneStars;

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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
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
          child: RatingSummary(
            counter: widget.product.rating!.length,
            average: widget.avgRating,
            showAverage: true,
            counterFiveStars: widget.counterFiveStars,
            counterFourStars: widget.counterFourStars,
            counterThreeStars: widget.counterThreeStars,
            counterTwoStars: widget.counterTwoStars,
            counterOneStars: widget.counterOneStars,
          ),
        ),
        SizedBox(height: mq.width * .05),
        InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (context) {
                return rateProductDialog();
              }),
          child: Container(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
        ),
        SizedBox(height: mq.width * .04),
        for (int i = 0; i < min(widget.product.rating!.length, 4); i++)
          ReviewUI(
            image: widget.product
                    .ratinguser![widget.product.ratinguser!.length - i - 1]
                ['imageUrl'],
            name: widget.product
                .ratinguser![widget.product.ratinguser!.length - i - 1]['name'],
            date: widget.product.rating![i].createdAt!,
            comment: widget.product.rating![i].review ?? '',
            rating: widget.product.rating![i].rating.toDouble(),
            onPressed: () => {},
            onTap: () => setState(() {
              isMore = !isMore;
            }),
            isLess: isMore,
          )
      ],
    );
  }

  AlertDialog rateProductDialog() {
    TextEditingController controller = TextEditingController();
    double rating = 0;
    return AlertDialog(
      title: const Text(
        "Drag your finger to rate",
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBar.builder(
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
              return const Icon(Icons.star,
                  color: GlobalVariables.secondaryColor);
            },
            //changes here
            onRatingUpdate: (rate) {
              setState(() {
                rating = rate;
              });
            },
          ),
          SizedBox(height: mq.width * .05),
          const Text('Write a review'),
          TextField(
            controller: controller,
          )
        ],
      ),
      // contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () {
              if (rating == 0 && controller.text.trim() == "") {
                showSnackBar(
                  context: context,
                  text: "Please add rating!",
                );
              } else {
                productDetailServices.rateProduct(
                  context: context,
                  product: widget.product,
                  rating: rating,
                  review: controller.text.trim(),
                );
              }
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
