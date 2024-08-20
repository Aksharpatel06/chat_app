import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  RxString chatMessage = ''.obs;
  TextEditingController txtChats = TextEditingController();

  void changeMessage(String value)
  {
    chatMessage.value = value;
  }
}