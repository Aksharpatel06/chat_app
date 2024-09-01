import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:chat_app/view/helper/notification_services.dart';
import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:chat_app/view/screen/home/home_page.dart';
import 'package:chat_app/view/screen/intro/intro_page.dart';
import 'package:chat_app/view/screen/otp/mobile/otp_page.dart';
import 'package:chat_app/view/screen/otp/verify/otp_verify_page.dart';
import 'package:chat_app/view/screen/sign/sign%20up/sign_up_page.dart';
import 'package:chat_app/view/screen/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'view/screen/sign/sign in/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationServices.notificationServices.initNotification();

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
      designSize:  Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Obx(
        () => GetMaterialApp(
          themeMode: themeController.themeMode.value,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          getPages: [
            GetPage(
              name: '/',
              page: () => const SplashPage(),
            ),
            GetPage(
              name: '/intro',
              page: () =>
                  GoogleFirebaseServices.googleFirebaseServices.currentUser() !=
                          null
                      ? const HomePage()
                      : const IntroPage(),
            ),
            GetPage(
              name: '/signin',
              page: () => const SignInPage(),
            ),
            GetPage(
              name: '/signup',
              page: () => const SignUpPage(),
            ),
            GetPage(
              name: '/otp',
              page: () => const OtpPage(),
            ),
            GetPage(
              name: '/otpAdd',
              page: () => const OtpVerifyPage(),
            ),
            GetPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            GetPage(
              name: '/chat',
              page: () => const ChatPage(),
            ),
            // GetPage(
            //   name: '/call',
            //   page: () => const CallPage(),
            // ),
          ],
        ),
      ),
    );
  }
}

//
// class NotificationServices {
//   static NotificationServices notificationServices = NotificationServices._();
//
//   NotificationServices._();
//
//   // 1.simple notification
//   // 2.scheduling
//   // 3.periodic
//   // 4.picture
//
//   // 1.simple notification
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification() async {
//     // tz.initializeTimeZones();
//     AndroidInitializationSettings androidInitializationSettings =
//     const AndroidInitializationSettings('mipmap/ic_launcher');
//     DarwinInitializationSettings darwinInitializationSettings =
//     const DarwinInitializationSettings();
//
//     InitializationSettings initializationSettings = InitializationSettings(
//         android: androidInitializationSettings,
//         iOS: darwinInitializationSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification() async {
//     AndroidNotificationDetails androidNotificationDetails =
//     const AndroidNotificationDetails(
//       'chat',
//       'chat-app',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//         0,
//         'Chat App',
//         "A chat app with firebase integration - authentication",
//         notificationDetails);
//   }
//
//
//
// // 2.scheduling
//
// // terminal : flutter pub add timezone
//
//   // import 'package:timezone/data/latest_all.dart' as tz;
//   // import 'package:timezone/timezone.dart' as tz;
//
//   Future<void> showScheduleNotification() async {
//     AndroidNotificationDetails androidNotificationDetails =
//     const AndroidNotificationDetails(
//       'chat',
//       'chat-app',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         1,
//         'Schedule Notification',
//         "A chat app with firebase integration - authentication",
//         tz.TZDateTime.now(tz.getLocation('Asia/Kolkata')).add(const Duration(seconds: 5)),
//         notificationDetails,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime);
//   }
// }

// class NotificationServices {
//   static NotificationServices notificationServices = NotificationServices._();
//
//   NotificationServices._();
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   //init
//   Future<void> initNotification() async {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings('mipmap/ic_launcher');
//     DarwinInitializationSettings darwinInitializationSettings =
//         const DarwinInitializationSettings();
//
//     InitializationSettings initializationSettings = InitializationSettings(
//         android: androidInitializationSettings,
//         iOS: darwinInitializationSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification(String title,String body) async {
//     AndroidNotificationDetails android = const AndroidNotificationDetails(
//         'chat_app', 'Simple Message',
//         importance: Importance.max, priority: Priority.high);
//     NotificationDetails details = NotificationDetails(android: android);
//
//     await flutterLocalNotificationsPlugin.show(001, title, body, details);
//   }
// }
