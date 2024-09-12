import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import for Firebase Timestamp
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../modal/user_modal.dart';

class ChatUserCard extends StatelessWidget {
  const ChatUserCard({
    super.key,
    required this.chatController,
    required this.user,
  });

  final ChatController chatController;
  final UserModal user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          chatController.changeReceiverEmail(
              user.email!, user.photoUrl!, user.username!, user.userToken!);
          Get.toNamed('/chat');
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            user.photoUrl!,
          ),
        ),
        title: Text(user.username!),
        subtitle: Text(
          user.lastMessage != null ? user.lastMessage! : '',
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
        trailing: user.timestamp != null && user.timestamp is Timestamp
            ? Text(TimeOfDay.fromDateTime(
                      (user.timestamp as Timestamp).toDate(),
                    ).format(context),
                style: const TextStyle(color: Colors.black54),
              )
            : const SizedBox(
                width: 15,
                height: 15,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 230, 119),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
      ),
    );
  }
}
