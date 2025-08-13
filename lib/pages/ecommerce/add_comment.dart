import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData;
import 'package:market/components/app/label.dart';
import 'package:market/components/comments/header.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class AddCommentPage extends StatefulWidget {
  final Map data;
  const AddCommentPage({super.key, required this.data});

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  String name = '';
  String email = '';
  int rating = 0;
  String comment = '';

  bool buttonLoading = false;
  bool ratingError = false;

  final _formKey = GlobalKey<FormState>();
  final loginController = Get.find<LoginController>();

  Future<void> send() async {
    FormData formData = FormData.fromMap({
      'name': name,
      'email': email,
      'rating': rating.toString(),
      'comment': comment,
      'post_id': widget.data['post_id'],
    });

    Map result = await httpRequest('${App.domain}/api/comments.php?action=add', fields: formData, snackbar: true);
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      SnackbarGlobal.show(payload['result'], type: SnackBarTypes.success);
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }

    setStateSafe(() => buttonLoading = false);
  }

  @override
  void initState() {
    super.initState();
    if (loginController.userdata.isNotEmpty) {
      name = '${loginController.userdata['first_name']} ${loginController.userdata['last_name']}';
      email = loginController.userdata['user_email'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Şərh bildir')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommentsHeader(data: widget.data),
              Padding(
                padding: const EdgeInsets.all(20.0).r,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (loginController.userdata.isEmpty) ...[
                        const FormLabel(label: 'Ad və soyadınız'),
                        TextFormField(
                          onChanged: (value) => name = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ad və soyadınızı qeyd etməmisiniz.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0.r),
                        const FormLabel(label: 'Email'),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => email = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email qeyd etməmisiniz.';
                            } else if (!GetUtils.isEmail(value.trim())) {
                              return 'Email düzgün deyil.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0.r),
                      ] else ...[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${loginController.userdata['first_name']} ${loginController.userdata['last_name']}',
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20.0.sp),
                              ),
                              TextSpan(
                                text: ' olaraq şərh bildirirsiniz.',
                                style: TextStyle(color: Colors.black, fontSize: 18.5.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0.r),
                      ],
                      const FormLabel(label: 'Qiymətləndirmə'),
                      Row(
                        children: [
                          for (var i = 1; i <= 5; i++) ...[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  rating = i;
                                  ratingError = false;
                                });
                              },
                              child: Icon((i <= rating) ? Icons.star : Icons.star_border, color: Colors.orange, size: 30.0.r),
                            ),
                          ],
                        ],
                      ),
                      if (ratingError) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0).r,
                          child: Text(
                            'Qiymətləndirmə qeyd etməmisiniz.',
                            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12.0.sp),
                          ),
                        ),
                      ],
                      SizedBox(height: 15.0.r),
                      const FormLabel(label: 'Mesajınız'),
                      TextFormField(
                        maxLines: 4,
                        onChanged: (value) => comment = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Heç bir mesaj qeyd etməmisiniz.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.0.r),
                      MsButton(
                        onTap: () async {
                          if (!buttonLoading) {
                            if (rating == 0) {
                              setState(() => ratingError = true);
                            }
                            if (_formKey.currentState!.validate() && rating != 0) {
                              send();
                            }
                          }
                        },
                        loading: buttonLoading,
                        title: 'Göndər',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
