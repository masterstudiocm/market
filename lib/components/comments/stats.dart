import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class CommentsStats extends StatelessWidget {
  final Map data;
  const CommentsStats({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0).r,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.grey2, width: 1.0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: Column(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 26.0.r),
                Text(
                  double.parse(data['calc']['total']).toStringAsFixed(1),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0.sp),
                ),
                const SizedBox(height: 5.0),
                Text('${data['calc']['count']} səs', style: TextStyle(fontSize: 12.0.sp)),
              ],
            ),
          ),
          SizedBox(width: 10.0.r),
          Expanded(
            child: Column(
              children: [
                for (var i = 5; i >= 1; i--) ...[
                  Row(
                    children: [
                      SizedBox(width: 12.0.r, child: Text(i.toString())),
                      SizedBox(width: 3.0.r),
                      Icon(Icons.star, color: Colors.orange, size: 17.0.r),
                      SizedBox(width: 15.0.r),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(height: 3.0.r, color: Theme.of(context).colorScheme.grey2),
                            Positioned(
                              child: FractionallySizedBox(
                                widthFactor: data['stats'][i.toString()] / int.parse(data['calc']['count']),
                                child: Container(height: 3.0.r, color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 55.0.r,
                        child: Text(
                          '${data['stats'][i.toString()].toString()} səs',
                          style: TextStyle(fontSize: 13.0.sp),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  if (i != 1) ...[SizedBox(height: 3.0.r)],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
