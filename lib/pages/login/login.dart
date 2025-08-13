import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/label.dart';
import 'package:market/components/login/separator.dart';
import 'package:market/components/login/show_hide_password.dart';
import 'package:market/components/login/social_buttons.dart';
import 'package:market/components/login/social_loading.dart';
import 'package:market/controllers/auth_controller.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/pages/login/forgot_password.dart';
import 'package:market/pages/login/registration.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/navigator.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool buttonLoading = false;
  String username = '';
  String password = '';
  bool showPassword = false;

  final _formKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();
  final loginController = Get.find<LoginController>();
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();
  final tabBarController = Get.find<TabBarController>();

  Future<void> login() async {
    setState(() => buttonLoading = true);
    Map result = await authController.login(username, password);
    final payload = result['payload'];
    if (payload['status'] == 'success') {
      loginController.update(payload['result']);
      cartController.get();
      wishlistController.get();
      if (mounted) Navigator.pop(context);
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
          appBar: const MsAppBar(title: Text('Daxil ol')),
          body: ListView(
            children: [
              Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormLabel(label: 'Email'),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            hintText: 'Email ünvanı',
                            prefixIcon: SizedBox(
                              width: 50.0.r,
                              child: MsSvgIcon(icon: 'assets/icons/email.svg', color: Theme.of(context).colorScheme.text),
                            ),
                          ),
                          onChanged: (value) => username = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'İstifadəçi adı və ya email qeyd etməlisiniz.';
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
                        SizedBox(height: 15.0.r),
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              navigatePage(context, const ForgotPasswordPage());
                            },
                            child: Text('Şifrənizi unutmusunuz?', style: Theme.of(context).textTheme.link),
                          ),
                        ),
                        SizedBox(height: 25.0.r),
                        MsButton(
                          onTap: () {
                            if (_formKey.currentState!.validate() && !buttonLoading) {
                              login();
                            }
                          },
                          loading: buttonLoading,
                          title: 'Daxil ol',
                        ),
                        Column(
                          children: [
                            const LoginSeparator(),
                            const SocialButtons(),
                            SizedBox(height: 25.0.r),
                            Wrap(
                              runSpacing: 5.0.r,
                              spacing: 5.0.r,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: [
                                Text('Sistem üzərində hesabınız yoxdur?', style: TextStyle(color: Theme.of(context).colorScheme.grey5)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    navigatePage(context, const RegistrationPage());
                                  },
                                  child: Text('Qeydiyyatdan keç', style: Theme.of(context).textTheme.link),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SocialLoading(),
      ],
    );
  }
}
