import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var themeMode=ThemeMode.dark.obs;
  Rx<Color> isTextFiledColor = const Color(0xffF0F0F0).obs;
  Rx<Color> senderMessageColor = const Color(0xfff6f6f6).withOpacity(0.5).obs;
  Rx<Color> reciverMessageColor = Colors.grey.shade400.obs;
  Rx<Color> timeColor = Colors.grey.shade400.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    changeMode();
  }

  void changeMode() {
    if (themeMode.value == ThemeMode.dark) {
      reciverMessageColor.value = Colors.transparent;
      senderMessageColor.value =  const Color(0xd856d076);
      isTextFiledColor.value =  const Color(0xfff0f0f0);
      timeColor.value = Colors.black;
      themeMode.value = ThemeMode.light;
    } else {
      isTextFiledColor.value = const Color(0xff000000);
      timeColor.value = Colors.white;
      reciverMessageColor.value = Colors.grey.shade800;
      senderMessageColor.value =const Color(0xff31C48D).withOpacity(0.5);
      themeMode.value = ThemeMode.dark;
    }
    update();
  }

  ThemeMode getThemeMode() => themeMode.value;
}
