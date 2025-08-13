import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class MsListTile extends StatelessWidget {
  const MsListTile({super.key, required this.onTap, required this.icon, required this.title, this.padding, this.borderRadius = 0});

  final GestureTapCallback onTap;
  final String icon;
  final String title;
  final EdgeInsets? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 15).r,
        child: Row(
          spacing: 20.r,
          children: [
            MsSvgIcon(icon: icon, color: Theme.of(context).colorScheme.primaryColor),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
