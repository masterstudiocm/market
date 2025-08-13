import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:market/classes/connection.dart';
import 'package:market/components/products/carousel_products.dart';
import 'package:market/components/single_product/appbar.dart';
import 'package:market/components/single_product/bottom.dart';
import 'package:market/components/single_product/rating.dart';
import 'package:market/components/single_product/tabs.dart';
import 'package:market/components/single_product/title.dart';
import 'package:market/components/single_product/variations.dart';
import 'package:market/controllers/variation_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/notify.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:market/widgets_extra/snackbar.dart';

class SingleProductPage extends StatefulWidget {
  final Map? data;
  final String? slug;
  const SingleProductPage({super.key, this.data, this.slug});

  @override
  State<SingleProductPage> createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  Map data = {};
  String slug = '';
  bool loading = false;
  bool serverError = false;
  bool connectError = false;
  List related = [];
  List combined = [];
  Map variations = {};
  bool safearea = false;

  final variationController = Get.put(VariationController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      setState(() {
        if (scrollController.position.pixels > 500) {
          safearea = true;
        } else {
          safearea = false;
        }
      });
    });

    variationController.reset();
    if (widget.data != null) {
      data = widget.data!;
      slug = data['post_slug'];
    } else {
      slug = widget.slug!;
      loading = true;
    }
    get();
  }

  Future<void> get() async {
    if (await checkConnectivity()) {
      String query = insertQuery('${App.domain}/api/product.php?action=get&slug=$slug');

      try {
        final response = await Dio().get(query, options: Options(headers: App.headers));
        if (response.statusCode == 200) {
          if (mounted) {
            var result = response.data;
            setState(() {
              if (result['status'] == 'success') {
                data = result['result']['postdata'];
                related = result['result']['related'];
                combined = result['result']['combined'];
                if (result['result']['variations'] is Map) {
                  variations = result['result']['variations'];
                }
              }
            });
          }
        } else {
          setState(() => serverError = true);
        }
      } catch (e) {
        setState(() => serverError = true);
        SnackbarGlobal.show('Single Product: ${e.toString()}');
      }
    } else {
      setState(() => connectError = true);
    }
    setState(() => loading = false);
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      data = {};
    });
    get();
  }

  void changeGallery(List value) {
    setState(() {
      data['gallery'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (data.isNotEmpty) ? SingleProductBottom(data: data, variations: variations) : null,
      body: SafeArea(
        top: safearea,
        child: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (data.isEmpty)
              ? MsNotify(heading: 'Heç bir məlumat tapılmadı', action: _refreshPage)
              : CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SingleProductAppBar(data: data),
                    SliverToBoxAdapter(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.0.r),
                                  SingleProductRating(data: data),
                                  SizedBox(height: 10.0.r),
                                  SingleProductTitle(data: data),
                                  SizedBox(height: 20.0.r),
                                  if (data['product_type'] == 'variable') ...[
                                    VariationProduct(
                                      data: variations,
                                      gallery: (data['variation_gallery'] is Map) ? data['variation_gallery'] : {},
                                      changeGallery: changeGallery,
                                    ),
                                  ],
                                  SingleProductTabs(data: data),
                                ],
                              ),
                            ),
                            if (combined.isNotEmpty) ...[SizedBox(height: 30.0.r), CarouselProducts(products: combined, title: 'Əlaqəli məhsullar')],
                            if (related.isNotEmpty) ...[SizedBox(height: 30.0.r), CarouselProducts(products: related, title: 'Oxşar məhsullar')],
                            SizedBox(height: 15.0.r),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
