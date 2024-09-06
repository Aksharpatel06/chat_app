import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:chat_app/view/screen/home/home_page.dart';
import 'package:chat_app/view/screen/intro/intro_page.dart';
import 'package:chat_app/view/screen/otp/mobile/otp_page.dart';
import 'package:chat_app/view/screen/otp/verify/otp_verify_page.dart';
import 'package:chat_app/view/screen/sign/sign%20in/sign_in_page.dart';
import 'package:chat_app/view/screen/sign/sign%20up/sign_up_page.dart';
import 'package:chat_app/view/screen/splash/splash_page.dart';
import 'package:get/get.dart';

List<GetPage> getPages =[
  GetPage(
    name: '/',
    page: () => const SplashPage(),
  ),
  GetPage(
    name: '/intro',
    page: () =>
    GoogleFirebaseServices.googleFirebaseServices.currentUser() !=
        null
        ? const HomePage()
        : const IntroPage(),
  ),
  GetPage(
    name: '/signin',
    page: () => const SignInPage(),
  ),
  GetPage(
    name: '/signup',
    page: () => const SignUpPage(),
  ),
  GetPage(
    name: '/otp',
    page: () => const OtpPage(),
  ),
  GetPage(
    name: '/otpAdd',
    page: () => const OtpVerifyPage(),
  ),
  GetPage(
    name: '/home',
    page: () => const HomePage(),
  ),
  GetPage(
    name: '/chat',
    page: () => const ChatPage(),
  ),
];