import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/single_product/gallery.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/icon_button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:share_plus/share_plus.dart';

class SingleProductAppBar extends StatefulWidget {
  final Map data;
  const SingleProductAppBar({super.key, required this.data});

  @override
  State<SingleProductAppBar> createState() => _SingleProductAppBarState();
}

class _SingleProductAppBarState extends State<SingleProductAppBar> {
  bool loading = false;

  final wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: App.toolbarHeight,
      expandedHeight: MediaQuery.of(context).size.height * Ecommerce.galleryHeight - MediaQuery.of(context).viewPadding.top,
      leadingWidth: App.leadingWidth,
      leading: Row(
        children: [
          SizedBox(width: 20.0.r),
          MsIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            icon: 'assets/arrows/arrow-left.svg',
            backgroundColor: Theme.of(context).colorScheme.base,
          ),
        ],
      ),
      actions: [
        MsIconButton(
          onTap: () async {
            setState(() => loading = true);
            await wishlistController.add(widget.data['post_id']);
            setState(() => loading = false);
          },
          backgroundColor: Theme.of(context).colorScheme.base,
          child: (loading)
              ? Container(
                  width: 20.0.r,
                  height: 20.0.r,
                  padding: const EdgeInsets.all(10.0).r,
                  child: CircularProgressIndicator(strokeWidth: 2.0, backgroundColor: Theme.of(context).colorScheme.bg),
                )
              : Obx(
                  () => (wishlistController.wishlist.contains(widget.data['post_id'].toString()))
                      ? MsSvgIcon(icon: 'assets/icons/heart-fill.svg', size: 20.0, color: Color(0xFFf68b81))
                      : MsSvgIcon(icon: 'assets/icons/heart.svg', size: 20.0, color: Theme.of(context).colorScheme.text),
                ),
        ),
        SizedBox(width: 5.0.r),
        MsIconButton(
          icon: 'assets/icons/share.svg',
          onTap: () {
            SharePlus.instance.share(ShareParams(text: widget.data['url']));
          },
          backgroundColor: Theme.of(context).colorScheme.base,
        ),
        SizedBox(width: 20.0.r),
      ],
      flexibleSpace: ProductGallerySlider(data: widget.data),
    );
  }
}
