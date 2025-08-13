import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/pages/general/single_post.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';
import 'package:market/widgets_extra/navigator.dart';

class SinglePostItem extends StatefulWidget {
  final Map data;

  const SinglePostItem({super.key, required this.data});

  @override
  State<SinglePostItem> createState() => _SinglePostItemState();
}

class _SinglePostItemState extends State<SinglePostItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatePage(context, SinglePostPage(data: widget.data), root: true);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0.r),
            child: AspectRatio(
              aspectRatio: 5 / 3,
              child: MsImage(url: widget.data['thumbnail_url']),
            ),
          ),
          SizedBox(height: 15.0.r),
          Text(
            widget.data['post_title'],
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.0.r),
          Text(
            widget.data['post_date'],
            style: TextStyle(fontSize: 14.0.sp, color: Theme.of(context).colorScheme.grey5),
          ),
        ],
      ),
    );
  }
}
