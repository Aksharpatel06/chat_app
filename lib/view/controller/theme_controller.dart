import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var themeMode=ThemeMode.system.obs;
  var isTextFiledColor = const Color(0xffF0F0F0).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (ThemeMode.system == ThemeMode.dark) {
      print("${themeMode}---- dark");
    } else if (ThemeMode.system == ThemeMode.light) {
      print("${themeMode}---- light");
    } else {
      print('hello');
    }
    changeMode();
  }

  void changeMode() {
    if (themeMode.value == ThemeMode.dark) {
      isTextFiledColor.value = const Color(0xffF0f0f0);
      themeMode.value = ThemeMode.light;
    } else {
      isTextFiledColor.value = const Color(0xff000000);
      themeMode.value = ThemeMode.dark;
    }
    update();
  }

  ThemeMode getThemeMode() => themeMode.value;
}
