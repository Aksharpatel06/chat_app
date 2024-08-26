import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/helper/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../helper/user_services.dart';
import '../../modal/user_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    ChatController chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Chatify',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8),
            child: Icon(Icons.qr_code_scanner),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8),
            child: Icon(Icons.camera_alt_outlined),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.more_vert),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: SizedBox(
              height: 50,
              child: SearchBar(
                hintText: 'search',
                trailing: Iterable.generate(
                  1,
                  (index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.search),
                  ),
                ),
                hintStyle: WidgetStatePropertyAll(
                    TextStyle(color: Colors.grey.shade400, fontSize: 19)),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StreamBuilder(
          stream: UserService.userSarvice.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var queryData = snapshot.data!.docs;
            List users = queryData.map((e) => e.data()).toList();
            List<UserModal> userList = users.map((e) => UserModal(e)).toList();
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    chatController.changeReceiverEmail(userList[index].email!,userList[index].photoUrl!);
                    Get.toNamed('/chat');
                  },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        userList[index].photoUrl!,
                      ),
                    ),
                    title: Text(userList[index].email!)),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 14),
        child: FloatingActionButton(
          onPressed: () {
            themeController.changeMode();
            GoogleFirebaseServices.googleFirebaseServices.emailLogout();

          },
          backgroundColor: Colors.green.shade500,
          child: const Icon(Icons.add_comment),
        ),
      ),
      bottomNavigationBar: Obx(
        () => StylishBottomBar(
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
      ),
    );
  }
}
