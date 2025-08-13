import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class MsOutlineButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final bool loading;
  final double borderRadius;
  final IconData iconData;
  final TextStyle? textStyle;
  final Widget? child;
  final double height;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? loadingIndicator;
  final Color? borderColor;

  const MsOutlineButton({
    super.key,
    required this.onTap,
    this.title,
    this.loading = false,
    this.borderRadius = 50.0,
    this.iconData = Icons.arrow_forward,
    this.textStyle,
    this.child,
    this.height = 54.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0),
    this.backgroundColor,
    this.titleColor,
    this.loadingIndicator,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Color background = backgroundColor ?? Colors.transparent;
    Color color = titleColor ?? Theme.of(context).colorScheme.text;
    Color border = borderColor ?? Theme.of(context).colorScheme.border;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        onTap: onTap,
        child: Ink(
          padding: padding.r,
          height: height.r,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border),
          ),
          child: Center(
            child: (loading)
                ? loadingIndicator ??
                      SizedBox(
                        width: 25.0.r,
                        height: 25.0.r,
                        child: CircularProgressIndicator(color: titleColor, backgroundColor: Colors.white.withValues(alpha: .5), strokeWidth: 2.0),
                      )
                : child ??
                      Center(
                        child: Text(
                          title!,
                          style: (textStyle != null)
                              ? textStyle
                              : TextStyle(color: color, fontSize: 15.0.sp, height: 1.1, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
