import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/cart/add_coupon_button.dart';
import 'package:market/components/cart/cart_bottom_navigation.dart';
import 'package:market/components/cart/cart_item.dart';
import 'package:market/components/cart/cart_total.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(
        title: Text('Səbət'),
        actions: [
          AddCouponButton(),
          SizedBox(width: 20.r),
        ],
      ),
      bottomNavigationBar: Obx(() => (cartController.cart.isNotEmpty) ? const CartBottomNavigation() : const SizedBox()),
      body: Obx(
        () => MsContainer(
          loading: cartController.loading.value,
          serverError: cartController.serverError.value,
          connectError: cartController.connectError.value,
          action: () => cartController.get(),
          child: (cartController.cart.isEmpty)
              ? MsNotify(
                  heading: 'Səbətiniz boşdur',
                  description: 'Kataloq səhifəsinə keçib sizi maraqlandıran məhsulları səbətə əlavə edə bilərsiniz.',
                  icon: 'assets/icons/basket.svg',
                  action: () => cartController.get(),
                  secondary: true,
                )
              : Stack(
                  children: [
                    MsRefreshIndicator(
                      onRefresh: () {
                        cartController.get();
                        return Future.value();
                      },
                      child: ListView(
                        children: [
                          if (cartController.data['info'] != '') ...[
                            Container(
                              margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0).r,
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0).r,
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10.0).r),
                              child: Row(
                                children: [
                                  MsSvgIcon(icon: 'assets/icons/info.svg', color: Colors.white),
                                  SizedBox(width: 15.0.r),
                                  Expanded(
                                    child: Text(
                                      cartController.data['info'],
                                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20.0).r,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartController.cart.length,
                            itemBuilder: (context, index) {
                              return CartItem(data: cartController.cart[index]);
                            },
                            separatorBuilder: (context, index) {
                              return Divider(color: Theme.of(context).colorScheme.grey2, height: 1.0, thickness: 1.0);
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(20.0).r,
                            child: DottedBorder(
                              options: RectDottedBorderOptions(color: Theme.of(context).colorScheme.grey3, dashPattern: const [8, 3]),
                              child: CartTotal(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (cartController.mainLoading.value) ...[
                      Positioned.fill(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Theme.of(context).colorScheme.base.withValues(alpha: .85),
                          child: const Center(child: MsIndicator()),
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
