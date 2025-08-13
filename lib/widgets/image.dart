import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/svg_icon.dart';

// ignore: must_be_immutable
class MsImage extends StatelessWidget {
  dynamic url;
  final double width;
  final double? height;
  final Color color;
  final BoxFit fit;
  final double pSize;
  final Color? pColor;
  final Color? pBackgroundColor;
  final bool enablePlaceholder;

  MsImage({
    super.key,
    required this.url,
    this.width = double.infinity,
    this.height,
    this.color = Colors.black,
    this.fit = BoxFit.cover,
    this.pSize = 50.0,
    this.pColor,
    this.pBackgroundColor,
    this.enablePlaceholder = true,
  });

  @override
  Widget build(BuildContext context) {
    String extension = '';
    if (url is String && url != '' && url != null && url != 'null') {
      extension = url.substring(url.length - 3);
    } else {
      url = '';
    }
    return (url != '')
        ? (extension == 'svg')
              ? SvgPicture.network(
                  url,
                  width: width.r,
                  height: height!.r,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  fit: BoxFit.contain,
                  headers: App.headers,
                )
              : CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeOutDuration: const Duration(milliseconds: 200),
                  imageUrl: url,
                  placeholder: (context, url) => (enablePlaceholder)
                      ? Container(
                          width: width.r,
                          height: height?.r,
                          color: pBackgroundColor ?? Theme.of(context).colorScheme.grey1,
                          child: MsSvgIcon(icon: App.placeholderImage, size: pSize, color: pColor ?? Theme.of(context).colorScheme.grey3),
                        )
                      : const SizedBox(),
                  errorWidget: (context, url, error) => (enablePlaceholder)
                      ? Container(
                          width: width.r,
                          height: height?.r,
                          color: Theme.of(context).colorScheme.grey1,
                          child: MsSvgIcon(icon: App.placeholderImage, size: width / pSize, color: Theme.of(context).colorScheme.grey3),
                        )
                      : const SizedBox(),
                  width: width.r,
                  height: height?.r,
                  fit: fit,
                  httpHeaders: App.headers,
                )
        : (enablePlaceholder)
        ? Container(
            width: width.r,
            height: height?.r,
            color: pBackgroundColor ?? Theme.of(context).colorScheme.grey1,
            child: MsSvgIcon(icon: App.placeholderImage, size: pSize, color: pColor ?? Theme.of(context).colorScheme.grey3),
          )
        : const SizedBox();
  }
}
