// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/delivery_location.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/details_widget.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/icon_details.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/price_and_title.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/ratings_reviews.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/similar_products.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/size_and_Color.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/top_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:provider/provider.dart';
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

  int counterFiveStars = 0;
  int counterFourStars = 0;
  int counterThreeStars = 0;
  int counterTwoStars = 0;
  int counterOneStars = 0;

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
      if (widget.product.rating![i].rating.toInt() == 1) {
        counterOneStars++;
      } else if (widget.product.rating![i].rating.toInt() == 2) {
        counterTwoStars++;
      } else if (widget.product.rating![i].rating.toInt() == 3) {
        counterThreeStars++;
      } else if (widget.product.rating![i].rating.toInt() == 4) {
        counterFourStars++;
      } else if (widget.product.rating![i].rating.toInt() == 5) {
        counterFiveStars++;
      }
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  var selectedNavigation = 0;
  static const tabs = ['', '', ''];
  final destinations = tabs
      .map(
        (page) => NavigationDestination(icon: Icon(Icons.abc), label: 'page'),
      )
      .toList();

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
    return AdaptiveLayout(
      //     primaryNavigation: SlotLayout(
      //   config: <Breakpoint, SlotLayoutConfig>{
      //     Breakpoints.medium: SlotLayout.from(
      //       //inAnimation: AdaptiveScaffold.leftOutIn,
      //       key: const Key('Primary Navigation Medium'),
      //       builder: (_) => AdaptiveScaffold.standardNavigationRail(
      //         selectedIndex: selectedNavigation,
      //         onDestinationSelected: (int newIndex) {
      //           setState(() {
      //             selectedNavigation = newIndex;
      //           });
      //         },
      //         leading: const Icon(Icons.menu),
      //         destinations: destinations
      //             .map((_) => AdaptiveScaffold.toRailDestination(_))
      //             .toList(),
      //         // backgroundColor: navRailTheme.backgroundColor,
      //         // selectedIconTheme: navRailTheme.selectedIconTheme,
      //         // unselectedIconTheme: navRailTheme.unselectedIconTheme,
      //         // selectedLabelTextStyle: navRailTheme.selectedLabelTextStyle,
      //         // unSelectedLabelTextStyle: navRailTheme.unselectedLabelTextStyle,
      //       ),
      //     ),
      //     Breakpoints.large: SlotLayout.from(
      //       key: const Key('Primary Navigation Large'),
      //       //inAnimation: AdaptiveScaffold.leftOutIn,
      //       builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
      //         // selectedIndex: selectedNavigation,
      //         // onDestinationSelected: (int newIndex) {
      //         //   setState(() {
      //         //     selectedNavigation = newIndex;
      //         //   });
      //         // },
      //         // //extended: true,
      //         // leading: const Row(
      //         //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         //   children: <Widget>[
      //         //     Text(
      //         //       'REPLY',
      //         //       style: TextStyle(color: Color.fromARGB(255, 255, 201, 197)),
      //         //     ),
      //         //     Icon(Icons.menu_open)
      //         //   ],
      //         // ),
      //         destinations: destinations
      //             // .map((_) => AdaptiveScaffold.to(_))
      //             // .toList(),
      //         // trailing: trailingNavRail,
      //         // backgroundColor: navRailTheme.backgroundColor,
      //         // selectedIconTheme: navRailTheme.selectedIconTheme,
      //         // unselectedIconTheme: navRailTheme.unselectedIconTheme,
      //         // selectedLabelTextStyle: navRailTheme.selectedLabelTextStyle,
      //         // unSelectedLabelTextStyle: navRailTheme.unselectedLabelTextStyle,
      //       ),
      //     ),
      //   },
      // ),
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.smallAndUp: SlotLayout.from(
            key: const Key('details-Small'),
            builder: (_) => Scaffold(
              appBar: GlobalVariables.getAppBar(
                  context: context,
                  onClickSearchNavigateTo: const MySearchScreen()),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .03)
                      .copyWith(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TopImage(
                        product: widget.product,
                        height: mq.height * .52,
                      ),
                      SizedBox(height: mq.height * .02),
                      TitleAndPrice(
                          product: widget.product,
                          avgRating: avgRating,
                          isProductOutOfStock: isProductOutOfStock),
                      SizedBox(height: mq.width * .03),
                      const Divider(thickness: 2),
                      SizedBox(height: mq.width * .01),
                      const SizeAndColor(),
                      SizedBox(height: mq.width * .03),
                      const Divider(thickness: 2),
                      SizedBox(height: mq.width * .03),
                      DeliveyLocation(pincode: pincode),
                      SizedBox(height: mq.width * .07),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isProductOutOfStock) {
                              showSnackBar(
                                  context: context,
                                  text: "Product is out of stock!");
                              return;
                            } else {
                              addToCart();
                              showSnackBar(
                                  context: context,
                                  text: "Added to Cart",
                                  onTapFunction: () {
                                    Navigator.pushNamed(
                                        context, CartScreen.routeName);
                                  },
                                  actionLabel: "View");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade800,
                              minimumSize:
                                  Size(mq.width * .95, mq.height * .06),
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
                                  context: context,
                                  text: "Product is out of stock!");
                              return;
                            } else {
                              // addToCart();
                              showSnackBar(
                                  context: context,
                                  text: "Need to redirect",
                                  onTapFunction: () {
                                    Navigator.pushNamed(
                                        context, CartScreen.routeName);
                                  },
                                  actionLabel: "View");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade800,
                              minimumSize:
                                  Size(mq.width * .95, mq.height * .06),
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
                      const DetailsWithICons(),
                      SizedBox(height: mq.width * .02),
                      const Divider(thickness: 1),
                      SizedBox(height: mq.width * .03),
                      DetilsWidget(product: widget.product),
                      SizedBox(height: mq.width * .02),
                      const Divider(thickness: 1),
                      SizedBox(height: mq.width * .03),
                      AllRatings(
                        counterFiveStars: counterFiveStars,
                        counterFourStars: counterFourStars,
                        counterThreeStars: counterThreeStars,
                        counterTwoStars: counterTwoStars,
                        counterOneStars: counterOneStars,
                        avgRating: avgRating,
                        myRating: myRating,
                        product: widget.product,
                      ),
                      SizedBox(height: mq.width * .03),
                      SimilarProducts(
                        product: widget.product,
                        isProductOutOfStock: isProductOutOfStock,
                      ),
                      SizedBox(height: mq.width * .35),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Breakpoints.large: SlotLayout.from(
            key: const Key('Body Medium'),
            builder: (_) => Scaffold(
              body: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .03)
                    .copyWith(top: 10),
                child: Column(children: [
                  TopImage(
                    product: widget.product,
                    height: mq.height * .95,
                  ),
                  SizedBox(height: mq.height * .02),
                ]),
              )),
            ),
          ),
        },
      ),
      secondaryBody: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.large: SlotLayout.from(
            key: const Key('Body Medium'),
            builder: (_) => Scaffold(
              body: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .03)
                    .copyWith(top: 10),
                child: Column(children: [
                  SizedBox(height: mq.height * .02),
                  TitleAndPrice(
                      product: widget.product,
                      avgRating: avgRating,
                      isProductOutOfStock: isProductOutOfStock),
                  SizedBox(height: mq.width * .03),
                  const Divider(thickness: 2),
                  SizedBox(height: mq.width * .03),
                  DeliveyLocation(pincode: pincode),
                  SizedBox(height: mq.width * .07),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (isProductOutOfStock) {
                          showSnackBar(
                              context: context,
                              text: "Product is out of stock!");
                          return;
                        } else {
                          addToCart();
                          showSnackBar(
                              context: context,
                              text: "Added to Cart",
                              onTapFunction: () {
                                Navigator.pushNamed(
                                    context, CartScreen.routeName);
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
                              context: context,
                              text: "Product is out of stock!");
                          return;
                        } else {
                          // addToCart();
                          showSnackBar(
                              context: context,
                              text: "Need to redirect",
                              onTapFunction: () {
                                Navigator.pushNamed(
                                    context, CartScreen.routeName);
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
                  const DetailsWithICons(),
                  SizedBox(height: mq.width * .02),
                  const Divider(thickness: 1),
                  SizedBox(height: mq.width * .03),
                  DetilsWidget(product: widget.product),
                  SizedBox(height: mq.width * .02),
                  const Divider(thickness: 1),
                  SizedBox(height: mq.width * .03),
                  AllRatings(
                    counterFiveStars: counterFiveStars,
                    counterFourStars: counterFourStars,
                    counterThreeStars: counterThreeStars,
                    counterTwoStars: counterTwoStars,
                    counterOneStars: counterOneStars,
                    avgRating: avgRating,
                    myRating: myRating,
                    product: widget.product,
                  ),
                  SizedBox(height: mq.width * .03),
                  SimilarProducts(
                      product: widget.product,
                      isProductOutOfStock: isProductOutOfStock),
                  SizedBox(height: mq.width * .35),
                ]),
              )),
            ),
          )
        },
      ),
    );
  }
}
