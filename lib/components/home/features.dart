import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

class HomeFeatures extends StatelessWidget {
  const HomeFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final sitedataController = Get.find<SiteDataController>();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100.0.r,
      child: (sitedataController.sitedata['features'] != null)
          ? ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: sitedataController.sitedata['features'].length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) ...[SizedBox(width: 20.0.r)],
                    Container(
                      width: 200.0.r,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0).r),
                      child: Row(
                        children: [
                          Container(
                            width: 50.0.r,
                            height: 50.0.r,
                            padding: const EdgeInsets.all(10.0).r,
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(50.0)),
                            child: MsSvgIcon(icon: 'assets/icons/check.svg', color: Theme.of(context).colorScheme.base),
                          ),
                          SizedBox(width: 10.0.r),
                          Expanded(
                            child: Text(
                              sitedataController.sitedata['features'][index]['f_heading_az'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index == sitedataController.sitedata['features'].length - 1) ...[SizedBox(width: 20.0.r)],
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 20.0);
              },
            )
          : SizedBox(),
    );
  }
}
