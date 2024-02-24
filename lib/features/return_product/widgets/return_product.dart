import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';

typedef QuantityCallback = void Function(int quantity);

class ReturnProduct extends StatefulWidget {
  final int index;
  final List<dynamic> products;
  final QuantityCallback onQuantitySelected;
  final bool isSelected;
  final int selectedQuantity;
  const ReturnProduct({
    super.key,
    required this.index,
    required this.products,
    required this.onQuantitySelected,
    required this.isSelected,
    required this.selectedQuantity,
  });

  @override
  State<ReturnProduct> createState() => _ReturnProductState();
}

class _ReturnProductState extends State<ReturnProduct> {
  ProductDetailServices productDetailServices = ProductDetailServices();
  final HomeServices homeServices = HomeServices();
late Size mq = MediaQuery.of(context).size;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> quantityItems = List.generate(
      widget.products[widget.index]['quantity'],
      (index) => DropdownMenuItem<int>(
        value: index + 1,
        child: Text((index + 1).toString()),
      ),
    );

    return Row(
      children: [
        // image
        Image.network(
          widget.products[widget.index]['product']['images'][0],
          fit: BoxFit.contain,
          height: mq.width * .26,
          width: mq.width * .26,
        ),
        // description
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.products[widget.index]['product']['name'],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
                maxLines: 2,
              ),
              Text(
                indianRupeesFormat
                    .format(widget.products[widget.index]['price']),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Color:",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    maxLines: 2,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: mq.width * .01),
                    width: mq.width * .025,
                    height: mq.width * .025,
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          '${widget.products[widget.index]['color']}')),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: mq.width * .025),
                      child: Text(
                        "Size: ${widget.products[widget.index]['size']}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        maxLines: 2,
                      )),
                  (widget.products[widget.index]['quantity'] == 0)
                      ? Container(
                          padding: EdgeInsets.only(left: mq.width * .025),
                          child: Text(
                            "Quantity: x${widget.products[widget.index]['quantity']}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            maxLines: 2,
                          ))
                      : Container(
                          padding: EdgeInsets.only(left: mq.width * .025),
                          child: Row(
                            children: [
                              const Text(
                                "Quantity: x ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                maxLines: 2,
                              ),
                              DropdownButton<int>(
                                value: widget.selectedQuantity,
                                items: quantityItems,
                                onChanged: widget.isSelected
                                    ? (value) {
                                        //setState(() {
                                          widget.onQuantitySelected(
                                              value!);
                                       // });
                                      }
                                    : null,
                              ),
                            ],
                          ))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
