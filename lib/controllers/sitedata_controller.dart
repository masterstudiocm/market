import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:market/classes/start_dialog.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

class SiteDataController {
  RxMap<dynamic, dynamic> sitedata = {}.obs;
  RxBool update = false.obs;
  final box = GetStorage();

  void get() async {
    box.writeIfNull('sitedata', {});
    sitedata.value = box.read('sitedata');
    update.value = true;

    Map result = await httpRequest('${App.domain}/api/site.php?action=get', snackbar: true);
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      sitedata = RxMap<dynamic, dynamic>.of(payload['result']);
      AppBadgePlus.updateBadge(sitedata['notify_count'] ?? 0);
      update.value = false;
      showStartDialog();
    }
  }
}
