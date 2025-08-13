import 'package:market/controllers/alert_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:market/themes/functions.dart';

void showStartDialog() async {
  int version = 0;
  int currentVersion = 0;

  final sitedataController = Get.find<SiteDataController>();

  if (sitedataController.sitedata.isNotEmpty) {
    if (sitedataController.sitedata['app_version_checker_status'] == '1' && sitedataController.sitedata['app_version'] != '') {
      version = getExtendedVersionNumber(sitedataController.sitedata['app_version']);

      final info = await PackageInfo.fromPlatform();
      currentVersion = getExtendedVersionNumber(info.version);

      if (version > currentVersion) {
        Get.dialog(
          barrierDismissible: (sitedataController.sitedata['force_update'] == '1') ? false : true,
          // ignore: deprecated_member_use
          WillPopScope(
            onWillPop: () async => sitedataController.sitedata['force_update'] == '1' ? false : true,
            child: MsDialog(
              title: 'Tətbiqin yeni versiyası mövcuddur.'.tr,
              content: sitedataController.sitedata['app_version_info'],
              actions: [
                if (sitedataController.sitedata['force_update'] != '1') ...[
                  Expanded(
                    child: MsOutlineButton(
                      onTap: () {
                        Get.back();
                      },
                      height: 45.0.r,
                      title: 'İmtina et'.tr,
                    ),
                  ),
                  SizedBox(width: 10.0.r),
                ],
                Expanded(
                  child: MsButton(
                    onTap: () {
                      launchUrl(Uri.parse('${App.domain}/download-app/'));
                    },
                    height: 45.0.r,
                    title: 'Yenilə'.tr,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (sitedataController.sitedata['app_alert_status'] == '1') {
      final info = await PackageInfo.fromPlatform();
      currentVersion = getExtendedVersionNumber(info.version);

      final alertController = Get.find<AlertController>();
      alertController.get();

      if (!alertController.alerts.contains(sitedataController.sitedata['app_alert_code'])) {
        Get.dialog(
          barrierDismissible: false,
          MsDialog(
            title: sitedataController.sitedata['app_alert_title'],
            content: sitedataController.sitedata['app_alert_desc'],
            actions: [
              Expanded(
                child: MsOutlineButton(
                  onTap: () {
                    alertController.add(sitedataController.sitedata['app_alert_code']);
                    Get.back();
                  },
                  height: 45.0.r,
                  title: 'Bağla'.tr,
                ),
              ),
              if (sitedataController.sitedata['app_alert_link'] != '') ...[
                SizedBox(width: 10.0.r),
                Expanded(
                  child: MsButton(
                    onTap: () {
                      alertController.add(sitedataController.sitedata['app_alert_code']);
                      launchUrl(Uri.parse(sitedataController.sitedata['app_alert_link']));
                    },
                    height: 45.0.r,
                    title: 'Yenilə'.tr,
                  ),
                ),
              ],
            ],
          ),
        );
      }
    }
  }
}
