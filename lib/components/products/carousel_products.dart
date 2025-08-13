import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/app_heading.dart';
import 'package:market/components/products/single_product_item.dart';
import 'package:market/themes/functions.dart';

class CarouselProducts extends StatelessWidget {
  final String? title;
  final List products;
  final Function()? onTap;
  const CarouselProducts({super.key, this.title, required this.products, this.onTap});

  @override
  Widget build(BuildContext context) {
    late double width;

    if (isTablet(context)) {
      width = MediaQuery.of(context).size.width / 3 - 33;
    } else {
      width = MediaQuery.of(context).size.width / 2 - 33;
    }

    return Column(
      children: [
        if (title != null) ...[AppHeading(title: title, onTap: onTap)],
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 340.0.r,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  if (index == 0) ...[SizedBox(width: 20.0.r)],
                  SizedBox(
                    width: width,
                    child: SingleProductItem(data: products[index]),
                  ),
                  if (index == products.length - 1) ...[SizedBox(width: 20.0.r)],
                ],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 15.0.r);
            },
          ),
        ),
      ],
    );
  }
}
