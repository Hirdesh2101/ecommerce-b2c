import 'package:ecommerce_major_project/features/checkout/services/checkout_services.dart';
import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/features/home/widgets/address_box.dart';
import 'package:ecommerce_major_project/features/cart/widgets/cart_product.dart';
import 'package:ecommerce_major_project/features/cart/widgets/cart_subtotal.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/checkout/screens/checkout_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    fetchCart();
    super.initState();
  }

  fetchCart() async {
    await homeServices.fetchCart(context);
  }

  void navigateToSearchScreen(String query) {
    //make sure to pass the arguments here!
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  //This function checks the availablity of the products first and then move forward.
  void navigateToAddress(num sum) async {
    final cartProvider = Provider.of<CartProvider>(context,listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    bool isProductAvailable =
        await CheckoutServices().checkProductsAvailability(context);

    if (isProductAvailable) {
      //make sure to pass the arguments here!
      if (context.mounted){
      Navigator.pushNamed(context, CheckoutScreen.routeName,
          arguments: [sum.toString(),cartProvider.getCart,userProvider.user.cart]);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
          title: "Your Cart",
          onClickSearchNavigateTo: const MySearchScreen()),
      body: Column(
        children: [
          SizedBox(height: mq.height * 0.01),
          const AddressBox(),
          CartSubtotal(
            sum: cartProvider.getSum,
          ),
          Padding(
            padding: EdgeInsets.all(mq.width * .025),
            child: CustomButton(
                text: isLoading
                    ? "Checking availablity"
                    : "Proceed to buy (${cartProvider.getCart!.length} ${cartProvider.getCart!.length == 1 ? 'item' : 'items'})",
                onTap: () {
                  if (isLoading || cartProvider.getCart!.isEmpty) {
                    return;
                  }
                  navigateToAddress(cartProvider.getSum);
                },
                color: (isLoading || cartProvider.getCart!.isEmpty)
                    ? Colors.yellow[200]
                    : Colors.yellow[500]),
          ),
          SizedBox(height: mq.height * 0.02),
          Container(color: Colors.black12.withOpacity(0.08), height: 1),
          SizedBox(height: mq.height * 0.02),
          Expanded(
            // height: mq.height * 0.5,
            child: cartProvider.getCart!.isEmpty
                    ? Column(
                        children: [
                          Image.asset("assets/images/no-orderss.png",
                              height: mq.height * .15),
                          const Text("No item in cart"),
                          SizedBox(height: mq.height * 0.02),
                          ElevatedButton(
                            onPressed: () {
                             tabProvider.setTab(0);
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
                        itemCount: cartProvider.getCart!.length,
                        itemBuilder: (context, index) {
                          // return CartProdcut
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailScreen.routeName,
                                arguments: cartProvider.getCart![index].product.id,
                              ).then((value) {
                                fetchCart();
                              });
                            },
                            child: CartProduct(
                              index: index,
                              product:
                                  cartProvider.getCart![index].product,
                              size: cartProvider.getCart![index].size,
                              color: cartProvider.getCart![index].color,
                              quantity: cartProvider.getCart![index].quantity,
                              fetchCart: fetchCart
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
