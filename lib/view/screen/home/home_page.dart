
import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../helper/firebase_database/user_services.dart';
import '../../modal/user_modal.dart';
import 'componects/bottom_navigation.dart';
import 'componects/chat_user_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    ChatController chatController = Get.find();

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                FutureBuilder(
                  future: UserService.userSarvice
                      .currentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const DrawerHeader(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return const DrawerHeader(
                        child: Center(child: Text('Error loading user data')),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const DrawerHeader(
                        child: Center(child: Text('No user data found')),
                      );
                    }

                    // Extract user data
                    final userData = snapshot.data!;
                    final userName = userData['username'] ?? 'User name';
                    final userEmail = userData['email'] ?? 'No email';
                    final userPhoto = userData['photoUrl'] ??
                        'https://via.placeholder.com/150';

                    return DrawerHeader(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28.r, // Responsive radius
                            backgroundImage: NetworkImage(userPhoto),
                          ),
                          SizedBox(height: 16.h), // Responsive height
                          Text(
                            userName,
                            // authController.userDetail['name'].toString(),
                            style: TextStyle(
                              fontSize: 20.sp, // Responsive font size
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            userEmail,
                            // authController.email.value,
                            style: TextStyle(
                              fontSize: 15.sp, // Responsive font size
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      size: 24.r,
                      color: Theme.of(context).colorScheme.primary,
                    ), // Responsive icon size
                    title: const Text('Home'), // Responsive font size
                    onTap: () {
                      Get.offNamed('/home');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(
                                'Do you change mode in app ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  themeController.changeMode();
                                  Navigator.pop(context);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: Icon(
                      Icons.mode,
                      size: 24.r,
                      color: Theme.of(context).colorScheme.primary,
                    ), // Responsive icon size
                    title:Text('Theme'), // Responsive font size
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: 24.r,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    // Responsive icon size
                    title: const Text('Setting'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25),
              child: ListTile(
                title: const Text('Logout'),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {
                  GoogleFirebaseServices.googleFirebaseServices.emailLogout();
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chatify',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25.sp,
            color: const Color(0xff31C48D),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8),
            child: Icon(Icons.qr_code_scanner),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Profile'),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ];
            },
          )
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
              itemBuilder: (context, index) => ChatUserCard(
                chatController: chatController,
                user: userList[index],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 14),
        child: FloatingActionButton(
          onPressed: () {
          },
          backgroundColor: Colors.green.shade500,
          child: const Icon(Icons.add_comment),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
          themeController: themeController, chatController: chatController),
    );
  }
}
