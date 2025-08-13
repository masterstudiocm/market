import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

enum SnackBarTypes { success, error, info }

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key = GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    SnackBarTypes type = SnackBarTypes.error,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    Color backgroundColor = MsColors.lightError;
    String icon = 'assets/widgets/remove.svg';

    if (type == SnackBarTypes.success) {
      backgroundColor = MsColors.lightSuccess;
      icon = 'assets/widgets/check.svg';
    } else if (type == SnackBarTypes.info) {
      backgroundColor = const Color(0xFF444444);
      icon = 'assets/widgets/info.svg';
    }

    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(0.0),
          duration: duration,
          content: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0).r,
                  decoration: BoxDecoration(color: darkenColor(backgroundColor, 0.2)),
                  child: MsSvgIcon(icon: icon, size: 24.0, color: Colors.white),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0).r,
                    child: Text(
                      message.replaceAll('<br>', '\n'),
                      style: TextStyle(color: Colors.white, fontFamily: App.fontFamily),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: backgroundColor,
          action: action,
        ),
      );
  }

  static void remove() {
    key.currentState!.removeCurrentSnackBar();
  }
}
