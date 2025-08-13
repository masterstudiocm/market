import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/app/label.dart';
import 'package:market/controllers/form_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/file_form_field.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class SendCvPage extends StatefulWidget {
  const SendCvPage({super.key});

  @override
  State<SendCvPage> createState() => _SendCvPageState();
}

class _SendCvPageState extends State<SendCvPage> {
  File? file;
  bool fileError = false;
  bool buttonLoading = false;
  double uploadProgress = 0.0;

  final FormController formController = FormController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> send() async {
    setState(() => buttonLoading = true);
    Map result = await formController.send(
      form: 'cv',
      fields: {'name': nameController.text.trim(), 'email': emailController.text.trim(), 'phone': phoneController.text.trim()},
      file: file,
      onProgress: (int sent, int total) {
        setState(() {
          uploadProgress = sent / total;
        });
      },
    );
    setStateSafe(() {
      buttonLoading = false;
      if (result['data'] != '') {
        _formKey.currentState!.reset();
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        file = null;
        uploadProgress = 0.0;
        SnackbarGlobal.show(result['data'], type: SnackBarTypes.success);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: Text('CV göndər')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Göndərilən CV-lər birbaşa HR komandasına göndərilməkdədir. '
                  'Uyğun vakansiya olduğu zaman sizinlə əlaqə saxlanılacaqdır.',
                ),
                SizedBox(height: 20.0.r),
                FormLabel(label: 'Ad və soyadınız'),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ad və soyadınızı qeyd etməmisiniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0.r),
                FormLabel(label: 'Email'),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email qeyd etməmisiniz.';
                    }
                    if (!GetUtils.isEmail(value.trim())) {
                      return 'Email düzgün deyil.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0.r),
                FormLabel(label: 'Telefon'),
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telefon qeyd etməmisiniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0.r),
                FormLabel(label: 'CV fayl (doc, docx, pdf)'),
                MsFileFormField(
                  initialFile: file,
                  allowedExtensions: ['doc', 'docx', 'pdf'],
                  validator: (value) {
                    if (value == null) return 'Heç bir fayl seçməmisiniz.';
                    return null;
                  },
                  onChanged: (value) => file = value,
                ),
                SizedBox(height: 20.0.r),
                MsButton(
                  onTap: () {
                    if (!buttonLoading) {
                      final isValid = _formKey.currentState?.validate() ?? false;
                      if (isValid) send();
                    }
                  },
                  title: 'Göndər',
                  loading: buttonLoading,
                  loadingIndicator: Text(
                    'Yüklənir... ${(uploadProgress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Colors.white, fontSize: 15.0.sp, height: 1.1, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
