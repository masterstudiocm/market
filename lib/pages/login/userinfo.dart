import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool loading = true;
  bool buttonLoading = false;
  Map data = {};
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  File? image;
  bool deleteStatus = false;

  final loginController = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

  Future<void> update() async {
    setState(() => buttonLoading = true);

    FormData formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'user_email': email,
      'phone': phone,
      'address': address,
      'session_key': loginController.userId.value,
    });

    Map result = await httpRequest('${App.domain}/api/users.php?action=update', fields: formData, snackbar: true);

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      SnackbarGlobal.show(payload['result']['message'], type: SnackBarTypes.success);
      loginController.update(payload['result']['user']);
      if (mounted) Navigator.pop(context);
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
    setStateSafe(() => buttonLoading = false);
  }

  @override
  void initState() {
    super.initState();
    if (loginController.userdata.isNotEmpty) {
      firstName = loginController.userdata['first_name'] ?? '';
      lastName = loginController.userdata['last_name'] ?? '';
      email = loginController.userdata['user_email'] ?? '';
      phone = loginController.userdata['phone'] ?? '';
      address = loginController.userdata['address'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Şəxsi məlumatlarınız')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0).r,
          children: [
            const FormLabel(label: 'Adınız'),
            TextFormField(
              initialValue: firstName,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 50.0.r,
                  child: MsSvgIcon(icon: 'assets/icons/user.svg', color: Theme.of(context).colorScheme.text),
                ),
              ),
              onChanged: (value) => firstName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Adınızı qeyd etməmisiniz.';
                }
                return null;
              },
            ),
            SizedBox(height: 15.0.r),
            const FormLabel(label: 'Soyadınız'),
            TextFormField(
              initialValue: lastName,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 50.0.r,
                  child: MsSvgIcon(icon: 'assets/icons/user.svg', color: Theme.of(context).colorScheme.text),
                ),
              ),
              onChanged: (value) => lastName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Soyadınızı qeyd etməmisiniz.';
                }
                return null;
              },
            ),
            SizedBox(height: 15.0.r),
            const FormLabel(label: 'Email'),
            TextFormField(
              initialValue: email,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 50.0.r,
                  child: MsSvgIcon(icon: 'assets/icons/email.svg', color: Theme.of(context).colorScheme.text),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
              validator: (value) {
                if (value == null) {
                  return 'Email qeyd etməmisiniz.';
                }
                if (!GetUtils.isEmail(value.trim())) {
                  return 'Email düzgün deyil.';
                }
                return null;
              },
            ),
            SizedBox(height: 15.0.r),
            const FormLabel(label: 'Telefon', required: false),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 50.0.r,
                  child: MsSvgIcon(icon: 'assets/icons/contact.svg', color: Theme.of(context).colorScheme.text),
                ),
              ),
              initialValue: phone,
              onChanged: (value) => phone = value,
            ),
            SizedBox(height: 15.0.r),
            const FormLabel(label: 'Çatdırılma ünvanı', required: false),
            TextFormField(
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 50.0.r,
                  child: MsSvgIcon(icon: 'assets/icons/location.svg', color: Theme.of(context).colorScheme.text),
                ),
              ),
              initialValue: address,
              onChanged: (value) => address = value,
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
    );
  }
}
