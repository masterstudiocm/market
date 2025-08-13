import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/classes/firebase_service.dart';
import 'package:market/classes/notification_service.dart';
import 'package:market/classes/translation.dart';
import 'package:market/components/app/bottom_nav_item.dart';
import 'package:market/components/app/exit_alert.dart';
import 'package:market/controllers/auth_controller.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/controllers/darkmode_controller.dart';
import 'package:market/controllers/language_controller.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/search_controller.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/controllers/welcome_controller.dart';
import 'package:market/controllers/wishlist_controller.dart';
import 'package:market/pages/navigation/cart.dart';
import 'package:market/pages/navigation/home.dart';
import 'package:market/pages/navigation/settings.dart';
import 'package:market/pages/navigation/terms.dart';
import 'package:market/pages/navigation/wishlist.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/routes.dart';
import 'package:market/themes/theme.dart';
import 'package:market/themes/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:market/widgets_extra/snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScreenUtil.ensureScreenSize();
  await FirebaseService.initializeFirebase();
  await NotificationService.initialize();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authController = Get.put(AuthController());
  final sitedataController = Get.put(SiteDataController());
  final loginController = Get.put(LoginController());
  final darkmodeController = Get.put(DarkModeController());
  final welcomeController = Get.put(WelcomeController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());
  final tabBarController = Get.put(TabBarController());
  final searchController = Get.put(SearchProductController());
  final langController = Get.put(LanguageController());

  late List pages;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        NotificationService.openNofication(message.data);
      }
    });

    sitedataController.get();
    loginController.get();
    darkmodeController.get();
    welcomeController.get();
    cartController.get();
    wishlistController.get();
    tabBarController.get();
    searchController.get();
    langController.get();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    pages = [const HomePage(), const TermsPage(), const WishlistPage(), const CartPage(), SettingsPage()];

    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.notification].request();
    statuses.forEach((permission, status) {});
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return ScreenUtilInit(
      designSize: (orientation == Orientation.portrait)
          ? isTablet(context)
                ? const Size(600, 690)
                : const Size(370, 690)
          : isTablet(context)
          ? Size(1000, 695)
          : const Size(830, 395),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        scaffoldMessengerKey: SnackbarGlobal.key,
        navigatorKey: TabBarController.navigatorKey,
        debugShowCheckedModeBanner: false,
        translations: TranslationService(),
        locale: Locale(langController.lang.value),
        fallbackLocale: Locale(langController.lang.value),
        theme: buildThemeData(Brightness.light),
        darkTheme: buildThemeData(Brightness.dark),
        themeMode: () {
          if (darkmodeController.mode.value == 'System') {
            return PlatformDispatcher.instance.platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
          } else if (darkmodeController.mode.value == 'Light') {
            return ThemeMode.light;
          } else {
            return ThemeMode.dark;
          }
        }(),
        title: 'MyModa',
        routes: Routes.routes,
        home: child,
      ),
      child: Obx(
        () => (welcomeController.welcome.value)
            ? const WelcomeScreen()
            : CupertinoTabScaffold(
                controller: tabBarController.controller,
                tabBar: CupertinoTabBar(
                  onTap: (index) {
                    SnackbarGlobal.remove();
                    tabBarController.update(index);
                    if (index == currentIndex) {
                      tabBarController.listOfKeys[index].currentState?.popUntil((r) => r.isFirst);
                    } else {
                      setState(() => currentIndex = index);
                    }
                  },
                  border: Border(
                    top: BorderSide(
                      width: 1.0,
                      color: (darkmodeController.mode.value == 'System')
                          ? (PlatformDispatcher.instance.platformBrightness == Brightness.dark)
                                ? MsColors.darkGrey1
                                : MsColors.lightGrey1
                          : (darkmodeController.mode.value == 'Light')
                          ? MsColors.lightGrey1
                          : MsColors.darkGrey1,
                    ),
                  ),
                  height: App.bottomNavBarHeight,
                  backgroundColor: (darkmodeController.mode.value == 'System')
                      ? (PlatformDispatcher.instance.platformBrightness == Brightness.dark)
                            ? MsColors.darkGrey1
                            : MsColors.lightBase
                      : (darkmodeController.mode.value == 'Light')
                      ? MsColors.lightBase
                      : MsColors.darkGrey1,
                  items: [
                    const BottomNavigationBarItem(
                      icon: MsBottomNavItem(icon: 'home.svg', label: 'Əsas', index: 0),
                    ),
                    BottomNavigationBarItem(
                      icon: MsBottomNavItem(icon: 'grid.svg', label: 'Kataloq', index: 1),
                    ),
                    BottomNavigationBarItem(
                      icon: MsBottomNavItem(icon: 'heart.svg', label: 'İstək listi', index: 2, badge: wishlistController.quantity.value),
                    ),
                    BottomNavigationBarItem(
                      icon: MsBottomNavItem(icon: 'cart.svg', label: 'Səbət', index: 3, badge: cartController.cart.length),
                    ),
                    const BottomNavigationBarItem(
                      icon: MsBottomNavItem(icon: 'user.svg', label: 'Hesab', index: 4),
                    ),
                  ],
                ),
                tabBuilder: (context, index) {
                  // ignore: deprecated_member_use
                  return WillPopScope(
                    onWillPop: () async {
                      SnackbarGlobal.remove();
                      final currentState = tabBarController.listOfKeys[tabBarController.controller.index].currentState;
                      if (currentState != null && currentState.canPop()) {
                        return !await tabBarController.listOfKeys[tabBarController.controller.index].currentState!.maybePop();
                      } else {
                        if (tabBarController.controller.index == 0) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AppExitAlert();
                            },
                          );
                        } else {
                          tabBarController.controller.index = 0;
                        }
                        return false;
                      }
                    },
                    child: CupertinoTabView(
                      routes: Routes.routes,
                      navigatorKey: tabBarController.listOfKeys[index],
                      builder: (context) {
                        return pages[index];
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
