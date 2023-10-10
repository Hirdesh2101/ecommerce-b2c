import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class LoadingSplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  const LoadingSplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    // You have to call it on your starting screen
    // SizeConfig().init(context);
    return  Scaffold(
      body:SafeArea(
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 50,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: mq.width * .03),
                Text(
                  "eSHOP",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.orange.shade400,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
