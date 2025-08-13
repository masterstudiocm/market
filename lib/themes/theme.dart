import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/custom_track.dart';
import 'package:market/themes/functions.dart';

class App {
  static String domain = 'https://fashion.betasayt.com';
  String serverError = 'Serverlə əlaqə yaratmaq mümkün olmadı';
  String connectError = 'İnternet bağlantısı ilə bağlı problem var';
  static String placeholderImage = 'assets/icons/placeholder.svg';
  static double toolbarHeight = 65.0.r;
  static String fontFamily = 'Inter';
  static double leadingWidth = 70.0.r;
  static double bottomNavBarHeight = 65.0.r;
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${generateRandomToken()}',
    'User-Agent': 'Mozilla/5.0 (compatible; MyFlutterApp/1.0)',
    'Cache-Control': 'no-cache',
    'Accept-Encoding': 'gzip, deflate',
    'Connection': 'keep-alive',
    'Referer': domain,
  };
}

class MsColors {
  static const Color lightPrimary = Color(0xFFDA8300);
  static const Color lightSecondary = Color(0xFF1e1d2f);
  static const Color lightOpacity = Color(0xFFebf3e6);
  static const Color lightGrey1 = Color(0xFFF5F5F5);
  static const Color lightGrey2 = Color(0xFFEEEEEE);
  static const Color lightGrey3 = Color(0xFFBDBDBD);
  static const Color lightGrey4 = Color(0xFF9E9E9E);
  static const Color lightGrey5 = Color(0xFF757575);
  static const Color lightGrey6 = Color(0xFF616161);
  static const Color lightText = Color(0xFF292A2E);
  static const Color lightOppoText = Color(0xFFFFFFFF);
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightBase = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightErrorText = Color(0xFFCA2C21);
  static const Color lightError = Color(0xFFDE4A4A);
  static const Color lightSuccess = Color(0xFF4CAF50);
  static const Color lightInfo = Color(0xFF2196F3);
  static const Color lightShimmerBase = Color(0xFFE0E0E0);
  static const Color lightShimmerHighlight = Color(0xFFF5F5F5);

  static const Color darkPrimary = Color(0xFFDA8300);
  static const Color darkSecondary = Color(0xFF1e1d2f);
  static const Color darkOpacity = Color(0xFF303030);
  static const Color darkGrey1 = Color(0xFF121212);
  static const Color darkGrey2 = Color(0xFF1E1E1E);
  static const Color darkGrey3 = Color(0xFF454545);
  static const Color darkGrey4 = Color(0xFF383838);
  static const Color darkGrey5 = Color(0xFF4A4A4A);
  static const Color darkGrey6 = Color(0xFF5C5C5C);
  static const Color darkText = Color(0xFFB7B7B7);
  static const Color darkOppoText = Color(0xFF000000);
  static const Color darkBg = Color(0xFF121212);
  static const Color darkBase = Color(0xFF000000);
  static const Color darkBorder = Color(0xFF424242);
  static const Color darkErrorText = Color(0xFFCA2C21);
  static const Color darkError = Color(0xFFCA2C21);
  static const Color darkSuccess = Color(0xFF4CAF50);
  static const Color darkInfo = Color(0xFF2196F3);
  static const Color darkShimmerBase = Color(0xFF2A2A2A);
  static const Color darkShimmerHighlight = Color(0xFF3C3C3C);

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(39, 121, 85, 72), Color.fromARGB(255, 67, 43, 35)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xFF0e0e13)],
  );
}

extension ColorSchemeExtension on ColorScheme {
  Color get primaryColor => brightness == Brightness.light ? MsColors.lightPrimary : MsColors.darkPrimary;
  Color get secondaryColor => brightness == Brightness.light ? MsColors.lightSecondary : MsColors.darkSecondary;
  Color get opacityColor => brightness == Brightness.light ? MsColors.lightOpacity : MsColors.darkOpacity;
  Color get grey1 => brightness == Brightness.light ? MsColors.lightGrey1 : MsColors.darkGrey1;
  Color get grey2 => brightness == Brightness.light ? MsColors.lightGrey2 : MsColors.darkGrey2;
  Color get grey3 => brightness == Brightness.light ? MsColors.lightGrey3 : MsColors.darkGrey3;
  Color get grey4 => brightness == Brightness.light ? MsColors.lightGrey4 : MsColors.darkGrey4;
  Color get grey5 => brightness == Brightness.light ? MsColors.lightGrey5 : MsColors.darkGrey5;
  Color get grey6 => brightness == Brightness.light ? MsColors.lightGrey6 : MsColors.darkGrey6;
  Color get bg => brightness == Brightness.light ? MsColors.lightBg : MsColors.darkBg;
  Color get base => brightness == Brightness.light ? MsColors.lightBase : MsColors.darkBase;
  Color get text => brightness == Brightness.light ? MsColors.lightText : MsColors.darkText;
  Color get oppotext => brightness == Brightness.light ? MsColors.lightOppoText : MsColors.darkOppoText;
  Color get colorText => brightness == Brightness.light ? MsColors.lightPrimary : MsColors.darkText;
  Color get oppositeText => brightness == Brightness.light ? MsColors.lightBg : MsColors.darkBg;
  Color get border => brightness == Brightness.light ? MsColors.lightBorder : MsColors.darkBorder;
  Color get errorText => brightness == Brightness.light ? MsColors.lightErrorText : MsColors.darkErrorText;
  Color get errorNotify => brightness == Brightness.light ? MsColors.lightError : MsColors.darkError;
  Color get successNotify => brightness == Brightness.light ? MsColors.lightSuccess : MsColors.darkSuccess;
  Color get infoNotify => brightness == Brightness.light ? MsColors.lightInfo : MsColors.darkInfo;
  Color get shimmerBase => brightness == Brightness.light ? MsColors.lightShimmerBase : MsColors.darkShimmerBase;
  Color get shimmerHighlight => brightness == Brightness.light ? MsColors.lightShimmerHighlight : MsColors.darkShimmerHighlight;
  LinearGradient get gradient => brightness == Brightness.light ? MsColors.lightGradient : MsColors.darkGradient;
}

