import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/chat_services.dart';
import '../../../helper/google_firebase_services.dart';

class MessageTextFieldAndButton extends StatelessWidget {
  const MessageTextFieldAndButton({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                              SizedBox(width: 15),
                              Icon(CupertinoIcons.money_dollar_circle_fill),
                              SizedBox(width: 15),
                              Icon(Icons.photo_camera),
                              SizedBox(width: 15),
                            ],
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_file),
                              SizedBox(width: 10),
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
                    if(controller.txtChats.text.isNotEmpty)
                      {
                        Map<String, dynamic> chat = {
                          'sender': GoogleFirebaseServices.googleFirebaseServices
                              .currentUser()!
                              .email ??
                              GoogleFirebaseServices.googleFirebaseServices
                                  .currentUser()!
                                  .phoneNumber!,
                          'receiver': controller.receiverEmail.value,
                          'message': controller.txtChats.text,
                          'timestamp': DateTime.now()
                        };
                        ChatServices.chatServices.insertData(
                          chat,
                          GoogleFirebaseServices.googleFirebaseServices
                              .currentUser()!
                              .email ??
                              GoogleFirebaseServices.googleFirebaseServices
                                  .currentUser()!
                                  .phoneNumber!,
                          controller.receiverEmail.value,
                        );
                        controller.txtChats.clear();
                      }
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
    );
  }
}
