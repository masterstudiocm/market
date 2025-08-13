import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/components/settings/profile_image.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/pages/ecommerce/notifications.dart';
import 'package:market/pages/login/login.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/icon_button.dart';
import 'package:market/widgets_extra/navigator.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final loginController = Get.find<LoginController>();
  final tabBarController = Get.find<TabBarController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
      toolbarHeight: 65.r,
      scrolledUnderElevation: 0.0,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5).r,
          alignment: Alignment.bottomCenter,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (loginController.userdata.isNotEmpty) ...[
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        tabBarController.update(4);
                      },
                      child: Row(
                        spacing: 15.r,
                        children: [
                          ProfilePicture(data: loginController.userdata, size: 45.0, fontSize: 14.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${loginController.userdata['first_name']} ${loginController.userdata['last_name']}',
                                style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                              Text(
                                loginController.userdata['user_email'],
                                style: TextStyle(fontSize: 12.0.sp, overflow: TextOverflow.ellipsis, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45.0),
                        child: Image.asset('assets/images/ic_launcher.png', width: 45.0.r, height: 45.0.r, fit: BoxFit.cover),
                      ),
                      SizedBox(width: 10.0.r),
                      MsButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        height: 38.0,
                        backgroundColor: Colors.transparent,
                        onTap: () {
                          navigatePage(context, LoginPage(), root: true);
                        },
                        child: Text(
                          'Daxil ol / Qeydiyyat',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
                MsIconButton(
                  onTap: () {
                    navigatePage(context, NotificationsPage());
                  },
                  icon: 'assets/icons/bell.svg',
                  iconColor: Colors.white,
                  borderColor: Colors.transparent,
                  backgroundColor: Color(0xFF2c2b3c),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
