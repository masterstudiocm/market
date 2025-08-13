import 'package:app_settings/app_settings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/settings/logout_alert.dart';
import 'package:market/components/settings/setting_section.dart';
import 'package:market/components/settings/settings_login_header.dart';
import 'package:market/pages/general/contact.dart';
import 'package:market/pages/general/cv.dart';
import 'package:market/pages/general/posts.dart';
import 'package:market/pages/ecommerce/orders.dart';
import 'package:market/pages/general/stores.dart';
import 'package:market/pages/general/submit_request.dart';
import 'package:market/pages/general/videos.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/pages/login/login.dart';
import 'package:market/pages/login/registration.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/navigator.dart';
import 'package:market/components/settings/bottomSheets/darkmode.dart';
import 'package:market/components/settings/setting_item.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/pages/general/about.dart';
import 'package:market/pages/login/change_password.dart';
import 'package:market/pages/general/faq.dart';
import 'package:market/pages/login/userinfo.dart';
import 'package:market/pages/general/message.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: Text('Parametrlər')),
      body: ListView(
        children: [
          Column(
            children: [
              const SettingsLoginHeader(),
              Padding(
                padding: const EdgeInsets.all(20.0).r,
                child: Column(
                  children: [
                    Obx(
                      () => (loginController.userdata.isNotEmpty)
                          ? SettingSection(
                              title: 'Hesabınız',
                              child: Column(
                                children: [
                                  SettingItem(
                                    title: 'Sifarişləriniz',
                                    image: 'assets/icons/orders.svg',
                                    onTap: () => Get.to(() => const OrdersPage()),
                                  ),
                                  SettingItem(
                                    title: 'Şəxsi məlumatlarınız',
                                    image: 'assets/icons/user-edit.svg',
                                    onTap: () => navigatePage(context, const UserInfoPage()),
                                  ),
                                  SettingItem(
                                    title: 'Şifrə dəyişdirmək',
                                    image: 'assets/icons/password.svg',
                                    onTap: () => navigatePage(context, const ChangePasswordPage()),
                                    border: false,
                                  ),
                                ],
                              ),
                            )
                          : SettingSection(
                              title: 'Hesab yaradın və ya daxil olun',
                              child: Column(
                                children: [
                                  SettingItem(
                                    title: 'Daxil ol',
                                    image: 'assets/icons/login.svg',
                                    onTap: () => navigatePage(context, const LoginPage(), root: true),
                                  ),
                                  SettingItem(
                                    title: 'Qeydiyyatdan keç',
                                    image: 'assets/icons/user-add.svg',
                                    onTap: () => navigatePage(context, const RegistrationPage(), root: true),
                                    border: false,
                                  ),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(height: 20.0.r),
                    SettingSection(
                      title: 'Bizim haqqımızda',
                      child: Column(
                        children: [
                          SettingItem(
                            title: 'Xəbər və yeniliklər',
                            image: 'assets/icons/newspaper.svg',
                            onTap: () => navigatePage(context, const PostsPage(), root: true),
                          ),
                          SettingItem(
                            title: 'Haqqımızda',
                            image: 'assets/icons/info.svg',
                            onTap: () => navigatePage(context, const AboutPage(), root: true),
                          ),
                          SettingItem(
                            title: 'Ən çox soruşulan suallar',
                            image: 'assets/icons/faq.svg',
                            onTap: () => navigatePage(context, const FaqPage(), root: true),
                          ),
                          SettingItem(
                            title: 'Videolar',
                            image: 'assets/icons/video.svg',
                            onTap: () => navigatePage(context, const VideosPage(), root: true),
                          ),
                          SettingItem(
                            title: 'Mağazalarımız',
                            image: 'assets/icons/location.svg',
                            onTap: () => navigatePage(context, const StoresPage(), root: true),
                          ),
                          SettingItem(
                            title: 'İstək göndərin',
                            image: 'assets/icons/request.svg',
                            onTap: () => navigatePage(context, const SubmitRequestPage(), root: true),
                            border: false,
                          ),
                          SettingItem(
                            title: 'CV göndərin',
                            image: 'assets/icons/cv.svg',
                            onTap: () => navigatePage(context, const SendCvPage(), root: true),
                            border: false,
                          ),
                          SettingItem(
                            title: 'Bizə yazın',
                            image: 'assets/icons/message.svg',
                            onTap: () => navigatePage(context, const MessagePage(), root: true),
                          ),
                          SettingItem(
                            title: 'Bizimlə əlaqə',
                            image: 'assets/icons/contact.svg',
                            onTap: () => navigatePage(context, const ContactPage(), root: true),
                            border: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SettingSection(
                      title: 'Tətbiq parametrləri',
                      child: Column(
                        children: [
                          SettingItem(
                            title: 'Qaranlıq rejim',
                            image: 'assets/icons/darkmode.svg',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                builder: (context) {
                                  return const DarkModeBottomSheet();
                                },
                              );
                            },
                          ),
                          SettingItem(
                            title: 'Bildirişlər',
                            image: 'assets/icons/bell.svg',
                            onTap: () {
                              AppSettings.openAppSettings(type: AppSettingsType.notification);
                            },
                          ),
                          SettingItem(
                            title: 'Dostunu dəvət et',
                            image: 'assets/icons/share.svg',
                            onTap: () {
                              SharePlus.instance.share(ShareParams(text: '${App.domain}/partials/download-app.php'));
                            },
                            border: false,
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => (loginController.userdata.isNotEmpty)
                          ? Column(
                              children: [
                                SizedBox(height: 20.0.r),
                                MsOutlineButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LogoutAlert();
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const MsSvgIcon(icon: 'assets/icons/logout.svg', size: 17.0, color: Colors.red),
                                      SizedBox(width: 10.0.r),
                                      Text(
                                        'Çıxış et',
                                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
