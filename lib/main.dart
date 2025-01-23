import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Services/fcm_service.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'Services/controller_handling.dart';
import 'Services/shared_preferences.dart';
import 'View/splash_screen.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Get.putAsync(() => FcmService().init());

  FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    statusBarIconBrightness: Brightness.light, // dark icons
    statusBarBrightness: Brightness.light, // iOS uses this property
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // await Get.putAsync(() => FcmService().init());
  // Get.put(() => FcmService().handleBackground());
  final sharedPrefs = SharedPrefs();
  await sharedPrefs.initialize();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  print("--------data---------${message.data}");
  String? sound = message.data['sound'];
  bool playSound = sound != null && sound.isNotEmpty;

  const String defaultChannelId = "notification_id_default";

  AndroidNotificationChannel defaultChannel = const AndroidNotificationChannel(
    defaultChannelId, // id
    'Default Notifications', // name
    description: '',
    importance: Importance.max,
    enableVibration: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(defaultChannel);

  String channelId = playSound ? 'notification_id_alarm' : defaultChannelId;

  // Prepare the notification
  Map<String, dynamic> notification = message.data;
  if (notification['title'] != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification['title'],
      notification['message'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'NotificationName', // Use a meaningful name here
          channelDescription: '',
          importance: Importance.max,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          playSound: playSound,
          sound: playSound ? RawResourceAndroidNotificationSound(sound) : null,
          icon: '@mipmap/ic_launcher',
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HandleControllers.createGetControllers();

    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) {
        return Center(
          child: SpinKitChasingDots(
            color: Colorutils.userdetailcolor,
            size: 28.w,
          ),
        );
      },
      child: ScreenUtilInit(
        designSize: const Size(430, 930),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          title: 'NIMS Teacher',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
