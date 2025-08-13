import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:market/classes/social_login.dart';
import 'package:market/components/login/social_buttons.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/snackbar.dart';

class SocialButton extends StatefulWidget {
  final SocialButtonType type;

  const SocialButton({super.key, required this.type});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  final loginController = Get.find<LoginController>();

  Future<dynamic> _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        Map info = {
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'id': userCredential.user!.uid,
          'photo': userCredential.user!.photoURL,
        };
        await SocialLogin().socialLogin(info, 'Google');
      }
    } on Exception catch (e) {
      SnackbarGlobal.show('Tətbiqdaxili xəta baş vermişdir.');
      debugPrint('exception->$e');
    }
  }

  Future<void> _facebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final data = await FacebookAuth.instance.getUserData();
        Map info = {'name': data['name'], 'email': data['email'], 'id': data['id'], 'photo': data['picture']['url']};
        await SocialLogin().socialLogin(info, 'Facebook');
      } else {
        SnackbarGlobal.show('Facebook profilinizdən heç bir məlumat əldə edilə bilmədi.');
        // print(result.status);
        debugPrint(result.message);
      }
    } catch (error) {
      SnackbarGlobal.show('Tətbiqdaxili xəta baş vermişdir.');
      debugPrint('Xəta: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? icon;
    String? text;
    Color bg = const Color(0xFFE13C30);

    if (widget.type == SocialButtonType.google) {
      icon = 'assets/brands/google-login.svg';
      text = 'Google ilə qeydiyyat';
    } else if (widget.type == SocialButtonType.facebook) {
      icon = 'assets/brands/facebook-basic.svg';
      text = 'Facebook ilə qeydiyyat';
      bg = const Color(0xFF1877F2);
    }

    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      onTap: () async {
        if (widget.type == SocialButtonType.google) {
          _googleLogin();
        } else if (widget.type == SocialButtonType.facebook) {
          _facebookLogin();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 54.0.r,
          padding: const EdgeInsets.symmetric(horizontal: 10.0).r,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30.0).r),
          child: Row(
            children: [
              Container(
                width: 40.0.r,
                height: 40.0.r,
                decoration: BoxDecoration(color: darkenColor(bg, 0.2), borderRadius: BorderRadius.circular(40.0).r),
                child: MsSvgIcon(icon: icon!, color: Colors.white),
              ),
              SizedBox(width: 10.0.r),
              Expanded(
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 13.3.sp),
                ),
              ),
              SizedBox(width: 40.0.r),
            ],
          ),
        ),
      ),
    );
  }
}
