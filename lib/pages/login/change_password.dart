import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/app/label.dart';
import 'package:market/components/login/show_hide_password.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool buttonLoading = false;
  bool showPassword = false;
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  final loginController = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

  Future<void> update() async {
    setState(() => buttonLoading = true);
    Map result = await loginController.changePassword({'current': currentPassword, 'new': newPassword, 'confirm': confirmPassword});
    setStateSafe(() {
      buttonLoading = false;
      currentPassword = '';
      newPassword = '';
      confirmPassword = '';
      _formKey.currentState!.reset();
      if (result['data'].isNotEmpty) {
        SnackbarGlobal.show(result['data'], type: SnackBarTypes.success);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Şifrə dəyişdirilməsi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0).r,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Şifrənizi dəyişdirmək istərmisinizsə, bu hissədə heç bir əməliyyat icra etməyin.',
                  style: TextStyle(color: Theme.of(context).colorScheme.grey5),
                ),
                SizedBox(height: 40.0.r),
                FormLabel(label: 'Hazırkı şifrəniz'),
                TextFormField(
                  initialValue: currentPassword,
                  obscureText: true,
                  onChanged: (value) => currentPassword = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hazırkı şifrənizi qeyd etməmisiniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0.r),
                FormLabel(label: 'Yeni şifrə'),
                Stack(
                  children: [
                    TextFormField(
                      initialValue: newPassword,
                      obscureText: !showPassword,
                      onChanged: (value) => newPassword = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yeni şifrə qeyd etməmisiniz.';
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
                FormLabel(label: 'Yeni şifrənin təkrarı'),
                Stack(
                  children: [
                    TextFormField(
                      initialValue: confirmPassword,
                      obscureText: !showPassword,
                      onChanged: (value) => confirmPassword = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yeni şifrənizin təkrarını qeyd etməmisiniz.';
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
                SizedBox(height: 25.0.r),
                MsButton(
                  onTap: () {
                    if (_formKey.currentState!.validate() && !buttonLoading) {
                      update();
                    }
                  },
                  loading: buttonLoading,
                  title: 'Yadda saxla',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
