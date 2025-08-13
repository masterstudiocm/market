import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:market/controllers/auth_controller.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class ConfirmAccountPage extends StatefulWidget {
  final String userId;
  const ConfirmAccountPage({super.key, required this.userId});

  @override
  State<ConfirmAccountPage> createState() => _ConfirmAccountPageState();
}

class _ConfirmAccountPageState extends State<ConfirmAccountPage> {
  bool buttonLoading = false;
  String code = '';

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  bool timeFinish = false;
  final authController = AuthController();
  final loginController = Get.find<LoginController>();
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();

  void onEnd() {
    if (mounted) {
      setState(() {
        timeFinish = true;
      });
    }
  }

  Future<void> confirm() async {
    setState(() => buttonLoading = true);
    Map result = await authController.confirmAccount(code, widget.userId);
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      loginController.update(payload['result']);
      cartController.get();
      wishlistController.get();
      SnackbarGlobal.show('Hesabınız təsdiqlənmişdir.', type: SnackBarTypes.success);
      if (mounted) Navigator.pop(context);
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
    setStateSafe(() => buttonLoading = false);
  }

  Future<void> resend() async {
    Map result = await authController.resend(widget.userId);
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      SnackbarGlobal.show(payload['result'], type: SnackBarTypes.success);
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Hesabınızı təsdiq edin')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0).r,
          children: [
            Text(
              'Emailinizə gələn kodu aşağıda qeyd edin. Heç bir email almamısınızsa, "SPAM" qovluğuna nəzər yetirin',
              style: TextStyle(color: Theme.of(context).colorScheme.grey5),
            ),
            SizedBox(height: 25.0.r),
            PinCodeTextField(
              enablePinAutofill: true,
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.none,
              dialogConfig: DialogConfig(
                dialogTitle: 'Buraya əlavə et',
                dialogContent: 'Kopyalanmış kodu əlavə etmək istəyirsiniz ',
                affirmativeText: 'Daxil et',
                negativeText: 'İmtina',
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5.0),
                borderWidth: 1.0,
                fieldHeight: 50,
                fieldWidth: 45,
                selectedFillColor: Theme.of(context).colorScheme.base,
                selectedColor: Theme.of(context).colorScheme.grey1,
                selectedBorderWidth: 1.0,
                activeFillColor: Theme.of(context).colorScheme.base,
                activeColor: Theme.of(context).colorScheme.grey4,
                activeBorderWidth: 1.0,
                inactiveFillColor: Theme.of(context).colorScheme.base,
                inactiveColor: Theme.of(context).colorScheme.grey3,
                inactiveBorderWidth: 1.0,
              ),
              animationDuration: const Duration(milliseconds: 100),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              pastedTextStyle: TextStyle(color: Theme.of(context).colorScheme.primaryColor, fontWeight: FontWeight.w600),
              onChanged: (value) => setState(() => code = value),
              beforeTextPaste: (text) {
                return true;
              },
            ),
            SizedBox(height: 20.0.r),
            MsButton(
              onTap: () {
                if (code.length == 6 && !buttonLoading) {
                  confirm();
                } else {
                  SnackbarGlobal.show('Təsdiq kodunu tam qeyd etməmisiniz.');
                }
              },
              loading: buttonLoading,
              title: 'Təsdiqlə',
            ),
            SizedBox(height: 30.0.r),
            Text(
              'Hələ də email ala bilməmisinizsə, vaxt bitdikdən sonra təkrar istək göndərin.',
              style: TextStyle(color: Theme.of(context).colorScheme.grey5),
              textAlign: TextAlign.center,
            ),
            (timeFinish)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
                        timeFinish = false;
                      });
                      resend();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0).r,
                      child: Text('Təkrar göndər', textAlign: TextAlign.center, style: Theme.of(context).textTheme.link),
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0.r),
                        CountdownTimer(
                          endTime: endTime,
                          onEnd: onEnd,
                          widgetBuilder: (_, time) {
                            return Text('${time!.min ?? '00'} : ${time.sec.toString().padLeft(2, '0')}');
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
