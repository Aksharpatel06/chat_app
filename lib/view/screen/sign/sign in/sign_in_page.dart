import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/colors.dart';
import '../componects/continue_with_other_browser.dart';
import '../componects/text_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();
    return Scaffold(
      // backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),

                // Welcome Text
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: CustomColors.primaryColor,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Sign in to continue your conversation',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: CustomColors.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 40.h),

                // Input Fields Container
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      SignTextField(
                        hintText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: CustomColors.secondaryColor,
                        ),
                        controller: signController,
                        textEditingController: signController.txtEmail,
                      ),

                      SizedBox(height: 15.h),

                      SignTextField(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: CustomColors.secondaryColor,
                        ),
                        controller: signController,
                        textEditingController: signController.txtPwd,
                      ),

                      SizedBox(height: 5.h),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Sign In Button
                      GestureDetector(
                        onTap: () {
                          GoogleFirebaseServices.googleFirebaseServices
                              .compareEmailAndPwd(
                            signController.txtEmail.text,
                            signController.txtPwd.text,
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
                              'Sign In',
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
                  sign: 'Sign Up',
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
