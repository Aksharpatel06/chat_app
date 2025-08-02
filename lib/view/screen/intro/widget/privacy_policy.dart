import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: CustomColors.primaryColor,
            size: 20.sp,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 30.h),
              _buildSection(
                'Information We Collect',
                'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.',
              ),
              _buildSection(
                'How We Use Your Information',
                'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.',
              ),
              _buildSection(
                'Information Sharing',
                'We do not sell, trade, or rent your personal information to third parties. We may share your information only in specific circumstances outlined in this policy.',
              ),
              _buildSection(
                'Data Security',
                'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
              ),
              _buildSection(
                'Your Rights',
                'You have the right to access, update, or delete your personal information. You may also opt out of certain communications from us.',
              ),
              _buildSection(
                'Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at privacy@chatify.com',
              ),
              SizedBox(height: 20.h),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.privacy_tip_outlined,
          size: 40.sp,
          color: CustomColors.secondaryColor,
        ),
        SizedBox(height: 15.h),
        Text(
          'Your Privacy Matters',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        Text(
          'Last updated: January 2025',
          style: TextStyle(
            fontSize: 14.sp,
            color: CustomColors.primaryColor.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      // decoration: BoxDecoration(
      //   color: CustomColors.cardBackground,
      //   borderRadius: BorderRadius.circular(12.r),
      //   border: Border.all(
      //     color: CustomColors.primaryColor.withOpacity(0.1),
      //     width: 1,
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: CustomColors.primaryColor.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      // decoration: BoxDecoration(
      //   color: CustomColors.cardBackground,
      //   borderRadius: BorderRadius.circular(12.r),
      //   border: Border.all(
      //     color: CustomColors.secondaryColor.withOpacity(0.2),
      //     width: 1,
      //   ),
      // ),
      child: Text(
        'This Privacy Policy is effective as of the date stated above and will remain in effect except with respect to any changes in its provisions in the future.',
        style: TextStyle(
          fontSize: 12.sp,
          color: CustomColors.primaryColor.withOpacity(0.5),
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
