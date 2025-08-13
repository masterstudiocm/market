import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormLabel extends StatelessWidget {
  final String label;
  final bool required;
  const FormLabel({super.key, required this.label, this.required = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0).r,
      child: Wrap(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          if (required) ...[
            SizedBox(width: 3.0.r),
            Text(
              '*',
              style: TextStyle(color: Colors.red, height: 1.sp, fontSize: 18.0.sp),
            )
          ]
        ],
      ),
    );
  }
}
