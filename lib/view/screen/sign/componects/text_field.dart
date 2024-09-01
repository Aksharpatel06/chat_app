import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/sign_controller.dart';

class SignTextField extends StatelessWidget {
  final String hintText;
  final SignController controller;
  final TextEditingController textEditingController;
  final Icon prefixIcon;

  const SignTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 35.h, vertical: 10.h),
      child: Obx(
        ()=> Container(
          height: 50.h,
          width: double.infinity,
          padding:  EdgeInsets.only(left: 5.h),
          child: TextField(
            controller: textEditingController,
            obscureText: (hintText == 'Password')
                ? (!controller.isShowPwd.value)
                    ? true
                    : false
                : false,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)
              ),
              filled: true,
              fillColor: themeController.isTextFiledColor.value,
              prefixIcon: prefixIcon,
              suffixIcon: (hintText == 'Password')
                  ? InkWell(
                      onTap: () {
                        controller.showPassword();
                      },
                      child: (!controller.isShowPwd.value)
                          ? const Icon(Icons.remove_red_eye_sharp)
                          : const Icon(Icons.visibility_off))
                  : null,
              hintText: hintText,
              contentPadding:  EdgeInsets.only(top: 12.h),
            ),
          ),
        ),
      ),
    );
  }
}
