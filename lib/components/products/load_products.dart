import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:market/components/products/single_product_item.dart';
import 'package:market/components/products/tools/filter_button.dart';
import 'package:market/components/products/tools/sort_button.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/pages/ecommerce/filter.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LoadProducts extends StatefulWidget {
  final String? search;
  final String? multiple;
  final Map? filter;
  final bool tools;
  final String sort;
  final String? type;
  final ScrollPhysics? physics;
  final EdgeInsets padding;
  final String? disabledFilter;

  const LoadProducts({
    super.key,
    this.search,
    this.multiple,
    this.filter,
    this.tools = false,
    this.sort = 'new',
    this.type,
    this.physics,
    this.padding = const EdgeInsets.all(20.0),
    this.disabledFilter,
  });

  @override
  State<LoadProducts> createState() => _LoadProductsState();
}

class _LoadProductsState extends State<LoadProducts> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List products = [];
  bool noProducts = false;
  int limit = 12;
  int offset = 0;
  String sort = '';
  Map filter = {};
  List price = [];
  bool loadMore = false;

  final sitedataController = Get.find<SiteDataController>();

  Future<void> get() async {
    String url = '${App.domain}/api/products.php?action=get';

    url = '$url&image_size=product&sort=$sort&limit=$limit&offset=$offset';

    if (widget.search != null) {
      url = '$url&search=${widget.search}';
    }

    if (widget.multiple != null) {
      url = '$url&multiple=${widget.multiple}';
    }

    if (filter.isNotEmpty) {
      filter.forEach((key, value) {
        url = '$url&$key=${value.join(',')}';
      });
    }

    if (widget.type != null) {
      url = '$url&type=${widget.type}';
    }

    if (price.isNotEmpty) {
      url = '$url&min=${price[0]}&max=${price[1]}';
    }

    Map result = await httpRequest(url);
    final payload = result['payload'];

    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      loadMore = false;

      if (payload['status'] == 'success') {
        products += payload['result'];
        noProducts = false;
      } else {
        noProducts = true;
      }
    });

    if (mounted && payload['status'] == 'success') {
      for (var i = 0; i < payload['result'].length; i++) {
        if (payload['result'][i]['thumbnail_url'] != null) {
          var image = CachedNetworkImageProvider(payload['result'][i]['thumbnail_url'], headers: App.headers);
          precacheImage(image, context);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sort = widget.sort;
    if (widget.filter != null) {
      filter = widget.filter!;
    }
    get();
  }

  void reset() {
    setState(() {
      products = [];
      loading = true;
      serverError = false;
      connectError = false;
      noProducts = false;
      offset = 0;
      loadMore = false;
    });
  }

  void _refreshPage() {
    reset();
    get();
  }

  void changeSort(String value) {
    setState(() {
      sort = value;
    });
    reset();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return MsContainer(
      loading: loading,
      serverError: serverError,
      connectError: connectError,
      action: _refreshPage,
      child: CustomScrollView(
        physics: widget.physics,
        shrinkWrap: true,
        slivers: [
          if (widget.tools) ...[
            SliverAppBar(
              toolbarHeight: 60.0.r,
              backgroundColor: Theme.of(context).colorScheme.base,
              floating: true,
              leading: const SizedBox(),
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0).r,
                child: Row(
                  children: [
                    SortButton(onChanged: changeSort, selected: sort),
                    SizedBox(width: 10.0.r),
                    FilterButton(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterPage(filter: filter, price: price, disabled: widget.disabledFilter),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            filter = result['filter'];
                            price = result['price'];
                          });
                          reset();
                          get();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: (products.isEmpty)
                ? SimpleNotify(text: 'Heç bir nəticə tapılmadı.')
                : Padding(
                    padding: widget.padding,
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet(context) ? 3 : 2,
                            childAspectRatio: 1 / 2,
                            mainAxisSpacing: 10.0.r,
                            crossAxisSpacing: 10.0.r,
                          ),
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleProductItem(data: products[index]);
                          },
                        ),
                        if (noProducts) ...[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 20.0).r,
                              child: Text('Göstəriləcək başqa məhsul yoxdur.', textAlign: TextAlign.center),
                            ),
                          ),
                        ] else if (products.length < limit) ...[
                          const SizedBox(),
                        ] else ...[
                          VisibilityDetector(
                            key: Key('visibility_detector_${products.length}'),
                            onVisibilityChanged: (visibilityInfo) {
                              var visiblePercentage = visibilityInfo.visibleFraction * 100;
                              if (visiblePercentage == 100 && !loadMore) {
                                setState(() {
                                  loadMore = true;
                                  offset = offset + limit;
                                  get();
                                });
                              }
                            },
                            child: MsIndicator(),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
