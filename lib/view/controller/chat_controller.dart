import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:chat_app/view/modal/chat_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {
  RxString currentLogin = ''.obs;

  RxString chatMessage = ''.obs;
  TextEditingController txtChats = TextEditingController();
  TextEditingController txtEditChats = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkCurrentUser();
  }

  void changeMessage(String value) {
    chatMessage.value = value;
  }

  RxInt bottomIndex = 0.obs;

  void changeBottomIndex(int value) {
    bottomIndex.value = value;
  }

  RxString receiverEmail = ''.obs;
  RxString receiverImageUrl = ''.obs;
  RxString receiverUserNameUrl = ''.obs;
  RxString receiverToken = ''.obs;

  void changeReceiverEmail(
      String email, String photoUrl, String user, String token) {
    log("$email and photo----------------------------------------------------");
    receiverEmail.value = email;
    receiverImageUrl.value = photoUrl;
    receiverUserNameUrl.value = user;
    receiverToken.value = token;
    update();
  }

  void checkCurrentUser() {
    log('------------------------------------------------\n');
    GoogleFirebaseServices.googleFirebaseServices.currentUser();
    log('------------------------------------------------\n');
  }

  RxString callId = ''.obs;

  RxBool isImage = false.obs;

  ImagePicker imagePicker = ImagePicker();
  Rx<File> imgPath= File('/data/user/0/com.example.chat_app/cache/6a997e24-2fdb-4d42-8d32-d96a866ea5ea/IMG-20240906-WA0069.jpg').obs;

  Future<void> selectedImage(ImageSource imageSource) async {
    final directory = await getApplicationDocumentsDirectory();
    File files = File('${directory.path}/${DateTime.now()}.png');
    isImage.value = true;
    log('${isImage.value}-----------------------------------');
    final XFile? image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      files = File(image.path);
    }
    update();
  }

  Future<File?> stringToFile(ChatModal chat) async {
      Uint8List bytes = base64Decode(chat.image!);
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/${chat.timestamp}.png');
      return file.writeAsBytes(bytes);

  }
}
