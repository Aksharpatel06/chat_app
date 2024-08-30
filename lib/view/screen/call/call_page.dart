// // import 'package:chat_app/view/controller/chat_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// // import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// //
// // class CallPage extends StatefulWidget {
// //   const CallPage({super.key});
// //
// //   @override
// //   _CallPageState createState() => _CallPageState();
// // }
// //
// // class _CallPageState extends State<CallPage> {
// //   late ChatController controller = Get.find();
// //
// //   // @override
// //   // void initState() {
// //   //   super.initState();
// //   //
// //   //   // Initialize the controller
// //   //   // controller = Get.find<ChatController>();
// //   //
// //   //   // Initialize ZegoUIKitPrebuiltCallInvitationService
// //   //   ZegoUIKitPrebuiltCallInvitationService().init(
// //   //     appID: 1452532973, // Replace with your AppID
// //   //     appSign: "46ec325594bc72046c41c5d757e1bc8f7b0827947967526d2e283e48ccc7241f", // Replace with your AppSign
// //   //     userID: 'User${controller.receiverEmail.value}', // Replace with the current user's ID
// //   //     userName: controller.receiverEmail.value.toString(), // Replace with the current user's name
// //   //     plugins: [ZegoUIKitSignalingPlugin()],
// //   //   );
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // return Container();
// //     return Obx(
// //           () => ZegoUIKitPrebuiltCall(
// //         appID: 1452532973,
// //         appSign: "46ec325594bc72046c41c5d757e1bc8f7b0827947967526d2e283e48ccc7241f",
// //         userID: 'User${controller.receiverEmail.value}',
// //         userName: controller.receiverEmail.value.toString(),
// //         plugins: [ZegoUIKitSignalingPlugin()],
// //         callID: controller.callId.value,
// //         config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     ZegoUIKitPrebuiltCallInvitationService().uninit();
// //     super.dispose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";
//
// import '../../controller/chat_controller.dart';
//
// class CallPage extends StatelessWidget {
//    const CallPage({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     ChatController controller = Get.find();
//     return ZegoUIKitPrebuiltCall(
//       callID: controller.callId.value,
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//       appID: 1452532973,
//       appSign:
//       "46ec325594bc72046c41c5d757e1bc8f7b0827947967526d2e283e48ccc7241f",
//       userID: 'User${controller.receiverEmail.value}',
//       userName: controller.receiverEmail.value,
//       plugins: [ZegoUIKitSignalingPlugin()],
//       // child: child, // Include the passed child widget
//     );
//   }
// }
