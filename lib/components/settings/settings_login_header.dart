import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:market/components/settings/profile_image.dart';
import 'package:get/get.dart';

class SettingsLoginHeader extends StatelessWidget {
  const SettingsLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Obx(
      () => (loginController.userdata.isNotEmpty)
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 40.0.r),
                      ProfilePicture(data: loginController.userdata, size: 100.0),
                      SizedBox(height: 10.0.r),
                      Text(
                        '${loginController.userdata['first_name']} ${loginController.userdata['last_name']}',
                        style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5.0.r),
                      Text(loginController.userdata['user_email']),
                      SizedBox(height: 25.0.r),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
