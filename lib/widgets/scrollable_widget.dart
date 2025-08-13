import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class MsScrollableWidget extends StatelessWidget {
  final Widget child;
  const MsScrollableWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height -
            App.toolbarHeight -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            80.r,
        child: child,
      ),
    );
  }
}
