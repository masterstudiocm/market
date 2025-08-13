import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:market/widgets/icon_button.dart';

class CartTotal extends StatefulWidget {
  const CartTotal({super.key});

  @override
  State<CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<CartTotal> {
  final cartController = Get.find<CartController>();

  Future<void> removeCoupon() async {
    cartController.mainLoading.value = true;
    await cartController.removeCoupon();
    await cartController.get();
    cartController.mainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (cartController.data['display_sale'] != '') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Toplam qiymət:'),
                  Text('${cartController.data['main_price']} ${Ecommerce.currency}', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 5.0.r),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Endirim:'),
                  Text(
                    cartController.data['display_sale'],
                    style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (cartController.data['coupon']['code'] != null) ...[
                SizedBox(height: 5.0.r),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cartController.data['coupon']['code']}:',
                      style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primaryColor),
                    ),
                    Row(
                      spacing: 10.r,
                      children: [
                        Text(
                          cartController.data['coupon']['sale'],
                          style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                        ),
                        MsIconButton(
                          onTap: () {
                            removeCoupon();
                          },
                          icon: 'assets/icons/close.svg',
                          borderColor: Colors.transparent,
                          iconSize: 8,
                          iconColor: Colors.white,
                          backgroundColor: Theme.of(context).colorScheme.errorText,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              Divider(height: 30.0.r, thickness: 1.0, color: Theme.of(context).colorScheme.grey2),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Yekun qiymət:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0.sp, color: Theme.of(context).colorScheme.text),
                ),
                Text(
                  '${cartController.data['final_price']} ${Ecommerce.currency}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0.sp, color: Theme.of(context).colorScheme.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
