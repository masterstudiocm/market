import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/label.dart';
import 'package:market/components/login/show_hide_password.dart';
import 'package:market/components/login/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/login/separator.dart';
import 'package:market/components/login/social_loading.dart';
import 'package:market/controllers/auth_controller.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/pages/login/confirm_account.dart';
import 'package:market/pages/login/login.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/navigator.dart';
import 'package:market/widgets_extra/snackbar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool buttonLoading = false;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.find<LoginController>();
  final authController = AuthController();

  Future<void> registration() async {
    setState(() => buttonLoading = true);
    Map result = await authController.registration({'first_name': firstName, 'last_name': lastName, 'user_email': email, 'user_password': password});
    final payload = result['payload'];
    if (payload['status'] == 'success') {
      Get.off(() => ConfirmAccountPage(userId: payload['result']['user_id'].toString()));
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
    setStateSafe(() => buttonLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const MsAppBar(title: Text('Qeydiyyat')),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0).r,
              children: [
                const SocialButtons(),
                const LoginSeparator(),
                const FormLabel(label: 'Adınız'),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Adınız',
                    prefixIcon: SizedBox(
                      width: 50.0.r,
                      child: MsSvgIcon(icon: 'assets/icons/user.svg', color: Theme.of(context).colorScheme.text),
                    ),
                  ),
                  onChanged: (value) => firstName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adınızı qeyd etməlisiniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0.r),
                const FormLabel(label: 'Soyadınız'),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Soyadınız',
                    prefixIcon: SizedBox(
                      width: 50.0.r,
                      child: MsSvgIcon(icon: 'assets/icons/user.svg', color: Theme.of(context).colorScheme.text),
                    ),
                  ),
                  onChanged: (value) => lastName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Soyadınızı qeyd etməlisiniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0.r),
                const FormLabel(label: 'Email'),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email ünvanı',
                    prefixIcon: SizedBox(
                      width: 50.0.r,
                      child: MsSvgIcon(icon: 'assets/icons/email.svg', color: Theme.of(context).colorScheme.text),
                    ),
                  ),
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email qeyd etməlisiniz.';
                    } else if (!GetUtils.isEmail(value.trim())) {
                      return 'Email düzgün deyil.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0.r),
                const FormLabel(label: 'Şifrə'),
                Stack(
                  children: [
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        hintText: 'Hesab şifrəsi',
                        prefixIcon: SizedBox(
                          width: 50.0.r,
                          child: MsSvgIcon(icon: 'assets/icons/password.svg', color: Theme.of(context).colorScheme.text),
                        ),
                      ),
                      obscureText: !showPassword,
                      onChanged: (value) => password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifrə qeyd etməmisiniz.';
                        }
                        return null;
                      },
                    ),
                    ShowHidePassword(
                      value: showPassword,
                      onTap: () {
                        setState(() => showPassword = !showPassword);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.0.r),
                MsButton(
                  onTap: () {
                    if (_formKey.currentState!.validate() && buttonLoading == false) {
                      registration();
                    }
                  },
                  loading: buttonLoading,
                  title: 'Qeydiyyatdan keç',
                ),
                SizedBox(height: 20.0.r),
                Column(
                  children: [
                    Wrap(
                      runSpacing: 5.0.r,
                      spacing: 5.0.r,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Text('Artıq qeydiyyatdan keçmisiniz?', style: TextStyle(color: Theme.of(context).colorScheme.grey5)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            navigatePage(context, const LoginPage());
                          },
                          child: Text('Daxil ol', style: Theme.of(context).textTheme.link),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SocialLoading(),
      ],
    );
  }
}
