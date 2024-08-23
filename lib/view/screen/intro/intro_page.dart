import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'asset/splash/Group 1.png',
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                const Text(
                  'Welcome to Chatify',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, wordSpacing: 2),
                    TextSpan(
                      children: [
                        TextSpan(text: 'Read our '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: Colors.blue)),
                        TextSpan(
                          text: '. Tap “Agree and Continue” to accept ',
                        ),
                        TextSpan(
                          text: 'Terms of Services.',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                GestureDetector(
                  onTap: () {
                    Get.offAndToNamed('/otp');
                  },
                  child: Container(
                    width: 300,
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
                      'Agree and Continue',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
