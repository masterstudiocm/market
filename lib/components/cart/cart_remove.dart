import 'package:get/get.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/widgets/icon_button.dart';
import 'package:flutter/material.dart';

class CartRemove extends StatefulWidget {
  final Map data;
  const CartRemove({super.key, required this.data});

  @override
  State<CartRemove> createState() => _CartRemoveState();
}

class _CartRemoveState extends State<CartRemove> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return MsIconButton(
      onTap: () {
        cartController.remove(widget.data['cart_product_id'], widget.data['cart_variation_id']);
      },
      icon: 'assets/icons/delete.svg',
      backgroundColor: Colors.red,
      iconColor: Colors.white,
      size: 26.0,
      iconSize: 13.0,
    );
  }
}
