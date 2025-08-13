import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class MsCheckbox extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final bool value;
  final Function(bool) onChanged;
  final EdgeInsets? padding;
  const MsCheckbox({super.key, required this.title, this.subtitle, this.value = false, required this.onChanged, this.padding});

  @override
  State<MsCheckbox> createState() => _MsCheckboxState();
}

class _MsCheckboxState extends State<MsCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0).r,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title,
                  if (widget.subtitle != null) ...[widget.subtitle!],
                ],
              ),
            ),
            SizedBox(width: 15.0.r),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 25.0.r,
              height: 25.0.r,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                  color: (widget.value) ? Theme.of(context).colorScheme.primaryColor : Theme.of(context).colorScheme.grey3,
                ),
                borderRadius: BorderRadius.circular(30.0),
                color: (widget.value) ? Theme.of(context).colorScheme.primaryColor : Colors.transparent,
              ),
              child: (widget.value) ? Icon(Icons.check, color: Colors.white, size: 16.0.r) : null,
            ),
          ],
        ),
      ),
    );
  }
}
