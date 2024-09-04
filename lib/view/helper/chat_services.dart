import 'dart:developer';

import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatServices {
  static ChatServices chatServices = ChatServices._();

  ChatServices._();

  ChatController controller = Get.find();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> insertData(Map<String, dynamic> chat, String receiver) async {
    log("${controller.currentLogin.value} ------------------------------------- $receiver");
    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    await firestore
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .add(chat);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChat(String receiver) {
    log("${controller.currentLogin.value} ------------------------------------- $receiver");

    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    controller.callId.value = docId;
    return firestore
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void updateChat(String message, String chatId, String receiver) {
    // 1. chat id field
    // 2. docId access

    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .doc(chatId)
        .update({
      'message': message,
    });
  }

  void deleteChat(String chatId, String receiver) {
    // 1. chat id field
    // 2. docId access

    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .doc(chatId)
        .delete();
  }

  void updateMessageReadStatus(String receiver, String chatId) {
    log("${controller.currentLogin.value} ------------------------------------- $receiver");

    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    controller.callId.value = docId;
    firestore
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .doc(chatId)
        .update({'read': true});
  }
}
