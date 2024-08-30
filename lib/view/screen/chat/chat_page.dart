import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:chat_app/view/helper/notification_services.dart';
import 'package:chat_app/view/modal/chat_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/chat_services.dart';
import 'componects/message_list.dart';
import 'componects/textfield_button.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find();
    String lastMessageId = "";
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 60,
        elevation: 1,
        leading: Row(
          children: [
            const BackButton(),
            Obx(
              () => CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  controller.receiverImageUrl.value,
                ),
              ),
            ),
          ],
        ),
        title: Obx(
          () => Text(
            controller.receiverEmail.value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        actions: const [
          // GestureDetector(
          //   onTap: () {
          //     Get.toNamed('/call');
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.only(left: 16.0, right: 8),
          //     child: Icon(Icons.add_call),
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => StreamBuilder(
                stream: ChatServices.chatServices.getChat(
                  GoogleFirebaseServices.googleFirebaseServices
                          .currentUser()!
                          .email ??
                      GoogleFirebaseServices.googleFirebaseServices
                          .currentUser()!
                          .phoneNumber!,
                  controller.receiverEmail.value,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  var queryData = snapshot.data!.docs;
                  List chats = queryData.map((e) => e.data()).toList();
                  List chatsId = queryData.map((e) => e.id).toList();
                  List<ChatModal> chatList =
                      chats.map((e) => ChatModal(e)).toList();


                  // if (queryData.isNotEmpty && queryData.last.id != lastMessageId) {
                  //   lastMessageId = queryData.last.id;
                  //
                  //   final Map<String, dynamic> data =
                  //   queryData.last.data();
                  //   final String message = data['message'];
                  //   final String senderEmail = data['sender'];
                  //
                  //
                  //   if (senderEmail !=
                  //       GoogleFirebaseServices.googleFirebaseServices
                  //           .currentUser()!
                  //           .phoneNumber||
                  //       senderEmail != GoogleFirebaseServices.googleFirebaseServices
                  //           .currentUser()!
                  //           .email) {
                  //     NotificationServices.notificationServices
                  //         .showNotification(
                  //       queryData.last.hashCode,
                  //
                  //       GoogleFirebaseServices.googleFirebaseServices
                  //           .currentUser()!
                  //           .phoneNumber ??
                  //           GoogleFirebaseServices.googleFirebaseServices
                  //               .currentUser()!
                  //               .email!,
                  //
                  //       message,
                  //     );
                  //   }
                  // }

                  return MessageList(
                      chatList: chatList,
                      controller: controller,
                      chatsId: chatsId);
                },
              ),
            ),
          ),
          MessageTextFieldAndButton(controller: controller),
        ],
      ),
    );
  }
}
