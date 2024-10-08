import 'package:chat_app/routes.dart';
import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';

// import 'package:chat_app/view/helper/firebase_database/status_services.dart';
import 'package:chat_app/view/helper/notification/api_services.dart';
import 'package:chat_app/view/helper/notification/firebase_messaging_services.dart';
import 'package:chat_app/view/helper/notification/notification_services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final appLifecycleObserver = AppLifecycleObserver();
  // appLifecycleObserver.startListening();

  NotificationServices.notificationServices.initNotification();
  await FirebaseMessagingServices.firebaseMessagingServices.requestPermission();
  await FirebaseMessagingServices.firebaseMessagingServices
      .generateDeviceToken();
  ApiService.apiService.getServerToken();
  FirebaseMessagingServices.firebaseMessagingServices.onMessageListener();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());
    Get.put(SignController());
    Get.put(ChatController());

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Obx(
        () => GetMaterialApp(
          themeMode: themeController.themeMode.value,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          getPages: getPages,
        ),
      ),
    );
  }
}
