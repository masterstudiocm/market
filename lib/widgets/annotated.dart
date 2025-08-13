import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:market/controllers/darkmode_controller.dart';

enum MsStatusBar { light, dark, auto }

class MsAnnotatedRegion extends StatelessWidget {
  final Widget child;
  final MsStatusBar? type;

  const MsAnnotatedRegion({super.key, required this.child, this.type});

  @override
  Widget build(BuildContext context) {
    final darkmodeController = Get.find<DarkModeController>();

    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    Brightness iconBrightness;
    Brightness statusBarBrightness;

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (type == MsStatusBar.light) {
      iconBrightness = Brightness.light;
      statusBarBrightness = isIOS ? Brightness.light : Brightness.dark;
    } else if (type == MsStatusBar.dark) {
      iconBrightness = Brightness.dark;
      statusBarBrightness = isIOS ? Brightness.dark : Brightness.light;
    } else {
      bool isSystemDark = platformBrightness == Brightness.dark;
      bool isDarkMode;

      if (darkmodeController.mode.value == 'System') {
        isDarkMode = isSystemDark;
      } else if (darkmodeController.mode.value == 'Dark') {
        isDarkMode = true;
      } else {
        isDarkMode = false;
      }

      if (isDarkMode) {
        iconBrightness = Brightness.light;
        statusBarBrightness = isIOS ? Brightness.light : Brightness.dark;
      } else {
        iconBrightness = Brightness.dark;
        statusBarBrightness = isIOS ? Brightness.dark : Brightness.light;
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
      child: child,
    );
  }
}
