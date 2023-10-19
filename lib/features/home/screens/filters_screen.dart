import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';

enum FilterType { atoZ, priceLtoH, priceHtoL }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          "Filters",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"))
        ],
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
    print(filterProvider2.filterNumber);
    _character = filterProvider2.filterNumber == 0
        ? null
        : getFilterType(filterProvider2.filterNumber);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    return Column(
      children: <Widget>[
        RadioListTile(
          activeColor: Colors.deepPurple.shade700,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: .1)),
          title: const Text('a-z'),
          value: FilterType.atoZ,
          groupValue: _character,
          onChanged: (FilterType? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.deepPurple.shade700,
          title: const Text('Price Low to High'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: .1)),
          value: FilterType.priceLtoH,
          groupValue: _character,
          onChanged: (FilterType? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.deepPurple.shade700,
          title: const Text('Price High to Low'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: .1)),
          value: FilterType.priceHtoL,
          groupValue: _character,
          onChanged: (FilterType? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  filterProvider.setFilterNumber(0);
                  Navigator.pop(context);
                },
                child: Text(
                  "\nClear",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple.shade700,
                      fontSize: 16),
                )),
            TextButton(
                onPressed: () {
                  if (_character == FilterType.atoZ) {
                    filterProvider.setFilterNumber(1);
                  } else if (_character == FilterType.priceLtoH) {
                    filterProvider.setFilterNumber(2);
                  } else if (_character == FilterType.priceHtoL) {
                    filterProvider.setFilterNumber(3);
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  "\nSubmit",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple.shade700,
                      fontSize: 16),
                )),
          ],
        )
      ],
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
