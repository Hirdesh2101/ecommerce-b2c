import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    this.text,
    this.image,
  });
  final String? text, image;

  @override
  Widget build(BuildContext context) {
late Size mq = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 40,
              // height: mq.height * .04,
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
        Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const Spacer(flex: 2),
        Image.asset(
          image!,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}
