import 'dart:developer';

import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:chat_app/view/modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../notification/firebase_messaging_services.dart';

class UserService {
  static UserService userSarvice = UserService._();
  SignController controller = Get.find();
  ChatController chat = Get.find();

  UserService._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModal userModal) async {
    CollectionReference user = firebaseFirestore.collection('user');
    await user.doc(userModal.email).set(userModal.objectToMap(userModal));
  }

  Stream<QuerySnapshot<Object?>> getUser() {

    if( GoogleFirebaseServices.googleFirebaseServices
        .currentUser()!
        .email == null||GoogleFirebaseServices.googleFirebaseServices
        .currentUser()!
        .email=='')
      {
        chat.currentLogin.value = GoogleFirebaseServices.googleFirebaseServices
            .currentUser()!
            .phoneNumber!;
      }
    else {
      chat.currentLogin.value = GoogleFirebaseServices.googleFirebaseServices
          .currentUser()!
          .email!;
    }

    chat.currentUserLogin.value = GoogleFirebaseServices.googleFirebaseServices
        .currentUser()!.displayName!;
    Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
        .collection('user')
        .where('email',
        isNotEqualTo: chat.currentLogin.value)
        .snapshots();
    return collectionStream;
  }

  Future<Map<String, dynamic>> currentUser() async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot data = await firestore.collection('user').doc(chat.currentLogin.value).get();

      if (data.exists) {
        return data.data() as Map<String, dynamic>;
      } else {
        log('Document does not exist');
        return {};
      }
    } catch (e) {
      log('Error fetching user data: $e');
      return {};
    }
  }

  Future<void> updateUserToken() async {
    String? token = await FirebaseMessagingServices.firebaseMessagingServices
        .generateDeviceToken();
    log('----------------------token-----------------');
    User? user = GoogleFirebaseServices.googleFirebaseServices.currentUser();
    firebaseFirestore.collection('user').doc(user!.email).update({'token': token});
  }

  Future<void> updateIsOnline(bool isOnline) async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return;

    await firebaseFirestore.collection('user').doc(userEmail).update({
      'isOnline': isOnline
    });
  }
}
