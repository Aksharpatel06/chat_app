

import 'package:chat_app/view/helper/notification/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/firebase_database/chat_services.dart';


class MessageTextFieldAndButton extends StatelessWidget {
  const MessageTextFieldAndButton({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            child: Container(
              height: 50.h,
              width: 270.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Obx(
                () => TextField(
                  controller: controller.txtChats,
                  onChanged: (value) => controller.changeMessage(value),
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(fontSize: 20.sp),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                    suffixIcon: controller.chatMessage.value.isEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    imagePickerDialog(context, controller);
                                  },
                                  icon: const Icon(Icons.attach_file)),
                              SizedBox(width: 15.w),
                              const Icon(
                                  CupertinoIcons.money_dollar_circle_fill),
                              SizedBox(width: 15.w),
                              const Icon(Icons.photo_camera),
                              SizedBox(width: 15.w),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    imagePickerDialog(context, controller);
                                  },
                                  icon: const Icon(Icons.attach_file)),
                              SizedBox(width: 10.w),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60.h,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 4),
              child: Obx(
                () => FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () async {
                    if (controller.txtChats.text.isNotEmpty) {
                      String messageContent;


                        messageContent = controller.txtChats.text;


                      Map<String, dynamic> chat = {
                        'sender': controller.currentLogin.value,
                        'receiver': controller.receiverEmail.value,
                        'message': messageContent,
                        'timestamp': DateTime.now(),
                        'read': null,
                        'isImage': false,
                      };

                      // Insert chat into the database
                      ChatServices.chatServices
                          .insertData(chat, controller.receiverEmail.value);

                      ApiService.apiService.sendMessage(
                        controller.currentUserLogin.value,
                        controller.txtChats.text,
                        controller.receiverToken.value,
                      );

                      controller.txtChats.clear();
                    }
                  },
                  child: controller.chatMessage.value.isNotEmpty
                      ? const Icon(Icons.send)
                      : const Icon(Icons.mic),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void imagePickerDialog(BuildContext context, ChatController controller) {
  showAdaptiveDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              // controller.selectedImage(ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Text('Take Photo')),
        TextButton(
            onPressed: () {
              // controller.selectedImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: const Text('Choose Photo')),
      ],
      content: const Text('Choose you option from below'),
    ),
  );
}
