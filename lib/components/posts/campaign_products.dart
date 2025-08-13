import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/products/load_products.dart';

class CampaignProducts extends StatelessWidget {
  final String? multiple;
  const CampaignProducts({super.key, required this.multiple});

  @override
  Widget build(BuildContext context) {
    return (multiple != null && multiple != '')
        ? Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0).r,
                child: Text('Kampaniyaya aid məhsullar', style: Theme.of(context).textTheme.titleMedium),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: LoadProducts(multiple: multiple, physics: const NeverScrollableScrollPhysics()),
              ),
            ],
          )
        : const SizedBox();
  }
}
