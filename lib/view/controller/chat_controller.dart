import 'dart:developer';

import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{

  RxString currentLogin=''.obs;

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
  RxString receiverUserNameUrl =''.obs;

  void changeReceiverEmail(String email,String photoUrl,String user)
  {
    log("$email and photo----------------------------------------------------");
    receiverEmail.value=email;
    receiverImageUrl.value =photoUrl;
    receiverUserNameUrl.value=user;
    update();
  }

  void checkCurrentUser()
  {
    log('------------------------------------------------\n');
   GoogleFirebaseServices.googleFirebaseServices.currentUser();
    log('------------------------------------------------\n');
  }

  RxString callId =''.obs;
}