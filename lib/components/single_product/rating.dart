import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/rating.dart';

class SingleProductRating extends StatelessWidget {
  final Map data;
  const SingleProductRating({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double vote = 0;
    if (data['commentsCount'] != '0') {
      vote = double.parse((double.parse(data['commentsSum']) / double.parse(data['commentsCount'])).toStringAsFixed(1));
    }
    return Row(
      children: [
        Text(
          vote.toString(),
          style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 5.0.r),
        MsRating(value: vote),
        SizedBox(width: 10.0.r),
        Text('(${data['commentsCount']} səs)', style: TextStyle(fontSize: 13.0.sp)),
      ],
    );
  }
}
