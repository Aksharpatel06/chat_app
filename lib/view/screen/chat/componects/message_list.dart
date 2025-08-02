import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/colors.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../helper/firebase_database/chat_services.dart';
import '../../../modal/chat_modal.dart';

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
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: chatList.length,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final message = chatList[index];
        final isMe = controller.currentLogin.value == message.sender;

        // Mark message as read
        if (!message.read &&
            message.receiver == controller.currentLogin.value) {
          ChatServices.chatServices.updateMessageReadStatus(
              controller.receiverEmail.value, chatsId[index]);
        }

        return _buildMessageBubble(context, message, isMe, index);
      },
    );
  }

  Widget _buildMessageBubble(
      BuildContext context, ChatModal message, bool isMe, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(),
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showMessageDialog(context, message, index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(message, isMe),
                    SizedBox(height: 4.h),
                    _buildMessageInfo(message, isMe),
                  ],
                ),
              ),
            ),
          ),
          if (isMe) _buildAvatar(isMe: true),
        ],
      ),
    );
  }

  Widget _buildAvatar({bool isMe = false}) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMe ? CustomColors.primaryColor : CustomColors.secondaryColor,
      ),
      child: Icon(
        Icons.person,
        color: CustomColors.textColor,
        size: 18.sp,
      ),
    );
  }

  Widget _buildMessageContent(ChatModal message, bool isMe) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280.w),
      decoration: BoxDecoration(
        color: isMe ? CustomColors.primaryColor : CustomColors.secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 18.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: message.isImage
            ? _buildImageMessage(message)
            : _buildTextMessage(message),
      ),
    );
  }

  Widget _buildTextMessage(ChatModal message) {
    return Text(
      message.message ?? '',
      style: TextStyle(
        fontSize: 15.sp,
        color: CustomColors.textColor,
        height: 1.3,
      ),
    );
  }

  Widget _buildImageMessage(ChatModal message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl: message.message ?? '',
        width: 200.w,
        height: 200.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 200.w,
          height: 200.h,
          color: CustomColors.backgroundColor.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 200.w,
          height: 200.h,
          color: CustomColors.backgroundColor.withOpacity(0.5),
          child: Icon(
            Icons.error_outline,
            color: CustomColors.primaryColor,
            size: 32.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInfo(ChatModal message, bool isMe) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            TimeOfDay.fromDateTime(message.timestamp!.toDate())
                .format(Get.context!),
            style: TextStyle(
              fontSize: 11.sp,
              color: CustomColors.primaryColor.withOpacity(0.8),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 4.w),
            Icon(
              message.read ? Icons.done_all : Icons.done,
              color: message.read
                  ? CustomColors.textColor
                  : CustomColors.primaryColor.withOpacity(0.6),
              size: 14.sp,
            ),
          ],
        ],
      ),
    );
  }

  void _showMessageDialog(BuildContext context, ChatModal message, int index) {
    if (message.sender != controller.currentLogin.value) return;
    controller.txtEditChats = TextEditingController(text: message.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Message Options',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!message.isImage)
              _buildDialogOption(
                icon: Icons.edit,
                title: 'Edit Message',
                color: CustomColors.secondaryColor,
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, index);
                },
              ),
            SizedBox(height: 8.h),
            _buildDialogOption(
              icon: Icons.delete,
              title: 'Delete Message',
              color: Colors.red.shade600,
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, message, index);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: CustomColors.primaryColor.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: CustomColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Edit Message',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryColor,
          ),
        ),
        content: TextField(
          controller: controller.txtEditChats,
          maxLines: 3,
          style: TextStyle(color: CustomColors.primaryColor),
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle:
                TextStyle(color: CustomColors.primaryColor.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: CustomColors.secondaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  BorderSide(color: CustomColors.primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.all(12.w),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: CustomColors.primaryColor.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ChatServices.chatServices.updateChat(
                controller.txtEditChats.text,
                chatsId[index],
                controller.receiverEmail.value,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.secondaryColor,
              foregroundColor: CustomColors.textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Save',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ChatModal message, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Message',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryColor,
          ),
        ),
        content: Text(
          message.isImage
              ? 'Are you sure you want to delete this image?'
              : 'Are you sure you want to delete this message?',
          style: TextStyle(
            fontSize: 14.sp,
            color: CustomColors.primaryColor.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: CustomColors.primaryColor.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ChatServices.chatServices.deleteChat(
                chatsId[index],
                controller.receiverEmail.value,
                message.isImage,
                imagePath: message.message ?? '',
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated loading widget with custom colors
class MessageLoadingWidget extends StatelessWidget {
  const MessageLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: index.isEven
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Container(
                    width: 200.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
