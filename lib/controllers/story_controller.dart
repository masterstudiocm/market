import 'package:get/get.dart';

class StoryController {
  RxBool animate = false.obs;
  RxDouble width = 0.0.obs;
  RxInt duration = 0.obs;
  RxDouble progress = 1.0.obs;

  void update() {
    width.value = 0.0;
    duration.value = 0;
    Future.delayed(const Duration(milliseconds: 100), () {
      width.value = Get.width;
      duration.value = 3900;
    });
  }

  void updateProgress(double value) {
    progress.value = 1.0 - value;
  }
}
