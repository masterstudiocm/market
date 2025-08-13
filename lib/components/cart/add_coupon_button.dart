import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/cart/coupon_modal_sheet.dart';
import 'package:market/widgets/button.dart';

class AddCouponButton extends StatelessWidget {
  const AddCouponButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MsButton(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) {
            return CouponModalSheet();
          },
        );
      },
      style: MsButtonStyle.secondary,
      height: 35.r,
      padding: const EdgeInsets.symmetric(horizontal: 13).r,
      child: Row(
        spacing: 5.r,
        children: [
          Icon(Icons.add, size: 16.r),
          Text(
            'Kupon',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
