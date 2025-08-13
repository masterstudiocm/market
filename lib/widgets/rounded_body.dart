import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class RoundedBody extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool space;
  const RoundedBody({super.key, required this.child, this.backgroundColor, this.space = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: (space) ? MediaQuery.of(context).viewPadding.top + App.toolbarHeight - 1.0 : -1.0,
          left: 0.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0.r,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0).r),
          child: Container(width: MediaQuery.of(context).size.width, color: backgroundColor ?? Theme.of(context).colorScheme.base, child: child),
        ),
      ],
    );
  }
}
