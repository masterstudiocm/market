import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:market/classes/notification_service.dart';
import 'package:market/firebase_options.dart';
import 'package:market/themes/functions.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    FirebaseMessaging.instance.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen(firebaseBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data['url'] != null && message.data['url'] != '') {
        redirectUrl(message.data['url']);
      }
    });
  }

  static Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
    Map<String, String>? payload = message.data.map((key, value) => MapEntry(key, value.toString()));
    NotificationService.showNotification(
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      payload: payload,
      bigPicture: payload['image'],
      notificationLayout: NotificationLayout.BigPicture,
    );
  }

  static Future<void> getInitialMessage() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null && message.data['url'] != null && message.data['url'] != '') {
      redirectUrl(message.data['url']);
    }
  }
}
