import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/pages/navigation/terms.dart';
import 'package:market/pages/ecommerce/single_taxonomy.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/navigator.dart';

class SingleTermItem extends StatelessWidget {
  final Map data;
  final bool showAll;
  const SingleTermItem({super.key, required this.data, this.showAll = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        (data['children'] != null && !showAll)
            ? navigatePage(context, TermsPage(parent: data))
            : navigatePage(context, SingleTaxonomyPage(data: data));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0).r,
        child: Row(
          children: [
            Expanded(
              child: Text(
                (showAll) ? 'Hamısına bax' : data['term_name'],
                style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
              ),
            ),
            MsSvgIcon(icon: 'assets/arrows/chevron-right.svg', size: 20.0, color: Theme.of(context).colorScheme.grey3),
          ],
        ),
      ),
    );
  }
}
