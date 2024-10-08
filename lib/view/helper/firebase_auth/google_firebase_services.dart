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
      await auth.signInWithEmailAndPassword(email: email!, password: pwd!);
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
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
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
      };

      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);

      UserService.userSarvice.updateUserToken();

      return "Suceess";
    } catch (e) {
      log(e.toString());
      return "";
    }
  }

  User? currentUser() {
    User? user = auth.currentUser;
    return user;
  }

  Future<void> mobileUser(String number, String countryCode) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: countryCode + number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user when the phone number is verified
          try {
            await auth.signInWithCredential(credential);
            Fluttertoast.showToast(msg: 'Phone number automatically verified and user signed in.');
            // Navigate to home or dashboard screen
            Get.offAllNamed('/home');
          } catch (e) {
            Fluttertoast.showToast(msg: 'Automatic verification failed.');
            log(e.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle errors such as invalid phone number or billing issues
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(
                msg: 'The provided phone number is not valid.');
          } else if (e.code == 'too-many-requests') {
            Fluttertoast.showToast(
                msg: 'Too many requests. Please try again later.');
          } else if (e.code == 'quota-exceeded') {
            Fluttertoast.showToast(
                msg: 'SMS quota exceeded. Enable billing in Firebase.');
          } else {
            Fluttertoast.showToast(
                msg: 'Phone verification failed. Try again later.');
          }
          log('Verification failed with error: ${e.code} - ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          sign.verificationId.value = verificationId;
          Fluttertoast.showToast(msg: 'OTP sent successfully.');
          Get.toNamed('/otpAdd');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(msg: 'Code retrieval timeout. Please try again.');
        },
      );
    } catch (e) {
      // Log any unexpected errors
      log('Error in phone number verification: $e');
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
