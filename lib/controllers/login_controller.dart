import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets_extra/snackbar.dart';

class LoginController {
  RxBool socialLoading = false.obs;
  RxString userId = '0'.obs;
  RxString guestId = '0'.obs;
  RxMap userdata = {}.obs;
  RxString token = ''.obs;
  final box = GetStorage();

  void get() async {
    box.writeIfNull('userId', '0');
    box.writeIfNull('guestId', '0');
    box.writeIfNull('platform', '');
    box.writeIfNull('userdata', {});
    userId.value = box.read('userId');
    guestId.value = box.read('guestId');
    userdata.value = box.read('userdata');
    String? tokenValue = await FirebaseMessaging.instance.getToken();
    if (tokenValue != null && tokenValue.isNotEmpty) {
      setToken(tokenValue);
    }
    if (userdata.isNotEmpty) {
      getUserData();
    } else {
      if (guestId.value != '0') {
        userId.value = guestId.value;
      } else {
        createGuestToken();
      }
    }
  }

  void update(Map udata, [String platform = '']) {
    userdata.value = udata;
    box.write('userdata', userdata);
    box.write('platform', platform);
    if (userdata.isNotEmpty && userdata['user_status'].toString() == '1') {
      userId.value = udata['user_id'].toString();
      box.write('userId', userId.value);
      updateUserToken();
    }
  }

  Future<void> getUserData() async {
    Map result = await httpRequest('${App.domain}/api/users.php?action=get', snackbar: true);

    final payload = result['payload'];

    if (payload['status'] == 'success' && payload['result']['user_status'].toString() == '1') {
      userdata.value = payload['result'];
      box.write('userdata', userdata);
      updateUserToken();
    } else if (payload['status'] != null) {
      logout();
      createGuestToken();
    }
  }

  Future<void> createGuestToken() async {
    Map result = await httpRequest('${App.domain}/api/auth.php?action=create', snackbar: true);

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      userId.value = payload['result'];
      guestId.value = payload['result'];
      userdata.value = {};
      box.write('userId', userId.value);
      box.write('guestId', guestId.value);
      box.write('userdata', userdata);
    }
  }

  void logout() async {
    deleteToken();
    userId.value = guestId.value;
    userdata.value = {};
    box.write('userId', guestId.value);
    box.write('userdata', {});
    String platform = box.read('platform');
    if (platform == 'Google') {
      GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } else if (platform == 'Facebook') {
      await FacebookAuth.instance.logOut();
    }
  }

  void setToken(String value) {
    box.write('token', value);
    token.value = value;
  }

  void updateUserToken() async {
    if (userdata.isNotEmpty) {
      List tokens = [];
      if (userdata['fcm_tokens'] != null && userdata['fcm_tokens'] != '') {
        tokens = json.decode(userdata['fcm_tokens'].replaceAll('&quot;', '"'));
      }

      if (!tokens.contains(token.value)) {
        tokens.add(token.value);
        String data = json.encode(tokens);

        FormData formData = FormData.fromMap({'fcm_tokens': data});

        await httpRequest('${App.domain}/api/users.php?action=update', fields: formData, snackbar: true);
      }
    }
  }

  void deleteToken() async {
    if (userdata.isNotEmpty) {
      List tokens = [];
      if (userdata['fcm_tokens'] != null && userdata['fcm_tokens'] != '') {
        tokens = json.decode(userdata['fcm_tokens']);
      }
      if (tokens.contains(token.value)) {
        tokens.remove(token.value);
        String data = json.encode(tokens);

        FormData formData = FormData.fromMap({'fcm_tokens': data});

        await httpRequest('${App.domain}/api/users.php?action=update', fields: formData, snackbar: true);
      }
    }
  }

  Future<Map<String, dynamic>> changePassword(Map values) async {
    Map data = {};

    FormData formData = FormData.fromMap({
      'current': values['current'] ?? '',
      'new': values['new'] ?? '',
      'confirm': values['confirm'] ?? '',
      'user_id': userId.value,
    });

    Map result = await httpRequest('${App.domain}/api/users.php?action=password', fields: formData, snackbar: true);

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data = payload['result'];
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }

    return {'data': data};
  }
}
