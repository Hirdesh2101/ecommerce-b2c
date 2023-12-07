import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/features/cart/services/cart_services.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  final Product product;
  final int quantity;
  final String color;
  final String size;
  final Function() fetchCart;

  const CartProduct(
      {required this.index,
      super.key,
      required this.product,
      required this.quantity,
      required this.size,
      required this.color,
      required this.fetchCart});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  int price = 0;
  int quantity = 0;

  @override
  void initState() {
    List<dynamic> variants = widget.product.varients;
    for (var variant in variants) {
      if (variant['color'] == widget.color) {
        price = variant['price'];
        for (var size in variant['sizes']) {
          if (size['size'] == widget.size) {
            quantity = size['quantity'];
          }
        }
      }
    }
    super.initState();
  }

  final ProductDetailServices productDetailServices = ProductDetailServices();
  final CartServices cartServices = CartServices();

  void increaseQuantity(Product product) async {
    await productDetailServices.addToCart(
        context: context,
        product: product,
        color: widget.color,
        size: widget.size);
    widget.fetchCart();
  }

  //changed the fun with alert dialog
  void decreaseQuantity(Product product) async {
    List<Cart> cartItems = context.read<CartProvider>().getCart ?? [];
    int totalCartItemCount = cartItems.length;
    if (totalCartItemCount == 1) {
      bool? removeItem = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Remove Item!",
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 25),
            ),
            content: const Text(
                "Are you sure you want to remove the last item from your cart?"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    onPressed: () {
                      Navigator.pop(context, false); // No was selected
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    onPressed: () {
                      Navigator.pop(context, true); // Yes was selected
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
      // If the user selected "Yes," remove the item from the cart
      if (removeItem != null && removeItem) {
        await cartServices.removeFromCart(
          context: context,
          product: product,
          color: widget.color,
          size: widget.size,
        );
        widget.fetchCart();
      }
    } else {
      // If there's more than one item, remove the item directly
      await cartServices.removeFromCart(
        context: context,
        product: product,
        color: widget.color,
        size: widget.size,
      );
      widget.fetchCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetching the particular product
    //final productCart = context.watch<UserProvider>().user.cart[widget.index];
    // final product = Product.fromJson(productCart['product']);
    // final quantity = productCart['quantity'];
    final indianRupeesFormat = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 0,
      symbol: '₹ ',
    );

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: mq.width * .025),
          child: Row(
            children: [
              // image
              Image.network(
                widget.product.images[0],
                fit: BoxFit.contain,
                height: mq.width * .25,
                width: mq.width * .25,
              ),
              SizedBox(width: mq.width * .01),
              // description
              Column(
                children: [
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(
                        left: mq.width * .025, top: mq.width * .0125),
                    child: Text(
                      widget.product.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(
                        left: mq.width * .025, top: mq.width * .0125),
                    child: Text(
                      indianRupeesFormat.format(price),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(left: mq.width * .025),
                    child: Text(
                      price < 500
                          ? "Shipping charges might apply"
                          : "Eligible for free shipping",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: mq.width * .025),
                    width: mq.width * .57,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Color:",
                          style: TextStyle(color: Colors.black, fontSize: 11),
                          maxLines: 2,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: mq.width * .01),
                          width: mq.width * .025,
                          height: mq.width * .025,
                          decoration: BoxDecoration(
                            color: Color(int.parse(widget.color)),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: mq.width * .025),
                            child: Text(
                              "Size: ${widget.size}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 11),
                              maxLines: 2,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(left: mq.width * .025),
                    child: quantity == 0
                        ? const Text(
                            "Out of Stock",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 11),
                            maxLines: 2,
                          )
                        : const Text(
                            "In Stock",
                            style: TextStyle(color: Colors.teal, fontSize: 11),
                            maxLines: 2,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: mq.width * .05, bottom: mq.width * .02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  borderRadius: BorderRadius.circular(mq.width * .0125),
                  color: Colors.black12,
                ),
                child: Row(children: [
                  InkWell(
                    onTap: () => decreaseQuantity(widget.product),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: const Icon(Icons.remove),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.zero),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text("${widget.quantity}"),
                    ),
                  ),
                  InkWell(
                    onTap: () => increaseQuantity(widget.product),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }
}
