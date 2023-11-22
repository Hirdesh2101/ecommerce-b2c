import 'dart:ui';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';
import 'package:ecommerce_major_project/features/checkout/services/checkout_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeliveyLocation extends StatefulWidget {
  const DeliveyLocation({super.key});

  @override
  State<DeliveyLocation> createState() => _DeliveyLocationState();
}

class _DeliveyLocationState extends State<DeliveyLocation> {
  final _addressFormKey = GlobalKey<FormState>();
  final CheckoutServices addressServices = CheckoutServices();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController flatBuildingController = TextEditingController();
  int deliveryAmount = 0;
  dynamic date = DateTime.now();
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  void initState() {
    final address =
        Provider.of<UserProvider>(context, listen: false).user.address;
    int indexOfHyphen = address.lastIndexOf('-');
    calculateDeliveryCharge(address.substring(indexOfHyphen + 1));
    super.initState();
  }

  @override
  void dispose() {
    areaController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    flatBuildingController.dispose();
    super.dispose();
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMM, EEEE');
    return formatter.format(dateTime);
  }

  Future<void> calculateDeliveryCharge(String pincode) async {
    dynamic charges =
        await addressServices.getDeliveryCharges(context, pincode);
    setState(() {
      deliveryAmount = charges['deliveryCharges'] as int;
      date = charges['deliveryDate'];
    });
  }

  void saveUserAddress() {
    var addressToBeUsed = "";
    if (_addressFormKey.currentState!.validate()) {
      addressToBeUsed =
          "${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}";
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
      int indexOfHyphen = addressToBeUsed.lastIndexOf('-');
      calculateDeliveryCharge(addressToBeUsed.substring(indexOfHyphen + 1));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = context.watch<UserProvider>().user.address;
    int indexOfHyphen = address.lastIndexOf('-');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deliver to: ${address.substring(indexOfHyphen + 1)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    elevation: 0,
                    builder: (context) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.grey
                                    .withOpacity(0.5), // Adjust the opacity
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                            child: Form(
                              key: _addressFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                      controller: flatBuildingController,
                                      hintText: "Flat, House No."),
                                  SizedBox(height: mq.height * .01),
                                  CustomTextField(
                                      controller: areaController,
                                      hintText: "Area, Street"),
                                  SizedBox(height: mq.height * .01),
                                  CustomTextField(
                                      controller: pincodeController,
                                      hintText: "Pincode",
                                      inputType: TextInputType.number),
                                  SizedBox(height: mq.height * .01),
                                  CustomTextField(
                                      controller: cityController,
                                      hintText: "Town/City"),
                                  SizedBox(height: mq.height * .04),
                                  CustomButton(
                                    text: "Save Address",
                                    onTap: () {
                                      saveUserAddress();
                                    },
                                    color: Colors.amber[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Change',
                  style: TextStyle(color: Colors.orange.shade800),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: mq.width * .02),
        Row(
          children: [
            const Icon(
              Icons.delivery_dining_outlined,
              color: Colors.grey,
              size: 28,
            ),
            SizedBox(width: mq.width * .03),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${deliveryAmount == 0 ? 'Free Delivery' : "Charges: ${indianRupeesFormat.format(double.parse(deliveryAmount.toString()))}"} | Delivery by ${formatDateTime(DateTime.parse(date.toString()))}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
