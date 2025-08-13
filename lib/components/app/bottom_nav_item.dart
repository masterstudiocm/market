import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class MsBottomNavItem extends StatelessWidget {
  const MsBottomNavItem({super.key, required this.icon, required this.label, required this.index, this.badge = 0});

  final String icon;
  final String label;
  final int index;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final tabBarController = Get.find<TabBarController>();
    String itemIcon = (index == tabBarController.controller.index) ? 'bold-$icon' : icon;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                MsSvgIcon(
                  icon: 'assets/navigations/$itemIcon',
                  size: 20.r,
                  color: (index == tabBarController.controller.index)
                      ? Theme.of(context).colorScheme.primaryColor
                      : Theme.of(context).colorScheme.grey5,
                ),
                if (badge != 0) ...[
                  Positioned(
                    top: -3.0,
                    right: -7.0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 15.0.r,
                      height: 15.0.r,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.text, borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        badge.toString(),
                        style: TextStyle(color: Theme.of(context).colorScheme.oppositeText, fontSize: 9.0.sp),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 7.0.r),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0).r,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.0.sp,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  color: (index == tabBarController.controller.index)
                      ? Theme.of(context).colorScheme.primaryColor
                      : Theme.of(context).colorScheme.grey5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
