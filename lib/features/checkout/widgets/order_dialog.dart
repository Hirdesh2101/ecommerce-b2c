import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderDialog {
  static Future showOrderStatusDialog(context,
      {bool isPaymentSuccess = false,
      String title = "Order not placed",
      String subtitle = "Please try again!"}) {
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black12, width: 4),
        ),
        actionsAlignment: MainAxisAlignment.end,
        // actionsPadding: EdgeInsets.only(right: 20, bottom: 20),
        title: isPaymentSuccess
            ? Image.asset("assets/images/successpayment.JPG", height: 150)
            : Image.asset("assets/images/failedpayment.png", height: 150),
        content: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // with google fonts
              Text(
                title,
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: GoogleFonts.lato(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              tabProvider.setTab(0);
              context.go('/');
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
