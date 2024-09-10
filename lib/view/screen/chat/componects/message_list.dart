
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/helper/firebase_database/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../modal/chat_modal.dart';
import 'change_message.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.chatList,
    required this.controller,
    required this.chatsId,
    required this.theme,
  });

  final List<ChatModal> chatList;
  final ChatController controller;
  final ThemeController theme;
  final List chatsId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.h),
      child: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          // Mark message as read if it belongs to the receiver
          if (chatList[index].read == false &&
              chatList[index].receiver == controller.currentLogin.value) {
            ChatServices.chatServices.updateMessageReadStatus(
                controller.receiverEmail.value, chatsId[index]);
          }

          // Handle image decoding and display
          if (chatList[index].isImage) {
            // Use await to handle the async file creation and ensure it's properly awaited
            // controller.stringToFile(chatList[index],index).then((file) {
            //     controller.imgPath.value = file;
            //               });
          }

          return Padding(
            padding: EdgeInsets.all(8.h),
            child: Align(
              alignment:
              (controller.currentLogin.value == chatList[index].sender)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: GestureDetector(
                onLongPress: () {
                  controller.txtEditChats =
                      TextEditingController(text: chatList[index].message);
                  if (chatList[index].sender == controller.currentLogin.value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                          const Text('What will you change this message to?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                editMessage(
                                    context, controller, chatsId[index]);
                              },
                              child: const Text('Edit'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteMessage(
                                    context, chatsId[index], controller);
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
                      () => Column(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 12.h),
                          child: Text(
                            chatList[index].message!,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: Row(
                          mainAxisAlignment: (controller.currentLogin.value ==
                              chatList[index].sender)
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            (chatList[index].read &&
                                chatList[index].sender ==
                                    controller.currentLogin.value)
                                ? Icon(
                              Icons.done_all_rounded,
                              color: Colors.blue.shade400,
                              size: 18.sp,
                            )
                                : Container(),
                            SizedBox(
                              width: (chatList[index].read &&
                                  chatList[index].sender ==
                                      controller.currentLogin.value)
                                  ? 5.w
                                  : 0.w,
                            ),
                            Text(
                              TimeOfDay.fromDateTime(
                                  chatList[index].timestamp!.toDate())
                                  .format(context),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: theme.timeColor.value,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
