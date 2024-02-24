import 'package:ecommerce_major_project/app_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingSplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const LoadingSplashScreen({super.key});

  @override
  State<LoadingSplashScreen> createState() => _LoadingSplashScreenState();
}

class _LoadingSplashScreenState extends State<LoadingSplashScreen> {
  late AppService _appService;
late Size mq = MediaQuery.of(context).size;

  @override
  void initState() {
    _appService = Provider.of<AppService>(context, listen: false);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await _appService.onAppStart(context);
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    // SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
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
