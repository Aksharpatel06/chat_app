import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/google_firebase_services.dart';
import '../../../modal/chat_modal.dart';
import 'change_message.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.chatList,
    required this.controller,
    required this.chatsId, required this.theme,
  });

  final List<ChatModal> chatList;
  final ChatController controller;
  final ThemeController theme;
  final List chatsId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: (GoogleFirebaseServices.googleFirebaseServices
                            .currentUser()!
                            .email ==
                        chatList[index].sender ||
                    GoogleFirebaseServices.googleFirebaseServices
                            .currentUser()!
                            .phoneNumber ==
                        chatList[index].sender)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: GestureDetector(
              onLongPress: () {
                controller.txtEditChats =
                    TextEditingController(text: chatList[index].message);
                if (chatList[index].sender ==
                        GoogleFirebaseServices.googleFirebaseServices
                            .currentUser()!
                            .email ||
                    chatList[index].sender ==
                        GoogleFirebaseServices.googleFirebaseServices
                            .currentUser()!
                            .phoneNumber) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            const Text('what will you change this message ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              editMessage(context, controller, chatsId[index]);
                            },
                            child: const Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteMessage(context, chatsId[index], controller);
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Obx(
                ()=> Column(
                  crossAxisAlignment: (controller.currentLogin.value ==
                      chatList[index].sender)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: (controller.currentLogin.value ==
                                  chatList[index].sender)
                          ? theme.senderMessageColor.value
                          : theme.reciverMessageColor.value,
                      borderOnForeground: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                        child: Text(
                          chatList[index].message!,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        TimeOfDay.fromDateTime(
                            chatList[index].timestamp!.toDate())
                            .format(context),
                        style: TextStyle(
                            fontSize: 10,
                            color: theme.timeColor.value,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
