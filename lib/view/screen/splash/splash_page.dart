import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        Get.offAndToNamed('/intro',);
      },
    );
    return Scaffold(
      body: Center(
        child: Image.asset('asset/splash/Group 1.png',fit: BoxFit.cover,),
      ),
    );
  }
}
