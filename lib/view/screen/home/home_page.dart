import 'package:chat_app/view/controller/chat_controller.dart';
import 'package:chat_app/view/controller/theme_controller.dart';
import 'package:chat_app/view/helper/firebase_auth/google_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/colors.dart';
import '../../helper/firebase_database/user_services.dart';
import '../../modal/user_modal.dart';
import 'componects/chat_user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    UserService.userSarvice..updateUserToken();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Handle scroll events if needed
  }

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: _buildModernDrawer(context, themeController),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildModernAppBar(context),
            ];
          },
          body: _buildUserList(),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 105.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor:
          Colors.transparent, // Transparent to show scaffold background
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context)
              .colorScheme
              .onSurface, // Use theme color for icon
          size: 20.r,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isCollapsed = constraints.maxHeight < 105.h;
          if (isCollapsed) {
            return FlexibleSpaceBar(
              title: SizedBox(height: 40, child: _buildSearchSection()),
              centerTitle: true,
              titlePadding: const EdgeInsets.fromLTRB(32.0, 8.0, 0.0, 8.0),
              collapseMode: CollapseMode.pin,
            );
          }
          return FlexibleSpaceBar(
            expandedTitleScale: context.isLandscape ? 1.0 : 1.2,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Chatify',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: CustomColors
                          .primaryColor, // Use CustomColors.primaryColor for title
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(height: 40, child: _buildSearchSection()),
              ],
            ),
            centerTitle: true,
            titlePadding: EdgeInsets.zero,
            collapseMode: CollapseMode.pin,
          );
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim().toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by name or email...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 20.r,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade500,
                    size: 20.r,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context)
              .colorScheme
              .surfaceVariant
              .withOpacity(0.5), // Use theme color for search bar background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    ChatController chatController = Get.find();
    return FutureBuilder(
        future: UserService.userSarvice.currentUser(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          return StreamBuilder(
            stream: UserService.userSarvice.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildErrorState(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }
              var queryData = snapshot.data!.docs;
              List users = queryData.map((e) => e.data()).toList();
              List<UserModal> userList =
                  users.map((e) => UserModal(e)).toList();

              // Filter users based on search query
              if (_searchQuery.isNotEmpty) {
                userList = userList.where((user) {
                  final username = user.username?.toLowerCase() ?? '';
                  final email = user.email?.toLowerCase() ?? '';
                  return username.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();
              } else {
                userList = userList.where((user) {
                  // Exclude the current user from the list
                  return asyncSnapshot.data!['userFriends']
                          .toString()
                          .contains(user.email ?? '') ||
                      asyncSnapshot.data!['userFriends']
                          .toString()
                          .contains(user.username ?? '');
                }).toList();
              }
              // Sort users - online first
              userList.sort((a, b) {
                if (a.isOnline == b.isOnline) {
                  return (a.username ?? '').compareTo(b.username ?? '');
                }
                return a.isOnline! ? -1 : 1;
              });
              if (userList.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.separated(
                padding: EdgeInsets.all(12.w),
                itemCount: userList.length,
                separatorBuilder: (context, index) => SizedBox(height: 5.h),
                itemBuilder: (context, index) => ChatUserCard(
                  chatController: chatController,
                  user: userList[index],
                ),
              );
            },
          );
        });
  }

  Widget _buildModernDrawer(
      BuildContext context, ThemeController themeController) {
    return Drawer(
      backgroundColor: Theme.of(context)
          .canvasColor, // Use theme canvas color for drawer background
      child: SafeArea(
        child: Column(
          children: [
            _buildSimpleHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildSimpleItem(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () => Get.offNamed('/home'),
                    ),
                    _buildSimpleItem(
                      icon: Icons.dark_mode,
                      title: 'Change Mode',
                      onTap: () =>
                          _showSimpleThemeDialog(context, themeController),
                    ),
                    _buildSimpleItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        // Settings functionality
                      },
                    ),
                    _buildSimpleItem(
                      icon: Icons.help,
                      title: 'Help',
                      onTap: () {
                        // Help functionality
                      },
                    ),
                    const Spacer(),
                    _buildSimpleItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        GoogleFirebaseServices.googleFirebaseServices
                            .emailLogout();
                      },
                      isLogout: true,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: FutureBuilder(
        future: UserService.userSarvice.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildHeaderSkeleton();
          }
          final userData = snapshot.data ?? {};
          final userName = userData['username'] ?? 'User';
          final userEmail = userData['email'] ?? 'user@example.com';
          final userPhoto = userData['photoUrl'] ?? '';
          return Column(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    userPhoto.isNotEmpty ? NetworkImage(userPhoto) : null,
                child: userPhoto.isEmpty
                    ? Icon(Icons.person,
                        size: 32.r, color: Colors.grey.shade600)
                    : null,
              ),
              SizedBox(height: 16.h),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.color, // Use theme text color
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: 120.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 160.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22.r,
                  color: isLogout
                      ? Colors.red.shade600
                      : Theme.of(context)
                          .colorScheme
                          .onSurface, // Use theme color for icons
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isLogout
                        ? Colors.red.shade600
                        : Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color, // Use theme text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: SizedBox(
        height: 200.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                CustomColors.primaryColor), // Use CustomColors.primaryColor
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 32.r,
              color: Colors.red.shade400,
            ),
            SizedBox(height: 12.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 32.r,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12.h),
            Text(
              'No conversations',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start chatting to see conversations here',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showSimpleThemeDialog(
      BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Change Theme',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'Switch between light and dark mode',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              themeController.changeMode();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  CustomColors.primaryColor, // Use CustomColors.primaryColor
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
