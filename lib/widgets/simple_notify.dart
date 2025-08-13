import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/scrollable_widget.dart';

class SimpleNotify extends StatelessWidget {
  const SimpleNotify({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return MsScrollableWidget(
      child: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
