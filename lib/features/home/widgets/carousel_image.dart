import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_major_project/features/home/providers/ads_provider.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    final carouselAds = context.watch<AdsProvider>().ads;
    return CarouselSlider(
      items: carouselAds.map((individaulAd) {
        return Builder(
          builder: (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: mq.height * .025),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  individaulAd.image,
                  fit: BoxFit.cover,
                  height: mq.width * .48,
                )),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),

        // aspectRatio: 16 / 9,
        autoPlayCurve: Curves.easeInOutCubic,

        scrollPhysics: const ClampingScrollPhysics(),
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        viewportFraction: 1,
        height: kIsWeb ? mq.height*0.2 : mq.width * .4,
      ),
    );
  }
}
