import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../controller/sign_controller.dart';
import '../componects/continue_with_other_browser.dart';
import '../componects/text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(
                height: 45.h,
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
                'Sign up for free',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
               SizedBox(
                height: 20.h,
              ),
              SignTextField(
                hintText: 'User name',
                prefixIcon: const Icon(Icons.person_2_outlined),
                controller: signController,
                textEditingController: signController.txtUser,
              ),
              SignTextField(
                hintText: 'Email id',
                prefixIcon: const Icon(Icons.email_outlined),
                controller: signController,
                textEditingController: signController.txtCreateMail,
              ),
              SignTextField(
                hintText: 'Password ',
                prefixIcon: const Icon(Icons.password),
                controller: signController,
                textEditingController: signController.txtCreatePwd,
              ),
               SizedBox(
                height: 30.h,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 40.h),
                child: GestureDetector(
                  onTap: () async {
                    signController.validateInputs(signController.txtCreateMail,
                        signController.txtCreatePwd);
                    Fluttertoast.showToast(
                        msg: (signController.error.value.isNotEmpty ||
                                signController.pwd.value.isNotEmpty)
                            ? signController.error.value.isNotEmpty
                                ? signController.error.value
                                : signController.pwd.value
                            : 'SuccessFully Register',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:
                            (signController.error.value.isNotEmpty ||
                                    signController.pwd.value.isNotEmpty)
                                ? Colors.redAccent
                                : Colors.green.withOpacity(0.7),
                        textColor: Colors.white,
                        fontSize: 16.0);
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
                      'Sign Up',
                      style: TextStyle(fontSize: 17.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),
               SizedBox(
                height: 30.h,
              ),
              const ContinueWithOtherBrowser(
                sign: 'Sign In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
