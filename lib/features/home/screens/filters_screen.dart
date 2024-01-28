import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';

import '../../../constants/global_variables.dart';
import '../../../services/event_logging/analytics_events.dart';
import '../../../services/event_logging/analytics_service.dart';
import '../../../services/get_it/locator.dart';

enum FilterType { atoZ, priceLtoH, priceHtoL }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  final AnalyticsService _analytics = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leadingWidth: 50,
        leading: IconButton(
          onPressed: ()
          {
            _analytics.track(eventName: AnalyticsEvents.addToCart, properties:{});
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
        title: Text("Sort By",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const FiltersAvailable(),
    );
  }
}

class FiltersAvailable extends StatefulWidget {
  const FiltersAvailable({super.key});

  @override
  State<FiltersAvailable> createState() => _FiltersAvailableState();
}

class _FiltersAvailableState extends State<FiltersAvailable> {
  FilterType? _character;

  @override
  void didChangeDependencies() {
    final filterProvider2 = Provider.of<FilterProvider>(context);

    _character = filterProvider2.filterNumber == 0
        ? null
        : getFilterType(filterProvider2.filterNumber);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final filterProvider = Provider.of<FilterProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 18),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: mq.height * 0.04,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
               // didChangeDependencies();
              },
              child: Text(
                GlobalVariables.sortList[index],
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ));
        },
        itemCount: GlobalVariables.sortList.length,
      ),
    );
  }

  FilterType? getFilterType(int filterNumber) {
    switch (filterNumber) {
      case 1:
        return FilterType.atoZ;
      case 2:
        return FilterType.priceLtoH;
      case 3:
        return FilterType.priceHtoL;
      default:
        return null;
    }
  }
}
