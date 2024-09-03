import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:chat_app/view/modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
    Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
        .collection('user')
        .where('email',
        isNotEqualTo: chat.currentLogin.value)
        .snapshots();
    return collectionStream;
  }

  DocumentReference<Object?> currentUser(UserModal userModal) {
    CollectionReference user = firebaseFirestore.collection('user');
    return user.doc(userModal.email);
  }
}
