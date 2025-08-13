import 'package:flutter/material.dart';
import 'package:market/widgets/icon_button.dart';

class ShowHidePassword extends StatelessWidget {
  final bool value;
  final Function() onTap;
  const ShowHidePassword({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Align(
        alignment: Alignment.centerRight,
        child: MsIconButton(borderColor: Colors.transparent, onTap: onTap, icon: (value) ? 'assets/icons/eye-slash.svg' : 'assets/icons/eye.svg'),
      ),
    );
  }
}
