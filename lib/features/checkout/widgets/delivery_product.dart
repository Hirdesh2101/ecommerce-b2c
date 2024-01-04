import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/features/cart/services/cart_services.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';

class OrderSummaryProduct extends StatefulWidget {
  final int index;
  final Product product;
  final String color;
  final String size;
  final num productQuantity;
  const OrderSummaryProduct(
      {required this.index,
      super.key,
      required this.product,
      required this.color,
      required this.size,
      required this.productQuantity});

  @override
  State<OrderSummaryProduct> createState() => _OrderSummaryProductState();
}

class _OrderSummaryProductState extends State<OrderSummaryProduct> {
  final ProductDetailServices productDetailServices = ProductDetailServices();
  int price = 0;
  final CartServices cartServices = CartServices();
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );
  @override
  void initState() {
    List<dynamic> variants = widget.product.varients;
    for (var variant in variants) {
      if (variant['color'] == widget.color) {
        price = variant['price'];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fetching the particular product
    //final productCart = context.watch<UserProvider>().user.cart[widget.index];
    //final product = Product.fromJson(productCart['product']);
    // final quantity = productCart['quantity'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // image
        Image.network(
          widget.product.images[0],
          fit: BoxFit.contain,
          height: mq.width * .25,
          width: mq.width * .25,
        ),
        // description
        Column(
          children: [
            Container(
              width: mq.width * .57,
              padding:
                  EdgeInsets.only(left: mq.width * .025, top: mq.width * .0125),
              child: Text(
                widget.product.name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
              ),
            ),
            Container(
              width: mq.width * .57,
              padding: EdgeInsets.only(left: mq.width * .025),
              child: Text(
                indianRupeesFormat.format(price),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 11),
                        maxLines: 2,
                      )),
                ],
              ),
            ),
            Container(
              width: mq.width * .57,
              padding: EdgeInsets.only(left: mq.width * .025),
              child: Text(
                "Quantity: ${widget.productQuantity}",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
