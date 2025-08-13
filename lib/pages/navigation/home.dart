import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/app/app_heading.dart';
import 'package:market/components/home/appbar.dart';
import 'package:market/components/home/features.dart';
import 'package:market/components/home/posts.dart';
import 'package:market/components/home/search.dart';
import 'package:market/components/home/terms.dart';
import 'package:market/components/home/title.dart';
import 'package:market/components/products/carousel_products.dart';
import 'package:market/components/products/load_products.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/pages/general/page.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/annotated.dart';
import 'package:market/widgets/refresh_indicator.dart';
import 'package:market/widgets_extra/navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List slides = [];
  List terms = [];
  List products = [];
  List posts = [];
  bool safearea = false;

  final sitedataController = Get.find<SiteDataController>();
  final tabBarController = Get.find<TabBarController>();

  Future<void> get() async {
    if (!loading) setState(() => loading = true);
    Map result = await httpRequest('${App.domain}/api/home.php?action=get');
    final payload = result['payload'];
    setStateSafe(() {
      if (payload['status'] == 'success') {
        loading = false;
        serverError = result['serverError'];
        connectError = result['connectError'];
        slides = payload['result']['slides'];
        posts = payload['result']['posts'];
        terms = payload['result']['terms'];
        products = payload['result']['new'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return MsAnnotatedRegion(
      type: MsStatusBar.light,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).viewPadding.top,
                color: Theme.of(context).colorScheme.secondaryColor,
              ),
            ),
            SafeArea(
              child: MsRefreshIndicator(
                onRefresh: get,
                child: CustomScrollView(
                  slivers: [
                    HomeAppBar(),
                    HomeSearch(),
                    HomeTitle(slides: slides, loading: loading),
                    if (!loading) ...[
                      SliverToBoxAdapter(
                        child: Container(
                          color: Theme.of(context).colorScheme.base,
                          child: Column(
                            children: [
                              HomeFeatures(),
                              SizedBox(height: 20.0.r),
                              AppHeading(
                                title: 'Kateqoriyalar',
                                onTap: () {
                                  tabBarController.update(1);
                                },
                              ),
                              HomeTerms(terms: terms),
                              SizedBox(height: 40.0.r),
                              CarouselProducts(
                                products: products,
                                title: 'Ən çox satılanlar',
                                onTap: () {
                                  navigatePage(context, GeneralPage(title: 'Bütün məhsullar', child: LoadProducts()));
                                },
                              ),
                              Container(
                                color: Theme.of(context).colorScheme.grey2,
                                padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 15.0).r,
                                child: HomePosts(posts: posts),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
