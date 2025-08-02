import 'package:chat_app/routes.dart';
import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';

import 'package:chat_app/view/helper/notification/api_services.dart';
import 'package:chat_app/view/helper/notification/firebase_messaging_services.dart';
import 'package:chat_app/view/helper/notification/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  NotificationServices.notificationServices.initNotification();
  await FirebaseMessagingServices.firebaseMessagingServices.requestPermission();
  await FirebaseMessagingServices.firebaseMessagingServices
      .generateDeviceToken();
  ApiService.apiService.getServerToken();
  FirebaseMessagingServices.firebaseMessagingServices.onMessageListener();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // When app starts, mark user online
    updateIsOnline(true);
  }

  @override
  void dispose() {
    // When widget is removed, mark user offline
    updateIsOnline(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      updateIsOnline(false);
    } else if (state == AppLifecycleState.resumed) {
      updateIsOnline(true); // App brought back to foreground
    }
  }

  Future<void> updateIsOnline(bool isOnline) async {
    final firebaseFirestore = FirebaseFirestore.instance;

    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return;

    try {
      await firebaseFirestore.collection('user').doc(userEmail).update({
        'isOnline': isOnline,
      });
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

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
