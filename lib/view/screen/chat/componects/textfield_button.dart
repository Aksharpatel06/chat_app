import 'package:chat_app/view/helper/notification/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/firebase_database/chat_services.dart';
import '../../../helper/firebase_auth/google_firebase_services.dart';

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
              width: 292.w,
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
                              const Icon(Icons.attach_file),
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
                              const Icon(Icons.attach_file),
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
                  onPressed: () {
                    if (controller.txtChats.text.isNotEmpty) {
                      Map<String, dynamic> chat = {
                        'sender': GoogleFirebaseServices.googleFirebaseServices
                                .currentUser()!
                                .email ??
                            GoogleFirebaseServices.googleFirebaseServices
                                .currentUser()!
                                .phoneNumber!,
                        'receiver': controller.receiverEmail.value,
                        'message': controller.txtChats.text,
                        'timestamp': DateTime.now(),
                        'read': null,
                      };
                      ChatServices.chatServices.insertData(
                        chat,
                        controller.receiverEmail.value,
                      );

                      ApiService.apiService.sendMessage(
                          controller.currentLogin.value,
                          controller.txtChats.text,
                          controller.receiverToken.value);

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
