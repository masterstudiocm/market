import 'package:get_storage/get_storage.dart';

class AlertController {
  final box = GetStorage();
  List<String> alerts = [];

  void get() {
    box.writeIfNull('alerts', []);
    alerts = box.read('alerts');
  }

  void add(String value) {
    if (!alerts.contains(value)) {
      alerts.add(value);
      box.write('alerts', alerts);
    }
  }
}
