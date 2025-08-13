import 'package:market/widgets/notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:flutter/material.dart';

class PaymentDeclinedPage extends StatelessWidget {
  const PaymentDeclinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Ödəmə problemi')),
      body: MsNotify(
        heading: 'Ödəniş zamanı xəta baş verdi',
        description:
            'Ödəniş prosesi zamanı provayder tərəfindən texniki nasazlıq yaranmışdır. Başqa bir kart yoxlayın və ya texniki dəstək xidmətimizlə əlaqəyə keçin.',
        action: () {
          Navigator.pop(context);
        },
        buttonText: 'Geriyə qayıt',
      ),
    );
  }
}
