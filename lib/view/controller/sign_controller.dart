import 'dart:developer';

import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // google and firebase current User
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString url = ''.obs;

  Future<void> getUserDetails() async {
    User? user = GoogleFirebaseServices.googleFirebaseServices.currentUser();
    if (user != null) {
      email.value = user.email!;
      url.value = user.photoURL!;
      name.value = user.displayName!;
    }
  }

  // google and firebase email id logout

  void emailLayout() {
    GoogleFirebaseServices.googleFirebaseServices.emailLogout();
  }

  // email and pwd validation
  RxString error = ''.obs;
  RxString pwd = ''.obs;

  Future<void> validateInputs(TextEditingController txtEmail,
      TextEditingController txtPwd) async {
    error.value = validateEmail(txtEmail.text) ?? '';
    pwd.value = validatePassword(txtPwd.text) ?? '';
    log('${error.isEmpty && pwd.isEmpty}');

    if (error.isEmpty && pwd.isEmpty) {
      await GoogleFirebaseServices.googleFirebaseServices
          .createEmailAndPassword(txtEmail.text, txtPwd.text);

      Get.toNamed('/signin');
    }
    update();
  }

  // email formated validation

  validateEmail(String? value) {
    if (value!.isEmpty || value == '') {
      return 'Please enter email!';
    } else {
      var g = '';
      var gmail = 'moc.liamg@';
      var gmai = 0;
      var sepcialChecking = 0;

      g = value;
      var len = g.length;
      var k = 0;
      if (len >= 11) {
        for (var j = len - 1; j > len - 11; j--) {
          if (g[j] != gmail[k]) {
            gmai = 1;
          }
          k++;
        }
        if (gmai == 0) {
          for (var j = 0; j < len - 11; j++) {
            if ((g.codeUnitAt(j) >= 33 && g.codeUnitAt(j) <= 47) ||
                (g.codeUnitAt(j) >= 58 && g.codeUnitAt(j) <= 64)) {
              sepcialChecking = 1;
            }
          }
          if (sepcialChecking == 0) {
          } else {
            return 'Invalid email format';
          }
        } else {
          return 'Invalid domain name!';
        }
      } else {
        return 'Please enter email!';
      }
    }
    return null;
  }

  // password validation

  validatePassword(String? value) {
    if (value!.isEmpty || value == '') {
      return 'Enter strong password!';
    } else {
      var upparcaseChecking = 0;
      var lowercaseChecking = 0;
      var numberChecking = 0;
      var sepcialCharcterChecking = 0;
      var len = value.length;
      if (len >= 8 && len <= 32) {
        for (var i = 0; i < len; i++) {
          if (value.codeUnitAt(i) >= 65 && value.codeUnitAt(i) <= 90) {
            upparcaseChecking = 1;
          }
        }
        if (upparcaseChecking == 1) {
          for (var i = 0; i < len; i++) {
            if (value.codeUnitAt(i) >= 97 && value.codeUnitAt(i) <= 122) {
              lowercaseChecking = 1;
            }
          }
          if (lowercaseChecking == 1) {
            for (var i = 0; i < len; i++) {
              if (value.codeUnitAt(i) >= 48 && value.codeUnitAt(i) <= 57) {
                numberChecking = 1;
              }
            }
            if (numberChecking == 1) {
              for (var i = 0; i < len; i++) {
                if ((value.codeUnitAt(i) >= 33 && value.codeUnitAt(i) <= 47) ||
                    (value.codeUnitAt(i) >= 58 && value.codeUnitAt(i) <= 64)) {
                  sepcialCharcterChecking = 1;
                }
              }
              if (sepcialCharcterChecking == 1) {
              } else {
                return 'Enter sepcial charcter password!';
              }
            } else {
              return 'Enter number password!';
            }
          } else {
            return 'Enter lower case password!';
          }
        } else {
          return 'Enter upper case password!';
        }
      } else {
        return 'Enter strong password!';
      }
    }
    return null;
  }



  TextEditingController countryController =
  TextEditingController(text: '+91');
  RxString phone = "".obs;
  RxString code = "".obs;
  RxBool remember =false.obs;

  RxString verificationId =''.obs;

  void changeCode(String value)
  {
    code.value = value;
  }

  void changeRemember(bool value)
  {
    remember.value=value;
  }

}
