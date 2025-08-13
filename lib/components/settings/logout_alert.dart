import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/dialog.dart';
import 'package:market/widgets/outline_button.dart';

class LogoutAlert extends StatelessWidget {
  LogoutAlert({super.key});

  final loginController = Get.find<LoginController>();
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return MsDialog(
      content: "Hesabınızdan çıxış etmək istədiyinizə əminsinizmi?",
      actions: [
        Expanded(
          child: MsOutlineButton(
            title: "Xeyr",
            onTap: () {
              Navigator.pop(context);
            },
            height: 45.0,
          ),
        ),
        SizedBox(width: 10.0.r),
        Expanded(
          child: MsButton(
            title: "Bəli",
            onTap: () {
              loginController.logout();
              cartController.get();
              wishlistController.get();
              Navigator.pop(context);
            },
            height: 45.0,
          ),
        ),
      ],
    );
  }
}
