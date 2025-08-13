import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class MsIconButton extends StatelessWidget {
  final Function() onTap;
  final String? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Widget? child;
  final double iconSize;
  final Color? borderColor;
  final double size;
  final double? borderRadius;
  const MsIconButton({
    super.key,
    required this.onTap,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.child,
    this.iconSize = 18.0,
    this.borderColor,
    this.size = 45.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? size)),
      onTap: onTap,
      child: Ink(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0.sp),
          border: Border.all(color: borderColor ?? backgroundColor ?? Theme.of(context).colorScheme.grey3),
          color: backgroundColor ?? Colors.transparent,
        ),
        child: child ?? MsSvgIcon(icon: icon!, size: iconSize, color: iconColor ?? Theme.of(context).colorScheme.text),
      ),
    );
  }
}
