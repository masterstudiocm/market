import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  final String? title;
  final Widget child;
  const SettingSection({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.grey4),
          ),
          SizedBox(height: 15.0.r),
        ],
        child,
      ],
    );
  }
}
