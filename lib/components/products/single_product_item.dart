import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:market/pages/ecommerce/single_product.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';
import 'package:market/widgets_extra/navigator.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleProductItem extends StatefulWidget {
  final Map data;
  const SingleProductItem({super.key, required this.data});

  @override
  State<SingleProductItem> createState() => _SingleProductItemState();
}

class _SingleProductItemState extends State<SingleProductItem> {
  bool wishlistLoading = false;
  List colors = [];
  String thumbnail = '';
  String activeColor = '';

  final wishlistController = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();

    thumbnail = widget.data['thumbnail_url'] ?? '';
    getVariationColors();
  }

  void getVariationColors() {
    if (widget.data['colors'] != null) {
      List<String> getColors = widget.data['color'].split(',');
      List<String> getColorCodes = widget.data['colors'].split(',');
      Map getGallery = (widget.data['variation_gallery'] is Map && widget.data['variation_gallery'].isNotEmpty)
          ? widget.data['variation_gallery']
          : {};
      if (getColors.isNotEmpty) {
        for (var i = 0; i < getColors.length; i++) {
          String image = '';
          if (getGallery[getColors[i]] != null && getGallery[getColors[i]][0] != null) {
            image = getGallery[getColors[i]][0];
            // precacheImage(CachedNetworkImageProvider(image), context);
          }
          colors.add({'id': getColors[i], 'color': hexToColor(getColorCodes[i].trim()), 'image': image});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget stockWidget = const SizedBox();

    if (widget.data['stock'] == '0') {
      stockWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0).r,
        decoration: const BoxDecoration(color: Colors.black),
        child: Text(
          'Bitib',
          style: TextStyle(color: Colors.white, fontSize: 10.0.sp),
        ),
      );
    } else if (widget.data['stock'] != '' && widget.data['stock'] != null && int.parse(widget.data['stock']) <= 5) {
      stockWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0).r,
        decoration: const BoxDecoration(color: Colors.black),
        child: Text(
          '${widget.data['stock']} ədəd qalıb',
          style: TextStyle(color: Colors.white, fontSize: 10.0.sp),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        navigatePage(context, SingleProductPage(data: widget.data));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0).r,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: MsImage(
                    url: thumbnail,
                    pSize: 45.0,
                    pBackgroundColor: Theme.of(context).colorScheme.grey2,
                    pColor: Theme.of(context).colorScheme.grey3,
                  ),
                ),
              ),
              Positioned(
                right: 7.0.r,
                top: 7.0.r,
                child: GestureDetector(
                  onTap: () async {
                    if (!wishlistLoading) {
                      setState(() => wishlistLoading = true);
                      await wishlistController.add(widget.data['post_id']);
                      setState(() => wishlistLoading = false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7.0).r,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.base, borderRadius: BorderRadius.circular(30.0).r),
                    child: Obx(
                      () => (wishlistLoading)
                          ? SizedBox(
                              width: 18.0.r,
                              height: 18.0.r,
                              child: CircularProgressIndicator(strokeWidth: 2.0, backgroundColor: Theme.of(context).colorScheme.bg),
                            )
                          : (wishlistController.wishlist.contains(widget.data['post_id']))
                          ? const MsSvgIcon(icon: 'assets/icons/heart-fill.svg', size: 18.0, color: Color(0xFFf68b81))
                          : MsSvgIcon(icon: 'assets/icons/heart.svg', size: 18.0, color: Theme.of(context).colorScheme.text),
                    ),
                  ),
                ),
              ),
              Positioned(bottom: 0.0, left: 5.0.r, child: stockWidget),
            ],
          ),
          SizedBox(height: 10.0.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data['post_title'],
                maxLines: 2,
                style: TextStyle(fontSize: 12.0.sp),
                overflow: TextOverflow.ellipsis,
              ),
              if (colors.length > 1) ...[
                SizedBox(height: 8.0.r),
                Wrap(
                  spacing: 3.0.r,
                  runSpacing: 3.0.r,
                  children: [
                    for (var color in colors) ...[
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (color['image'] != '') {
                            setState(() {
                              thumbnail = color['image'];
                            });
                          }
                          setState(() {
                            activeColor = color['id'];
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 24.0.r,
                              height: 24.0.r,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (activeColor == color['id']) ? Theme.of(context).colorScheme.text : Theme.of(context).colorScheme.border,
                                ),
                                borderRadius: BorderRadius.circular(26.0),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  width: 16.0.r,
                                  height: 16.0.r,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0).r, color: color['color']),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              SizedBox(height: 8.0.r),
              displayPrice(context, widget.data, fontSize: 14.0.sp),
            ],
          ),
        ],
      ),
    );
  }
}
