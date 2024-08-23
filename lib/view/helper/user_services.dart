import 'package:chat_app/view/modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSarvice {
  static UserSarvice userSarvice = UserSarvice._();

  UserSarvice._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  Future<void> addUser(UserModal userModal)
  async {
    CollectionReference user = firebaseFirestore.collection('user');
    await user.doc(userModal.email).set(userModal.objectToMap(userModal));
  }


  Stream<QuerySnapshot<Object?>> getUser()
  {
    Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance.collection('users').snapshots();
    return collectionStream;
  }

  DocumentReference<Object?> currentUser(UserModal userModal)
  {
    CollectionReference user= firebaseFirestore.collection('user');
    return user.doc(userModal.email);
  }
}