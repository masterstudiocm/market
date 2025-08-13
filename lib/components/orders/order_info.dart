import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool copy;
  const OrderInfoItem({super.key, required this.label, required this.value, this.copy = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: Theme.of(context).textTheme.titleSmall),
        SizedBox(width: 30.0.r),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (copy) {
                  Clipboard.setData(ClipboardData(text: value));
                  SnackbarGlobal.show('Məlumat panoya kopyalandı.', type: SnackBarTypes.info);
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  if (copy) ...[SizedBox(width: 8.0.r), Icon(Icons.copy, size: 16.0.r, color: Theme.of(context).colorScheme.grey5)],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
