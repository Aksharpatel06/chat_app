import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/screen/chat/chat_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/user_services.dart';
import '../../modal/user_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
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
          stream: UserSarvice.userSarvice.getUser(),
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
              itemBuilder: (context, index) => ListTile(
                  leading: Image.network(
                    userList[index].photoUrl!,
                    fit: BoxFit.cover,
                  ),
                  title: Text(userList[index].email!)),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 14),
        child: FloatingActionButton(
          onPressed: () {
            themeController.changeMode();
          },
          backgroundColor: Colors.green.shade500,
          child: const Icon(Icons.add_comment),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(
          () => CurvedNavigationBar(
            backgroundColor: Colors.green.shade200,
            buttonBackgroundColor: Colors.green,
            color: themeController.themeMode.value == ThemeMode.dark
                ? Colors.black
                : Colors.white,
            items: const [
              Icon(Icons.chat_sharp),
              Icon(Icons.update),
              Icon(Icons.groups_2_outlined),
              Icon(Icons.call),
            ],
          ),
        ),
      ),
    );
  }
}
