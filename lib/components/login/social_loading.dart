import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/indicator.dart';

class SocialLoading extends StatelessWidget {
  const SocialLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    return Obx(
      () => (loginController.socialLoading.value)
          ? Positioned.fill(
              child: GestureDetector(
                onDoubleTap: () {
                  loginController.socialLoading.value = false;
                },
                child: Container(
                  color: Colors.black.withValues(alpha: .3),
                  child: Center(
                    child: Container(
                      width: 100.0.r,
                      height: 100.0.r,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.base, borderRadius: BorderRadius.circular(15.0).r),
                      child: const MsIndicator(),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
