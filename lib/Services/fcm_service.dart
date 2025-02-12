import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class FcmService extends GetxService {
  //pre-config
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification_id', // id
    'NotificationName', // name
    description: '',
    importance: Importance.max,
    // playSound: true,
    // sound: RawResourceAndroidNotificationSound("alarm"),
    enableVibration: true,
  );

  //init local notification
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();

//Print Fcm Token
  Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print(token);
    return token;
  }

  //Display Notification
  displayNotification(Map<String, dynamic> notification) async {
    print("Sound parameter: ${notification['sound']}"); // Debug print
    print("=========Notification==========$notification");

    // Determine if the sound should be played
    bool playSound = notification['sound'] != null && notification['sound'].isNotEmpty; // Play sound only if it is "alarm"
    String channelId = 'notification_id_${notification['sound'] ?? 'default'}';

    if(notification['title'] != null) {
      int notiId = notification.hashCode;
      if(notification['category'] == 'chat') {
        notiId = "${notification['class']}${notification['batch']}${notification['subject_Id']}".hashCode;
        await removeNotificationWithPayload(notiId);
      }
      flutterLocalNotificationsPlugin.show(
        notiId,
        notification['title'],
        notification['message'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channel.name,
            color: Colors.yellow,
            importance: Importance.max,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            playSound: playSound, // Use the boolean value to set this
            sound: playSound ? RawResourceAndroidNotificationSound(notification['sound']) : null,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            fullScreenIntent: true,
            styleInformation: BigTextStyleInformation(
              notification['message'] ?? '',
              htmlFormatBigText: true,
              contentTitle: notification['title'] ?? '',
              htmlFormatContentTitle: true,
              // summaryText: "Swipe down to see more",
              htmlFormatSummaryText: true,
            ),
          ),
        ),
        payload: json.encode(notification),
      );
    }
  }

  Future<void> removeNotificationWithPayload(int targetMessageId) async {
    final List<ActiveNotification> activeNotifications =
    await flutterLocalNotificationsPlugin.getActiveNotifications();

    for (var notification in activeNotifications) {
      if (notification.id == targetMessageId) {
        await flutterLocalNotificationsPlugin.cancel(notification.id ?? 0);
        break;
      }
    }
  }


  //Background
  // Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  //   print("------gbfgb--------${message.data}");
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     displayNotification(notification, message.data['sound']);
  //   }
  // }

  // handleBackground() {
  //   //BackGround Handler
  //   print("--------hdgywedy-----");
  //   FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  // }

  handleForeground() {
    //Foreground Handler
    requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("------gbfgb--------${message.toMap()}");
      Map<String, dynamic>? notification = message.data;
      displayNotification(notification);
      // AndroidNotification? android = message.notification?.android;
      // if (android != null) {
      //   displayNotification(notification);
      // }
    });
  }

  Future<FcmService> init() async {
    print('$runtimeType is ready!');

    // await Firebase.initializeApp(
    //   //options: DefaultFirebaseOptions.currentPlatform,
    // );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    //
    handleForeground();
    //Token
    //getToken();
    return this;
  }

  Future<void> requestPermission() async {
    // Check for Android permissions
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      // var audio = await Permission.audio.status;

      if (status.isDenied) {
        // Request notification permission
        await Permission.notification.request();
      }

      // if (audio.isDenied) {
      //   // Request audio permission
      //   var result = await Permission.audio.request();
      //   if (result.isGranted) {
      //     print("Audio permission granted");
      //   } else {
      //     print("Audio permission denied");
      //   }
      // }
    }

    // Request permission for iOS
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
          alert: true, badge: true, sound: true);
      if (result == true) {
        print("Permission granted");
      } else {
        print("Permission denied");
      }
    }
  }
}