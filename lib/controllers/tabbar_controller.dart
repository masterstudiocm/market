import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TabBarController {
  late List<GlobalKey<NavigatorState>> listOfKeys;
  late CupertinoTabController controller;
  static final navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  final RxInt currentIndex = 0.obs;

  void get() {
    controller = CupertinoTabController(initialIndex: 0);
    listOfKeys = [firstTabNavKey, secondTabNavKey, thirdTabNavKey, fourthTabNavKey, fifthTabNavKey];
  }

  void update(int value) {
    if (value < listOfKeys.length) {
      controller.index = value;
      currentIndex.value = value;
      listOfKeys[value].currentState?.popUntil((r) => r.isFirst);
    }
  }
}
