import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:chat_app/view/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page:() => const ChatPage(),),
        GetPage(name: '/home', page:() => const HomePage(),),
      ],
    );
  }
}
