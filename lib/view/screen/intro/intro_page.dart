import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginOptionsPage extends StatelessWidget {
  const LoginOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 40.h),
                    _buildLoginButtons(),
                    SizedBox(height: 30.h),
                    _buildDivider(),
                    SizedBox(height: 30.h),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome To Chatify',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Choose your preferred login method',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(20.r),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.1),
      //       blurRadius: 15,
      //       offset: const Offset(0, 5),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          _buildLoginButton(
            title: 'Login with Mobile',
            icon: Icons.phone_android_outlined,
            color: CustomColors.secondaryColor,
            onTap: () => Get.toNamed('/otp'),
          ),
          SizedBox(height: 15.h),
          _buildLoginWIthEmailButton(
            title: 'Login with Email',
            icon: Icons.email_outlined,
            color: CustomColors.secondaryColor,
            onTap: () => Get.toNamed('/signin'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.sp),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginWIthEmailButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: CustomColors.textColor,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
          side: BorderSide(
            color: CustomColors.primaryColor,
          ),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22.sp,
            color: color,
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: CustomColors.primaryColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            'OR',
            style: TextStyle(
                color: CustomColors.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Divider(color: CustomColors.primaryColor)),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        TextButton(
          onPressed: () => Get.toNamed('/signup'),
          child: Text(
            "Don't have an account? Sign Up",
            style: TextStyle(
              color: CustomColors.backgroundColor,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text.rich(
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12, wordSpacing: 2, color: CustomColors.textColor),
            TextSpan(
              children: [
                const TextSpan(text: 'Read our '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => Get.toNamed('/privacy'),
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: CustomColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const TextSpan(
                  text: '. Tap “Agree and Continue” to accept ',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => Get.toNamed('/services'),
                    child: const Text(
                      'Terms of Services.',
                      style: TextStyle(
                        color: CustomColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
