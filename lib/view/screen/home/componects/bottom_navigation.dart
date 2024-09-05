import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../controller/chat_controller.dart';
import '../../../controller/theme_controller.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.themeController,
    required this.chatController,
  });

  final ThemeController themeController;
  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => StylishBottomBar(
        backgroundColor: themeController.isTextFiledColor.value,
        option: DotBarOptions(
          dotStyle: DotStyle.tile,
          gradient: const LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.pink,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.chat_sharp,
            ),
            selectedIcon: const Icon(Icons.chat_sharp),
            selectedColor: Colors.teal,
            unSelectedColor: Colors.grey,
            title: const Text('Chats'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.update),
            selectedIcon: const Icon(Icons.update),
            selectedColor: Colors.red,
            title: const Text('Updates'),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.groups_2_outlined,
              ),
              selectedIcon: const Icon(
                Icons.groups_2_outlined,
              ),
              selectedColor: Colors.deepOrangeAccent,
              title: const Text('Communities')),
          BottomBarItem(
            icon: const Icon(
              Icons.call,
            ),
            selectedIcon: const Icon(
              Icons.call,
            ),
            selectedColor: Colors.deepPurple,
            title: const Text('Calls'),
          ),
        ],
        hasNotch: true,
        // backgroundColor: ,
        currentIndex: chatController.bottomIndex.value,
        notchStyle: NotchStyle.square,
        onTap: (index) {
          chatController.changeBottomIndex(index);
        },
      ),
    );
  }
}
