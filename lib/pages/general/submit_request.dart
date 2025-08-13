import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/label.dart';
import 'package:market/controllers/form_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class SubmitRequestPage extends StatefulWidget {
  const SubmitRequestPage({super.key});

  @override
  State<SubmitRequestPage> createState() => _SubmitRequestPageState();
}

class _SubmitRequestPageState extends State<SubmitRequestPage> {
  List<File> files = [];
  bool fileError = false;
  bool buttonLoading = false;
  double uploadProgress = 0.0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController noteController = TextEditingController();
  final FormController formController = FormController();

  Future<void> send() async {
    setState(() => buttonLoading = true);
    Map result = await formController.send(
      form: 'request',
      fields: {'note': noteController.text.trim()},
      files: files,
      onProgress: (int sent, int total) {
        setState(() {
          uploadProgress = sent / total;
        });
      },
    );
    setStateSafe(() {
      buttonLoading = false;
      if (result['data'] != '') {
        noteController.clear();
        files = [];
        fileError = false;
      }
      SnackbarGlobal.show(result['data'], type: SnackBarTypes.success);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: Text('İstək göndərin')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Burada siz öz çizimlərinizi bizə göndərərək özünüzə məxsus geyim kombininizi yarada bilərsiniz.'),
                SizedBox(height: 20.0.r),
                FormLabel(label: 'Çizimləri buraya əlavə edin'),
                InkWell(
                  customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0).r),
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['jpeg', 'jpg', 'png', 'avif', 'webp'],
                    );

                    if (result != null) {
                      setState(() {
                        fileError = false;
                        files = files + result.paths.map((path) => File(path!)).toList();
                      });
                    } else {
                      SnackbarGlobal.show('Heç bir fayl seçilmədi');
                    }
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(20.0).r,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: (fileError) ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.border),
                      borderRadius: BorderRadius.circular(10.0).r,
                    ),
                    child: MsSvgIcon(icon: 'assets/widgets/upload.svg'),
                  ),
                ),
                if (files.isNotEmpty) ...[
                  SizedBox(height: 20.0.r),
                  Wrap(
                    spacing: 10.0.r,
                    runSpacing: 10.0.r,
                    children: [
                      for (var file in files) ...[
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0).r,
                              child: Container(
                                width: 100.0.r,
                                height: 100.0.r,
                                color: Theme.of(context).colorScheme.grey2,
                                child: Image.file(file, fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: -5.0.r,
                              right: -5.0.r,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => files.remove(file));
                                },
                                child: Container(
                                  width: 30.0.r,
                                  height: 30.0.r,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30.0).r),
                                  child: Icon(Icons.close, color: Colors.white, size: 18.0.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ] else if (fileError) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                    child: Text(
                      'Heç bir fayl seçməmisiniz.',
                      style: TextStyle(fontSize: 12.0.sp, color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
                SizedBox(height: 20.0.r),
                FormLabel(label: 'Qeydiniz'),
                TextFormField(
                  controller: noteController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Qeydinizi daxil etməmisiniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0.r),
                MsButton(
                  onTap: () {
                    if (!buttonLoading) {
                      if (files.isEmpty) {
                        setState(() => fileError = true);
                      }
                      if (_formKey.currentState!.validate() && files.isNotEmpty) {
                        send();
                      }
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
