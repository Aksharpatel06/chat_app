import 'package:flutter/material.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/google_firebase_services.dart';
import '../../../modal/chat_modal.dart';
import '../chat_page.dart';
import 'change_message.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.chatList,
    required this.controller,
    required this.chatsId,
  });

  final List<ChatModal> chatList;
  final ChatController controller;
  final List chatsId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: (GoogleFirebaseServices
              .googleFirebaseServices
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
              controller.txtEditChats = TextEditingController(
                  text: chatList[index].message);
              if (chatList[index].sender ==
                  GoogleFirebaseServices.googleFirebaseServices
                      .currentUser()!
                      .email||chatList[index].sender ==
                  GoogleFirebaseServices.googleFirebaseServices
                      .currentUser()!
                      .phoneNumber) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                          'what will you change this message ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            editMessage(context, controller,
                                chatsId[index]);
                          },
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteMessage(context,  chatsId[index],controller);
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
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(chatList[index].message!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
