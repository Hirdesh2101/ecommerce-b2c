import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/screens/top_categories.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: GlobalVariables.getAppBar(
              context: context,
              wantBackNavigation: false,
              onClickSearchNavigateTo: const MySearchScreen()),

          body: const TopCategories(),
          ),
    );
  }
}
