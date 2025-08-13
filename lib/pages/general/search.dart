import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/products/load_products.dart';
import 'package:market/components/search/history.dart';
import 'package:market/components/search/input.dart';
import 'package:market/components/search/popular_keywords.dart';
import 'package:market/controllers/search_controller.dart';
import 'package:market/widgets_extra/appbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = Get.find<SearchProductController>();

  @override
  void dispose() {
    super.dispose();
    searchController.add('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Axtarış')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchInput(),
          Obx(
            () => Expanded(
              child: (searchController.keyword.value != '')
                  ? ListView(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0).r,
                          child: Text('Axtarış nəticələriniz', style: Theme.of(context).textTheme.titleSmall),
                        ),
                        LoadProducts(
                          key: searchController.loadProductsKey,
                          physics: const NeverScrollableScrollPhysics(),
                          search: searchController.keyword.value,
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0).r,
                        ),
                      ],
                    )
                  : ListView(shrinkWrap: true, padding: const EdgeInsets.all(20.0).r, children: const [SearchHistory(), PopularKeywods()]),
            ),
          ),
        ],
      ),
    );
  }
}
