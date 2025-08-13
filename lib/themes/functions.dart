import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide FormData;
import 'package:intl/intl.dart';
import 'package:market/classes/connection.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/tabbar_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  if (versionCells.isNotEmpty) {
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
  return 0;
}

String removeHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

Color hexToColor(String hexColor, {substr = false}) {
  if (hexColor.isNotEmpty && hexColor.length > 6) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  } else {
    return Color(0xFFFFFFFF);
  }
}

Future<void> redirectUrl(String? url) async {
  if (url != null && url != '') {
    final tabBarController = Get.find<TabBarController>();
    tabBarController.get();
    url = url.replaceAll(RegExp(r'/$'), '');
    var parse = Uri.parse(url);
    String domain = parse.origin;
    List<String> pathSegments = parse.pathSegments;
    if (!(domain == App.domain || domain == '${App.domain}/')) {
      launchUrl(parse);
    } else if (pathSegments.isEmpty) {
      tabBarController.update(0);
    } else if (pathSegments.isNotEmpty) {
      if (RegExp(r'^[a-zA-Z]{2}$').hasMatch(pathSegments[0])) {
        pathSegments.removeAt(0);
        pathSegments = pathSegments.asMap().values.toList();
      }
      if (pathSegments[0] == 'mehsul-kateqoriyasi' && pathSegments.length > 1) {
        var category = pathSegments[1];
        tabBarController.listOfKeys[tabBarController.controller.index].currentState!.pushNamed('/mehsul-kateqoriyasi/', arguments: [category]);
      } else if (pathSegments[0] == 'brand' && pathSegments.length > 1) {
        var category = pathSegments[1];
        tabBarController.listOfKeys[tabBarController.controller.index].currentState!.pushNamed('/brand/', arguments: [category]);
      } else if (pathSegments[0] == 'product' && pathSegments.length > 1) {
        var product = pathSegments[1];
        tabBarController.listOfKeys[tabBarController.controller.index].currentState!.pushNamed('/product/', arguments: [product]);
      } else if (pathSegments[0] == 'product') {
        tabBarController.listOfKeys[tabBarController.controller.index].currentState!.pushNamed('/products/');
      } else {
        var slug = pathSegments[0];
        if (await checkConnectivity()) {
          String query = insertQuery('${App.domain}/api/posts.php?action=get&slug=$slug');
          final response = await Dio().get(query, options: Options(headers: App.headers));

          if (response.statusCode == 200) {
            var result = response.data;
            if (result['status'] == 'success') {
              if (result['result']['post_type'] == 'post') {
                tabBarController.listOfKeys[tabBarController.controller.index].currentState!.pushNamed('/post/', arguments: [slug]);
              } else {
                launchUrl(Uri.parse(url));
              }
            } else {
              launchUrl(Uri.parse(url));
            }
          } else {
            launchUrl(Uri.parse(url));
          }
        }
      }
    }
  }
}

Future getDataFromSlug(String slug, {type = 'post'}) async {
  Map result = await httpRequest('${App.domain}/api/slug.php?action=get&slug=$slug&type=$type', snackbar: true);
  final payload = result['payload'];
  if (payload['status'] == 'success') {
    return result['result'];
  }
}

Color darkenColor(Color color, double amount) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

String insertQuery(String query) {
  final loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.find<LoginController>();
  return '$query&session_key=${loginController.userId.value}&key=${dotenv.env['API_KEY']}';
}

String formatedDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
    1.0,
  );
}

List<String> splitText(String text, {String separator = ' '}) {
  List<String> parts = text.split(separator);
  int count = parts.length;
  if (count < 2) {
    return [text, ''];
  } else {
    int firstPartCount = (count / 2).truncate();
    String firstPart = parts.sublist(0, firstPartCount).join(' ');
    String secondPart = parts.sublist(firstPartCount, count).join(separator).trim();
    return [firstPart, secondPart];
  }
}

String getDate(String date, {String format = 'dd.MM.yyyy'}) {
  DateTime dateTime = DateTime.parse(date);
  DateFormat formatter = DateFormat(format);

  return formatter.format(dateTime);
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return "$twoDigitMinutes:$twoDigitSeconds";
}

extension SafeSetState<T extends StatefulWidget> on State<T> {
  void setStateSafe(VoidCallback fn) {
    if (!mounted) return;
    // ignore: invalid_use_of_protected_member
    setState(fn);
  }
}

Future<Map<String, dynamic>> httpRequest(
  String url, {
  dynamic fields,
  bool snackbar = false,
  ProgressCallback? onProgress,
  bool insert = true,
}) async {
  bool serverError = false;
  bool connectError = false;
  bool catchError = false;
  Map<String, dynamic> data = {};

  if (await checkConnectivity()) {
    try {
      final response = await Dio().post(
        url = (insert) ? insertQuery(url) : url,
        data: (fields is Map) ? FormData.fromMap(Map<String, dynamic>.from(fields)) : fields,
        options: Options(headers: App.headers),
        onSendProgress: onProgress,
      );

      if ((response.statusCode ?? 0) ~/ 100 == 2) {
        if (response.data is Map) {
          data = response.data;
        } else {
          serverError = true;
        }
      } else {
        serverError = true;
      }
    } catch (e) {
      catchError = true;
      serverError = true;
      SnackbarGlobal.show(e.toString());
    }
  } else {
    connectError = true;
  }

  if (snackbar && !catchError) {
    if (connectError) {
      SnackbarGlobal.show(App().connectError);
    } else if (serverError) {
      SnackbarGlobal.show(App().serverError);
    }
  }

  return {'serverError': serverError, 'connectError': connectError, 'payload': data};
}

String generateRandomToken({int length = 20}) {
  final random = Random.secure();
  final values = List<int>.generate(length, (i) => random.nextInt(256));
  return base64UrlEncode(values);
}

bool isTablet(BuildContext context) {
  final shortestSide = MediaQuery.of(context).size.shortestSide;
  return shortestSide >= 600;
}
