import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:chat_app/view/helper/firebase_database/chat_services.dart';
import 'package:chat_app/view/modal/chat_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/colors.dart';
import '../../../controller/chat_controller.dart';
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

class _ChatUserCardState extends State<ChatUserCard>
    with TickerProviderStateMixin {
  ChatModal? chat;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: StreamBuilder(
        stream: ChatServices.chatServices.getLastChat(widget.user.email!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorCard();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard();
          }
          var queryData = snapshot.data!.docs;
          final list = queryData.map((e) => ChatModal(e.data())).toList();
          if (list.isNotEmpty) chat = list[0];
          return _buildChatCard(context);
        },
      ),
    );
  }

  Widget _buildChatCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : CustomColors
                .cardBackground, // Use CustomColors.cardBackground for light mode
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.shade200, // Keep grey for subtle border
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          widget.chatController.changeReceiverEmail(
            widget.user.email!,
            widget.user.photoUrl!,
            widget.user.username!,
            widget.user.userToken!,
          );
          Get.toNamed('/chat');
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              _buildUserAvatar(),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserName(),
                    SizedBox(height: 6.h),
                    _buildLastMessage(),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              _buildTrailingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: NetworkImage(widget.user.photoUrl!),
          backgroundColor:
              Colors.grey.shade200, // Keep neutral grey for avatar background
        ),
        if (widget.user.isOnline ?? false)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: CustomColors.onlineColor, // Use CustomColors.onlineColor
                shape: BoxShape.circle,
                border: Border.all(
                    color: CustomColors.cardBackground,
                    width: 2.5), // Border matches card background
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserName() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.user.username!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.color, // Keep theme text color for adaptability
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.user.isOnline ?? false)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: CustomColors.onlineColor, // Use CustomColors.onlineColor
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Online',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLastMessage() {
    String messageText = chat?.message ?? 'Say hello to start chatting! 👋';
    final hasUnreadMessage = chat != null && !chat!.read;
    return Text(
      messageText,
      style: TextStyle(
        fontSize: 14.sp,
        color: hasUnreadMessage
            ? Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color // Keep theme text color for adaptability
            : Colors.grey.shade600, // Keep grey for subtle text
        fontWeight: hasUnreadMessage ? FontWeight.w500 : FontWeight.w400,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTrailingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chat != null) _buildMessageTime(context),
        SizedBox(height: 8.h),
        _buildMessageStatus(),
      ],
    );
  }

  Widget _buildMessageTime(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Keep grey for subtle background
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        TimeOfDay.fromDateTime(chat!.timestamp!.toDate()).format(context),
        style: TextStyle(
          fontSize: 11.sp,
          color: Colors.grey.shade600, // Keep grey for subtle text
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageStatus() {
    if (chat == null) {
      return SizedBox(width: 20.w, height: 20.h);
    }
    if (!chat!.read &&
        chat!.sender !=
            GoogleFirebaseServices.googleFirebaseServices
                .currentUser()!
                .email) {
      return Container(
        width: 20.w,
        height: 20.h,
        decoration: const BoxDecoration(
          color: CustomColors.unreadColor, // Use CustomColors.unreadColor
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: CustomColors.unreadColor
            .withOpacity(0.1), // Use CustomColors.unreadColor
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.done_all_rounded,
        size: 14.r,
        color: CustomColors.unreadColor, // Use CustomColors.unreadColor
      ),
    );
  }

  Widget _buildLoadingCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : CustomColors
                .cardBackground, // Use CustomColors.cardBackground for light mode
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Keep grey for subtle shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors
                    .grey.shade200, // Keep neutral grey for loading avatar
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors
                          .unreadColor, // Using unreadColor for loading indicator as it was blue in original
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.grey
                          .shade200, // Keep neutral grey for loading text placeholder
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.grey
                          .shade200, // Keep neutral grey for loading text placeholder
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3), // Specific error background color
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFFF6B6B)
              .withOpacity(0.3), // Specific error border color
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B)
                    .withOpacity(0.1), // Specific error icon background
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFFF6B6B), // Specific error icon color
                size: 20.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                'Unable to load chat data',
                style: TextStyle(
                  color: const Color(0xFFFF6B6B), // Specific error text color
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
