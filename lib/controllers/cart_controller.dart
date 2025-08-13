import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:get/get.dart';
import 'package:market/widgets_extra/snackbar.dart';

class CartController {
  RxMap data = {}.obs;
  RxList cart = [].obs;
  RxBool loading = false.obs;
  RxBool mainLoading = false.obs;
  RxBool serverError = false.obs;
  RxBool connectError = false.obs;

  Future<void> fetch(String url) async {
    mainLoading.value = true;
    loading.value = true;

    Map result = await httpRequest(url);

    mainLoading.value = false;
    loading.value = false;

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data.value = payload['result'];
      cart.value = payload['result']['cart'];
    }
  }

  Future<void> get() async {
    data.value = {};
    cart.value = [];
    loading.value = true;
    String url = '${App.domain}/api/cart.php?action=get';
    await fetch(url);
  }

  Future<void> add(String productId, String variationId, String quantity) async {
    Map result = await httpRequest(
      '${App.domain}/api/cart.php?action=update&process=increase&product_id=$productId&variation_id=$variationId&quantity=$quantity',
      snackbar: true,
    );

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      update(payload['result']);
      SnackbarGlobal.show('Məhsul uğurla səbətə əlavə edildi.', type: SnackBarTypes.success);
    } else {
      SnackbarGlobal.show(payload['error']);
    }
  }

  Future<void> decrease(String productId, String variationId, String date) async {
    mainLoading.value = true;
    String url = '${App.domain}/api/cart.php?action=update&process=decrease&product_id=$productId&variation_id=$variationId&date=$date';
    await fetch(url);
  }

  Future<void> increase(String productId, String variationId, String date) async {
    mainLoading.value = true;
    String url = '${App.domain}/api/cart.php?action=update&process=increase&product_id=$productId&variation_id=$variationId&date=$date';
    await fetch(url);
  }

  Future<void> remove(String productId, String variationId) async {
    mainLoading.value = true;
    String url = '${App.domain}/api/cart.php?action=remove&product_id=$productId&variation_id=$variationId';
    await fetch(url);
  }

  void update(Map value) {
    data.value = value;
    cart.value = data['cart'];
  }

  int increaseQuantity(dynamic quantity) {
    if (quantity != '') {
      quantity++;
    }
    return quantity;
  }

  int decreaseQuantity(dynamic quantity) {
    if (quantity != '' && quantity > 1) {
      quantity--;
    }
    return quantity;
  }

  Future<Map> addCoupon(String coupon) async {
    Map result = await httpRequest('${App.domain}/api/coupon.php?action=apply&coupon_code=$coupon', snackbar: true);
    return result['payload'];
  }

  Future<Map> removeCoupon() async {
    Map result = await httpRequest('${App.domain}/api/coupon.php?action=remove', snackbar: true);
    return result['payload'];
  }
}
