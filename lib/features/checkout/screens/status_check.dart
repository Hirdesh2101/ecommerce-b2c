import 'dart:async';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/features/checkout/services/checkout_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({
    Key? key,
    required this.orderId,
  }) : super(key: key);
  final String orderId;

  @override
  AddFundsCheckStatusState createState() => AddFundsCheckStatusState();
}

class AddFundsCheckStatusState extends State<CheckStatus> {
  Timer? timer;
  // Timer? timer2;
  bool isLoading = true;
  dynamic status;
  CheckoutServices checkoutServices = CheckoutServices();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      status =
          await checkoutServices.checkPaymentStatus(context, widget.orderId);
      setState(() {
        isLoading = false;
      });
    });
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      //if (!isLoading && status['status'] == "PAYMENT_PENDING") {
      if (status['status'] == "PAYMENT_INITIATED") {
        fetchData();
        debugPrint("Timer");
      }
      if (status['status'] == "PAYMENT_INITIATED") {
        timer?.cancel();
        setState(() {
          status['status'] = null;
        });
      }
      //}
    });
    // timer2 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
    //   setState(() {
    //     if (seconds == 0) {
    //       seconds = 15;
    //     } else {
    //       seconds--;
    //     }
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    // timer2?.cancel();
    super.dispose();
  }

  void fetchData() async {
    status = await checkoutServices.checkPaymentStatus(context, widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text("Order Status",
            style: TextStyle(
                fontStyle: FontStyle.normal, fontSize: 20, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: mq.height * .05),
          isLoading || status['status'] == "PAYMENT_INITIATED"
              ? const Text(
                  'Processing Payment...',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )
              : status['status'] == "PAYMENT_SUCCESS"
                  ? const Text(
                      'Order Placed Successfully',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      'Order Failed',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
          if (!isLoading &&
              status['status'] != "PAYMENY_INITIATED" &&
              status['status'] != "PAYMENT_SUCCESS")
            SizedBox(height: mq.height * .05),
          isLoading || status['status'] == "PAYMENT_INITIATED"
              ? Lottie.asset('assets/transfer_fundsprocess.json',
                  width: mq.width, height: mq.width, fit: BoxFit.cover)
              : status['status'] == "PAYMENT_SUCCESS"
                  ? Lottie.asset('assets/check-okey-done.json',
                      width: mq.width, height: mq.width, fit: BoxFit.cover)
                  : Center(
                      child: Lottie.asset('assets/transaction-canceled.json',
                          width: mq.width * 0.8,
                          height: mq.width * 0.8,
                          fit: BoxFit.cover),
                    ),
          if (!isLoading && status['status'] == "PAYMENT_SUCCESS")
            Text(
              "Order ID : ${status['order']['_id']}\nTime: ${DateTime.fromMillisecondsSinceEpoch(status['order']['orderedAt'])} \nPayment ID : ${status['order']['paymentId']}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          if (!isLoading &&
              status['status'] != "PAYMENT_INITIATED" &&
              status['status'] != "PAYMENT_SUCCESS")
            SizedBox(height: mq.height * .05),
          if (!isLoading &&
              status['status'] != "PAYMENT_INITIATED" &&
              status['status'] != "PAYMENT_SUCCESS")
            const Text(
              "SORRY THE ORDER COULD NOT BE PLACED \nA REFUND HAS BEEN ISSUED\n IT GENERALLY TAKES 5 TO 7 DAYS TO PROCESS THE REFUND AMOUNT",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: mq.height * .05),
          if (!isLoading && status['status'] != "PAYMENT_INITIATED")
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: 'Done',
                  onTap: () {
                    final AuthService authService = AuthService();
                    authService.getUserData(context);
                    tabProvider.setTab(0);
                    context.go('/home');
                  },
                  color: Colors.yellow,
                )),
        ],
      )),
    );
  }
}