ThemeData buildThemeData(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: brightness == Brightness.light ? MsColors.lightPrimary : MsColors.darkPrimary,
    brightness: brightness,
  );

  return ThemeData(
    fontFamily: App.fontFamily,
    colorScheme: colorScheme,
    primaryColor: colorScheme.primaryColor,
    scaffoldBackgroundColor: colorScheme.base,
    splashColor: colorScheme.primaryColor.withValues(alpha: .3),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primaryColor, circularTrackColor: Colors.transparent),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryColor,
      elevation: 0.0,
      sizeConstraints: BoxConstraints(minWidth: 55.0.r, minHeight: 55.0.r),
      extendedPadding: const EdgeInsets.all(20.0).r,
    ),
    appBarTheme: AppBarTheme(
      color: colorScheme.base,
      toolbarHeight: App.toolbarHeight,
      shadowColor: colorScheme.base,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontFamily: App.fontFamily, fontSize: 20.0.sp, fontWeight: FontWeight.w500, color: colorScheme.text),
      iconTheme: IconThemeData(color: colorScheme.base),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: colorScheme.base),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 20.0.sp),
      filled: false,
      fillColor: colorScheme.grey2,
      constraints: BoxConstraints(minWidth: 40.0.r),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0.r),
        borderSide: BorderSide(color: colorScheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0.r),
        borderSide: BorderSide(color: colorScheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0.r),
        borderSide: BorderSide(color: colorScheme.primaryColor),
      ),
      labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0.sp),
      hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0.sp, color: colorScheme.grey5),
      errorStyle: TextStyle(fontSize: 12.0.sp, color: colorScheme.errorText),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500, height: 1.3, color: colorScheme.base),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0).r)),
      behavior: SnackBarBehavior.floating,
      elevation: 0.0,
      actionTextColor: colorScheme.base,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.bg,
      surfaceTintColor: colorScheme.base,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    ),
    listTileTheme: const ListTileThemeData(horizontalTitleGap: 0.0),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primaryColor; // Selected state
        }
        return Colors.transparent; // Default state
      }),
      visualDensity: VisualDensity.comfortable,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      side: BorderSide(color: colorScheme.grey4, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primaryColor; // Selected state
        }
        return colorScheme.grey4; // Default state
      }),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colorScheme.base,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      textStyle: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primaryColor),
    ),
    dialogTheme: DialogThemeData(
      surfaceTintColor: colorScheme.base,
      backgroundColor: colorScheme.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0).r),
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primaryColor),
    ),
    tabBarTheme: TabBarThemeData(
      indicator: BoxDecoration(color: colorScheme.primaryColor, borderRadius: BorderRadius.circular(10.0.r)),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerHeight: 0.0,
      dividerColor: Colors.transparent,
      unselectedLabelColor: colorScheme.text,
      labelStyle: TextStyle(color: colorScheme.base, fontWeight: FontWeight.w600),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primaryColor,
      inactiveTrackColor: colorScheme.grey2,
      thumbColor: colorScheme.primaryColor,
      trackHeight: 2.0.r,
      trackShape: CustomTrackShape(),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0.r, elevation: 0.0),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0.r),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.primaryColor,
      selectionHandleColor: colorScheme.primaryColor,
      selectionColor: colorScheme.primaryColor.withValues(alpha: .3),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 28.0.sp, fontWeight: FontWeight.w500, height: 1.2, color: colorScheme.text),
      displayMedium: TextStyle(fontSize: 26.0.sp, fontWeight: FontWeight.w500, height: 1.2, color: colorScheme.text),
      displaySmall: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.w500, height: 1.2, color: colorScheme.text),
      headlineMedium: TextStyle(fontSize: 22.0.sp, fontWeight: FontWeight.w500, height: 1.2, color: colorScheme.text),
      headlineSmall: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w500, height: 1.2, color: colorScheme.text),
      titleLarge: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w600, height: 1.2, color: colorScheme.text),
      titleMedium: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w600, height: 1.2, color: colorScheme.text),
      titleSmall: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, height: 1.2, color: colorScheme.text),
      bodyLarge: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w400, height: 1.2, color: colorScheme.text),
      bodyMedium: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w400, height: 1.2, color: colorScheme.text),
      bodySmall: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400, height: 1.2, color: colorScheme.text),
    ),
  );
}

extension CustomStyles on TextTheme {
  TextStyle get link {
    return TextStyle(color: const Color(0xFF1B5EC9), fontWeight: FontWeight.w600);
  }

  // TextStyle get titleSmall {
  //   final isDarkMode = ThemeData.estimateBrightnessForColor(MsColors.primary) == Brightness.dark;
  //   final textColor = isDarkMode ? MsColors.secondary : MsColors.lightGrey2;

  //   return TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13.0, height: 1.2);
  // }

  // TextStyle get headlineSmall {
  //   final isDarkMode = ThemeData.estimateBrightnessForColor(MsColors.primary) == Brightness.dark;
  //   final textColor = isDarkMode ? MsColors.secondary : MsColors.secondary;

  //   return TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13.0, height: 1.2);
  // }
}
