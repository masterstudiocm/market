import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/pages/ecommerce/orders.dart';
import 'package:market/pages/ecommerce/payment_canceled.dart';
import 'package:market/pages/ecommerce/payment_declined.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/dialog.dart';
import 'package:market/widgets/icon_button.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  const PaymentPage({super.key, required this.url, required this.orderId});

  final String url;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;
  bool showProgess = false;
  double progressPercent = 0;
  String url = '';

  final cartController = Get.find<CartController>();

  bool conditions() {
    for (var page in Ecommerce.successPaymentUrls) {
      if (url.contains('${App.domain}/$page/')) {
        Get.close(2);
        Get.to(() => const OrdersPage());
        SnackbarGlobal.show('Ödəniş prosesi uğurla yekunlaşdı. Sifarişiniz qeydə alınmışdır.', type: SnackBarTypes.success);
        cartController.get();
        return true;
      }
    }
    for (var page in Ecommerce.declinedPaymentUrls) {
      if (url.contains('${App.domain}/$page/')) {
        Get.close(2);
        Get.to(() => const PaymentDeclinedPage());
        return true;
      }
    }
    for (var page in Ecommerce.canceledPaymentUrls) {
      if (url.contains('${App.domain}/$page/')) {
        Get.close(2);
        Get.to(() => const PaymentCanceledPage());
        return true;
      }
    }
    return false;
  }

  void exitAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return MsDialog(
          content: 'Ödəniş səhifəsindən çıxış edirsiniz. Çıxış etdiyinizdə ödənişdən imtina etmiş olacaqsınız.',
          actions: [
            Expanded(
              child: MsOutlineButton(
                height: 45.0,
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'İmtina et',
              ),
            ),
            SizedBox(width: 10.0.r),
            Expanded(
              child: MsButton(
                height: 45.0,
                onTap: () {
                  Get.close(3);
                  Get.to(() => const PaymentCanceledPage(), transition: Transition.fade);
                },
                title: 'Çıxış',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> backAction() async {
    for (var page in Ecommerce.successPaymentUrls) {
      if (url.contains(page)) {
        Get.close(2);
        Get.to(() => const OrdersPage());
        return true;
      }
    }
    exitAlert();
    return true;
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                showProgess = true;
                progressPercent = progress / 100;
                if (progressPercent == 1.0) {
                  showProgess = false;
                }
              });
            }
          },
          onNavigationRequest: (navigation) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              this.url = url;
            });
            conditions();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await backAction();
      },
      child: Scaffold(
        appBar: MsAppBar(
          title: const Text('Onlayn ödəniş'),
          leading: MsIconButton(
            borderColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.grey1,
            onTap: () async {
              await backAction();
            },
            child: Icon(Icons.close, color: Theme.of(context).colorScheme.text),
          ),
        ),
        body: Column(
          children: [
            if (showProgess) ...[
              LinearProgressIndicator(value: progressPercent, color: Theme.of(context).colorScheme.secondaryColor, backgroundColor: Colors.white),
            ],
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
