import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleFirebaseServices {


  static GoogleFirebaseServices googleFirebaseServices = GoogleFirebaseServices._();
  GoogleFirebaseServices._();
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();


  Future<void> createEmailAndPassword(String? email, String? pwd) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email!, password: pwd!);
      Get.toNamed('/signin');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> compareEmailAndPwd(String? email, String? pwd) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: pwd!);
      Get.toNamed('/home');
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'user-not-found' || e.code=="invalid-email") {
        Fluttertoast.showToast(
            msg: "No User Found for that Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password' || e.code=='invalid-credential') {
        Fluttertoast.showToast(
            msg: "Wrong Password Provided by User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if(e.code=='channel-error'){
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

  void emailLogout()
  {
    try{
      googleSignIn.signOut();
      auth.signOut();
    }catch(e)
    {
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


      return "Suceess";
    } catch (e) {
      log(e.toString());
      return "Failed";
    }
  }


  User? currentUser()
  {
    User? user = auth.currentUser;
    if(user!=null)
    {
      print(user.email);
      print(user.displayName);
      print(user.phoneNumber);
      print(user.photoURL);
    }
    return user;
  }
}