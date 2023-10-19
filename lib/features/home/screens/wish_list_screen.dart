// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_product.dart';

class WishListScreen extends StatefulWidget {
  // List<Product>? wishList;
  const WishListScreen({
    Key? key,
    // this.wishList,
  }) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool isLoading = true;
  List<Product>? wishList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    fetchWishlist();
    super.initState();
  }

  fetchWishlist() async {
    setState(() {
      isLoading = true;
    });
    wishList = await homeServices.fetchWishList(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          title: "Your Wishlist",
          onClickSearchNavigateTo: const MySearchScreen()),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            alignment: Alignment.center,
            // color: Colors.redAccent,
            padding: EdgeInsets.only(top: mq.height * .02),
            // height: mq.height * 0.55,
            child: isLoading?const ColorLoader2() :
            
            wishList == null || wishList!.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no-orderss.png",
                        height: mq.height * .25,
                      ),
                      const Text(
                        "Oops, no item in wishList",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: mq.height * .01),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, BottomBar.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent),
                          child: const Text(
                            "Add a product now",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    for (int index = 0; index < wishList!.length; index++)
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                              arguments: wishList![index].id,
                            );
                          },
                          child: WishListProduct(index: index,product: wishList![index],fetchWishList: fetchWishlist,)),
                  ]),
          ),
        ],
      ),
    );
  }
}
