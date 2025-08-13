import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/icon_button.dart';

class SinglePostBackButton extends StatelessWidget {
  const SinglePostBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 15.0.r),
        MsIconButton(
          backgroundColor: const Color.fromARGB(65, 0, 0, 0),
          onTap: () {
            Navigator.pop(context);
          },
          icon: 'assets/arrows/arrow-left.svg',
          borderColor: Colors.transparent,
          iconColor: Colors.white,
        ),
      ],
    );
  }
}
