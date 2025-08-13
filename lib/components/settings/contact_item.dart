import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem extends StatelessWidget {
  final String title;
  final String value;
  final String? url;
  final String image;
  final Color? color;
  final bool border;

  const ContactItem({super.key, required this.title, required this.image, this.url, required this.value, this.color, this.border = true});

  @override
  Widget build(BuildContext context) {
    return (url != null && url != '')
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await launchUrl(Uri.parse(url!));
              },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: value));
                SnackbarGlobal.show('Məlumat panoya kopyalandı.', type: SnackBarTypes.info);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0).r,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: (border) ? 1.0 : 0.0, color: Theme.of(context).colorScheme.grey1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50.0.r,
                            height: 50.0.r,
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey1, borderRadius: BorderRadius.circular(50.0).r),
                            child: MsSvgIcon(
                              icon: image,
                              size: 20.0,
                              originalColor: true,
                              color: color != null ? Theme.of(context).colorScheme.primaryColor : null,
                            ),
                          ),
                          SizedBox(width: 15.0.r),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.grey5)),
                                SizedBox(height: 3.0.r),
                                Text(
                                  value,
                                  style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    MsSvgIcon(icon: 'assets/arrows/chevron-right.svg', color: Theme.of(context).colorScheme.grey3, size: 20.0),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
