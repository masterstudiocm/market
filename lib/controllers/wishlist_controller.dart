import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:get/get.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/widgets_extra/snackbar.dart';

class WishlistController {
  RxList wishlist = [].obs;
  RxInt quantity = 0.obs;
  RxBool loading = false.obs;
  RxBool serverError = false.obs;
  RxBool connectError = false.obs;
  final loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.find<LoginController>();

  Future<void> get() async {
    loading.value = true;

    Map result = await httpRequest('${App.domain}/api/wishlist.php?action=list&session_key=${loginController.userId.value}');

    loading.value = false;
    serverError.value = result['serverError'];
    connectError.value = result['connectError'];

    final payload = result['payload'];
    if (payload['status'] == 'success') {
      update(payload['result']);
    }
  }

  void update(List? data) {
    if (data != null) {
      wishlist.value = data.map((e) => e.toString()).toList();
      count();
    }
  }

  void count() {
    quantity.value = wishlist.length;
  }

  Future<void> add(String productId) async {
    Map result = await httpRequest(
      '${App.domain}/api/wishlist.php?action=update&product_id=$productId&session_key=${loginController.userId.value}',
      snackbar: true,
    );
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      update(payload['result']['list']);
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
  }
}
