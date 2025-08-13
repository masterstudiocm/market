import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/image.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets_extra/pagination.dart';

class HomeSlider extends StatefulWidget {
  final bool loading;
  final List slides;

  const HomeSlider({super.key, required this.slides, required this.loading});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return (widget.loading)
        ? MsIndicator()
        : (widget.slides.isNotEmpty)
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0.r),
                child: Container(
                  color: Colors.black,
                  child: CarouselSlider.builder(
                    itemCount: widget.slides.length,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      List heading = splitText(widget.slides[itemIndex]['s_heading_az']);
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          redirectUrl(widget.slides[itemIndex]['s_url']);
                        },
                        child: Stack(
                          children: [
                            MsImage(
                              url: widget.slides[itemIndex]['s_image'],
                              height: double.infinity,
                              width: MediaQuery.of(context).size.width,
                              pSize: 60.r,
                              pBackgroundColor: Colors.black,
                              pColor: Colors.black,
                            ),
                            Positioned.fill(
                              child: Container(
                                padding: const EdgeInsets.all(17.0).r,
                                child: Column(
                                  spacing: 3.r,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSliderText(activeIndex: activeIndex, itemIndex: itemIndex, heading: heading[0]),
                                    AnimatedSliderText(activeIndex: activeIndex, itemIndex: itemIndex, heading: heading[1]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: double.infinity,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 6),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      onPageChanged: (index, reason) {
                        setState(() => activeIndex = index);
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 10.0.r,
                left: 0.0,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Pagination(data: widget.slides, activeIndex: activeIndex),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class AnimatedSliderText extends StatelessWidget {
  const AnimatedSliderText({super.key, required this.activeIndex, required this.itemIndex, required this.heading});

  final int activeIndex;
  final int itemIndex;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return (heading != '')
        ? AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            opacity: activeIndex == itemIndex ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0).r,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                heading,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.0.sp),
              ),
            ),
          )
        : SizedBox();
  }
}
