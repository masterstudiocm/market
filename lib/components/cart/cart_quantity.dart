import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/cart/cart_quantity_arrow.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:flutter/material.dart';

class CartQuantity extends StatefulWidget {
  final Map data;
  const CartQuantity({super.key, required this.data});

  @override
  State<CartQuantity> createState() => _CartQuantityState();
}

class _CartQuantityState extends State<CartQuantity> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          CartQuantityArrow(
            onTap: () {
              cartController.decrease(widget.data['cart_product_id'], widget.data['cart_variation_id'], widget.data['cart_date']);
            },
            icon: 'assets/icons/minus.svg',
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0).r,
            constraints: BoxConstraints(minWidth: 35.0.r),
            child: Text(
              widget.data['cart_quantity'].toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(fontSize: 13.0.sp, height: 1.3),
            ),
          ),
          CartQuantityArrow(
            onTap: () {
              cartController.increase(widget.data['cart_product_id'], widget.data['cart_variation_id'], widget.data['cart_date']);
            },
            icon: 'assets/icons/plus.svg',
          ),
        ],
      ),
    );
  }
}
