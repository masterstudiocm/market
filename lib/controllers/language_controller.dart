import 'dart:ui';

import 'package:market/controllers/sitedata_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController {
  RxString lang = 'az'.obs;
  RxMap langs = {'az': 'Azərbaycan dili', 'en': 'English', 'ru': 'Русский'}.obs;

  final box = GetStorage();

  void get() {
    box.writeIfNull('lang', 'az');
    lang.value = box.read('lang');
  }

  void update(String data) {
    lang.value = data;
    box.write('lang', data);
    Get.updateLocale(Locale(data));
    final sitedataController = Get.isRegistered<SiteDataController>() ? Get.find<SiteDataController>() : Get.find<SiteDataController>();
    sitedataController.get();
  }
}
