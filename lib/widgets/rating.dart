import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:flutter/material.dart';

class MsRating extends StatelessWidget {
  final double value;
  const MsRating({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            for (var i = 1; i <= 5; i++) ...[Icon(Icons.star, color: Theme.of(context).colorScheme.grey3, size: 17.0.sp)],
          ],
        ),
        Row(
          children: [
            for (var i = 1; i <= value; i++) ...[Icon(Icons.star, color: Colors.orange, size: 17.0.sp)],
          ],
        ),
      ],
    );
  }
}
