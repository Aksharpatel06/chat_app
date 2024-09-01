import 'package:flutter/material.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/chat_services.dart';
import '../../../helper/google_firebase_services.dart';
import '../../../modal/chat_modal.dart';

void changeThisMessage(ChatController controller,ChatModal chat,BuildContext context,String chatId)
{
  controller.txtEditChats = TextEditingController(
      text: chat.message);
  if (chat.sender ==
      GoogleFirebaseServices.googleFirebaseServices
          .currentUser()!
          .email||chat.sender ==
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
                    chatId);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                deleteMessage(context, chatId,controller);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}


void editMessage(BuildContext context, ChatController controller, String chatId) {
  Navigator.pop(context);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller.txtEditChats,
        ),
        actions: [
          TextButton(
            onPressed: () {
              ChatServices.chatServices.updateChat(
                controller.txtEditChats.text,
                chatId,
                controller.receiverEmail.value,
              );
              Navigator.pop(context);
            },
            child: const Text('edit'),
          )
        ],
      );
    },
  );
}


void deleteMessage(BuildContext context,String chatId,ChatController controller)
{
  Navigator.pop(context);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text(
            'Do you delete this message ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              ChatServices.chatServices
                  .deleteChat(
                chatId,

                controller.receiverEmail
                    .value,
              );
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
