import 'package:market/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  const BottomSheetHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0).r,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey2)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          SizedBox(width: 15.0.r),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, size: 26.0.r, color: Theme.of(context).colorScheme.text),
          ),
        ],
      ),
    );
  }
}
