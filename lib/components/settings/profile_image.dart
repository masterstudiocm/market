import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/alphabet.dart';
import 'package:market/widgets/image.dart';

class ProfilePicture extends StatelessWidget {
  final Map data;
  final double size;
  final double fontSize;

  const ProfilePicture({super.key, required this.data, this.size = 80.0, this.fontSize = 24.0});

  @override
  Widget build(BuildContext context) {
    return (data['profile_image'] != '' && data['profile_image'] != null)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(size.r),
            child: MsImage(url: data['profile_image'], width: size.r, height: size.r),
          )
        : AlphabetPP(data: data, size: size, fontSize: fontSize);
  }
}
