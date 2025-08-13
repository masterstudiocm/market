import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/pages/general/search.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/navigator.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
      pinned: true,
      toolbarHeight: 70.r,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).r,
        child: GestureDetector(
          onTap: () {
            navigatePage(context, SearchPage());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0).r,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0.r), color: Color(0xFF2c2b3c)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Axtarış sözünüzü yazın...',
                    style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                  ),
                ),
                MsSvgIcon(icon: 'assets/icons/search.svg', color: Colors.white, size: 17.r),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
