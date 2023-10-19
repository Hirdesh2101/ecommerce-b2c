import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';

class WishListProduct extends StatefulWidget {
  final int index;
  final Product product;
  const WishListProduct({required this.index, super.key,required this.product});

  @override
  State<WishListProduct> createState() => _WishListProductState();
}

class _WishListProductState extends State<WishListProduct> {
  ProductDetailServices productDetailServices = ProductDetailServices();
  final HomeServices homeServices = HomeServices();
  final indianRupeesFormat = NumberFormat.currency(
           name: "INR",
           locale: 'en_IN',
           decimalDigits: 0,
           symbol: '₹ ',
        );

  void removeProduct(Product product) {
    homeServices.removeFromWishList(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    // fetching the particular product

    return Container(
      margin: EdgeInsets.fromLTRB(mq.width * .025, 0, mq.width * .04, 0),
      child: Row(
        children: [
          // image
          Image.network(
            widget.product.images[0],
            fit: BoxFit.contain,
            height: mq.width * .26,
            width: mq.width * .26,
          ),
          // description
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                ),
                Text(
                 indianRupeesFormat.format(widget.product.varients[0]['price']),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO Add new button
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (widget.product.totalQuantity == 0) {
                    //       showSnackBar(
                    //           context: context, text: "Product out of stock");
                    //     } else {
                    //       productDetailServices.addToCart(
                    //           context: context, product: widget.product);
                    //       showSnackBar(
                    //         context: context,
                    //         text: "Added to cart",
                    //         actionLabel: "View Cart",
                    //         onTapFunction: () {
                    //           Navigator.pushNamed(
                    //               context, CartScreen.routeName);
                    //         },
                    //       );
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     elevation: 1,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //         side: const BorderSide(
                    //             color: Colors.black, width: 0.4)),
                    //     backgroundColor: Colors.deepPurple,
                    //   ),
                    //   child: const Text(
                    //     "Add to cart",
                    //     style: TextStyle(color: Colors.white, fontSize: 13),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        HomeServices().removeFromWishList(
                            context: context, product: widget.product);
                      },
                      child: const Icon(
                        IconlyBold.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
