import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../controller/sign_controller.dart';
import '../../../helper/google_firebase_services.dart';

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();

    return Scaffold(
      body: Container(
        margin:  EdgeInsets.only(left: 25.h, right: 25.h),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/otp/img1.png',
                width: 150.w,
                height: 150.h,
              ),
               SizedBox(
                height: 25.h,
              ),
               Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 10.h,
              ),
               Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
               SizedBox(
                height: 30.h,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  signController.changeCode(value);
                },
                onCompleted: (pin) => print(pin),
              ),
               SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 45.h,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r))),
                    onPressed: () {
                      GoogleFirebaseServices.googleFirebaseServices
                          .mobileVarifaction(signController.code.value);
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Edit Phone Number ?",
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
