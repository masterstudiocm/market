import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';
import 'package:market/widgets_extra/lightbox.dart';

class SinglePostHeader extends StatelessWidget {
  const SinglePostHeader({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showDialog(
            barrierColor: Colors.black.withValues(alpha: .8),
            context: context,
            builder: (BuildContext context) {
              return MsLightbox(
                child: Center(child: MsImage(url: data['media_url'])),
              );
            },
          );
        },
        child: Stack(
          children: <Widget>[
            MsImage(url: data['media_url'], height: double.infinity, pSize: (MediaQuery.of(context).size.width - 40) / 4),
            Container(decoration: BoxDecoration(gradient: Theme.of(context).colorScheme.gradient)),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(15.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data['post_title'],
                      style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    SizedBox(height: 15.0.r),
                    Text(
                      data['post_date'],
                      style: TextStyle(color: Theme.of(context).colorScheme.grey3, fontSize: 14.0.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
