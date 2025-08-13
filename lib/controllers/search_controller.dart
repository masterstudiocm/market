import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchProductController {
  RxList history = [].obs;
  RxString keyword = ''.obs;
  GlobalKey loadProductsKey = GlobalKey();
  List popularKeywords = ['shop', 'Kadayıf', 'Şəkərbura', 'Şöbiye'];
  final TextEditingController textController = TextEditingController();
  final box = GetStorage();

  void get() {
    box.writeIfNull('history', []);
    history.assignAll(box.read('history'));
  }

  void add(String value) {
    keyword.value = value;
    textController.text = value;
    if (value != '') {
      history.remove(value);
      history.insert(0, value);
      box.write('history', history);
      loadProductsKey = GlobalKey();
    }
  }

  void remove(String value) {
    history.remove(value);
    box.write('history', history);
  }

  void empty() {
    history.value = [];
    box.write('history', []);
  }

  void dispose() {
    textController.dispose();
  }
}
