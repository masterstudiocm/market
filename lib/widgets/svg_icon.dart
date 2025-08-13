import 'package:market/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MsSvgIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double size;
  final bool originalColor;

  const MsSvgIcon({super.key, required this.icon, this.color, this.size = 20.0, this.originalColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        width: size.r,
        height: size.r,
        fit: BoxFit.contain,
        colorFilter: color != null
            ? ColorFilter.mode(color ?? Theme.of(context).colorScheme.text, BlendMode.srcIn)
            : originalColor
            ? null
            : ColorFilter.mode(Theme.of(context).colorScheme.text, BlendMode.srcIn),
      ),
    );
  }
}
