import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/features/home/widgets/address_box.dart';
import 'package:ecommerce_major_project/features/search/widgets/searched_product.dart';
import 'package:ecommerce_major_project/features/search/services/search_services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "/search-screen";
  final String searchQuery;
  const SearchScreen({required this.searchQuery, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  final SearchServices searchServices = SearchServices();

late Size mq = MediaQuery.of(context).size;
  @override
  void initState() {
    super.initState();
    fetchSearchedProduct();
  }

  // void navigateToSearchScreen(String query) {
  //   //make sure to pass the arguments here!

  //   Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  // }

  //fetching the searched product with the search query
  fetchSearchedProduct() async {
    products = await searchServices.searchProducts(
        context: context, query: widget.searchQuery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
        context: context,
        wantBackNavigation: true,
        title: "All results for ${widget.searchQuery}",
        // onClickSearchNavigateTo:
        //     MySearchScreen(searchQueryAlready: widget.searchQuery)
      ),
      body: products == null
          ? const ColorLoader2()
          : products!.isEmpty
              ? Center(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no-orderss.png",
                        height: mq.height * .25,
                      ),
                      const Text(
                        "Oops, No product to display",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: mq.height * .01),
                      ElevatedButton(
                          onPressed: () {
                            tabProvider.setTab(0);
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent),
                          child: const Text(
                            "Explore other items!",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                )
              : Column(
                  children: [
                    const AddressBox(),
                    SizedBox(height: mq.width * .025),
                    Expanded(
                      child: ListView.builder(
                          itemCount: products!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  context
                                      .push('/product/${products![index].id}');
                                },
                                child:
                                    SearchedProduct(product: products![index]));
                          }),
                    )
                  ],
                ),
    );
  }
}
