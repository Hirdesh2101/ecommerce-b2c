import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewUI extends StatelessWidget {
  final String image, name, date, comment;
  final double rating;
  final Function onTap, onPressed;
  final bool isLess;
  const ReviewUI({
    super.key,
    required this.image,
    required this.name,
    required this.date,
    required this.comment,
    required this.rating,
    required this.onTap,
    required this.isLess,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
late Size mq = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 10.0),
          leading: ClipOval(
              child: Image.network(image ==""?
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnWaCAfSN08VMtSjYBj0QKSfHk4-fjJZCOxgHLPuBSAw&s":image,
                  width: mq.width * 0.08,
                  height: mq.width * 0.08,
                  fit: BoxFit.cover)),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
         DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(date))),
            style: const TextStyle(fontSize: 14.0),
          ),
          trailing: IconButton(
            onPressed: () => onPressed,
            icon: const Icon(Icons.more_vert),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
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
