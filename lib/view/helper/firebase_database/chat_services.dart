import 'dart:developer';
import 'dart:io';

import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modal/chat_modal.dart';

class ChatServices {
  static ChatServices chatServices = ChatServices._();

  ChatServices._();

  ChatController controller = Get.find();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> insertData(Map<String, dynamic> chat, String receiver) async {
    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    await firestore
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .add(chat);
    firestore
        .collection('user')
        .doc(controller.currentLogin.value)
        .update({'lastMessage': chat['message']});
    firestore
        .collection('user')
        .doc(controller.currentLogin.value)
        .update({'lastTimeStamp': chat['timestamp']});
    firestore
        .collection('user')
        .doc(receiver)
        .update({'lastMessage': chat['message']});
    firestore
        .collection('user')
        .doc(receiver)
        .update({'lastTimeStamp': chat['timestamp']});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChat(String receiver) {
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastChat(String receiver) {
    List doc = [controller.currentLogin.value, receiver];
    doc.sort();
    String docId = doc.join('_');
    controller.callId.value = docId;
    return firestore
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  // Future<void> sendChatImage(ChatModal chatModal, File file) async {
  //   //getting image file extension
  //   final ext = file.path.split('.').last;
  //
  //   //storage file ref with path
  //   final ref = storage.ref().child(
  //       'images/${chatModal.timestamp}/${DateTime.now().millisecondsSinceEpoch}.$ext');
  //
  //   //uploading image
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });
  //
  //   //updating image in firestore database
  //   final imageUrl = await ref.getDownloadURL();
  // }

  String getLastMessageTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
