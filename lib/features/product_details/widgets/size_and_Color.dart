import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class SizeAndColor extends StatefulWidget {
  const SizeAndColor({super.key});

  @override
  State<SizeAndColor> createState() => _SizeAndColorState();
}

class _SizeAndColorState extends State<SizeAndColor> {
  final List<Color> productColors = [Colors.orange, Colors.green];

  final List<String> productSize = ["XS", "S", "M", "L", "XL", "XXL", "XXXL"];

  int selectedSize = -1;
  int selectedColor = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Size",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          maxLines: 2,
        ),
        SizedBox(height: mq.width * .01),
        SizedBox(
          height: mq.height * .06,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: productSize.length,
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
                        color:  selectedSize== index ? Colors.red.shade400 :Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(44.0),
                    ),
                    child: Text(
                      productSize[index],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: selectedSize== index ? Colors.red.shade400 :Colors.black54,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: mq.width * .03),
        const Text(
          "Color",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          maxLines: 2,
        ),
        SizedBox(height: mq.width * .01),
        SizedBox(
          height: mq.height * .06,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productColors.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(44.0),
                  onTap: () =>
                      setState(() {
                        selectedColor = index;
                      }),
                  child: Container(
                    height: mq.height * .06,
                    width: mq.height * .06,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: productColors[index],
                      border: Border.all(
                        width: 2.0,
                        color: selectedColor == index ?Colors.red: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(44.0),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
