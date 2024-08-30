import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContinueWithOtherBrowser extends StatelessWidget {
  final String sign;

  const ContinueWithOtherBrowser({
    super.key,
    required this.sign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'Did You have an Account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: () {
                if (sign == 'Sign Up') {
                  Get.toNamed('/signup');
                } else {
                  Get.back();
                }
              },
              child: Text(
                sign,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: 18.sp,
                  color: Color(0xff31C48D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
         SizedBox(
          height: 30.h,
        ),
         Text(
          'Or continue with',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
         SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                String status = await GoogleFirebaseServices.googleFirebaseServices
                    .signInWithGoogle();
                Fluttertoast.showToast(msg: status);
                if (status == 'Suceess') {
                  Get.offAndToNamed('/home');

                }
              },
              child: Container(
                height: 50.h,
                width: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xffc5cdee).withOpacity(0.5),
                  image: const DecorationImage(
                    image: AssetImage('asset/sign in/google.png'),
                  ),
                ),
              ),
            ),
             SizedBox(
              width: 20.w,
            ),
            GestureDetector(
              onTap: () async {},
              child: Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xffc5cdee).withOpacity(0.5),
                  image: const DecorationImage(
                    image: AssetImage('asset/sign in/facebook.png'),
                  ),
                ),
              ),
            ),
             SizedBox(
              width: 20.w,
            ),
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color(0xffc5cdee).withOpacity(0.5),
                image: const DecorationImage(
                  image: AssetImage('asset/sign in/apple.png'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
