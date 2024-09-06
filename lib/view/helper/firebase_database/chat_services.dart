
import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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

  // String getLastMessageTime(
  //     {required BuildContext context,
  //       required String time,}) {
  //   final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  //   final DateTime now = DateTime.now();
  //
  //   if (now.day == sent.day &&
  //       now.month == sent.month &&
  //       now.year == sent.year) {
  //     return TimeOfDay.fromDateTime(sent).format(context);
  //   }
  //
  //   return '${sent.day} ${_getMonth(sent)}';
  // }
  //
  // String _getMonth(DateTime date) {
  //   switch (date.month) {
  //     case 1:
  //       return 'Jan';
  //     case 2:
  //       return 'Feb';
  //     case 3:
  //       return 'Mar';
  //     case 4:
  //       return 'Apr';
  //     case 5:
  //       return 'May';
  //     case 6:
  //       return 'Jun';
  //     case 7:
  //       return 'Jul';
  //     case 8:
  //       return 'Aug';
  //     case 9:
  //       return 'Sept';
  //     case 10:
  //       return 'Oct';
  //     case 11:
  //       return 'Nov';
  //     case 12:
  //       return 'Dec';
  //   }
  //   return 'NA';
  // }


}
