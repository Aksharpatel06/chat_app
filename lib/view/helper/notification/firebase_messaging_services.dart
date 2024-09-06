import 'dart:developer';

import 'package:chat_app/view/helper/notification/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingServices {
  FirebaseMessagingServices._();

  static FirebaseMessagingServices firebaseMessagingServices =
      FirebaseMessagingServices._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // 4. return token
  Future<String?> generateDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    // todo user cloud store -save
    log("Device Token:$token}");
    return token;
  }

  //
  void onMessageListener() {
    FirebaseMessaging.onMessage.listen(
      (event) {
        NotificationServices.notificationServices.showNotification(
            event.notification!.title!, event.notification!.body!);
      },
    );
  }
}
