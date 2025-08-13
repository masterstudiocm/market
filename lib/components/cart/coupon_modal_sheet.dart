import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/app/label.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/bottom_sheet.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets_extra/snackbar.dart';

class CouponModalSheet extends StatefulWidget {
  const CouponModalSheet({super.key});

  @override
  State<CouponModalSheet> createState() => _CouponModalSheetState();
}

class _CouponModalSheetState extends State<CouponModalSheet> {
  bool buttonLoading = false;
  String coupon = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final cartController = Get.find<CartController>();

  Future<void> apply() async {
    setState(() => buttonLoading = true);
    final payload = await cartController.addCoupon(coupon);
    if (payload['status'] == 'success') {
      if (mounted) Navigator.pop(context);
      cartController.get();
    } else {
      SnackbarGlobal.show(payload['error']);
    }
    setStateSafe(() => buttonLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
      title: 'Kupon kodunu daxil edin',
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormLabel(label: 'Kupon kodunuz'),
                TextFormField(
                  onChanged: (value) => coupon = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zəhmət olmasa kupon kodunu daxil edin';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.r),
                MsButton(
                  onTap: () {
                    if (_formKey.currentState!.validate() && !buttonLoading) {
                      apply();
                    }
                  },
                  loading: buttonLoading,
                  title: 'Tətbiq et',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
