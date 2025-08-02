import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../utils/colors.dart';
import '../../../controller/sign_controller.dart';
import '../../../helper/firebase_auth/google_firebase_services.dart';

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.find();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),

                // Image Container with modern styling
                Container(
                  height: 160.h,
                  width: 160.w,
                  padding: EdgeInsets.all(25.w),
                  // decoration: BoxDecoration(
                  //   color: CustomColors.cardBackground,
                  //   borderRadius: BorderRadius.circular(40.r),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: CustomColors.primaryColor.withOpacity(0.1),
                  //       blurRadius: 25,
                  //       offset: const Offset(0, 15),
                  //     ),
                  //   ],
                  // ),
                  child: Image.asset(
                    'asset/otp/img1.png',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 40.h),

                // Title
                Text(
                  "Phone Verification",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryColor,
                  ),
                ),

                SizedBox(height: 12.h),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "We need to register your phone number to get started!",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: CustomColors.secondaryColor,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // OTP Input Container
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 25.w),
                  // decoration: BoxDecoration(
                  //   color: CustomColors.cardBackground,
                  //   borderRadius: BorderRadius.circular(25.r),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: CustomColors.primaryColor.withOpacity(0.08),
                  //       blurRadius: 25,
                  //       offset: const Offset(0, 15),
                  //     ),
                  //   ],
                  // ),
                  child: Column(
                    children: [
                      Text(
                        "Enter OTP Code",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryColor,
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // Custom Pinput styling
                      Pinput(
                        length: 6,
                        showCursor: true,
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onChanged: (value) {
                          signController.changeCode(value);
                        },
                        onCompleted: (pin) => print(pin),
                        defaultPinTheme: PinTheme(
                          width: 50.w,
                          height: 55.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryColor,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.textColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color:
                                  CustomColors.backgroundColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 50.w,
                          height: 55.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryColor,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.textColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: CustomColors.secondaryColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CustomColors.secondaryColor
                                    .withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          width: 50.w,
                          height: 55.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.textColor,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.secondaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: CustomColors.secondaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // Verify Button
                      Container(
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
                              color: CustomColors.primaryColor.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27.r),
                            ),
                          ),
                          onPressed: () {
                            GoogleFirebaseServices.googleFirebaseServices
                                .mobileVarifaction(signController.code.value);
                          },
                          child: Text(
                            "Verify Phone Number",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Phone Number Button
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18.sp,
                        color: CustomColors.secondaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Edit Phone Number?",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
