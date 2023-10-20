import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/home_screen.dart';
import 'package:ecommerce_major_project/features/account/screens/account_screen.dart';
import 'package:ecommerce_major_project/features/category_grid/category_grid_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = "/actual-home";
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  //int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const CategoryGridScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  // void updatePage(int page) {
    
  // }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    myTextTheme = Theme.of(context).textTheme;
    final tabProvider = Provider.of<TabProvider>(context);
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      body: pages[tabProvider.tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabProvider.tab,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: (val){
          tabProvider.setTab(val);
        },
        items: [
          //HOME PAGE
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: tabProvider.tab == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: tabProvider.tab == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          // CATEGORIES
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: tabProvider.tab == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: tabProvider.tab == 1
                  ? const Icon(Icons.grid_view_sharp)
                  : const Icon(Icons.grid_view_outlined),
            ),
            label: '',
          ),
          //CART
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: tabProvider.tab == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: badges.Badge(
                // displaying no of items in cart
                badgeContent: Text("$userCartLen",
                    style: const TextStyle(color: Colors.white)),

                badgeStyle: const badges.BadgeStyle(
                    badgeColor: Color.fromARGB(255, 19, 17, 17)),
                child: tabProvider.tab == 2
                    ? const Icon(Icons.shopping_cart_rounded)
                    : const Icon(
                        Icons.shopping_cart_outlined,
                      ),
              ),
            ),
            label: '',
          ),
          //ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: tabProvider.tab == 3
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth),
                ),
              ),
              child: tabProvider.tab == 3
                  ? const Icon(Icons.person_rounded)
                  : const Icon(Icons.person_outlined),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
