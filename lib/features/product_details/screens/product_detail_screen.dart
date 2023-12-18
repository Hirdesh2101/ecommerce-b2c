// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/buybuttons.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/delivery_location.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/details_widget.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/icon_details.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/price_and_title.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/ratings_reviews.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/similar_products.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/size_and_color.dart';
import 'package:ecommerce_major_project/features/product_details/widgets/top_image.dart';
import 'package:ecommerce_major_project/models/cart.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-details';
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailServices productDetailServices = ProductDetailServices();

  num myRating = 0.0;
  double avgRating = 0.0;
  int selectedSize = -1;
  int selectedColor = 0;

  int counterFiveStars = 0;
  int counterFourStars = 0;
  int counterThreeStars = 0;
  int counterTwoStars = 0;
  int counterOneStars = 0;

  Product? product;
  List<Product>? _similarProducts;
  bool isProductLoading = true;
  bool isProductOutOfStock = false;

  @override
  void initState() {
    fetchProduct(widget.productId);
    super.initState();
  }

  fetchProduct(String productId) async {
    var id = Provider.of<UserProvider>(context, listen: false).user.id;
    setState(() {
      isProductLoading = true;
    });
    product = await productDetailServices.getProductById(
      context: context,
      productId: productId,
    );
    _similarProducts = await productDetailServices.fetchSimilarProducts(
      context: context,
      category: product!.category,
    );
    if (product != null) {
      double totalRating = 0.0;

      for (int i = 0; i < product!.rating!.length; i++) {
        totalRating += product!.rating![i].rating;
        //showing our own rating in the product! details page
        //overall rating will be avgRating but
        //when we see a particular product! we will be able to see
        //our given rating, i.e.  myRating
        if (product!.rating![i].rating.toInt() == 1) {
          counterOneStars++;
        } else if (product!.rating![i].rating.toInt() == 2) {
          counterTwoStars++;
        } else if (product!.rating![i].rating.toInt() == 3) {
          counterThreeStars++;
        } else if (product!.rating![i].rating.toInt() == 4) {
          counterFourStars++;
        } else if (product!.rating![i].rating.toInt() == 5) {
          counterFiveStars++;
        }
        if (product!.rating![i].userId == id) {
          myRating = product!.rating![i].rating;
        }
      }
      if (totalRating != 0) {
        avgRating = totalRating / product!.rating!.length;
      }
    }
    _similarProducts = _similarProducts!.where((similarProduct) {
      return similarProduct.id != productId;
    }).toList();

    setState(() {
      isProductLoading = false;
    });
  }

  var selectedNavigation = 0;
  static const tabs = ['', '', ''];
  final destinations = tabs
      .map(
        (page) =>
            const NavigationDestination(icon: Icon(Icons.abc), label: 'page'),
      )
      .toList();
  void addToCart() {
    if (selectedSize == -1) {
      showSnackBar(
        context: context,
        text: "Please select a size!",
      );
    } else if (isProductOutOfStock) {
      showSnackBar(context: context, text: "Product is out of stock!");
      return;
    } else {
      debugPrint("Triggered add to cart <====");
      debugPrint("Product is  : ${product!.name}");
      productDetailServices.addToCart(
          context: context,
          product: product!,
          color: product!.varients[selectedColor]['color'],
          size: product!.varients[selectedColor]['sizes'][selectedSize]
              ['size']);
      debugPrint("Execution finished add to cart <====");
      showSnackBar(
          context: context,
          text: "Added to Cart",
          onTapFunction: () {
            final tabProvider =
                Provider.of<TabProvider>(context, listen: false);
            tabProvider.setTab(2);
            // GlobalVariables.navigatorKey.currentState!
            //     .popUntil((route) => route.isFirst);
            //TODO here use global context for redirection
            context.go('/cart');
            //Navigator.pushNamed(context, CartScreen.);
          },
          actionLabel: "View");
    }
  }

  void buyNow() {
    if (selectedSize == -1) {
      showSnackBar(
        context: context,
        text: "Please select a size!",
      );
    } else if (isProductOutOfStock) {
      showSnackBar(context: context, text: "Product is out of stock!");
      return;
    } else {
      debugPrint("Triggered buynow <====");
      debugPrint("Product is  : ${product!.name}");
      List<Cart> buyNowCart = [
        Cart(
            product: product!,
            quantity: 1,
            color: product!.varients[selectedColor]['color'],
            size: product!.varients[selectedColor]['sizes'][selectedSize]
                ['size'])
      ];
      List<dynamic> buyNowUserCart = [
        {
          'product': product!.id,
          'quantity': 1,
          'color': product!.varients[selectedColor]['color'],
          'size': product!.varients[selectedColor]['sizes'][selectedSize]
              ['size']
        }
      ];
      context.push('/checkout',extra: [ product!.varients[selectedColor]['price'].toString(),
        buyNowCart,
        buyNowUserCart]);
    }
  }

  void setColor(int color) {
    if (selectedColor != color) {
      setState(() {
        selectedColor = color;
        selectedSize = -1;
      });
    }
  }

  void setSize(int size) {
    if (selectedSize != size) {
      setState(() {
        selectedSize = size;
        isProductOutOfStock = product!.varients[selectedColor]['sizes']
                [selectedSize]['quantity'] ==
            0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  //TODO add actions
                  wantActions: false
                  //onClickSearchNavigateTo: const MySearchScreen()
                  ),
              body: isProductLoading
                  ? const Center(
                      child: ColorLoader2(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * .03)
                                .copyWith(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TopImage(
                              product: product!,
                              height: mq.height * .52,
                            ),
                            SizedBox(height: mq.height * .02),
                            TitleAndPrice(
                                product: product!,
                                colorVarient: selectedColor,
                                avgRating: avgRating,
                                isProductOutOfStock: isProductOutOfStock),
                            SizedBox(height: mq.width * .03),
                            const Divider(thickness: 2),
                            SizedBox(height: mq.width * .01),
                            SizeAndColor(
                                product: product!,
                                selectedColor: selectedColor,
                                selectedSize: selectedSize,
                                setColor: setColor,
                                setSize: setSize),
                            const DeliveyLocation(),
                            SizedBox(height: mq.width * .07),
                            BuyButtons(
                              addToCart: addToCart,
                              buyNow: buyNow,
                            ),
                            SizedBox(height: mq.width * .03),
                            const Divider(thickness: 1),
                            SizedBox(height: mq.width * .02),
                            DetailsWithICons(product: product!),
                            SizedBox(height: mq.width * .02),
                            const Divider(thickness: 1),
                            SizedBox(height: mq.width * .03),
                            DetilsWidget(product: product!),
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
                              product: product!,
                            ),
                            SizedBox(height: mq.width * .03),
                            SimilarProducts(
                              products: _similarProducts,
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
                    product: product!,
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
                      product: product!,
                      colorVarient: selectedColor,
                      avgRating: avgRating,
                      isProductOutOfStock: isProductOutOfStock),
                  SizedBox(height: mq.width * .03),
                  const Divider(thickness: 2),
                  SizedBox(height: mq.width * .01),
                  SizeAndColor(
                      product: product!,
                      selectedColor: selectedColor,
                      selectedSize: selectedSize,
                      setColor: setColor,
                      setSize: setSize),
                  const DeliveyLocation(),
                  SizedBox(height: mq.width * .07),
                  BuyButtons(
                    addToCart: addToCart,
                    buyNow: buyNow,
                  ),
                  SizedBox(height: mq.width * .03),
                  const Divider(thickness: 1),
                  SizedBox(height: mq.width * .02),
                  DetailsWithICons(product: product!),
                  SizedBox(height: mq.width * .02),
                  const Divider(thickness: 1),
                  SizedBox(height: mq.width * .03),
                  DetilsWidget(product: product!),
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
                    product: product!,
                  ),
                  SizedBox(height: mq.width * .03),
                  SimilarProducts(
                    products: _similarProducts,
                    isProductOutOfStock: isProductOutOfStock,
                  ),
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
