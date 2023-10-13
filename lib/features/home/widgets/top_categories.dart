import 'dart:math';

import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/home/widgets/carousel_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/category_deals_screen.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories>
    with TickerProviderStateMixin {
  // tabbar variables
  int activeTabIndex = 0;
  late final TabController _tabController;
  final int _tabLength = 5;


  //products
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  final ProductDetailServices productDetailServices = ProductDetailServices();
  //add to cart function copied, link it to the gridview items buttons

  bool favSelected = false;

  List<String> categoriesList = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLength, vsync: this);
    fetchCategoryProducts(categoriesList[activeTabIndex]);
  }

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  void addToCart(String productName, Product product) {
    print("Triggered add to cart <====");
    print("Product is  : $productName");
    productDetailServices.addToCart(context: context, product: product);
    print("Execution finished add to cart <====");
  }

  fetchCategoryProducts(String categoryName) async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: categoryName,
    );
    setState(() {});
    print("\n\n =======> Product List is :  =======> ${productList![0].name}");
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.only(top: mq.height * .01),
            child: const CarouselImage(),
          )),
        ];
      },
      body: Column(
        children: [
          DefaultTabController(
            length: _tabLength,
            child: SizedBox(
              // color: Colors.cyan,
              height: mq.height * .07,
              // height: mq.height * .1,
              width: double.infinity,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    activeTabIndex = index;
                  });
                  if (productList == null) {
                    fetchCategoryProducts(categoriesList[activeTabIndex]);
                  }
                },
                physics: const BouncingScrollPhysics(),
                splashBorderRadius: BorderRadius.circular(15),
                indicatorWeight: 1,
                indicatorColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                isScrollable: true,
                tabs: [
                  for (int index = 0; index < _tabLength; index++)
                    Tab(
                      child: SizedBox(
                        height: mq.height * .06,
                        // width: 140,
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: mq.width * .001,
                          ),
                          color: activeTabIndex == index
                              ? Colors.black87
                              : Colors.grey.shade50,
                          elevation: .8,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: GlobalVariables.primaryGreyTextColor,
                                  width: 0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    GlobalVariables.categoryImages[index]
                                        ['image']!,
                                    height: 30,
                                    // ignore: deprecated_member_use
                                    color: activeTabIndex == index
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                  SizedBox(width: mq.width * .015),
                                  Text(
                                    GlobalVariables.categoryImages[index]
                                        ['title']!,
                                    style: TextStyle(
                                      color: activeTabIndex == index
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          NotificationListener(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                _onTabChanged();
              }
              return false;
            },
            child: Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  //
                  for (int i = 0; i < _tabLength; i++)
                    Container(
                      height: mq.height * 0.3,
                      decoration: BoxDecoration(
                          //color: Colors.cyanAccent,
                          border: Border(
                              top: BorderSide(
                                  color: Colors.grey.shade700, width: 0.4))),
                      child: CustomScrollView(
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: mq.height * .008,
                              ).copyWith(right: mq.height * .015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateToCategoryPage(context,
                                          categoriesList[activeTabIndex]);
                                    },
                                    child: Text("See All",
                                        style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: productList == null
                                ? const ColorLoader2()
                                : productList!.isEmpty
                                    ? const Center(
                                        child: Text("No item to fetch"),
                                      )
                                    : const SizedBox.shrink(),
                          ),
                          if (productList != null && productList!.isNotEmpty)
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                horizontal: mq.width * .04,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: kIsWeb ? 4 : 2,
                                  childAspectRatio: kIsWeb? 1.1: 0.72,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                    childCount: min(productList!.length, 8),
                                    (context, index) {
                                  Product product = productList![index];
                                  bool isProductOutOfStock =
                                      productList![index].quantity == 0;
                                  print(
                                      "\n\n============> product category : ${categoriesList[activeTabIndex]}");
                                  return Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Card(
                                        color: const Color.fromARGB(
                                            255, 254, 252, 255),
                                        elevation: 2.5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              ProductDetailScreen.routeName,
                                              arguments: product,
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: mq.width * .025,
                                                vertical: mq.width * .02),
                                            child: Column(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.stretch,
                                              children: [
                                                // navigate to product details screen
                                                SizedBox(
                                                  // color: Colors.redAccent,
                                                  // width: double.infinity,
                                                  height: mq.height * .15,
                                                  width: mq.width * .4,
                                                  child: Image.network(
                                                    // "https://rukminim1.flixcart.com/image/416/416/xif0q/computer/e/k/k/-original-imagg5jsxzthfd39.jpeg?q=70",
                                                    //iphone
                                                    // "https://rukminim1.flixcart.com/image/416/416/ktketu80/mobile/8/z/w/iphone-13-mlph3hn-a-apple-original-imag6vzzhrxgazsg.jpeg?q=70",
                                                    product.images[0],

                                                    //TV
                                                    // "https://rukminim1.flixcart.com/image/416/416/kiyw9e80-0/television/p/0/w/32path0011-thomson-original-imafynyvsmeuwtzr.jpeg?q=70",
                                                    // width: mq.width * .2,
                                                    // height: mq.height * .15,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: mq.height * .005),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    product.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  // color: Colors.blueAccent,
                                                  child: Text(
                                                    "₹ ${product.price.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton.icon(
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade200),
                                                      onPressed: () {
                                                        homeServices
                                                            .addToWishList(
                                                                context:
                                                                    context,
                                                                product:
                                                                    product);
                                                        showSnackBar(
                                                            context: context,
                                                            text:
                                                                "Added to WishList",
                                                            onTapFunction: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(GlobalVariables
                                                                      .createRoute(
                                                                          const WishListScreen()));
                                                            },
                                                            actionLabel:
                                                                "View");
                                                      },
                                                      icon: const Icon(
                                                          CupertinoIcons.add,
                                                          size: 18,
                                                          color:
                                                              Colors.black87),
                                                      label: const Text(
                                                          "WishList",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87)),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          if (isProductOutOfStock) {
                                                            showSnackBar(
                                                                context:
                                                                    context,
                                                                text:
                                                                    "Product is out of stock!");
                                                            return;
                                                          } else {
                                                            addToCart(
                                                                product.name,
                                                                product);
                                                            showSnackBar(
                                                                context:
                                                                    context,
                                                                text:
                                                                    "Added to Cart",
                                                                onTapFunction:
                                                                    () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      CartScreen
                                                                          .routeName);
                                                                },
                                                                actionLabel:
                                                                    "View");
                                                          }
                                                        },
                                                        child: const Icon(
                                                            CupertinoIcons
                                                                .cart_badge_plus,
                                                            size: 35)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTabChanged() {
    switch (_tabController.index) {
      case 0:
        // handle 0 position
        activeTabIndex = 0;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;

      case 1:
        activeTabIndex = 1;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        // handle 1 position
        break;

      case 2:
        activeTabIndex = 2;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        // handle 1 position
        break;

      case 3:
        activeTabIndex = 3;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;

      case 4:
        activeTabIndex = 4;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;
    }
  }
}
