import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class LoginSeparator extends StatelessWidget {
  const LoginSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0.r),
        Stack(
          children: [
            Divider(height: 30.0.r, color: Theme.of(context).colorScheme.grey2),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  color: Theme.of(context).colorScheme.base,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0).r,
                  child: Text('və ya alternativ olaraq', style: TextStyle(color: Theme.of(context).colorScheme.grey5)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0.r),
      ],
    );
  }
}
