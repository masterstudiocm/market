import 'package:get/get.dart';

class VariationController {
  RxMap selecteds = {}.obs;
  RxMap stockControl = {}.obs;
  RxString selectedVariationId = '0'.obs;

  void updateVariationId(String value) {
    selectedVariationId.value = value;
  }

  void updateSelecteds(Map value) {
    selecteds.value = value;
  }

  void updateStockControl(Map value) {
    stockControl.value = value;
  }

  void reset() {
    updateVariationId('0');
    updateSelecteds({});
    updateStockControl({});
  }
}
