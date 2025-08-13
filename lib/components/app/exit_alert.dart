import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/dialog.dart';
import 'package:market/widgets/outline_button.dart';

class AppExitAlert extends StatelessWidget {
  const AppExitAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return MsDialog(
      content: 'Çıxış etmək istədiyinizə əminsinizmi?',
      actions: [
        Expanded(
          child: MsOutlineButton(
            onTap: () {
              Navigator.pop(context);
            },
            height: 45.0,
            title: 'Xeyr',
          ),
        ),
        SizedBox(width: 10.0.r),
        Expanded(
          child: MsButton(
            onTap: () {
              SystemNavigator.pop();
            },
            height: 45.0,
            title: 'Bəli',
          ),
        ),
      ],
    );
  }
}
