import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets_extra/pagination.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MsGallery extends StatefulWidget {
  final List imageUrls;
  final int initialIndex;
  final bool downloadButton;

  const MsGallery({super.key, required this.imageUrls, required this.initialIndex, this.downloadButton = true});

  @override
  State<MsGallery> createState() => _MsGalleryState();
}

class _MsGalleryState extends State<MsGallery> {
  late int _currentIndex;
  bool showDownloadedBar = false;
  bool showProgressBar = false;
  int progress = 0;
  String taskId = '';
  bool dismissed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          allowImplicitScrolling: true,
          loadingBuilder: (context, event) {
            return const MsIndicator();
          },
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          itemCount: widget.imageUrls.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.imageUrls[index], headers: App.headers),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          pageController: PageController(initialPage: _currentIndex),
        ),
        if (widget.imageUrls.length > 1) ...[
          Positioned(
            bottom: 15.0.r,
            left: 0,
            right: 0,
            child: Pagination(data: widget.imageUrls, activeIndex: _currentIndex),
          ),
        ],
      ],
    );
  }
}
