import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 60,
        elevation: 1,
        leading: const Row(
          children: [
            BackButton(),
            CircleAvatar(
              radius: 25,
            ),
          ],
        ),
        title: const Text(
          'Name',
          style: TextStyle(fontWeight: FontWeight.w600),
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
              child: Container(
            height: 500,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xff1e2829).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: controller.txtChats,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: const TextStyle(fontSize: 20),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                      suffixIcon: controller.txtChats.text.isEmpty
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.attach_file),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.photo_camera),
                                SizedBox(
                                  width: 10,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 4),
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () {},
                    child: controller.txtChats.text.isEmpty
                        ? const Icon(Icons.mic)
                        : const Icon(Icons.send),
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
