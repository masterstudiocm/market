import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class SingleProductTab extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String icon;

  const SingleProductTab({super.key, required this.onTap, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12.0).r,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 38.0.r,
              height: 38.0.r,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(30.0.r)),
              child: MsSvgIcon(icon: icon, size: 17.0, color: Theme.of(context).colorScheme.oppositeText),
            ),
            SizedBox(width: 12.0.r),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0.sp),
              ),
            ),
            SizedBox(width: 10.0.r),
            MsSvgIcon(icon: 'assets/arrows/chevron-right.svg', size: 22.0, color: Theme.of(context).colorScheme.grey3),
          ],
        ),
      ),
    );
  }
}
