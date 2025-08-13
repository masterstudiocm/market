import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MsIndicator extends StatelessWidget {
  final double strokeWidth;
  const MsIndicator({super.key, this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: SizedBox(
          width: 40.0.r,
          height: 40.0.r,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth.r,
          ),
        ),
      ),
    );
  }
}
