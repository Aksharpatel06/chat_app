import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import '../../controller/theme_controller.dart';
import '../../modal/chat_modal.dart';
import '../../helper/firebase_database/chat_services.dart';
import 'componects/message_list.dart';
import 'componects/textfield_button.dart';

class CustomColors {
  static const Color primaryColor = Color(0xFF3E5F44);
  static const Color secondaryColor = Color(0xFF5E936C);
  static const Color backgroundColor = Color(0xFF93DA97);
  static const Color textColor = Color(0xFFE8FFD7);
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    final ChatController controller = Get.find();

    return Scaffold(
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          Expanded(
            child: _buildChatContent(controller, themeController),
          ),
          _buildInputSection(controller),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatController controller) {
    return AppBar(
      backgroundColor: CustomColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back,
          color: CustomColors.textColor,
          size: 24.sp,
        ),
      ),
      title: Row(
        children: [
          _buildUserAvatar(controller),
          SizedBox(width: 12.w),
          Expanded(child: _buildUserInfo(controller)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showMoreOptions(),
          icon: Icon(
            Icons.videocam,
            color: CustomColors.textColor,
            size: 24.sp,
          ),
        ),
        IconButton(
          onPressed: () => _showMoreOptions(),
          icon: Icon(
            Icons.call,
            color: CustomColors.textColor,
            size: 24.sp,
          ),
        ),
        IconButton(
          onPressed: () => _showMoreOptions(),
          icon: Icon(
            Icons.more_vert,
            color: CustomColors.textColor,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(ChatController controller) {
    return Obx(
      () => Stack(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.secondaryColor,
            ),
            child: ClipOval(
              child: controller.receiverImageUrl.value.isNotEmpty
                  ? Image.network(
                      controller.receiverImageUrl.value,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: CustomColors.textColor,
                        size: 20.sp,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: CustomColors.textColor,
                      size: 20.sp,
                    ),
            ),
          ),
          if (_isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CustomColors.textColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(ChatController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.receiverUserNameUrl.value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: CustomColors.textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _isOnline ? 'Online' : 'Last seen recently',
            style: TextStyle(
              fontSize: 12.sp,
              color: CustomColors.textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent(
      ChatController controller, ThemeController themeController) {
    return Obx(
      () => StreamBuilder(
        stream: ChatServices.chatServices.getChat(
          controller.receiverEmail.value,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          var queryData = snapshot.data!.docs;
          List chats = queryData.map((e) => e.data()).toList();
          List chatsId = queryData.map((e) => e.id).toList().reversed.toList();
          List<ChatModal> chatList =
              chats.map((e) => ChatModal(e)).toList().reversed.toList();

          if (chatList.isEmpty) {
            return _buildEmptyState();
          }

          return MessageList(
            chatList: chatList,
            controller: controller,
            chatsId: chatsId,
            theme: themeController,
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: CustomColors.primaryColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading messages...',
            style: TextStyle(
              fontSize: 16.sp,
              color: CustomColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: CustomColors.secondaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: CustomColors.primaryColor,
              size: 30.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 14.sp,
              color: CustomColors.primaryColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              foregroundColor: CustomColors.textColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              'Retry',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: CustomColors.secondaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: CustomColors.primaryColor,
              size: 50.sp,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start a conversation by sending\nyour first message',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: CustomColors.primaryColor.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(ChatController controller) {
    return ModernMessageInputField(controller: controller);
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: CustomColors.textColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: CustomColors.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            _buildMoreOption(
              icon: Icons.person,
              title: 'View Profile',
              onTap: () {},
            ),
            _buildMoreOption(
              icon: Icons.search,
              title: 'Search Messages',
              onTap: () {},
            ),
            _buildMoreOption(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {},
            ),
            _buildMoreOption(
              icon: Icons.block,
              title: 'Block Contact',
              color: Colors.red,
              onTap: () {},
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: (color ?? CustomColors.primaryColor).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color ?? CustomColors.primaryColor,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: CustomColors.primaryColor,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
