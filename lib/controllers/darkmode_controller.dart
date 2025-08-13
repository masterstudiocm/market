import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DarkModeController {
  RxString mode = 'System'.obs;
  RxMap<String, String> modes = {
    'System': 'Sistemə uyğun',
    'Light': 'Aydınlıq rejim',
    'Dark': 'Qaranlıq rejim',
  }.obs;

  final box = GetStorage();

  DarkModeController() {
    PlatformDispatcher.instance.onPlatformBrightnessChanged =
        _onBrightnessChanged;
  }

  void get() {
    box.writeIfNull('mode', 'System');
    mode.value = box.read('mode');
    _applyTheme();
  }

  void update(String data) {
    mode.value = data;
    box.write('mode', data);
    _applyTheme();
  }

  void _applyTheme() {
    if (mode.value == 'System') {
      Brightness brightness = PlatformDispatcher.instance.platformBrightness;
      Get.changeThemeMode(
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light);
    } else if (mode.value == 'Light') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (mode.value == 'Dark') {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  void _onBrightnessChanged() {
    if (mode.value == 'System') {
      _applyTheme();
    }
  }
}
