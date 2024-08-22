import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignController extends GetxController{

  // signin page text field
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPwd = TextEditingController();

  // signup page text field
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtCreateMail = TextEditingController();
  TextEditingController txtCreatePwd = TextEditingController();

  // show password in signIn page
  RxBool isShowPwd = false.obs;

  void showPassword()
  {
    isShowPwd.value = !isShowPwd.value;
    update();
  }

}
