import 'dart:ui';
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/address/services/checkout_services.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/features/home/widgets/address_box.dart';
import 'package:ecommerce_major_project/features/cart/widgets/cart_product.dart';
import 'package:ecommerce_major_project/features/cart/widgets/cart_subtotal.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/address/screens/checkout_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  final HomeServices homeServices = HomeServices();
  List<Map<String, dynamic>>? cart;
  num sum = 0;

  @override
  void initState() {
    fetchCart();
    super.initState();
  }

  fetchCart() async {
    setState(() {
      isLoading = true;
    });
    cart = await homeServices.fetchCart(context);
    sum = 0;
    for (var cartItem in cart!) {
      List<dynamic> variants = cartItem['product']['varients'];
      for (var variant in variants) {
        if (variant['color'] == cartItem['color']) {
          sum += cartItem['quantity'] * variant['price'];
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSearchScreen(String query) {
    //make sure to pass the arguments here!
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  //This function checks the availablity of the products first and then move forward.
  void navigateToAddress(num sum, List cart) async {
    setState(() {
      isLoading = true;
    });

    bool isProductAvailable =
        await CheckoutServices().checkProductsAvailability(context, cart);

    if (isProductAvailable) {
      //make sure to pass the arguments here!
      Navigator.pushNamed(context, CheckoutScreen.routeName,
          arguments: [sum.toString(), cart]);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
          title: "Your Cart",
          onClickSearchNavigateTo: const MySearchScreen()),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: mq.height * 0.01),
              const AddressBox(),
              CartSubtotal(
                sum: sum,
              ),
              Padding(
                padding: EdgeInsets.all(mq.width * .025),
                child: CustomButton(
                    text: isLoading
                        ? "Checking availablity"
                        : "Proceed to buy (${cart!.length} ${cart!.length == 1 ? 'item' : 'items'})",
                    onTap: () {
                      if (isLoading || cart!.isEmpty) {
                        return;
                      }
                      navigateToAddress(sum, cart!);
                    },
                    color: (isLoading || cart!.isEmpty)
                        ? Colors.yellow[200]
                        : Colors.yellow[500]),
              ),
              SizedBox(height: mq.height * 0.02),
              Container(color: Colors.black12.withOpacity(0.08), height: 1),
              SizedBox(height: mq.height * 0.02),
              Expanded(
                // height: mq.height * 0.5,
                child: isLoading
                    ? const ColorLoader2()
                    : cart!.isEmpty
                        ? Column(
                            children: [
                              Image.asset("assets/images/no-orderss.png",
                                  height: mq.height * .15),
                              const Text("No item in cart"),
                              SizedBox(height: mq.height * 0.02),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, BottomBar.routeName);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    backgroundColor: Colors.deepPurpleAccent),
                                child: const Text(
                                  "Keep Exploring",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            itemCount: cart!.length,
                            itemBuilder: (context, index) {
                              // return CartProdcut
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductDetailScreen.routeName,
                                    arguments: cart![index]['product']['_id'],
                                  );
                                },
                                child: CartProduct(
                                  index: index,
                                  product:
                                      Product.fromJson(cart![index]['product']),
                                  size: cart![index]['size'],
                                  color: cart![index]['color'],
                                  quantity: cart![index]['quantity'],
                                  fetchCart: fetchCart
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          if(isLoading)
          Positioned.fill(
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 3.0,
                  sigmaY: 3.0,
                ),
                child: Container(
                  color: Colors.grey.withOpacity(0.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
