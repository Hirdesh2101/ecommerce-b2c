import 'dart:io';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/return_product/services/refund_service.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';

class ReturnProductScreen extends StatefulWidget {
  const ReturnProductScreen(
      {super.key, required this.order, required this.selectedProduct});
  final Order order;
  final List<dynamic> selectedProduct;

  @override
  State<ReturnProductScreen> createState() => _ReturnProductScreenState();
}

class _ReturnProductScreenState extends State<ReturnProductScreen> {
  final _returnProuctFormKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  RefundServices refundServices = RefundServices();
  bool isLoading = false;

  List<File> images = [];
  bool showLoader = false;

  void selectImages() async {
    var result = await pickImages();
    setState(() {
      images.addAll(result);
    });
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GlobalVariables.getAppBar(
            title: "Return Product",
            context: context,
            onClickSearchNavigateTo: const MySearchScreen()),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _returnProuctFormKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .03),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mq.height * .01),
                    const Text("Why do want to return the product?",
                        style: TextStyle(fontSize: 18)),
                    Text(
                      "We deeply regret the inconvenience caused. Please take a minute to fill this feedback form",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    SizedBox(height: mq.height * .02),
                    images.isNotEmpty
                        ?
                        // images picked are not null
                        images.length == 1
                            ? Center(
                                child: Image.file(
                                  images[0],
                                  fit: BoxFit.cover,
                                  height: mq.width * .48,
                                ),
                              )
                            : CarouselSlider(
                                items: images.map((i) {
                                  return Builder(
                                    builder: (context) => Image.file(
                                      i,
                                      fit: BoxFit.cover,
                                      height: mq.width * .48,
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 2),
                                  viewportFraction: 1,
                                  height: mq.width * .48,
                                ),
                              )
                        :
                        // no images picked
                        GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(mq.width * .025),
                              dashPattern: const [10, 4.5],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: mq.height * .1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: mq.height * .02),
                                    const Text("Upload images",
                                        style:
                                            TextStyle(color: Colors.black26)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    if (images.length == 1) SizedBox(height: mq.height * .03),
                    if (images.length == 1)
                      GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(mq.width * .025),
                          dashPattern: const [10, 4.5],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: mq.height * .1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40),
                                Text(
                                  "Add More Images images.\nMinimum 2 images required!",
                                  style: TextStyle(
                                    color: Colors.black26,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: mq.height * .03),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Tell us what went wrong",
                      maxLines: 4,
                    ),
                    SizedBox(height: mq.height * .03),
                    ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (descriptionController.text.trim().isEmpty) {
                                  showSnackBar(
                                      context: context,
                                      text: 'Please tell us what went wrong!');
                                  return;
                                }
                                if (images.isEmpty) {
                                  showSnackBar(
                                      context: context,
                                      text: 'Please add images!');
                                  return;
                                }
                                if (images.length < 2) {
                                  showSnackBar(
                                      context: context,
                                      text: 'Please select atlest 2 images!');
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                refundServices
                                    .requestRefund(
                                        context: context,
                                        order: widget.order,
                                        reason:
                                            descriptionController.text.trim(),
                                        images: images,
                                        productArray: widget.selectedProduct)
                                    .then((_) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            // alignment: Alignment.center,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 88, 88)),
                        child: Text(
                          isLoading? "Please Wait..":"Return Product",
                          style: const TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
