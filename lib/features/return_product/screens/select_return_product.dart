import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/return_product/widgets/return_product.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:go_router/go_router.dart';

class SelectReturnProduct extends StatefulWidget {
  const SelectReturnProduct({super.key, required this.order,required this.copy});
  final Order order;
  final List<dynamic> copy;

  @override
  State<SelectReturnProduct> createState() => _SelectReturnProductState();
}

class _SelectReturnProductState extends State<SelectReturnProduct> {
  List<dynamic> selectedProducts = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GlobalVariables.getAppBar(
            title: "Return Product",
            context: context,
            //onClickSearchNavigateTo: const MySearchScreen()
            ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.01),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * .01),
                const Text("Select a product you want to return :",
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: mq.height * .01),
                Expanded(
                    child: ListView.builder(
                        itemCount: widget.copy.length,
                        itemBuilder: ((context, index) {
                          final product = widget.copy[index];
                          final isSelectedIdx = selectedProducts.indexWhere(
                              (element) =>
                                  element['product'] == product['product']);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelectedIdx != -1) {
                                  selectedProducts.removeAt(isSelectedIdx);
                                } else {
                                  final selectedProduct =
                                      Map<String, dynamic>.from(product);
                                  selectedProduct['quantity'] = 1;
                                  selectedProducts.add(selectedProduct);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  activeColor:
                                      const Color.fromARGB(255, 255, 100, 100),
                                  value: isSelectedIdx != -1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (isSelectedIdx != -1) {
                                        selectedProducts
                                            .removeAt(isSelectedIdx);
                                      } else {
                                        final selectedProduct =
                                            Map<String, dynamic>.from(product);
                                        selectedProduct['quantity'] = 1;
                                        selectedProducts.add(selectedProduct);
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: mq.height * 0.01),
                                    child: ReturnProduct(
                                      products: widget.copy,
                                      index: index,
                                      isSelected: isSelectedIdx != -1,
                                      selectedQuantity: isSelectedIdx != -1
                                          ? selectedProducts[isSelectedIdx]
                                              ['quantity']
                                          : 1,
                                      onQuantitySelected: (quantity) {
                                        if (isSelectedIdx != -1) {
                                          setState(() {
                                            selectedProducts[isSelectedIdx]
                                                ['quantity'] = quantity;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))),
                SizedBox(height: mq.height * .01),
                Container(
                    width: mq.width,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.02),
                    child: ElevatedButton(
                        onPressed: selectedProducts.isEmpty
                            ? null
                            : () {
                              context.go('newreturn',extra: [widget.order,selectedProducts]);
                              },
                        style: ElevatedButton.styleFrom(
                            // alignment: Alignment.center,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 100, 100)),
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
          ),
        ));
  }
}
