import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/home/slider.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/themes/theme.dart';

class HomeTitle extends StatefulWidget {
  final List slides;
  final bool loading;
  const HomeTitle({super.key, required this.slides, required this.loading});

  @override
  State<HomeTitle> createState() => _HomeTitleState();
}

class _HomeTitleState extends State<HomeTitle> {
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
      toolbarHeight: 160.0.r,
      flexibleSpace: Stack(
        children: [
          if (!widget.loading) ...[
            Positioned(
              top: 50.r,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 120.r,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.base,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                ),
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).r,
            child: HomeSlider(slides: widget.slides, loading: widget.loading),
          ),
        ],
      ),
    );
  }
}
