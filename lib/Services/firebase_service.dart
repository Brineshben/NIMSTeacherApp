// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/state_manager.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:teacherapp/View/Menu/drawer.dart';
//
// import '../main.dart';
//
// class FireBaseService extends GetxService {
//   //pre-config
//   final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     "notification_id_default",
//     "Default Notification",
//     description: '',
//     importance: Importance.max,
//     playSound: true,
//     enableVibration: true,
//   );
//
//   //init local notification
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   // FlutterLocalNotificationsPlugin();
//
// //Print Fcm Token
//   static Future<String?> fbToken() async {
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     print("Firebase tokken ================== $fcmToken");
//     return fcmToken;
//   }
//
//   //Display Notification
//   displayNotification(Map<String, dynamic> notification) {
//     print("=========Notification==========$notification");
//
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification['title'],
//       notification['message'],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           color: Colors.yellow,
//           importance: Importance.max,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//           enableVibration: true,
//         ),
//       ),
//       payload: json.encode(notification),
//     );
//   }
//
//   //Background
//   // Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
//   //   print("------gbfgb--------${message.data}");
//   //   RemoteNotification? notification = message.notification;
//   //   AndroidNotification? android = message.notification?.android;
//   //   if (notification != null && android != null) {
//   //     displayNotification(notification, message.data['sound']);
//   //   }
//   // }
//
//   // handleBackground() {
//   //   //BackGround Handler
//   //   print("--------hdgywedy-----");
//   //   FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
//   // }
//
//   handleForeground() {
//     //Foreground Handler
//     requestPermission();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("------message data--------${message.data}");
//       Map<String, dynamic>? notification = message.data;
//       displayNotification(notification);
//       // AndroidNotification? android = message.notification?.android;
//       // if (android != null) {
//       //   displayNotification(notification);
//       // }
//     });
//   }
//
//   Future<FireBaseService> init() async {
//     print('$runtimeType is ready!');
//
//     // await Firebase.initializeApp(
//     //   //options: DefaultFirebaseOptions.currentPlatform,
//     // );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     //
//     handleForeground();
//     //Token
//     //getToken();
//     return this;
//   }
//
//   Future<void> requestPermission() async {
//     // Check for Android permissions
//     if (Platform.isAndroid) {
//       var status = await Permission.notification.status;
//       // var audio = await Permission.audio.status;
//
//       if (status.isDenied) {
//         // Request notification permission
//         await Permission.notification.request();
//       }
//
//       // if (audio.isDenied) {
//       //   // Request audio permission
//       //   var result = await Permission.audio.request();
//       //   if (result.isGranted) {
//       //     print("Audio permission granted");
//       //   } else {
//       //     print("Audio permission denied");
//       //   }
//       // }
//     }
//
//     // Request permission for iOS
//     if (Platform.isIOS) {
//       final bool? result = await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(alert: true, badge: true, sound: true);
//       if (result == true) {
//         print("Permission granted");
//       } else {
//         print("Permission denied");
//       }
//     }
//   }
// }
