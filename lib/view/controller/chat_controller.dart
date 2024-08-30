import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  RxString chatMessage = ''.obs;
  TextEditingController txtChats = TextEditingController();
  TextEditingController txtEditChats = TextEditingController();

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

  RxString callId =''.obs;
}