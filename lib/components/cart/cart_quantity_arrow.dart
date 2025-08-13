import 'package:flutter/material.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/icon_button.dart';

class CartQuantityArrow extends StatelessWidget {
  final Function() onTap;
  final String icon;

  const CartQuantityArrow({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return MsIconButton(
      onTap: onTap,
      icon: icon,
      borderColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.grey2,
      size: 26.0,
      iconSize: 10.0,
    );
  }
}
