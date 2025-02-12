
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import '../../Controller/api_controllers/chatClassGroupController.dart';
import '../../Controller/api_controllers/feedViewController.dart';
import '../../Controller/api_controllers/parentChatListController.dart';
import '../../Controller/home_controller/home_controller.dart';
import '../../Models/api_models/chat_group_api_model.dart';
import '../../Utils/constants.dart';
import '../../main.dart';
import '../Chat_View/feed_view _chat_screen.dart';
import '../Home_Page/Home_Widgets/bottom_navigationbar.dart';
import 'drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // Widget getScreen({required int pageIndex}) {
  //   switch(pageIndex) {
  //     case 0: return const Homepage();
  //     case 2: return const ChatWithParentsPage();
  //     case 8: return const Leader();
  //     default: return const Homepage();
  //   }
  // }

  Future<void> setupInteractedMessage() async {
    final initialMessage = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (initialMessage?.didNotificationLaunchApp ?? false) {
      if (initialMessage?.notificationResponse?.payload != null) {
        RemoteMessage message = RemoteMessage(
          data: json.decode(initialMessage!.notificationResponse!.payload!),
        );
        await _handleMessage(message);
      }
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data['category'] == 'student_tracking') {
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const DrawerScreen()),
      //         (route) => false);
      if (Get.find<PageIndexController>().navLength.value == 4) {
        Get.find<HomeController>().currentIndex.value = 3;
        Get.find<PageIndexController>().changePage(currentPage: 3);
      } else if (Get.find<PageIndexController>().navLength.value == 5) {
        Get.find<HomeController>().currentIndex.value = 4;
        Get.find<PageIndexController>().changePage(currentPage: 4);
      }
    } else if (message.data['category'] == 'chat') {
      print("push Notification data ----------------------- ${message.data}");
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const DrawerScreen()),
      //         (route) => false);

      await Future.wait([
        Get.delete<FeedViewController>().then((_) => Get.lazyPut(() => FeedViewController())),
        Get.delete<ChatClassGroupController>().then((_) => Get.lazyPut(() => ChatClassGroupController())),
        Get.delete<ParentChatListController>().then((_) => Get.lazyPut(() => ParentChatListController())),
      ]);

      Get.find<HomeController>().currentIndex.value = 2;
      Get.find<PageIndexController>().changePage(currentPage: 2);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedViewChatScreen(
            msgData: ClassTeacherGroup(
              classTeacherClass: message.data['class'],
              batch: message.data['batch'],
              subjectId: message.data['subject_Id'],
              subjectName: message.data['subject'],
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupInteractedMessage();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleDark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetX<PageIndexController>(
            builder: (PageIndexController controller) {
              return controller.menuItemsPerRole[controller.pageIndex.value].page;
              // return getScreen(
              //     pageIndex: controller.pageIndex.value,
              // );
            },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
