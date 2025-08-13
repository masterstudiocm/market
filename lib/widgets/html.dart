import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:market/widgets/gallery.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets_extra/lightbox.dart';
import 'package:url_launcher/url_launcher.dart';

class MsHtml extends StatefulWidget {
  final String data;
  final Color? color;
  final bool selectable;
  final double fontSize;

  const MsHtml({super.key, required this.data, this.color, this.selectable = false, this.fontSize = 14.0});

  @override
  State<MsHtml> createState() => _MsHtmlState();
}

class _MsHtmlState extends State<MsHtml> {
  @override
  Widget build(BuildContext context) {
    final imageUrlRegExp = RegExp(r'<img[^>]+src="([^">]+)"', caseSensitive: false);
    final imageUrls = imageUrlRegExp.allMatches(widget.data).map((match) => match.group(1) ?? '').toList();

    var htmlWidget = HtmlWidget(
      widget.data,
      textStyle: TextStyle(
        color: (widget.color != null) ? widget.color : Theme.of(context).colorScheme.text,
        fontSize: widget.fontSize.sp,
        height: 1.5,
        fontFamily: App.fontFamily,
      ),
      factoryBuilder: () => MyWidgetFactory(),
      onTapImage: (ImageMetadata image) {
        final index = imageUrls.indexOf(image.sources.first.url);

        showDialog(
          barrierColor: Colors.black.withValues(alpha: .9),
          context: context,
          builder: (context) {
            return MsLightbox(
              child: MsGallery(imageUrls: imageUrls, initialIndex: index),
            );
          },
        );
      },
      onTapUrl: (url) {
        return launchUrl(Uri.parse(url));
      },
      onLoadingBuilder: (context, element, loadingProgress) {
        return const MsIndicator();
      },
      customStylesBuilder: (element) {
        if (element.localName == 'img') {
          return {'width': '100%'};
        } else if (element.localName == 'strong' || element.localName == 'h1' || element.localName == 'h2' || element.localName == 'h3') {
          return {'font-family': App.fontFamily, 'font-weight': '600', 'font-style': 'normal'};
        }
        return null;
      },
    );

    return (widget.selectable) ? SelectionArea(child: htmlWidget) : htmlWidget;
  }
}

class MyWidgetFactory extends WidgetFactory {
  @override
  void parseStyle(BuildTree tree, style) {
    if (style.property == 'font-family') {
      // ignore
      return;
    }

    return super.parseStyle(tree, style);
  }
}
