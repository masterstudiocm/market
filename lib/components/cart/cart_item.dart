import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/cart/cart_quantity.dart';
import 'package:market/components/cart/cart_remove.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/pages/ecommerce/single_product.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:market/widgets_extra/navigator.dart';

class CartItem extends StatefulWidget {
  final Map data;
  const CartItem({super.key, required this.data});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatePage(context, SingleProductPage(slug: widget.data['data']['post_slug']));
      },
      child: Container(
        height: 180.0.r,
        padding: const EdgeInsets.symmetric(vertical: 20.0).r,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0).r,
              child: MsImage(url: widget.data['data']['product_thumbnail'], width: 120.0, height: 140.0, pColor: Theme.of(context).colorScheme.bg),
            ),
            SizedBox(width: 20.0.r),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['data']['post_title'],
                    style: TextStyle(fontSize: 14.0.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.0.r),
                  if (widget.data['data']['product_type'] == 'variable') ...[
                    Text(
                      widget.data['data']['variation_name'],
                      style: TextStyle(color: Theme.of(context).colorScheme.grey4, fontSize: 12.0.sp),
                    ),
                    SizedBox(height: 5.0.r),
                  ],
                  displayPrice(context, widget.data['data'], variation: true),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CartQuantity(data: widget.data),
                      CartRemove(data: widget.data),
                    ],
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
