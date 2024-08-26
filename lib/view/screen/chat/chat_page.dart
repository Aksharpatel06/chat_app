import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:chat_app/view/modal/chat_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/chat_services.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();
    ChatController controller = Get.put(ChatController());
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
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8),
            child: Icon(Icons.add_call),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatServices.chatServices.getChat(
                  GoogleFirebaseServices.googleFirebaseServices
                      .currentUser()!
                      .email??signController.phone.value,
                  controller.receiverEmail.value),
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
                List<ChatModal> chatList =
                    chats.map((e) => ChatModal(e)).toList();
                return ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: GoogleFirebaseServices.googleFirebaseServices
                                    .currentUser()!
                                    .email ==
                                chatList[index].sender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Card(child: Text(chatList[index].message!))),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Container(
                    height: 50,
                    width: 292,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Obx(
                      () => TextField(
                        controller: controller.txtChats,
                        onChanged: (value) => controller.changeMessage(value),
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: const TextStyle(fontSize: 20),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                          suffixIcon: controller.chatMessage.value.isEmpty
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.attach_file),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(CupertinoIcons
                                        .money_dollar_circle_fill),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(Icons.photo_camera),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.attach_file),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 4),
                    child: Obx(
                      () => FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          Map<String, dynamic> chat = {
                            'sender': GoogleFirebaseServices
                                .googleFirebaseServices
                                .currentUser()!
                                .email??signController.phone.value,
                            'receiver': controller.receiverEmail.value,
                            'message': controller.txtChats.text,
                            'timestamp': DateTime.now()
                          };
                          ChatServices.chatServices.insertData(
                              chat,
                              GoogleFirebaseServices.googleFirebaseServices
                                  .currentUser()!
                                  .email??signController.phone.value,
                              controller.receiverEmail.value);
                          controller.txtChats.clear();
                        },
                        child: controller.chatMessage.value.isEmpty
                            ? const Icon(Icons.mic)
                            : const Icon(Icons.send),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
