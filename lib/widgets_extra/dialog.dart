import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MsDialogContainer extends StatelessWidget {
  final Widget child;
  final Function? onClose;
  const MsDialogContainer({super.key, required this.child, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dismissible(
          key: GlobalKey(),
          direction: DismissDirection.down,
          onUpdate: (data) {
            if (data.progress >= .5) {
              Navigator.pop(context);
              onClose;
            }
          },
          child: child,
        ),
        Positioned(
          top: 10.0.r,
          right: 10.0.r,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0).r,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0).r,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: .5), borderRadius: BorderRadius.circular(50.0).r),
                child: Icon(Icons.close, color: Colors.white, size: 26.0.sp),
              ),
            ),
          ),
        )
      ],
    );
  }
}
