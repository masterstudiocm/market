import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData;
import 'package:market/components/app/label.dart';
import 'package:market/controllers/form_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets_extra/appbar.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String name = '';
  String email = '';
  String message = '';

  bool buttonLoading = false;
  Map data = <dynamic, dynamic>{};

  final FormController formController = FormController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: const Text('Mesaj göndərin')),
      body: Form(
        key: _formKey,
        child: (data.isNotEmpty)
            ? MsNotify(heading: data['result'], type: MsNotifyTypes.success)
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Əlavə sual və təkliflərinizlə bağlı aşağıdakı formdan bizə yaza bilərsiniz. Ən qısa zamanda əməkdaşlarımız sizə geri dönüş edəcəklər.',
                      style: TextStyle(fontSize: 14.0.r, color: Theme.of(context).colorScheme.grey5, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.0.r),
                    const FormLabel(label: 'Ad və soyadınız'),
                    TextFormField(
                      onChanged: (value) => name = value,
                      validator: (String? value) {
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email qeyd etməmisiniz.';
                        } else if (!GetUtils.isEmail(value.trim())) {
                          return 'Email düzgün deyil.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0.r),
                    const FormLabel(label: 'Mesajınız'),
                    TextFormField(
                      maxLines: 4,
                      onChanged: (value) => message = value,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Heç bir mesaj qeyd etməmisiniz.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0.r),
                    MsButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate() && !buttonLoading) {
                          setState(() => buttonLoading = true);
                          Map result = await formController.send(form: 'contact', fields: {'name': name, 'email': email, 'message': message});
                          setStateSafe(() {
                            buttonLoading = false;
                            data = result['data'];
                          });
                        }
                      },
                      loading: buttonLoading,
                      title: 'Göndər',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
