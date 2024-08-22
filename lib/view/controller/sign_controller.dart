import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignController extends GetxController{

  // signin page text field
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPwd = TextEditingController();

  // show password in signIn page
  RxBool isShowPwd = false.obs;

  void showPassword()
  {
    isShowPwd.value = !isShowPwd.value;
  }

}
