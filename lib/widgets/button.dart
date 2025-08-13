import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

enum MsButtonStyle { primary, secondary, light, white }

class MsButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final MsButtonStyle style;
  final bool loading;
  final bool disabled;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? child;
  final double height;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? loadingIndicator;

  const MsButton({
    super.key,
    required this.onTap,
    this.title,
    this.style = MsButtonStyle.primary,
    this.loading = false,
    this.disabled = false,
    this.borderRadius = 50.0,
    this.textStyle,
    this.child,
    this.height = 54.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0),
    this.backgroundColor,
    this.titleColor,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = (disabled) ? Colors.grey : backgroundColor ?? _getBackgroundColor(context);
    final textColor = (disabled) ? Colors.white : titleColor ?? _getTextColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        onTap: (disabled) ? null : onTap,
        child: Ink(
          padding: padding.r,
          height: height.r,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(borderRadius)),
          child: Center(
            child: (loading)
                ? loadingIndicator ??
                      SizedBox(
                        width: 25.0.r,
                        height: 25.0.r,
                        child: CircularProgressIndicator(color: textColor, backgroundColor: Colors.white.withValues(alpha: .5), strokeWidth: 2.0),
                      )
                : child ??
                      Center(
                        child: Text(
                          title!,
                          style: (textStyle != null)
                              ? textStyle
                              : TextStyle(color: textColor, fontSize: 15.0.sp, height: 1.1, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (style) {
      case MsButtonStyle.primary:
        return Theme.of(context).colorScheme.primaryColor;
      case MsButtonStyle.secondary:
        return Theme.of(context).colorScheme.secondaryColor;
      case MsButtonStyle.light:
        return Theme.of(context).colorScheme.grey1;
      case MsButtonStyle.white:
        return Colors.white;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (style) {
      case MsButtonStyle.primary:
        return Colors.white;
      case MsButtonStyle.secondary:
        return Colors.white;
      case MsButtonStyle.light:
        return Colors.black;
      case MsButtonStyle.white:
        return Colors.black;
    }
  }
}
