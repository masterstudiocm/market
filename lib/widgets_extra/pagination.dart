import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Pagination extends StatefulWidget {
  final List data;
  final int activeIndex;
  final Color? activeColor;
  final Color? color;
  const Pagination({
    super.key,
    required this.data,
    required this.activeIndex,
    this.activeColor,
    this.color,
  });

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  List<Widget> pagination() => List<Widget>.generate(
      widget.data.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0).r,
            height: 5.0.r,
            width: widget.activeIndex == index ? 20.0.r : 5.0.r,
            decoration: BoxDecoration(
              color: widget.activeIndex == index
                  ? (widget.activeColor != null)
                      ? widget.activeColor
                      : Colors.white
                  : (widget.color != null)
                      ? widget.color
                      : Colors.white.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(10.0.r),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pagination(),
    );
  }
}
