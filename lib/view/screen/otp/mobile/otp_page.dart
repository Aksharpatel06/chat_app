import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    SignController signController = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
              ),
              Image.asset(
                'asset/splash/Group 1.png',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 100.h,
              ),
              Text(
                'Sign in to your Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 35.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: const Text(
                        'Phone Number',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Container(
                        height: 50.h,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 5.h),
                        decoration: BoxDecoration(
                            color: themeController.isTextFiledColor.value,
                            borderRadius: BorderRadius.circular(50.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.h,
                            ),
                            SizedBox(
                              width: 40.h,
                              child: TextField(
                                controller: signController.countryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 33.sp, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            Expanded(
                                child: TextField(
                              onChanged: (value) {
                                signController.phone.value = value;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 5.h),
                child: Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: signController.remember.value,
                        onChanged: (value) {
                          signController.changeRemember(value!);
                        },
                      ),
                    ),
                    const Text('Remember me')
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.h),
                child: GestureDetector(
                  onTap: () {
                    GoogleFirebaseServices.googleFirebaseServices.mobileUser(
                        signController.phone.value,
                        signController.countryController.text);
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
                    child: Text(
                      'Send the otp',
                      style: TextStyle(fontSize: 17.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'do you login with',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/signin');
                    },
                    child: Text(
                      'Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xff31C48D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
