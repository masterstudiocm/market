import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/gallery.dart';
import 'package:market/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/lightbox.dart';
import 'package:market/widgets_extra/pagination.dart';

class ProductGallerySlider extends StatefulWidget {
  final Map data;
  const ProductGallerySlider({super.key, required this.data});

  @override
  State<ProductGallerySlider> createState() => _ProductGallerySliderState();
}

class _ProductGallerySliderState extends State<ProductGallerySlider> {
  List images = [];
  int activeIndex = 0;

  Future<void> setGallery() async {
    if (mounted) {
      List<String> newImages = [];

      if (widget.data['gallery'].isNotEmpty) {
        newImages = List<String>.from(widget.data['gallery']);
      } else if (widget.data['variation_gallery'].isNotEmpty) {
        newImages = List<String>.from(widget.data['variation_gallery'].values.first);
      } else if (widget.data['media_url'] != null) {
        newImages.add(widget.data['media_url']);
      }

      setState(() {
        images = newImages;
      });

      for (String url in newImages) {
        final image = CachedNetworkImageProvider(url, headers: App.headers);
        await precacheImage(image, context);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setGallery();
  }

  @override
  void didUpdateWidget(covariant ProductGallerySlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    setGallery();
  }

  @override
  Widget build(BuildContext context) {
    return (images.isEmpty)
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.grey2,
            child: MsSvgIcon(icon: App.placeholderImage, size: 100.0.r, color: Theme.of(context).colorScheme.grey3),
          )
        : Stack(
            children: [
              CarouselSlider.builder(
                itemCount: images.length,
                options: CarouselOptions(
                  enableInfiniteScroll: (images.length == 1) ? false : true,
                  height: MediaQuery.of(context).size.height * Ecommerce.galleryHeight,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  initialPage: 0,
                  onPageChanged: ((index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }),
                ),
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierColor: Colors.black.withValues(alpha: .8),
                      context: context,
                      builder: (context) {
                        return MsLightbox(
                          child: MsGallery(imageUrls: images, initialIndex: itemIndex),
                        );
                      },
                    );
                  },
                  child: MsImage(
                    url: images[itemIndex],
                    height: MediaQuery.of(context).size.height * Ecommerce.galleryHeight,
                    pBackgroundColor: Theme.of(context).colorScheme.grey2,
                    pColor: Theme.of(context).colorScheme.grey3,
                  ),
                ),
              ),
              if (images.length > 1) ...[
                Positioned.fill(
                  bottom: 10.0.r,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Pagination(data: images, activeIndex: activeIndex),
                  ),
                ),
              ],
            ],
          );
  }
}
