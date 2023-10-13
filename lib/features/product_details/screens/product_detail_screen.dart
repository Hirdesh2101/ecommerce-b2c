// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/rating_summary.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/reviewSummary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-details';
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailServices productDetailServices = ProductDetailServices();

  num myRating = 0.0;
  double avgRating = 0.0;
  int currentIndex = 0;
  bool isMore = false;

  String pincode = '395001';

  @override
  void initState() {
    super.initState();
    double totalRating = 0.0;

    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      //showing our own rating in the product details page
      //overall rating will be avgRating but
      //when we see a particular product we will be able to see
      //our given rating, i.e.  myRating
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    //make sure to pass the arguments here!

    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    debugPrint("Triggered add to cart <====");
    debugPrint("Product is  : ${widget.product.name}");
    productDetailServices.addToCart(context: context, product: widget.product);
    debugPrint("Execution finished add to cart <====");
  }

  @override
  Widget build(BuildContext context) {
    bool isProductOutOfStock = widget.product.quantity == 0;
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context, onClickSearchNavigateTo: const MySearchScreen()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .03)
              .copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: mq.height * .52,
                        child: PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (value) {
                              setState(() {
                                currentIndex = value;
                              });
                            },
                            itemCount: widget.product.images.length,
                            // physics: PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              // print("............index = $index");

                              return Builder(
                                builder: (context) => InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        barrierColor:
                                            Colors.black.withOpacity(0.7),
                                        barrierDismissible: true,
                                        pageBuilder:
                                            (BuildContext context, _, __) {
                                          return InteractiveViewer(
                                            child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(10),
                                              child: SafeArea(
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Image.network(
                                                          widget.product
                                                              .images[index],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 8, 0, 0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Icon(
                                                          Icons.close_rounded,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: mq.height * .05),
                                    child: Image.network(
                                        widget.product.images[index],
                                        fit: BoxFit.contain,
                                        height: mq.width * .3),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: mq.height * 0.02,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            HomeServices().addToWishList(
                                context: context, product: widget.product);
                            showSnackBar(
                                context: context,
                                text: "Added to WishList",
                                onTapFunction: () {
                                  Navigator.of(context).push(
                                      GlobalVariables.createRoute(
                                          const WishListScreen()));
                                },
                                actionLabel: "View");
                          },
                          child: const Icon(
                            Icons.favorite_border_rounded,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showSnackBar(
                                context: context,
                                text:
                                    "Share feature yet to be implemented using deep links");
                          },
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: mq.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: mq.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${avgRating.toStringAsFixed(2)} ",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.star, color: Colors.yellow.shade600),
                      // SizedBox(width: mq.width * .01),
                      Text(
                        "(1.8K Reviews)",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  isProductOutOfStock
                      ? const Text(
                          "Out of Stock",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600),
                        )
                      : const Text("In Stock",
                          style: TextStyle(color: Colors.teal)),
                ],
              ),
              SizedBox(height: mq.height * .01),
              SizedBox(height: mq.width * .025),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "₹${widget.product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: mq.width * .02),
                            ),
                            TextSpan(
                              text:
                                  "₹${widget.product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: mq.width * .02),
                            ),
                            const TextSpan(
                              text: "28% off",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: mq.width * .05),
                ],
              ),
              SizedBox(height: mq.width * .03),
              const Divider(thickness: 2),
              SizedBox(height: mq.width * .03),
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
              SizedBox(height: mq.width * .07),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (isProductOutOfStock) {
                      showSnackBar(
                          context: context, text: "Product is out of stock!");
                      return;
                    } else {
                      addToCart();
                      showSnackBar(
                          context: context,
                          text: "Added to Cart",
                          onTapFunction: () {
                            Navigator.pushNamed(context, CartScreen.routeName);
                          },
                          actionLabel: "View");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade800,
                      minimumSize: Size(mq.width * .95, mq.height * .06),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: mq.width * .02),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (isProductOutOfStock) {
                      showSnackBar(
                          context: context, text: "Product is out of stock!");
                      return;
                    } else {
                      // addToCart();
                      showSnackBar(
                          context: context,
                          text: "Need to redirect",
                          onTapFunction: () {
                            Navigator.pushNamed(context, CartScreen.routeName);
                          },
                          actionLabel: "View");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade800,
                      minimumSize: Size(mq.width * .95, mq.height * .06),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: mq.width * .03),
              const Divider(thickness: 1),
              SizedBox(height: mq.width * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  iconAndText(IconlyBold.swap, '7 Days Return',
                      '7 days return of product in case of Defective item, physical damage, wrong item or missing item.',
                      color: Colors.red),
                  iconAndText(IconlyBold.shield_done, '1 Year Warranty',
                      "1 Year warranty on the item in case of internal manufacturing issue.",
                      color: Colors.green),
                  iconAndText(IconlyBold.star, 'Popular',
                      'Popular item in this category.',
                      color: Colors.amber),
                ],
              ),
              SizedBox(height: mq.width * .02),
              const Divider(thickness: 1),
              SizedBox(height: mq.width * .03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(thickness: 1),
                  const Text(
                    'Top Highlights',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: mq.width * .01),
                  Text(
                    "${widget.product.description}",
                    style: const TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: mq.width * .02),
                  const Text(
                    'Other Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: mq.width * .01),
                  for (int i = 0; i < 5; i++)
                    Container(
                      width: mq.width,
                      padding: EdgeInsets.symmetric(vertical: mq.height * 0.01),
                      decoration: BoxDecoration(
                          color: i % 2 != 0
                              ? Colors.blueGrey.shade50
                              : Colors.white),
                      child: Text(
                        "${widget.product.brandName}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  SizedBox(height: mq.width * .02),
                  const Text(
                    'Warranty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: mq.width * .01),
                  const Text(
                    "Contains the warranty summary",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: mq.width * .02),
              const Divider(thickness: 1),
              SizedBox(height: mq.width * .03),
              Column(
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
              ),
              SizedBox(height: mq.width * .03),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Similar Products',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Container(
                height: 500,
                width: mq.width,
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: 30,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Card(
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.red,
                          ),
                          color: Colors.red,
                        )),
              ),
              SizedBox(height: mq.width * .35),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconAndText(IconData iconData, String title, String description,
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
        initialRating: double.parse(myRating.toString()),
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

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xFFFF7643)
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
