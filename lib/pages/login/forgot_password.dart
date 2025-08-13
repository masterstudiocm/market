import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/auth_controller.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:market/widgets/svg_icon.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool buttonLoading = false;
  String username = '';

  final _formKey = GlobalKey<FormState>();
  final authController = AuthController();
  final loginController = Get.find<LoginController>();

  Future<void> reset() async {
    setState(() => buttonLoading = true);
    Map result = await authController.forgotPassword(username);
    final payload = result['payload'];
    if (payload['status'] == 'success') {
      SnackbarGlobal.show(payload['result'], type: SnackBarTypes.success, duration: const Duration(seconds: 15));
      if (mounted) Navigator.pop(context);
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
    setStateSafe(() => buttonLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Şifrə sıfırlanması')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: Column(
            children: [
              SizedBox(height: 10.0.r),
              Text(
                'Aşağıdakı hissəyə email ünvanınızı daxil edərək şifrənizi sıfırlayın',
                style: TextStyle(color: Theme.of(context).colorScheme.grey5),
              ),
              SizedBox(height: 20.0.r),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: SizedBox(
                    width: 50.0.r,
                    child: MsSvgIcon(icon: 'assets/icons/email.svg', color: Theme.of(context).colorScheme.text),
                  ),
                ),
                onChanged: (value) => username = value.trim(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email qeyd etməlisiniz.';
                  }
                  if (!GetUtils.isEmail(value.trim())) {
                    return 'Email düzgün formatda deyil.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0.r),
              MsButton(
                onTap: () {
                  if (_formKey.currentState!.validate() && !buttonLoading) {
                    reset();
                    FocusScope.of(context).unfocus();
                  }
                },
                loading: buttonLoading,
                title: 'Sıfırla',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
