import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/chatClassGroupController.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Controller/home_controller/home_controller.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import 'package:teacherapp/Models/api_models/HierarchyModel.dart';
import 'package:teacherapp/Models/api_models/chat_group_api_model.dart';
import 'package:teacherapp/Services/controller_handling.dart';
import 'package:teacherapp/Services/firebase_service.dart';
import 'package:teacherapp/View/Chat_List/chat_list.dart';
import 'package:teacherapp/View/Chat_View/feed_view%20_chat_screen.dart';
import 'package:teacherapp/View/Menu/layer_dummy.dart';
import 'package:teacherapp/View/Menu/main_page.dart';
import 'menu_page.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// @pragma('vm:entry-point')
// Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
//   print("--------data---------${message.data}");
//
//   const String defaultChannelId = "notification_id_default";
//
//   AndroidNotificationChannel defaultChannel = const AndroidNotificationChannel(
//     defaultChannelId, // id
//     'Default Notifications', // name
//     description: '',
//     importance: Importance.max,
//     enableVibration: true,
//   );
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(defaultChannel);
//
//   // Prepare the notification
//   Map<String, dynamic> notification = message.data;
//   flutterLocalNotificationsPlugin.show(
//     notification.hashCode,
//     notification['title'],
//     notification['message'],
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         defaultChannelId,
//         'Background Notification',
//         channelDescription: '',
//         importance: Importance.max,
//         playSound: true,
//         enableVibration: true,
//         icon: '@mipmap/ic_launcher',
//       ),
//     ),
//     payload: json.encode(notification),
//   );
// }
//
// Future<void> _handleMessageOnTap(NotificationResponse message, BuildContext context) async {
//   print("-----message----${message.payload}");
//
//   Map<String, dynamic> data = json.decode(message.payload!);
//   print("-----message----${data['class']}");
//
//   if (data['category'] == "chat") {
//     // HandleControllers.deleteAllGetControllers();
//     // HandleControllers.createGetControllers();
//     Get.delete<FeedViewController>();
//     Get.put(FeedViewController());
//     Get.delete<ChatClassGroupController>();
//     Get.put(ChatClassGroupController());
//     Get.delete<ParentChatListController>();
//     Get.put(ParentChatListController());
//
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => DrawerScreen()),
//         (route) => false);
//     Get.find<HomeController>().currentIndex.value = 2;
//     Get.find<PageIndexController>().changePage(currentPage: 2);
//
//     // Navigator.of(context).push(MaterialPageRoute(
//     //   builder: (context) => DrawerScreen(),
//     // ));
//
//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => const ChatWithParentsPage(),
//     //     ));
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FeedViewChatScreen(
//           msgData: ClassTeacherGroup(
//             classTeacherClass: data['class'],
//             batch: data['batch'],
//             subjectId: data['subject_Id'],
//             subjectName: data['subject'],
//           ),
//         ),
//       ),
//     );
//
//     // studentClass: data['class'],
//     //   batch: data['batch'],
//     //   subId: data['subject_Id'],
//     //   subName: data['subject'],
//     //   teacherId: data['teacher_id'],
//     //   teacherImage: data['teacher_image'],
//     //   teacherName: data['teacher_name'],
//     //   isGroup: data['subject_Id'] == "class_group" ? true : false,
//   }
// }
//
// Future<void> _handleMessage(RemoteMessage message, BuildContext context) async {
//   print("-----message----${message.data}");
//
//   Map<String, dynamic> data = message.data;
//   print("-----message----${data['class']}");
//
//   if (data['category'] == "chat") {
//     // HandleControllers.deleteAllGetControllers();
//     // HandleControllers.createGetControllers();
//     Get.delete<FeedViewController>();
//     Get.put(FeedViewController());
//     Get.delete<ChatClassGroupController>();
//     Get.put(ChatClassGroupController());
//     Get.delete<ParentChatListController>();
//     Get.put(ParentChatListController());
//
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => DrawerScreen()),
//         (route) => false);
//     Get.find<HomeController>().currentIndex.value = 2;
//     Get.find<PageIndexController>().changePage(currentPage: 2);
//
//     // Navigator.of(context).push(MaterialPageRoute(
//     //   builder: (context) => DrawerScreen(),
//     // ));
//
//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => const ChatWithParentsPage(),
//     //     ));
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FeedViewChatScreen(
//           msgData: ClassTeacherGroup(
//             classTeacherClass: data['class'],
//             batch: data['batch'],
//             subjectId: data['subject_Id'],
//             subjectName: data['subject'],
//           ),
//         ),
//       ),
//     );
//
//     // studentClass: data['class'],
//     //   batch: data['batch'],
//     //   subId: data['subject_Id'],
//     //   subName: data['subject'],
//     //   teacherId: data['teacher_id'],
//     //   teacherImage: data['teacher_image'],
//     //   teacherName: data['teacher_name'],
//     //   isGroup: data['subject_Id'] == "class_group" ? true : false,
//   }
// }
//
// Future<void> setupInteractedMessage(BuildContext context) async {
//   RemoteMessage? initialMessage =
//       await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null) {
//     _handleMessage(initialMessage, context);
//   }
//   FirebaseMessaging.onMessageOpenedApp.listen(
//     (event) {
//       _handleMessage(event, context);
//     },
//   );
// }

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    print("rebuild -------------------------- ");
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) async {
    //     // print(
    //     //     "firebase token ----------------------- ${await FireBaseService.fbToken()}");
    //     FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    //     await Get.putAsync(() => FireBaseService().init());
    //
    //     flutterLocalNotificationsPlugin.initialize(
    //       const InitializationSettings(
    //         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    //       ),
    //       onDidReceiveNotificationResponse: (NotificationResponse response) {
    //         if (response.payload != null) {
    //           _handleMessageOnTap(response, context);
    //         }
    //       },
    //       onDidReceiveBackgroundNotificationResponse:
    //           (NotificationResponse response) {
    //         if (response.payload != null) {
    //           _handleMessageOnTap(response, context);
    //         }
    //       },
    //     );
    //
    //     await setupInteractedMessage(context);
    //   },
    // );
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF118376),
            Color(0xFF067B6D),
            Color(0xFF138376),
          ],
        ),
      ),
      child: ZoomDrawer(
        controller: _drawerController,
        menuScreenWidth: double.infinity,
        style: DrawerStyle.defaultStyle,
        menuScreen: const MenuScreen(),
        mainScreen: const MainScreen(),
        borderRadius: 28.0,
        showShadow: true,
        drawerShadowsBackgroundColor: Colors.grey,
        angle: 0,
        mainScreenScale: 0.5,
        drawerStyleBuilder:
            (context, percentOpen, slideWidth, menuScreen, mainScreen) {
          double slide = (slideWidth * 0.8) * percentOpen;
          double layerSlide = (slideWidth * 0.6) * percentOpen;
          double scaleFactor = 1.0 - (percentOpen * 0.3);
          double layerScaleFactor = 1.0 - (percentOpen * 0.4);
          return Stack(
            children: [
              menuScreen,
              Transform(
                transform: Matrix4.identity()
                  ..translate(layerSlide, 0, 0)
                  ..scale(layerScaleFactor, layerScaleFactor, 1.0),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30).w,
                  child: Stack(
                    children: [
                      const ChatWithParentsDummyLayer(),
                      Container(
                        color: Colors.teal.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(slide, 0, 0)
                  ..scale(scaleFactor, scaleFactor, 1.0),
                alignment: Alignment.center,
                child: mainScreen,
              ),
            ],
          );
        },
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        shadowLayer2Color: Colors.transparent,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.easeInBack,
      ),
    );
  }
}
