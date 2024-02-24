import 'dart:convert';
import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';
import 'package:ecommerce_major_project/features/checkout/widgets/order_dialog.dart';
import 'package:ecommerce_major_project/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
// import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ecommerce_major_project/features/checkout/widgets/delivery_product.dart';
import 'package:ecommerce_major_project/features/checkout/services/checkout_services.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';
  final String totalAmount;
  final List<Cart> mycart;
  final List<dynamic> userProviderCart;
  const CheckoutScreen(
      {super.key,
      required this.totalAmount,
      required this.mycart,
      required this.userProviderCart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController flatBuildingController = TextEditingController();
late Size mq = MediaQuery.of(context).size;

  String? recentOrderId;
  int totalAmount = 0;
  int deliveryAmount = 0;
  int currentStep = 0;
  bool addnewAdress = false;
  bool goToPayment = false;
  bool paymentProcess = false;
  String addressToBeUsed = "";
  final _razorpay = Razorpay();
  bool goToFinalPayment = false;
  // List<PaymentItem> paymentItems = [];
  final _addressFormKey = GlobalKey<FormState>();
  final CheckoutServices addressServices = CheckoutServices();
  List<String> checkoutSteps = ["Address", "Delivery", "Payment"];
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  void initState() {
    super.initState();
    // paymentItems.add(
    //   PaymentItem(
    //     label: 'Total Amount',
    //     amount: widget.totalAmount,
    //     status: PaymentItemStatus.final_price,
    //   ),
    // );

    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    totalAmount = double.parse(widget.totalAmount).toInt();
  }

  @override
  void dispose() {
    areaController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    flatBuildingController.dispose();
    super.dispose();
  }

  Future<void> calculateDeliveryCharge(String pincode) async {
    dynamic charges =
        await addressServices.getDeliveryCharges(context, pincode);
    deliveryAmount = charges['deliveryCharges'] as int;
    totalAmount += charges['deliveryCharges'] as int;
  }

  void deliverToThisAddress(String addressFromProvider) async {
    addressToBeUsed = "";

    if (addnewAdress || addressFromProvider == "") {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}";
        addressServices.saveUserAddress(
            context: context, address: addressToBeUsed);
        int indexOfHyphen = addressToBeUsed.lastIndexOf('-');
        await calculateDeliveryCharge(
            addressToBeUsed.substring(indexOfHyphen + 1));
        setState(() {
          goToPayment = true;
        });
      } else {
        //throw Exception("Please enter all the values");
      }
    } else {
      addressToBeUsed = addressFromProvider;
      int indexOfHyphen = addressToBeUsed.lastIndexOf('-');
      await calculateDeliveryCharge(
          addressToBeUsed.substring(indexOfHyphen + 1));
      setState(() {
        goToPayment = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    var address = user.address;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: GlobalVariables.getAppBar(
          context: context,
          wantActions: false,
          title: "Checkout",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: Column(
              children: [
                SizedBox(
                  width: mq.width * .8,
                  height: mq.height * .06,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // left container
                          Container(
                            // alignment: Alignment.centerLeft,
                            height: mq.height * .004,
                            width: mq.width * .3,
                            color: goToPayment
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                          // right container
                          Container(
                            // alignment: Alignment.centerLeft,
                            height: mq.height * .004,
                            width: mq.width * .3,
                            color: goToFinalPayment
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: i == 0
                                    ? const BorderSide(width: 1.5)
                                    : goToPayment && i == 1
                                        ? const BorderSide(width: 1.5)
                                        : goToFinalPayment && i == 2
                                            ? const BorderSide(width: 1.5)
                                            : BorderSide.none,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(mq.height * .01),
                                // color: Colors.red,
                                alignment: Alignment.center,
                                foregroundDecoration: const BoxDecoration(),
                                child: Text(checkoutSteps[i]),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                goToPayment
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: mq.height * .03),
                          Container(
                            padding: EdgeInsets.only(left: mq.width * .025),
                            child: Text(
                              "Total Payable Amount: ${indianRupeesFormat.format(double.parse(totalAmount.toString()))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: mq.width * .025),
                            child: Text(
                              "Delivery Charges: ${indianRupeesFormat.format(double.parse(deliveryAmount.toString()))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: mq.height * .02),
                          CustomButton(
                              text:
                                  paymentProcess ? "Processing..." : "Pay now",
                              onTap: () async {
                                if (paymentProcess) {
                                  return;
                                }
                                setState(() {
                                  goToFinalPayment = true;
                                  paymentProcess = true;
                                });
                                bool isProductAvailable =
                                    await CheckoutServices()
                                        .checkProductsAvailability(context);

                                if (isProductAvailable && context.mounted) {
                                  //Order is placed first to pass the order ID in razor pay.
                                  Response? response =
                                      await addressServices.placeOrder(
                                    context: context,
                                    address: user.address,
                                    cart: widget.userProviderCart,
                                    totalSum: totalAmount,
                                  );

                                  if (response?.statusCode == 200) {
                                    try {
                                      Map<String, dynamic> options =
                                          jsonDecode(response!.body);
                                      recentOrderId = options["description"];

                                      _razorpay.open(options);
                                    } catch (e) {
                                      recentOrderId = null;
                                      setState(() {
                                        paymentProcess = false;
                                      });

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Error : $e")));
                                      }
                                    }
                                  } else {
                                    recentOrderId = null;
                                    setState(() {
                                      paymentProcess = false;
                                    });
                                    paymentProcess = false;
                                  }
                                } else {
                                  setState(() {
                                    goToFinalPayment = false;
                                    paymentProcess = false;
                                  });
                                }
                              },
                              color: paymentProcess
                                  ? const Color.fromARGB(255, 108, 255, 255)
                                      .withOpacity(0.5)
                                  : const Color.fromARGB(255, 108, 255, 255)),
                          SizedBox(height: mq.height * .02),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: const Text("Order Summary",
                                  style: TextStyle(fontSize: 20))),
                          SizedBox(height: mq.height * .02),
                          SizedBox(
                            // height: mq.height * .55,
                            // width: double.infinity,
                            child: ListView.separated(
                              // padding: EdgeInsets.all(10),
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.mycart.length,
                              itemBuilder: (context, index) {
                                return OrderSummaryProduct(
                                  index: index,
                                  product: widget.mycart[index].product,
                                  color: widget.mycart[index].color,
                                  size: widget.mycart[index].size,
                                  productQuantity:
                                      widget.mycart[index].quantity,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: mq.height * 0.01,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: mq.height * .02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (address.isNotEmpty)
                              const Text("Pick an address",
                                  style: GlobalVariables.appBarTextStyle),
                            if (address.isNotEmpty)
                              SizedBox(height: mq.height * .015),
                            if (address.isNotEmpty)
                              addnewAdress
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          addnewAdress = !addnewAdress;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 2,
                                            color: const Color.fromARGB(
                                                255, 156, 152, 163),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(mq.width * .025),
                                          child: Text(
                                            "Delivery to : $address",
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    )
                                  : badges.Badge(
                                      // displaying no of items in cart
                                      badgeContent: const Icon(
                                        Icons.check_circle,
                                        color: Color.fromARGB(255, 93, 36, 179),
                                      ),
                                      badgeStyle: const badges.BadgeStyle(
                                        badgeColor:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 2,
                                            color: const Color.fromARGB(
                                                255, 93, 36, 179),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(mq.width * .025),
                                          child: Text(
                                            "Delivery to : $address",
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ),
                            SizedBox(height: mq.height * .025),
                            address.isNotEmpty
                                ? const Text(
                                    "OR ADD NEW ADDRESS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  )
                                : const Text("ADD A NEW ADDRESS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                            SizedBox(height: mq.height * .025),
                            Focus(
                              onFocusChange: (value) {
                                setState(() {
                                  addnewAdress = true;
                                });
                              },
                              child: Form(
                                key: _addressFormKey,
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                                      text: address.isNotEmpty
                                          ? addnewAdress
                                              ? "Deliver to new address"
                                              : "Deliver to selected address"
                                          : "Deliver to new address",
                                      onTap: () {
                                        deliverToThisAddress(address);
                                      },
                                      color: Colors.amber[400],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (recentOrderId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.push('/status/$recentOrderId');
      });
      //recentOrderId = null;
    } else {
      OrderDialog.showOrderStatusDialog(
        context,
        subtitle: "Your payment will be refunded soon!",
      );
      recentOrderId = null;
      return;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CheckoutServices().updateOrderWhenCancelled(
      context: context,
      orderId: recentOrderId ?? '',
    );
    OrderDialog.showOrderStatusDialog(
      context,
      subtitle:
          "Payment Error ==> Code : ${response.code} \nMessage : ${response.message}",
    );
    recentOrderId = null;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    OrderDialog.showOrderStatusDialog(
      context,
      isPaymentSuccess: true,
      title: "Your order has been placed!",
      subtitle: "External Wallet : ${response.walletName}",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("External Wallet"),
        content: Text("External Wallet : ${response.walletName}"),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
    recentOrderId = null;
  }
}
