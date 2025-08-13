import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeading extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  const AppHeading({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return (title != null)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0).r,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0.sp,
                    ),
                  ),
                ),
                if (onTap != null) ...[
                  SizedBox(width: 30.0.r),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onTap,
                    child: Text(
                      'Hamısı',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ]
              ],
            ),
          )
        : const SizedBox();
  }
}
