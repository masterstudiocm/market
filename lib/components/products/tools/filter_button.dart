import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:market/widgets/svg_icon.dart';

class FilterButton extends StatelessWidget {
  final Function() onTap;

  const FilterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MsOutlineButton(
        onTap: onTap,
        height: 40.0,
        borderColor: Theme.of(context).colorScheme.grey2,
        padding: const EdgeInsets.symmetric(horizontal: 15.0).r,
        child: Row(
          children: [
            MsSvgIcon(icon: 'assets/icons/filter.svg', size: 15.0, color: Theme.of(context).colorScheme.grey5),
            SizedBox(width: 10.0.r),
            const Text('Filter'),
          ],
        ),
      ),
    );
  }
}
