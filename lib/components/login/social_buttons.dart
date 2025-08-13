import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/login/social_button.dart';

enum SocialButtonType { google, facebook }

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(type: SocialButtonType.google),
        SizedBox(height: 10.0.r),
        SocialButton(type: SocialButtonType.facebook),
      ],
    );
  }
}
