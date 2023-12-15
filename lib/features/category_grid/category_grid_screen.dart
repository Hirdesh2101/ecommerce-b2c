import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CategoryGridScreen extends StatefulWidget {
  const CategoryGridScreen({super.key});

  @override
  State<CategoryGridScreen> createState() => _CategoryGridScreenState();
}

class _CategoryGridScreenState extends State<CategoryGridScreen> {
  void navigateToCategoryPage(BuildContext context, String category) {
    context.go('category/$category');
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
          title: "All Categories",
          //onClickSearchNavigateTo: const MySearchScreen()
          ),
      body: GridView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(mq.height * .01),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.4,
            crossAxisSpacing: mq.width * .03,
            mainAxisSpacing: mq.width * .015,
            crossAxisCount: 2),
        itemCount: categoryProvider.tab,
        itemBuilder: (context, index) {
          // print("\n\nimage path is : ${myCategoryList[index]['title']}");
          final categoryTitle = categoryProvider.category[index].name;
          final categoryImage = categoryProvider.category[index].image;

          return InkWell(
            onTap: () {
              navigateToCategoryPage(
                  context, categoryProvider.category[index].name);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.network(categoryImage),
                  ),
                  SizedBox(height: mq.height * .01),
                  Text(
                    categoryTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 16),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
