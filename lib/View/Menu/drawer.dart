import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/chatClassGroupController.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Controller/home_controller/home_controller.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import 'package:teacherapp/Models/api_models/chat_group_api_model.dart';
import 'package:teacherapp/View/Chat_View/feed_view_chat_screen.dart';
import 'package:teacherapp/View/Menu/layer_dummy.dart';
import 'package:teacherapp/View/Menu/main_page.dart';
import '../../main.dart';
import 'menu_page.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  Future<void> setupInteractedMessage() async {

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!);
            RemoteMessage message = RemoteMessage(data: data);
            _handleMessage(message);
          } catch (e) {
            print("Error decoding notification payload: $e");
          }
        }
      },
    );
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data['category'] == 'student_tracking') {
      Get.find<PageIndexController>().message.value = message;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DrawerScreen()),
              (route) => false);
      if (Get.find<PageIndexController>().navLength.value == 4) {
        Get.find<HomeController>().currentIndex.value = 3;
        Get.find<PageIndexController>().changePage(currentPage: 3);
      } else if (Get.find<PageIndexController>().navLength.value == 5) {
        Get.find<HomeController>().currentIndex.value = 4;
        Get.find<PageIndexController>().changePage(currentPage: 4);
      }
    } else if (message.data['category'] == 'chat') {
      print("push Notification data ----------------------- ${message.data}");
      if(Get.find<PageIndexController>().message.value == null) {
        Get.find<PageIndexController>().message.value = message;
        if(Get.find<HomeController>().currentIndex.value == 2) {
          Get.find<HomeController>().currentIndex.value = 0;
          Get.find<PageIndexController>().changePage(currentPage: 0);
        }

        await Future.wait([
          Get.delete<FeedViewController>().then((_) => Get.lazyPut(() => FeedViewController())),
          Get.delete<ChatClassGroupController>().then((_) => Get.lazyPut(() => ChatClassGroupController())),
          Get.delete<ParentChatListController>().then((_) => Get.lazyPut(() => ParentChatListController())),
        ]);

        Get.find<HomeController>().currentIndex.value = 2;
        Get.find<PageIndexController>().changePage(currentPage: 2);

        if(Get.find<PageIndexController>().isChatScreen.value) {
          Navigator.pushReplacement(
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
        } else {
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
