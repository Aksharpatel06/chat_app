import 'dart:developer';

import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  RxString chatMessage = ''.obs;
  TextEditingController txtChats = TextEditingController();
  TextEditingController txtEditChats = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkCurrentUser();
  }

  void changeMessage(String value)
  {

    chatMessage.value = value;
  }

  RxInt bottomIndex=0.obs;

  void changeBottomIndex(int value)
  {
    bottomIndex.value=value;
  }

  RxString receiverEmail =''.obs;
  RxString receiverImageUrl =''.obs;

  void changeReceiverEmail(String email,String photoUrl)
  {
    log("$email and photo----------------------------------------------------");
    receiverEmail.value=email;
    receiverImageUrl.value =photoUrl;
    update();
  }

  void checkCurrentUser()
  {
    print('------------------------------------------------\n');
   User? user= GoogleFirebaseServices.googleFirebaseServices.currentUser();
    print('------------------------------------------------\n');
    print('------------------------------------------------\n');

   // print(user)
  }

  RxString callId =''.obs;
}