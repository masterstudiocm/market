import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/pages/ecommerce/single_order.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets_extra/navigator.dart';

class SingleOrderItem extends StatelessWidget {
  const SingleOrderItem({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        navigatePage(context, SingleOrderPage(orderId: data['order_id']));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11.0).r,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.base,
                borderRadius: BorderRadius.circular(10.0).r,
                border: Border.all(width: 1.0, color: Theme.of(context).colorScheme.grey2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0).r,
                    color: Theme.of(context).colorScheme.grey1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['order_date'], style: TextStyle(fontWeight: FontWeight.w500)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0).r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Ecommerce.orderStatusColors[data['order_status']],
                          ),
                          child: Text(
                            getOrderStatus(data['order_status']),
                            style: TextStyle(color: Colors.white, fontSize: 13.0.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0).r,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Sifariş:', style: Theme.of(context).textTheme.titleSmall),
                            SizedBox(width: 5.0.r),
                            Text(
                              data['order_number'],
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.grey5),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.r),
                        Row(
                          children: [
                            Text('Toplam:', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(width: 5.0),
                            Text(
                              '${data['order_total_price']} ${data['order_currency']}',
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.grey5),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.r),
                        Row(
                          children: [
                            Text('Məhsul sayı:', style: Theme.of(context).textTheme.titleSmall),
                            SizedBox(width: 5.0.r),
                            if (data['order_product_quantity'] != null) ...[
                              Text(
                                data['order_product_quantity'],
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.grey5),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15.0.r,
            bottom: 15.0.r,
            child: Row(
              children: [
                Text(
                  'Detallar',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0.sp, color: Theme.of(context).colorScheme.primaryColor, height: 1.25),
                ),
                SizedBox(width: 3.0.r),
                Icon(Icons.arrow_forward_ios_rounded, size: 12.0.r, color: Theme.of(context).colorScheme.primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
