import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';

class SizeAndColor extends StatefulWidget {
  const SizeAndColor({super.key, required this.product});
  final Product product;

  @override
  State<SizeAndColor> createState() => _SizeAndColorState();
}

class _SizeAndColorState extends State<SizeAndColor> {
  //final List<String> productSize = ;

  int selectedSize = -1;
  int selectedColor = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product.sizeQuantities.isNotEmpty)
          const Text(
            "Size",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            maxLines: 2,
          ),
        if (widget.product.sizeQuantities.isNotEmpty)
          SizedBox(height: mq.width * .01),
        if (widget.product.sizeQuantities.isNotEmpty)
          SizedBox(
            height: mq.height * .06,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.sizeQuantities.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(44.0),
                    onTap: () => setState(() {
                      selectedSize = index;
                    }),
                    child: Container(
                      height: mq.height * .06,
                      width: mq.height * .06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: selectedSize == index
                              ? Colors.red.shade400
                              : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                      child: Text(
                        widget.product.sizeQuantities[index]['size'],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: selectedSize == index
                              ? Colors.red.shade400
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (widget.product.varients.isNotEmpty)
          SizedBox(height: mq.width * .03),
        if (widget.product.varients.isNotEmpty)
          const Text(
            "Color",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            maxLines: 2,
          ),
        if (widget.product.varients.isNotEmpty)
          SizedBox(height: mq.width * .01),
        if (widget.product.varients.isNotEmpty)
          SizedBox(
            height: mq.height * .06,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.varients.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(44.0),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        ProductDetailScreen.routeName,
                        arguments: widget.product.varients[index]['_id'],
                      );
                    },
                    child: Container(
                      height: mq.height * .06,
                      width: mq.height * .06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(int.parse('0xFF'
                            '${widget.product.varients[index]['color'].substring(1)}')),
                        border: Border.all(
                          width: 2.0,
                          color: selectedColor == index
                              ? Colors.red
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (widget.product.varients.isNotEmpty ||
            widget.product.sizeQuantities.isNotEmpty)
          SizedBox(height: mq.width * .03),
        if (widget.product.varients.isNotEmpty ||
            widget.product.sizeQuantities.isNotEmpty)
          const Divider(thickness: 2),
        if (widget.product.varients.isNotEmpty ||
            widget.product.sizeQuantities.isNotEmpty)
          SizedBox(height: mq.width * .03),
      ],
    );
  }
}
