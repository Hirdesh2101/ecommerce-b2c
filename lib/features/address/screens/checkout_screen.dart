import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';
import 'package:ecommerce_major_project/features/address/widgets/order_dialog.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ecommerce_major_project/features/address/widgets/delivery_product.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/features/address/services/checkout_services.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';
  final String totalAmount;
  final List<Map<String,dynamic>> cart;
  const CheckoutScreen({super.key, required this.totalAmount,required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController flatBuildingController = TextEditingController();

  int totalAmount = 0;
  int currentStep = 0;
  bool addnewAdress = false;
  bool goToPayment = false;
  String addressToBeUsed = "";
  final _razorpay = Razorpay();
  bool goToFinalPayment = false;
  List<PaymentItem> paymentItems = [];
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
    paymentItems.add(
      PaymentItem(
        label: 'Total Amount',
        amount: widget.totalAmount,
        status: PaymentItemStatus.final_price,
      ),
    );

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

  void placeOrder(String addressFromProvider) {
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: num.parse(widget.totalAmount));
  }

  void deliverToThisAddress(String addressFromProvider) {
    addressToBeUsed = "";

    if (addnewAdress || addressFromProvider == "") {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}";
        addressServices.saveUserAddress(
            context: context, address: addressToBeUsed);
        setState(() {
          goToPayment = true;
        });
      } else {
        //throw Exception("Please enter all the values");
      }
    } else {
      addressToBeUsed = addressFromProvider;
      setState(() {
        goToPayment = true;
      });
    }

    print("Address to be used:\n==> $addressToBeUsed");
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
          onClickSearchNavigateTo: const MySearchScreen(),
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
                              "Total Payable Amount: ${indianRupeesFormat.format(double.parse(widget.totalAmount))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: mq.height * .02),
                          CustomButton(
                              text: "Pay now",
                              onTap: () async {
                                setState(() {
                                  goToFinalPayment = true;
                                });
                                bool isProductAvailable =
                                    await CheckoutServices()
                                        .checkProductsAvailability(
                                            context, user.cart);

                                if (isProductAvailable) {
                                  var options = {
                                    'key': 'rzp_test_7NBmERXaABkUpY',
                                    //amount is in paisa, multiply by 100 to convert
                                    'amount': 100 * totalAmount,
                                    'name': 'AKR Company',
                                    'description': 'Ecommerce Bill',
                                    'prefill': {
                                      'contact': '8888888888',
                                      'email': 'test@razorpay.com'
                                    }
                                  };
                                  try {
                                    _razorpay.open(options);

                                    print(
                                        "Inside after razor pay open..............$address");
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Error : $e")));
                                  }
                                } else {
                                  setState(() {
                                    goToFinalPayment = false;
                                  });
                                }
                              },
                              color: const Color.fromARGB(255, 108, 255, 255)),
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
                              itemCount: user.cart.length,
                              itemBuilder: (context, index) {
                                // return CartProdcut
                                return OrderSummaryProduct(index: index,product: Product.fromJson(widget.cart[index]['product']),);
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
    String address =
        Provider.of<UserProvider>(context, listen: false).user.address;
    placeOrder(address);

    print(
        "\n\nPayment successful : \n\nPayment ID :  ${response.paymentId} \n\n Order ID : ${response.orderId} \n\n Signature : ${response.signature}");

    OrderDialog.showOrderStatusDialog(
      context,
      isPaymentSuccess: true,
      title: "Order has been placed!",
      subtitle:
          "Transaction ID : ${DateTime.now().millisecondsSinceEpoch}\nTime: ${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}\nPayment ID : ${response.paymentId}\nOrder ID : ${response.orderId}\nSignature : ${response.signature}",
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        "Payment Error ==> Code : ${response.code} \nMessage : ${response.message}  ");
    OrderDialog.showOrderStatusDialog(
      context,
      subtitle:
          "Payment Error ==> Code : ${response.code} \nMessage : ${response.message}",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet : ${response.walletName}");

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
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
