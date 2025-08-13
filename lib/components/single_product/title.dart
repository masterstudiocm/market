import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';

class SingleProductTitle extends StatefulWidget {
  final Map data;
  const SingleProductTitle({super.key, required this.data});

  @override
  State<SingleProductTitle> createState() => _SingleProductTitleState();
}

class _SingleProductTitleState extends State<SingleProductTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Theme.of(context).colorScheme.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data['post_title'], style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10.0),
              displayPrice(context, widget.data, fontSize: 20.0.sp),
            ],
          ),
          if (widget.data['stock'] == '0') ...[
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3.0)),
              child: Text(
                'Məhsul bitib',
                style: TextStyle(color: Colors.white, fontSize: 12.0.sp, height: 1.2),
              ),
            ),
          ] else if (widget.data['stock'] != '' && widget.data['stock'] != null && int.parse(widget.data['stock']) <= 5) ...[
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
              child: Text(
                '${widget.data['stock']} ədəd qalıb',
                style: TextStyle(color: Colors.white, fontSize: 12.0.sp, height: 1.2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
