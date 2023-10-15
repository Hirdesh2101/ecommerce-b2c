import 'dart:math';
import 'package:ecommerce_major_project/features/home/widgets/carousel_image.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final int _tabLength = 5; final indianRupeesFormat = NumberFormat.currency(
           name: "INR",
           locale: 'en_IN',
           decimalDigits: 0,
           symbol: '₹ ',
        );

  //products
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  final ProductDetailServices productDetailServices = ProductDetailServices();
  //add to cart function copied, link it to the gridview items buttons

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
              height: mq.height * .07,
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
                      child: Card(
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
                  for (int i = 0; i < _tabLength; i++)
                    Container(
                      height: mq.height * 0.3,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Colors.grey.shade700, width: 0.4))),
                      child: CustomScrollView(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: kIsWeb ? 4 : 2,
                                  childAspectRatio: kIsWeb ? 1.1 : 0.69,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 0,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                    childCount: min(productList!.length, 8),
                                    (context, index) {
                                  Product product = productList![index];
                                  bool isProductOutOfStock =
                                      productList![index].quantity == 0;
                                  print(
                                      "\n\n============> product category : ${categoriesList[activeTabIndex]}");

                                  final user =
                                      context.watch<UserProvider>().user;
                                  List<dynamic> wishList = user.wishList != null
                                      ? user.wishList!
                                      : [];
                                  bool isProductWishListed = false;

                                  for (int i = 0; i < wishList.length; i++) {
                                    final productWishList = wishList[i];
                                    final productFromJson = Product.fromJson(
                                        productWishList['product']);
                                    final productId = productFromJson.id;

                                    if (productId == product.id) {
                                      isProductWishListed = true;
                                      break;
                                    }
                                  }

                                  return InkWell(
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
                                        vertical: mq.width * .012,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // navigate to product details screen
                                          SizedBox(
                                            height: mq.height * .2,
                                            width: mq.width * .4,
                                            child: Image.network(
                                              product.images[0],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
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
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                GoogleFonts.lato(fontSize: 13),
                                          ),
                                          SizedBox(height: mq.height * .005),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      indianRupeesFormat.format(product.price),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                      width: mq.width * .02),
                                                ),
                                                TextSpan(
                                                  text:
                                                      indianRupeesFormat.format(product.price),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                      width: mq.width * .02),
                                                ),
                                                const TextSpan(
                                                  text: "28% off",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                isProductOutOfStock
                                                    ? 'Out of Stock'
                                                    : productList![index]
                                                                .quantity <
                                                            5
                                                        ? 'Only ${productList![index].quantity} left'
                                                        : 'In Stock',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: isProductOutOfStock
                                                      ? Colors.red
                                                      : productList![index]
                                                                  .quantity <
                                                              5
                                                          ? Colors.amber
                                                          : Colors.green,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (isProductWishListed) {
                                                    HomeServices()
                                                        .removeFromWishList(
                                                            context: context,
                                                            product: product);
                                                    showSnackBar(
                                                      context: context,
                                                      text:
                                                          "Removed from WishList",
                                                    );
                                                  } else {
                                                    HomeServices()
                                                        .addToWishList(
                                                            context: context,
                                                            product: product);
                                                    showSnackBar(
                                                      context: context,
                                                      text: "Added to WishList",
                                                      onTapFunction: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          GlobalVariables
                                                              .createRoute(
                                                            const WishListScreen(),
                                                          ),
                                                        );
                                                      },
                                                      actionLabel: "View",
                                                    );
                                                  }
                                                },
                                                child: Icon(
                                                  isProductWishListed
                                                      ? Icons.favorite_rounded
                                                      : Icons
                                                          .favorite_border_rounded,
                                                  size: 26,
                                                  color: isProductWishListed
                                                      ? Colors.pink
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
