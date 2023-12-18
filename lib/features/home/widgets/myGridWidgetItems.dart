import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/utils.dart';
import '../../../main.dart';
import '../../../models/product.dart';
import '../../../providers/tab_provider.dart';
import '../services/home_services.dart';

class GridWidgetItems extends StatelessWidget {
  final Product product;
  final bool isProductWishListed;
  GridWidgetItems({required this.product,required this.isProductWishListed,super.key});


  int calculatePercentageDiscount(num originalPrice, num discountedPrice) {
    if (originalPrice <= 0 || discountedPrice <= 0) {
      return 0;
    }
    double discount = (originalPrice - discountedPrice) / originalPrice * 100.0;

    return discount.toInt();
  }

// tabbar variables
  int activeTabIndex = 0;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );


  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // navigate to product details screen
          Stack(children: [
            SizedBox(
              height: mq.height * .24,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.images[0],
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: mq.height * .0165,
                width: mq.width * .17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    "EXCLUSIVE",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                        fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: mq.height * 0.182,
              left: mq.width * 0.372,
              child: Container(
                height: mq.height * .07,
                width: mq.width * .07,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white),
                child: InkWell(
                  onTap: () {
                    if (isProductWishListed) {
                      HomeServices().removeFromWishList(
                          context: context, product: product);
                      showSnackBar(
                        context: context,
                        text: "Removed from WishList",
                      );
                    } else {
                      HomeServices().addToWishList(
                          context: context, product: product);
                      showSnackBar(
                        context: context,
                        text: "Added to WishList",
                        onTapFunction: () {
                          final tabProvider =
                          Provider.of<TabProvider>(
                              context,
                              listen: false);
                          tabProvider.setTab(3);
                          context.go('/account/wishlist');
                        },
                        actionLabel: "View",
                      );
                    }
                  },
                  child: Center(
                    child: Icon(
                      isProductWishListed
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: isProductWishListed
                          ? Colors.pink
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(height: mq.height * .005),
          Text(
            product.brandName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: mq.height * .005),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
                fontSize: 13, color: Colors.black54),
          ),
          SizedBox(height: mq.height * .005),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: indianRupeesFormat
                      .format(product.varients[0]['price']),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                WidgetSpan(
                  child: SizedBox(width: mq.width * .02),
                ),
                TextSpan(
                  text: indianRupeesFormat.format(
                      product.varients[0]['markedPrice']),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                WidgetSpan(
                  child: SizedBox(width: mq.width * .02),
                ),
                TextSpan(
                  text:
                  "${calculatePercentageDiscount(
                      product.varients[0]['price'],
                      product.varients[0]['markedPrice'])}% off",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}

