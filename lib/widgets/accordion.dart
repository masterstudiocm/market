import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class MsAccordion extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Function()? onTap;
  final bool active;

  const MsAccordion({super.key, required this.title, required this.content, this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.grey2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 15.0).r, child: title),
                ),
                SizedBox(width: 15.0.r),
                AnimatedRotation(
                  turns: active ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: MsSvgIcon(icon: 'assets/arrows/chevron-down.svg', size: 26.0, color: Theme.of(context).colorScheme.grey5),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Visibility(
                visible: active,
                child: Container(padding: const EdgeInsets.only(bottom: 15.0).r, child: content),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
