import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';

class SizeAndColor extends StatefulWidget {
  const SizeAndColor({super.key, required this.product,required this.selectedColor,required this.selectedSize,required this.setColor,required this.setSize});
  final Product product;
  final int selectedSize;
  final int selectedColor;
  final Function(int) setColor;
  final Function(int) setSize;

  @override
  State<SizeAndColor> createState() => _SizeAndColorState();
}

class _SizeAndColorState extends State<SizeAndColor> {
  //final List<String> productSize = ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product.varients[widget.selectedColor]['sizes'].isNotEmpty)
          const Text(
            "Size",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            maxLines: 2,
          ),
        if (widget.product.varients[widget.selectedColor]['sizes'].isNotEmpty)
          SizedBox(height: mq.width * .01),
        if (widget.product.varients[widget.selectedColor]['sizes'].isNotEmpty)
          SizedBox(
            height: mq.height * .06,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.varients[widget.selectedColor]['sizes'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(44.0),
                    onTap:() {widget.setSize(index);},
                    child: Container(
                      height: mq.height * .06,
                      width: mq.height * .06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: widget.selectedSize == index
                              ? Colors.red.shade400
                              : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                      child: Text(
                        widget.product.varients[widget.selectedColor]['sizes'][index]['size'],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: widget.selectedSize == index
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
                    onTap:() {widget.setColor(index);},
                    child: Container(
                      height: mq.height * .06,
                      width: mq.height * .06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(int.parse('0xFF'
                            '${widget.product.varients[index]['color'].substring(1)}')),
                        border: Border.all(
                          width: 4.0,
                          color: widget.selectedColor == index
                              ? Colors.blueAccent
                              : Colors.black,
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
            widget.product.varients[widget.selectedColor]['sizes'].isNotEmpty)
          SizedBox(height: mq.width * .03),
        if (widget.product.varients.isNotEmpty ||
            widget.product.varients[widget.selectedColor]['sizes'].isNotEmpty)
          const Divider(thickness: 2),
        if (widget.product.varients.isNotEmpty ||
            widget.product.varients[widget.selectedColor]['sizes'].isNotEmpty)
          SizedBox(height: mq.width * .03),
      ],
    );
  }
}
