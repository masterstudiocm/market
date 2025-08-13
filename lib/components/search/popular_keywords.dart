import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/search_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class PopularKeywods extends StatelessWidget {
  const PopularKeywods({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchProductController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Populyar axtarışlar', style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 15.0.r),
        Wrap(
          spacing: 10.0.r,
          runSpacing: 10.0.r,
          children: [
            for (var item in searchController.popularKeywords) ...[
              InkWell(
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                onTap: () {
                  searchController.add(item);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Ink(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0).r,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(30.0).r,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MsSvgIcon(icon: 'assets/icons/search.svg', size: 18.0, color: Theme.of(context).colorScheme.primaryColor),
                      SizedBox(width: 10.0.r),
                      Text(item),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
