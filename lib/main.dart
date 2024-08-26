import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:chat_app/view/screen/home/home_page.dart';
import 'package:chat_app/view/screen/intro/intro_page.dart';
import 'package:chat_app/view/screen/otp/mobile/otp_page.dart';
import 'package:chat_app/view/screen/otp/verify/otp_verify_page.dart';
import 'package:chat_app/view/screen/sign/sign%20up/sign_up_page.dart';
import 'package:chat_app/view/screen/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'view/screen/sign/sign in/sign_in_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        themeMode: themeController.themeMode.value,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        getPages: [
          GetPage(
            name: '/',
            page: () =>
            const SplashPage(),
          ),
          GetPage(
            name: '/intro',
            page: () => const IntroPage(),
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
        ],
      ),
    );
  }
}
