import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Pay Now"),
      onPressed: () {
        var options = {
          'key': 'rzp_test_7NBmERXaABkUpY',
          //amount is in paisa, multiply by 100 to convert
          'amount': 100,
          'name': 'AKR Company',
          'description': 'Ecommerce Bill',
          'prefill': {
            'contact': '8888888888',
            'email': 'test@razorpay.com',
          }
        };

        try {
          _razorpay.open(options);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error : $e")));
        }
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black12, width: 4),
              ),
              actionsAlignment: MainAxisAlignment.end,
              // actionsPadding: EdgeInsets.only(right: 20, bottom: 20),
              title:
                  Image.asset("assets/images/croppedsuccess.gif", height: 150),
              content: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // normal
                    const Text(
                      "Your order has been placed",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.black87),
                    ),

                    // with google fonts
                    Text("Your order has been placed",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.black87),
                        )),
                    const SizedBox(height: 10),
                    Text(
                        "Transaction ID : 38991357462586421\nTime: ${DateTime.now().hour} : ${DateTime.now().minute}"),
                  ],
                ),
              ),
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
        });
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(
            "Payment ID : ${response.paymentId}\nOrder ID : ${response.orderId}\nSignature : ${response.signature}"),
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
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Oops, Error occured"),
        content: Text(
            "Payment Error ==> Code : ${response.code} \nMessage : ${response.message}"),
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
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    

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
  }
}

///frontend - wigets , packages 
///theming sizing 
/// ---service--- 
/// ---globals---
/// ---modals---
/// kam chalu kre ya wait 
/// <---chalu--->
///
/// mongodb  --- atlas //search (512mb)
/// 