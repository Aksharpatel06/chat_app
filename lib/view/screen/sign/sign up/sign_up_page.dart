import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../controller/sign_controller.dart';
import '../componects/continue_with_other_browser.dart';
import '../componects/text_field.dart';

import '../../../../utils/colors.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),

                // Welcome Text
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: CustomColors.primaryColor,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Join us and start chatting today',
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
                    children: [
                      SignTextField(
                        hintText: 'Full Name',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: CustomColors.secondaryColor,
                        ),
                        controller: signController,
                        textEditingController: signController.txtUser,
                      ),

                      SizedBox(height: 15.h),

                      SignTextField(
                        hintText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: CustomColors.secondaryColor,
                        ),
                        controller: signController,
                        textEditingController: signController.txtCreateMail,
                      ),

                      SizedBox(height: 15.h),

                      SignTextField(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: CustomColors.secondaryColor,
                        ),
                        controller: signController,
                        textEditingController: signController.txtCreatePwd,
                      ),

                      SizedBox(height: 30.h),

                      // Sign Up Button
                      GestureDetector(
                        onTap: () async {
                          signController.validateInputs(
                            signController.txtCreateMail,
                            signController.txtCreatePwd,
                          );

                          // Enhanced Toast with custom colors
                          String message =
                              (signController.error.value.isNotEmpty ||
                                      signController.pwd.value.isNotEmpty)
                                  ? signController.error.value.isNotEmpty
                                      ? signController.error.value
                                      : signController.pwd.value
                                  : 'Successfully Registered!';

                          bool isError =
                              signController.error.value.isNotEmpty ||
                                  signController.pwd.value.isNotEmpty;

                          Fluttertoast.showToast(
                            msg: message,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: isError
                                ? CustomColors.errorColor
                                : CustomColors.successColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
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
                              'Create Account',
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

                SizedBox(height: 35.h),

                const ContinueWithOtherBrowser(
                  sign: 'Sign In',
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
