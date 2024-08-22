import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignController signController = Get.put(SignController());
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            Image.asset(
              'asset/splash/Group 1.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 45,
            ),
            const Text(
              'Sign in to your Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SignInTextField(
              hintText: 'Email id',
              prefixIcon: const Icon(Icons.email_outlined),
              controller: signController,
              textEditingController: signController.txtEmail,
            ),
            SignInTextField(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.password),
              controller: signController,
              textEditingController: signController.txtPwd,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade400),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: GestureDetector(
                onTap: () {
                  Get.offAndToNamed('/home');
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
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
                      borderRadius: BorderRadius.circular(25)),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Did You have an Account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' Sign up ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff31C48D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Or continue with',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // String status = await GoogleSignInSarvice.googleSignInSarvice
                        //     .signInWithGoogle();
                        // Fluttertoast.showToast(msg: status);
                        // if (status == 'Suceess') {
                        //   Get.to(const HomeScreen());
                        //   if (account == 'Already have an account') {
                        //     controller.getUserDetails();
                        //   }
                        //   User? user = GoogleSignInSarvice.googleSignInSarvice.currentUser();
                        //   Map m1={
                        //     'name':user!.displayName,
                        //     'email':user.email,
                        //   };
                        //
                        //   DetailsModal details = DetailsModal(m1);
                        //   UserSarvice.userSarvice.addUser(details);
                        // }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffc5cdee).withOpacity(0.5),
                          image: const DecorationImage(
                            image: AssetImage('asset/sign in/google.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // String status = await FacebookSignIn.facebookSignIn
                        //     .signInWithFacebook();
                        // Fluttertoast.showToast(msg: status);
                        // if (status == 'Success') {
                        //   Get.to(const HomeScreen());
                        //   if (account == 'Already have an account') {
                        //     controller.getUserDetails();
                        //   }
                        //   User? user = FacebookSignIn.facebookSignIn.currentUser();
                        //   Map m1={
                        //     'name':user!.displayName,
                        //     'email':user.email,
                        //   };
                        //
                        //   DetailsModal details = DetailsModal(m1);
                        //   UserSarvice.userSarvice.addUser(details);
                        // }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffc5cdee).withOpacity(0.5),
                          image: const DecorationImage(
                            image: AssetImage('asset/sign in/facebook.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffc5cdee).withOpacity(0.5),
                        image: const DecorationImage(
                          image: AssetImage('asset/sign in/apple.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignInTextField extends StatelessWidget {
  final String hintText;
  final SignController controller;
  final TextEditingController textEditingController;
  final Icon prefixIcon;

  const SignInTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            color: const Color(0xffF0F0F0),
            borderRadius: BorderRadius.circular(50)),
        child: TextField(
          controller: textEditingController,
          obscureText: (!controller.isShowPwd.value) ? true : false,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: (hintText == 'Password')
                ? InkWell(
                    onTap: () {
                      controller.showPassword();
                    },
                    child: (!controller.isShowPwd.value)
                        ? const Icon(Icons.remove_red_eye_sharp)
                        : const Icon(Icons.visibility_off))
                : null,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 12),
          ),
        ),
      ),
    );
  }
}
