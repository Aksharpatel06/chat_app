import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var isTextFiled = const Color(0xffF0F0F0).obs;

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
  }

  void changeMode() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
    update();
  }

  ThemeMode getThemeMode() => themeMode.value;
}
