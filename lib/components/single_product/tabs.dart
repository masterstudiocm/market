import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/single_product/tab.dart';
import 'package:market/pages/ecommerce/comments.dart';
import 'package:market/pages/general/page.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/html.dart';
import 'package:market/widgets_extra/navigator.dart';

class SingleProductTabs extends StatelessWidget {
  final Map data;
  const SingleProductTabs({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0.r),
          SingleProductTab(
            onTap: () {
              navigatePage(
                context,
                GeneralPage(
                  title: 'Məhsul haqqında',
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0).r,
                    child: MsHtml(data: data['about_az']),
                  ),
                ),
                root: true,
              );
            },
            icon: 'assets/icons/info.svg',
            title: 'Məhsul haqqında',
          ),
          SingleProductTab(
            onTap: () {
              navigatePage(context, Comments(data: data), root: true);
            },
            icon: 'assets/icons/comment.svg',
            title: 'Şərhlər (${data['commentsCount']})',
          ),
          SingleProductTab(
            onTap: () {
              navigatePage(
                context,
                GeneralPage(
                  title: 'Çatdırılma şərtləri',
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0).r,
                    child: MsHtml(data: data['about_az']),
                  ),
                ),
                root: true,
              );
            },
            icon: 'assets/icons/delivery.svg',
            title: 'Çatdırılma şərtləri',
          ),
        ],
      ),
    );
  }
}
