import 'dart:io';
import 'package:chat_app/utils/colors.dart' show CustomColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/chat_controller.dart';
import '../../../helper/firebase_database/chat_services.dart';

class ModernMessageInputField extends StatefulWidget {
  const ModernMessageInputField({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  State<ModernMessageInputField> createState() =>
      _ModernMessageInputFieldState();
}

class _ModernMessageInputFieldState extends State<ModernMessageInputField> {
  bool _showAttachments = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showAttachments) _buildAttachmentOptions(),
        _buildMainInputRow(),
      ],
    );
  }

  Widget _buildMainInputRow() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _buildMessageInput()),
          SizedBox(width: 12.w),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 50.h,
        maxHeight: 120.h,
      ),
      decoration: BoxDecoration(
        color: CustomColors.textColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: CustomColors.secondaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Obx(() => widget.controller.imagePath.value.path.isNotEmpty
          ? _buildImagePreview()
          : _buildTextInput()),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 100.h,
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: FileImage(widget.controller.imagePath.value),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () => widget.controller.changeImagePath(File('')),
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return TextField(
      controller: widget.controller.txtChats,
      onChanged: (value) => widget.controller.changeMessage(value),
      maxLines: null,
      style: TextStyle(
        fontSize: 16.sp,
        color: CustomColors.primaryColor,
        height: 1.4,
      ),
      decoration: InputDecoration(
        hintText: 'Type a message...',
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: CustomColors.primaryColor.withOpacity(0.5),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 15.h,
        ),
        suffixIcon: _buildAttachmentButton(),
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAttachments = !_showAttachments;
          });
        },
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: CustomColors.secondaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _showAttachments ? Icons.close : Icons.attach_file,
            color: CustomColors.textColor,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Obx(
      () => GestureDetector(
        onTap: widget.controller.chatMessage.value.isNotEmpty ||
                widget.controller.imagePath.value.path.isNotEmpty
            ? _sendMessage
            : null,
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: widget.controller.chatMessage.value.isNotEmpty ||
                    widget.controller.imagePath.value.path.isNotEmpty
                ? CustomColors.primaryColor
                : CustomColors.primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.send,
            color: CustomColors.textColor,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOptions() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: Icons.camera_alt,
            label: 'Camera',
            onTap: () => _handleAttachment('camera'),
          ),
          _buildAttachmentOption(
            icon: Icons.photo,
            label: 'Gallery',
            onTap: () => _handleAttachment('gallery'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: CustomColors.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: CustomColors.textColor,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: CustomColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    try {
      if (widget.controller.txtChats.text.isEmpty &&
          widget.controller.imagePath.value.path.isNotEmpty) {
        // Send image
        String messageContent = await ChatServices.chatServices
            .uploadImageToFirebase(widget.controller.receiverEmail.value,
                widget.controller.imagePath.value.path);

        Map<String, dynamic> chat = {
          'sender': widget.controller.currentLogin.value,
          'receiver': widget.controller.receiverEmail.value,
          'message': messageContent,
          'timestamp': DateTime.now(),
          'read': null,
          'isImage': true,
        };

        ChatServices.chatServices.insertData(
          chat,
          widget.controller.receiverEmail.value,
        );

        widget.controller.changeImagePath(File(''));
      } else if (widget.controller.txtChats.text.isNotEmpty) {
        // Send text message
        String messageContent = widget.controller.txtChats.text;
        Map<String, dynamic> chat = {
          'sender': widget.controller.currentLogin.value,
          'receiver': widget.controller.receiverEmail.value,
          'message': messageContent,
          'timestamp': DateTime.now(),
          'read': null,
          'isImage': false,
        };

        ChatServices.chatServices.insertData(
          chat,
          widget.controller.receiverEmail.value,
        );

        widget.controller.txtChats.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _handleAttachment(String type) {
    setState(() {
      _showAttachments = false;
    });

    switch (type) {
      case 'camera':
        _pickImage(ImageSource.camera);
        break;
      case 'gallery':
        _pickImage(ImageSource.gallery);
        break;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? imageFile = await _imagePicker.pickImage(source: source);
    if (imageFile != null) {
      widget.controller.changeImagePath(File(imageFile.path));
    }
  }
}

// Simple typing indicator
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: CustomColors.secondaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Typing...',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: CustomColors.primaryColor,
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 20.w,
                  height: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: const BoxDecoration(
                          color: CustomColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
