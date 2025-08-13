import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/html.dart';

class MsDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget>? actions;
  final bool center;
  final String error;
  const MsDialog({super.key, this.title, this.content, this.actions, this.center = false, this.error = ''});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w500),
                textAlign: (center) ? TextAlign.center : TextAlign.start,
              ),
              SizedBox(height: 15.0.r),
            ],
            if (content != null) ...[MsHtml(data: content!), SizedBox(height: 20.0.r)],
            if (actions != null) ...[Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!)],
            if (error != '') ...[
              SizedBox(height: 15.0.r),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600),
                textAlign: (center) ? TextAlign.center : TextAlign.start,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
