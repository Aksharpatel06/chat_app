import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';
import '../../../helper/firebase_database/chat_services.dart';
import '../../../modal/chat_modal.dart';
import '../../../modal/user_modal.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({
    super.key,
    required this.chatController,
    required this.user,
  });

  final ChatController chatController;
  final UserModal user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  ChatModal? chat;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatServices.chatServices.getLastChat(widget.user.email!),
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
        final list = queryData.map((e) => ChatModal(e.data())).toList();
        if (list.isNotEmpty) chat = list[0];

        // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(chat!.timestamp as int);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              widget.chatController.changeReceiverEmail(widget.user.email!,
                  widget.user.photoUrl!, widget.user.username!,widget.user.userToken!);
              Get.toNamed('/chat');
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.user.photoUrl!,
              ),
            ),
            title: Text(widget.user.username!),
            subtitle: Text(
              chat == null
                  ? ''
                  : chat!.message != null
                      ? chat!.message!
                      : 'hi',
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            trailing: chat == null
                ? null
                : !chat!.read
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 230, 119),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )
                    :
                    //message sent time
                    Text(
                        TimeOfDay.fromDateTime(chat!.timestamp!.toDate())
                            .format(context),
                        style: const TextStyle(color: Colors.black54),
                      ),
          ),
        );
      },
    );
  }
}
