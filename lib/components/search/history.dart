import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/search_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchProductController>();

    return Obx(
      () => (searchController.history.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Axtarış tarixçəniz', style: Theme.of(context).textTheme.titleSmall),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        searchController.empty();
                      },
                      child: Text('Təmizlə', style: Theme.of(context).textTheme.link),
                    ),
                  ],
                ),
                SizedBox(height: 10.0.r),
                Wrap(
                  spacing: 10.0.r,
                  runSpacing: 10.0.r,
                  children: [
                    for (var item in searchController.history.take(10).toList()) ...[
                      InkWell(
                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        onTap: () {
                          searchController.add(item);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0).r,
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey2, borderRadius: BorderRadius.circular(30.0).r),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MsSvgIcon(icon: 'assets/icons/history.svg', size: 20.0, color: Theme.of(context).colorScheme.grey4),
                              SizedBox(width: 10.0.r),
                              Flexible(child: Text(item)),
                              SizedBox(width: 10.0.r),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  searchController.remove(item);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0).r,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50.0).r),
                                  child: MsSvgIcon(icon: 'assets/icons/close.svg', size: 10.0, color: Theme.of(context).colorScheme.base),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 30.0),
              ],
            )
          : SizedBox(),
    );
  }
}
