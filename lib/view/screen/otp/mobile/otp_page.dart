import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../sign/componects/text_field.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Phone Verification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: CustomColors.primaryColor,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Enter your details to continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: CustomColors.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 35.h),

                // Input Fields Container
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username Field
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryColor,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      SignTextField(
                        hintText: 'Enter your username',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: CustomColors.secondaryColor,
                        ),
                        controller: signController,
                        textEditingController: signController.txtUserName,
                      ),

                      SizedBox(height: 20.h),

                      // Phone Number Field
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryColor,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CustomColors.primaryColor.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: CustomColors.textColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color:
                                  CustomColors.backgroundColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Country Code
                              Container(
                                width: 80.w,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: TextField(
                                  controller: signController.countryController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '+91',
                                  ),
                                ),
                              ),

                              // Divider
                              Container(
                                height: 30.h,
                                width: 1.5,
                                color:
                                    CustomColors.primaryColor.withOpacity(0.8),
                              ),

                              // Phone Number
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: TextField(
                                    onChanged: (value) {
                                      signController.phone.value = value;
                                    },
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.primaryColor,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter phone number",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Remember Me Checkbox
                      Row(
                        children: [
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return CustomColors.secondaryColor;
                                        }
                                        return Colors.transparent;
                                      },
                                    ),
                                    checkColor: MaterialStateProperty.all(
                                        CustomColors.textColor),
                                    side: BorderSide(
                                      color: CustomColors.secondaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Checkbox(
                                  value: signController.remember.value,
                                  onChanged: (value) {
                                    signController.changeRemember(value!);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),

                      // Send OTP Button
                      GestureDetector(
                        onTap: () {
                          GoogleFirebaseServices.googleFirebaseServices
                              .mobileUser(
                            signController.phone.value,
                            signController.countryController.text,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.primaryColor,
                                CustomColors.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(27.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    CustomColors.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: CustomColors.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Login with Email Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Want to login with ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: CustomColors.primaryColor.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signin');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Email?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: CustomColors.secondaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
