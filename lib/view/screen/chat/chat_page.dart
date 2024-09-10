import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/modal/chat_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../helper/firebase_database/chat_services.dart';
import 'componects/message_list.dart';
import 'componects/textfield_button.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    final ChatController controller = Get.find();
    // String lastMessageId = "";
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100.w,
        toolbarHeight: 60.h,
        elevation: 1,
        leading: Row(
          children: [
             BackButton(
              onPressed: () {
                // controller.isImage.value = false;
                // controller.imgPath!.value.delete();
              },
            ),
            Obx(
              () => CircleAvatar(
                radius: 21.r,
                backgroundImage: NetworkImage(
                  controller.receiverImageUrl.value,
                ),
              ),
            ),
          ],
        ),
        title: Obx(
          () => Text(
            controller.receiverUserNameUrl.value,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 8),
              child: Icon(Icons.add_call),
            ),
          ),
          const Padding(
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

                  return MessageList(
                    chatList: chatList,
                    controller: controller,
                    chatsId: chatsId,
                    theme: themeController,
                  );
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
