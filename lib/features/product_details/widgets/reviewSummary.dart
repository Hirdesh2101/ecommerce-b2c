import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewUI extends StatelessWidget {
  final String image, name, date, comment;
  final double rating;
  final Function onTap, onPressed;
  final bool isLess;
  const ReviewUI({
    Key? key,
    required this.image,
    required this.name,
    required this.date,
    required this.comment,
    required this.rating,
    required this.onTap,
    required this.isLess,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding:  const EdgeInsets.only(left:10.0),
          leading: Container(
            height: mq.width * 0.08,
            width: mq.width * 0.08,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(44.0),
            ),
            // child:  Image.network(
            //  image,
            //   fit: BoxFit.cover,
            // ),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            date,
            style: TextStyle(fontSize: 14.0),
          ),
          trailing: IconButton(
            onPressed: () => onPressed,
            icon: const Icon(Icons.more_vert),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBarIndicator(
                rating: rating,
                itemSize: 18,
                unratedColor: const Color(0xFFEEEEEE),
                itemBuilder: (context, index) {
                  return const Icon(Icons.star, color: Colors.amber);
                },
              ),
              GestureDetector(
                onTap: () => onTap,
                child: Text(
                        comment,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const Divider(thickness: 1),
            ],
          ),
        ),
      ],
    );
  }
}
