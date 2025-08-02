import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  static NotificationServices notificationServices = NotificationServices._();
  NotificationServices._();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body, String image) async {
    String imagePath = '';
    if (image.isNotEmpty) {
      imagePath =
          await downloadImageToFile(image, 'notification_image.jpg') ?? '';
    }
    try {
      final BigPictureStyleInformation? bigPictureStyle = image.isNotEmpty
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imagePath),
              contentTitle: title,
              summaryText: body,
            )
          : null;

      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'chat',
        'chat-app',
        styleInformation: bigPictureStyle,
        importance: Importance.max,
        priority: Priority.high,
      );

      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
      );
    } catch (e, stack) {
      debugPrint('Error showing notification: $e  \n$stack');
    }
  }

  Future<String?> downloadImageToFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
