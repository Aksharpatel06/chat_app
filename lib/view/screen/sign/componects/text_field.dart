import 'package:flutter/material.dart';

import '../../../controller/sign_controller.dart';

class SignTextField extends StatelessWidget {
  final String hintText;
  final SignController controller;
  final TextEditingController textEditingController;
  final Icon prefixIcon;

  const SignTextField({
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
          obscureText: (hintText == 'Password')
              ? (!controller.isShowPwd.value)
                  ? true
                  : false
              : false,
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
