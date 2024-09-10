import 'dart:developer';

import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../modal/user_modal.dart';
import '../firebase_database/user_services.dart';

class GoogleFirebaseServices {
  SignController sign = Get.find();
  static GoogleFirebaseServices googleFirebaseServices =
      GoogleFirebaseServices._();

  GoogleFirebaseServices._();

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> createEmailAndPassword(String? email, String? pwd) async {
    try {
      // log("$email--------------------$pwd");
      await auth.createUserWithEmailAndPassword(email: email!, password: pwd!);
      Get.toNamed('/signin');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> compareEmailAndPwd(String? email, String? pwd) async {
    try {
      // log("$email--------------------$pwd");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: pwd!);
      Map userModal = {
        'username': sign.txtUser.text,
        'email': sign.txtCreateMail.text,
      };

      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);
      currentUser();
      UserService.userSarvice.updateUserToken();

      Get.toNamed('/home');
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'user-not-found' || e.code == "invalid-email") {
        Fluttertoast.showToast(
            msg: "No User Found for that Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        Fluttertoast.showToast(
            msg: "Wrong Password Provided by User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'channel-error') {
        Fluttertoast.showToast(
            msg: "Enter the email and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void emailLogout() {
    try {
      googleSignIn.signOut();
      auth.signOut();
      currentUser();
      sign.phone.value = '';
      Get.offAndToNamed('/otp');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      auth.signInWithCredential(authCredential);
      currentUser();

      Map userModal = {
        'username': auth.currentUser!.displayName,
        'email': auth.currentUser!.email,
        'photoUrl': auth.currentUser!.photoURL,
        // 'token':await FirebaseMessagingServices.firebaseMessagingServices
        //     .generateDeviceToken(),
      };

      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);

      UserService.userSarvice.updateUserToken();

      return "Suceess";
    } catch (e) {
      log(e.toString());
      return "Failed";
    }
  }

  User? currentUser() {
    User? user = auth.currentUser;
    return user;
  }

  Future<void> mobileUser(String number, String countryCode) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode+number,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(
                msg: 'The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          sign.verificationId.value = verificationId;
          Get.toNamed('/otpAdd');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> mobileVarifaction(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: sign.verificationId.value, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      currentUser();
      Map userModal = {
        'username': sign.txtUserName.text,
        'email': auth.currentUser!.phoneNumber,
      };
      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);
      UserService.userSarvice.updateUserToken();

      Get.offAndToNamed('/home');
    } catch (e) {
      log(e.toString());
    }
  }
}
