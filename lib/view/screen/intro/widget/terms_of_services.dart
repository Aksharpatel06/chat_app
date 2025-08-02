import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
                'Acceptance of Terms',
                'By accessing and using Chatify, you accept and agree to be bound by the terms and provision of this agreement.',
              ),
              _buildSection(
                'Use License',
                'Permission is granted to temporarily use Chatify for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
              ),
              _buildSection(
                'User Account',
                'You are responsible for safeguarding your account information and for all activities that occur under your account. You must notify us immediately of any unauthorized use.',
              ),
              _buildSection(
                'Prohibited Uses',
                'You may not use our service for any unlawful purpose, to transmit any harmful content, or to violate any laws in your jurisdiction.',
              ),
              _buildSection(
                'Content Guidelines',
                'Users are expected to communicate respectfully and refrain from sharing inappropriate, harmful, or offensive content through our platform.',
              ),
              _buildSection(
                'Service Availability',
                'We strive to keep Chatify available at all times, but we do not guarantee uninterrupted service and may suspend service for maintenance or updates.',
              ),
              _buildSection(
                'Termination',
                'We may terminate or suspend your account and access to the service immediately, without prior notice, for conduct that we believe violates these Terms.',
              ),
              _buildSection(
                'Changes to Terms',
                'We reserve the right to update these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms.',
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      // decoration: BoxDecoration(
      //   color: CustomColors.cardBackground,
      //   borderRadius: BorderRadius.circular(15.r),
      //   boxShadow: [
      //     BoxShadow(
      //       color: CustomColors.primaryColor.withOpacity(0.05),
      //       blurRadius: 10,
      //       offset: const Offset(0, 5),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 40.sp,
            color: CustomColors.secondaryColor,
          ),
          SizedBox(height: 15.h),
          Text(
            'Terms of Service',
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
      ),
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
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14.sp,
                color: CustomColors.primaryColor.withOpacity(0.7),
                height: 1.5,
              ),
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
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 24.sp,
            color: CustomColors.secondaryColor.withOpacity(0.7),
          ),
          SizedBox(height: 12.h),
          Text(
            'Questions about our Terms?',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Contact us at terms@chatify.com for any clarifications or concerns regarding these terms of service.',
            style: TextStyle(
              fontSize: 12.sp,
              color: CustomColors.primaryColor.withOpacity(0.6),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
