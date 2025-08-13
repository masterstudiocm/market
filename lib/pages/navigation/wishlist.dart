import 'package:market/components/products/load_products.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/icon_button.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/widgets_extra/appbar.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final loginController = Get.find<LoginController>();
  final wishlistController = Get.find<WishlistController>();
  final tabBarController = Get.find<TabBarController>();
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(
        title: Text('İstək listi'),
        actions: [
          MsIconButton(
            onTap: () {
              wishlistController.get();
            },
            icon: 'assets/icons/refresh.svg',
            backgroundColor: Theme.of(context).colorScheme.grey1,
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: Obx(() {
        if (tabBarController.controller.index != 2) {
          key = GlobalKey();
        }
        return MsContainer(
          loading: wishlistController.loading.value,
          serverError: wishlistController.serverError.value,
          connectError: wishlistController.connectError.value,
          action: () => wishlistController.get(),
          child: (wishlistController.wishlist.isEmpty)
              ? MsNotify(
                  icon: 'assets/icons/heart-fill.svg',
                  heading: 'İstək listiniz boşdur',
                  description: 'Hər bir məhsulun üzərindəki ürək işarəsinə toxunaraq onları istək listinə əlavə edə bilərsiniz.',
                  action: () => wishlistController.get(),
                  secondary: true,
                )
              : MsRefreshIndicator(
                  onRefresh: () {
                    wishlistController.get();
                    return Future.value();
                  },
                  child: LoadProducts(key: key, multiple: wishlistController.wishlist.reversed.join(',')),
                ),
        );
      }),
    );
  }
}
