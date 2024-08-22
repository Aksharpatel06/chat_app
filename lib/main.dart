import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:chat_app/view/screen/home/home_page.dart';
import 'package:chat_app/view/screen/intro/intro_page.dart';
import 'package:chat_app/view/screen/sign/sign%20up/sign_up_page.dart';
import 'package:chat_app/view/screen/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/screen/sign/sign in/sign_in_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());

    return Obx(
          () =>
          GetMaterialApp(
            themeMode: themeController.themeMode.value,
            // Observe themeMode changes
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
