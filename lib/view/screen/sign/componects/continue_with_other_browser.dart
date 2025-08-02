import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/colors.dart';

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
        // Account Question and Sign Up/In Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sign == 'Sign Up'
                  ? "Don't have an account? "
                  : "Already have an account? ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: CustomColors.primaryColor.withOpacity(0.7),
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
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                sign,
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

        SizedBox(height: 35.h),

        // Divider with "Or continue with" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: CustomColors.primaryColor.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.primaryColor.withOpacity(0.6),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: CustomColors.primaryColor.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 25.h),

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Sign In
            _buildSocialButton(
              onTap: () async {
                String status = await GoogleFirebaseServices
                    .googleFirebaseServices
                    .signInWithGoogle();
                if (status == 'Success') {
                  Get.offAndToNamed('/home');
                }
              },
              assetPath: 'asset/sign in/google.png',
              isActive: true,
            ),

            SizedBox(width: 20.w),

            // Facebook Sign In (Inactive)
            _buildSocialButton(
              onTap: () async {
                // Facebook login implementation
              },
              assetPath: 'asset/sign in/facebook.png',
              isActive: false,
            ),

            SizedBox(width: 20.w),

            // Apple Sign In (Inactive)
            _buildSocialButton(
              onTap: () async {
                // Apple login implementation
              },
              assetPath: 'asset/sign in/apple.png',
              isActive: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String assetPath,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55.h,
        width: 55.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: isActive
              ? CustomColors.cardBackground
              : CustomColors.cardBackground.withOpacity(0.5),
          border: Border.all(
            color: isActive
                ? CustomColors.secondaryColor.withOpacity(0.3)
                : CustomColors.primaryColor.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: CustomColors.primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Image.asset(
            assetPath,
            color: isActive ? null : Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
