import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:market/classes/connection.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets_extra/snackbar.dart';

class SocialLogin {
  Future<void> socialLogin(Map info, String socialPlatform) async {
    final loginController = Get.find<LoginController>();

    try {
      if (await checkConnectivity()) {
        loginController.socialLoading.value = true;

        FormData formData = FormData.fromMap({'social_platform': socialPlatform, 'info': json.encode(info)});

        final response = await Dio().post(
          "${App.domain}/api/auth.php?action=social",
          data: formData,
          options: Options(headers: App.headers),
        );

        if (response.statusCode == 200) {
          var result = response.data;
          if (result['status'] == 'success') {
            if (result['result']['user_status'].toString() == '1') {
              loginController.update(result['result'], socialPlatform);
              Get.back(); // Assuming you're using GetX navigation
            } else {
              SnackbarGlobal.show('Sizin hesabınız aktiv deyil.');
            }
          } else {
            SnackbarGlobal.show(result['error']);
          }
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      SnackbarGlobal.show('Error occurred during social login.');
    } finally {
      loginController.socialLoading.value = false;
    }
  }
}
