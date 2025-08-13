import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:market/themes/theme.dart';

class SettingItem extends StatefulWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  final Color? iconBgColor;
  final bool border;

  const SettingItem({super.key, required this.title, required this.image, required this.onTap, this.iconBgColor, this.border = true});

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    MsSvgIcon(icon: widget.image, size: 24.0, color: Theme.of(context).colorScheme.text),
                    SizedBox(width: 20.0.sp),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                      ),
                    ),
                  ],
                ),
              ),
              MsSvgIcon(icon: 'assets/arrows/chevron-right.svg', color: Theme.of(context).colorScheme.grey4, size: 16.0.r),
            ],
          ),
        ),
      ),
    );
  }
}
