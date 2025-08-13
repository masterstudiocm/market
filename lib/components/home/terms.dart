import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/pages/ecommerce/single_taxonomy.dart';
import 'package:market/pages/navigation/terms.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';
import 'package:market/widgets_extra/navigator.dart';

class HomeTerms extends StatelessWidget {
  final List terms;
  const HomeTerms({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    return (terms.isNotEmpty)
        ? GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet(context) ? 3 : 2,
              childAspectRatio: 2 / 1,
              mainAxisSpacing: 10.0.r,
              crossAxisSpacing: 10.0.r,
            ),
            itemCount: terms.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (terms[index]['children'] != null) {
                    navigatePage(context, TermsPage(parent: terms[index]));
                  } else {
                    navigatePage(context, SingleTaxonomyPage(data: terms[index]));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey2, borderRadius: BorderRadius.circular(10.0).r),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 12.0, 65.0, 12.0).r,
                        child: Text(
                          terms[index]['term_name'],
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0.sp),
                        ),
                      ),
                      Positioned(
                        top: 3.0.r,
                        right: -20.0.r,
                        child: MsImage(url: terms[index]['term_thumbnail'], width: 80.0.r, height: 80.0.r, enablePlaceholder: false),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}
