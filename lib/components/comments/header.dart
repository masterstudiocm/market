import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/single_product/rating.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';

class CommentsHeader extends StatelessWidget {
  final Map data;
  const CommentsHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0).r,
      height: 170.0.r,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.grey2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0).r,
            child: MsImage(url: data['thumbnail_url'], width: 100.0, height: 130.0),
          ),
          SizedBox(width: 15.0.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['post_title'], style: TextStyle(fontSize: 12.0.sp)),
                SizedBox(height: 5.0.r),
                displayPrice(context, data, fontSize: 15.0.sp),
                const Spacer(),
                SingleProductRating(data: data),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
