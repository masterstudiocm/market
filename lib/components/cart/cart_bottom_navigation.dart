import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/cart/cart_total.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/pages/ecommerce/checkout.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/html.dart';
import 'package:flutter/material.dart';
import 'package:market/widgets_extra/navigator.dart';

class CartBottomNavigation extends StatefulWidget {
  const CartBottomNavigation({super.key});

  @override
  State<CartBottomNavigation> createState() => _CartBottomNavigationState();
}

class _CartBottomNavigationState extends State<CartBottomNavigation> {
  bool visible = false;

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.base,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedCartTotal(visible: visible),
            Ink(
              color: Theme.of(context).colorScheme.base,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cartController.data['error'] != '') ...[const CartError()],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0).r,
                    child: MsButton(
                      onTap: () {
                        navigatePage(context, CheckoutPage(), root: true);
                      },
                      title: 'Sifarişi tamamla',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartError extends StatefulWidget {
  const CartError({super.key});

  @override
  State<CartError> createState() => _CartErrorState();
}

class _CartErrorState extends State<CartError> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      color: const Color.fromARGB(255, 204, 49, 38),
      child: MsHtml(data: cartController.data['error'], color: Theme.of(context).colorScheme.bg),
    );
  }
}

class AnimatedCartTotal extends StatelessWidget {
  final bool visible;
  const AnimatedCartTotal({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Visibility(
          visible: visible,
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey2)),
              color: Theme.of(context).colorScheme.base,
            ),
            child: const CartTotal(),
          ),
        ),
      ),
    );
  }
}
