import 'package:market/components/app/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class MsBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  const MsBottomSheet({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.none,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetHeader(title: title),
            child,
          ],
        ),
      ),
    );
  }
}
