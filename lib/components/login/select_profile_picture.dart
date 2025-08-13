import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/settings/profile_image.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/alphabet.dart';

class SelectProfilePicture extends StatelessWidget {
  final File? image;
  final bool deleteStatus;
  final Function() delete;
  final Function(String source) select;
  const SelectProfilePicture({super.key, this.image, required this.deleteStatus, required this.delete, required this.select});

  @override
  Widget build(BuildContext context) {
    double imageSize = 150.0.r;

    final loginController = Get.find<LoginController>();

    return Container(
      padding: const EdgeInsets.only(bottom: 30.0),
      alignment: Alignment.center,
      child: Stack(
        children: [
          (image != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize),
                  child: Image.file(image!, width: imageSize, height: imageSize, fit: BoxFit.cover),
                )
              : (deleteStatus)
              ? AlphabetPP(data: loginController.userdata, size: 150.0, fontSize: 35.0)
              : ProfilePicture(data: loginController.userdata, size: 150.0),
          Positioned.fill(
            bottom: 0.0,
            right: 0.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryColor, borderRadius: BorderRadius.circular(50.0)),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Text('Dəyişdir', style: TextStyle(color: Theme.of(context).colorScheme.bg, fontSize: 12.0, height: 1.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
