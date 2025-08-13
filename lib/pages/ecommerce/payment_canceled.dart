import 'package:market/widgets/notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:flutter/material.dart';

class PaymentCanceledPage extends StatelessWidget {
  const PaymentCanceledPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Ödəmə problemi')),
      body: MsNotify(
        heading: 'Ödənişdən imtina edildi',
        description: 'Görünüşə görə ödəniş prosesini sona qədər davam etdirmədiyiniz üçün proses yarımçıq dayandırılmışdır.',
        action: () {
          Navigator.pop(context);
        },
        buttonText: 'Geriyə qayıt',
      ),
    );
  }
}
