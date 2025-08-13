import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/icon_button.dart';

class MsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final Widget? leading;
  final List<Widget>? actions;

  const MsAppBar({super.key, this.title, this.backgroundColor, this.titleTextStyle, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: App.toolbarHeight,
      leadingWidth: App.leadingWidth,
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      titleSpacing: 20.0,
      centerTitle: true,
      leading: (leading != null)
          ? Row(
              children: [
                SizedBox(width: 20.0.r),
                leading!,
              ],
            )
          : Navigator.canPop(context)
          ? Row(
              children: [
                SizedBox(width: 20.0.r),
                MsIconButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderColor: Colors.transparent,
                  backgroundColor: Theme.of(context).colorScheme.grey1,
                  icon: 'assets/arrows/arrow-left.svg',
                ),
              ],
            )
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(App.toolbarHeight);
}
