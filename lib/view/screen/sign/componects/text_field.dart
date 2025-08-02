import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/sign_controller.dart';

import '../../../../utils/colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: CustomColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: (hintText.toLowerCase().contains('password'))
            ? !controller.isShowPwd.value
            : false,
        obscuringCharacter: '●',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: CustomColors.primaryColor,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.backgroundColor.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.secondaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          filled: true,
          fillColor: CustomColors.textColor.withOpacity(0.3),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Icon(
              prefixIcon.icon,
              color: CustomColors.secondaryColor,
              size: 22.sp,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 50.w,
          ),
          suffixIcon: (hintText.toLowerCase().contains('password'))
              ? Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Obx(
                    () => IconButton(
                      onPressed: () {
                        controller.showPassword();
                      },
                      icon: Icon(
                        !controller.isShowPwd.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: CustomColors.secondaryColor,
                        size: 22.sp,
                      ),
                    ),
                  ),
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            // color: CustomColors.primaryColor.withOpacity(0.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
          ),
        ),
      ),
    );
  }
}
