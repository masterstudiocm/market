import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:market/widgets/svg_icon.dart';

enum MsNotifyTypes { success, error, info }

class MsNotify extends StatelessWidget {
  final MsNotifyTypes type;
  final String? icon;
  final String? heading;
  final String? description;
  final String buttonText;
  final Function()? action;
  final bool secondary;
  const MsNotify({
    super.key,
    this.type = MsNotifyTypes.error,
    this.icon,
    this.heading,
    this.description,
    this.buttonText = 'Səhifəni yenilə',
    this.action,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final tabBarController = Get.find<TabBarController>();

    String notifyIcon = icon ?? '';
    Color color = Theme.of(context).colorScheme.errorNotify;

    if (notifyIcon == '') {
      if (type == MsNotifyTypes.error) {
        notifyIcon = 'assets/widgets/circle-xmark.svg';
      } else if (type == MsNotifyTypes.success) {
        notifyIcon = 'assets/widgets/check.svg';
        color = Theme.of(context).colorScheme.successNotify;
      } else if (type == MsNotifyTypes.info) {
        notifyIcon = 'assets/widgets/info.svg';
        color = Theme.of(context).colorScheme.infoNotify;
      }
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20.0).r,
      child: Column(
        children: [
          const Spacer(),
          if (notifyIcon != '') ...[
            Container(
              width: 80.0.r,
              height: 80.0.r,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0).r, color: color),
              child: MsSvgIcon(icon: notifyIcon, color: Theme.of(context).colorScheme.base, size: 36.0),
            ),
            SizedBox(height: 20.0.r),
          ],
          if (heading != null) ...[
            Text(
              heading!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.0.r),
          ],
          if (description != null) ...[
            Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.grey5, height: 1.3),
            ),
            SizedBox(height: 20.0.r),
          ],
          const Spacer(),
          if (action != null) ...[
            MsButton(onTap: action!, title: buttonText),
            if (secondary) ...[
              SizedBox(height: 10.0.r),
              MsOutlineButton(
                onTap: () {
                  tabBarController.update(1);
                },
                title: 'Kataloqa bax',
              ),
            ],
          ],
        ],
      ),
    );
  }
}
