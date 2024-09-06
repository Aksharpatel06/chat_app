import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:chat_app/view/helper/firebase_database/user_services.dart';
import 'package:chat_app/view/modal/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../componects/continue_with_other_browser.dart';
import '../componects/text_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(
                height: 35.h,
              ),
              SizedBox(
                height: 175.h,
                child: Image.asset(
                  'asset/splash/Group 1.png',
                  fit: BoxFit.cover,
                ),
              ),
               SizedBox(
                height: 30.h,
              ),
               Text(
                'Sign in to your Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
               SizedBox(
                height: 30.h,
              ),
              SignTextField(
                hintText: 'Email id',
                prefixIcon: const Icon(Icons.email_outlined),
                controller: signController,
                textEditingController: signController.txtEmail,
              ),
              SignTextField(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.password),
                controller: signController,
                textEditingController: signController.txtPwd,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 50.h),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400),
                    )),
              ),
               SizedBox(
                height: 30.h,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 40.h),
                child: GestureDetector(
                  onTap: () {
                    GoogleFirebaseServices.googleFirebaseServices
                        .compareEmailAndPwd(signController.txtEmail.text,
                            signController.txtPwd.text);
                    Map userModal={
                      'username':signController.txtUser.text,
                      'email':signController.txtCreateMail.text
                    };

                    UserModal user = UserModal(userModal);
                    UserService.userSarvice.addUser(user);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                        color: const Color(0xff31C48D),
                        borderRadius: BorderRadius.circular(25.r)),
                    child:  Text(
                      'Sign In',
                      style: TextStyle(fontSize: 17.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),
               SizedBox(
                height: 35.h,
              ),
              const ContinueWithOtherBrowser(
                sign: 'Sign Up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
