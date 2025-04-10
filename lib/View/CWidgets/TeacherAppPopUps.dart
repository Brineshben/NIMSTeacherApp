import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/db_controller/Feed_db_controller.dart';
import 'package:teacherapp/Services/shared_preferences.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/Login_page/login.dart';

import '../../Controller/api_controllers/LearningwalkSubmit.dart';
import '../../Controller/ui_controllers/page_controller.dart';
import '../../Services/api_services.dart';
import '../../Services/controller_handling.dart';
import '../MorePage/Hodclinic/TrackingPageHod.dart';

class TeacherAppPopUps {
  UserAuthController userAuthController = Get.find<UserAuthController>();
  static final TeacherAppPopUps _instance = TeacherAppPopUps._internal();

  TeacherAppPopUps._internal();

  factory TeacherAppPopUps() {
    return _instance;
  }

  static submitFailed({
    String? title,
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Column(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 50.w,
            ),
            if (title != null) SizedBox(height: 10.w),
            if (title != null)
              Text(
                title,
                style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                  color: Colors.black,
                ),
              ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionName,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static submitFailedTwoBack({
    String? title,
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Column(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 50.w,
            ),
            if (title != null) SizedBox(height: 10.w),
            if (title != null)
              Text(
                title,
                style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                  color: Colors.black,
                ),
              ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionName,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static submitFailedThreeLearningBack({
    String? title,
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Column(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 50.w,
              ),
              if (title != null) SizedBox(height: 10.w),
              if (title != null)
                Text(
                  title,
                  style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    actionName,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static submitFailedTwoBackforupdate({
    String? title,
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop:  false,
        child: AlertDialog(
          
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Column(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 50.w,
              ),
              if (title != null) SizedBox(height: 10.w),
              if (title != null)
                Text(
                  title,
                  style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    actionName,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Trackingpop({
    String? title,
    required String message,
    required String actionName,
    required Color iconColor,
    required String timeText,
    required String image,
    required String sendername,
  }) {
    return Get.dialog(
      Padding(
        padding: EdgeInsets.zero, // Removes side padding

        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          // Removes inset padding
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),

          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      child: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset("assets/images/walinglogo.svg")),
              if (title != null) SizedBox(height: 10.w),
              if (title != null)
                Text(
                  title,
                  style:
                      TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Avatar (Lucas)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90.h),
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) => CircleAvatar(
                                radius: 25.r,
                                backgroundColor:
                                    Colorutils.chatcolor.withOpacity(0.1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      "assets/images/profileOne.svg"),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 25.r,
                                backgroundColor:
                                    Colorutils.chatcolor.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      "assets/images/profileOne.svg"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dashed Line with Time Text in the Middle

                  SizedBox(
                    width: 210,
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: <Color>[
                              Colorutils.popcolor1,
                              Colorutils.popcolor2
                            ],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: SvgPicture.asset(
                          "assets/images/Line 224.svg",
                          color: Colors.white, // Set a default color here
                        ),
                      ),
                    ),
                  ),
                  // Right Avatar (You)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Colorutils.chatcolor.withOpacity(0.3),
                          radius: 18,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                                "assets/images/profileOne.svg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(sendername,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 10)),
                    ),
                    const Text("You",
                        style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),

          actionsAlignment: MainAxisAlignment.center,
          actions: [
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(TrackingpageHod());
                // PageIndexController pageSwitchController =
                //     Get.find<PageIndexController>();
                // pageSwitchController.changePage(
                //     currentPage: pageSwitchController.navLength.value - 1);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 45,
                decoration: BoxDecoration(
                    color: Colorutils.userdetailcolor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    actionName,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            )
            // FilledButton(
            //   onPressed: () {
            //     Get.back();
            //
            //   },
            //   style: ButtonStyle(
            //
            //     backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         actionName,
            //         style: TextStyle(color: Colors.white, fontSize: 16.sp),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  static Trackingpoplate({
    String? title,
    required String message,
    required String actionName,
    required Color iconColor,
    required String timeText,
    required String image,
    required String sendername,
  }) {
    return Get.dialog(
      Padding(
        padding: EdgeInsets.zero,
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          // Removes inset padding

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          title: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        child: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset("assets/images/Warning.png")),
                if (title != null) SizedBox(height: 10.w),
                if (title != null)
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Avatar (Lucas)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90.h),
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) => CircleAvatar(
                                radius: 25.r,
                                backgroundColor:
                                    Colorutils.chatcolor.withOpacity(0.1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      "assets/images/profileOne.svg"),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 25.r,
                                backgroundColor:
                                    Colorutils.chatcolor.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      "assets/images/profileOne.svg"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dashed Line with Time Text in the Middle

                  SizedBox(
                    width: 210,
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: <Color>[Colorutils.red, Colorutils.white],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: SvgPicture.asset(
                          "assets/images/Line red.svg",
                          color: Colors.white, // Set a default color here
                        ),
                      ),
                    ),
                  ),
                  // Right Avatar (You)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Colorutils.chatcolor.withOpacity(0.3),
                          radius: 18,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                                "assets/images/profileOne.svg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(sendername,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 10)),
                    ),
                    const Text("You",
                        style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(const TrackingpageHod());

                // PageIndexController pageSwitchController =
                // Get.find<PageIndexController>();
                // pageSwitchController.changePage(
                //     currentPage: pageSwitchController.navLength.value - 1);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 45,
                decoration: BoxDecoration(
                    color: Colorutils.userdetailcolor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    actionName,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            )
            // FilledButton(
            //   onPressed: () {
            //     Get.back();
            //
            //   },
            //   style: ButtonStyle(
            //
            //     backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         actionName,
            //         style: TextStyle(color: Colors.white, fontSize: 16.sp),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  static submitFailedThreeBack({
    String? title,
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
    required bool fromScan,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Column(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 50.w,
            ),
            if (title != null) SizedBox(height: 10.w),
            if (title != null)
              Text(
                title,
                style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                  color: Colors.black,
                ),
              ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionName,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    ).then(
      (value) {
        if (fromScan) {
          Get.back();
        } else {
          Get.back();
          Get.back();
        }
      },
    );
  }

  static logOutPopUp({required BuildContext context}) {
        SpringlishController springlishController =  Get.find<SpringlishController>();
    return Get.dialog(
      barrierDismissible:  false,
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Column(
          children: [
            SizedBox(height: 10.w),
            Text(
              "Logout",
              style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to Logout?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                          height: 45.0.h,
                  width: 108.w,
                  child: Obx(()=> FilledButton( 
                    
                    onPressed:  springlishController.lououtbool.value?null:() async {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),),
                ),
                SizedBox(
                  height: 45.h,
                  width: 108.w,
                  child: Obx(()=>FilledButton(
                    onPressed: springlishController.lououtbool.value?null:() async {
                  //  context.loaderOverlay.show();
            springlishController.lououtbool.value = true;
                      await Get.find<FeedDBController>()
                          .deleteMessageDBLogout();
      
                      ////
                      try {
                        await ApiServices.fcmtokenlogout(
                            emailId: Get.find<UserAuthController>()
                                    .userData
                                    .value
                                    .username ??
                                '');
                      } catch (e) {
                        print("firebase token delete error --------- $e");
                      }
                      ////
                    await SharedPrefs().removeLoginData();
                      await SharedPrefs().removeLoginCreds();
                    
                      HandleControllers.deleteAllGetControllers();
      
                      
                   
                    if(context.mounted){
                    Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (_) => false);
                    } 
                     springlishController.lououtbool.value =false;
                     
      
                     Get.delete<SpringlishController>();
           HandleControllers.createGetControllers();
            // context.loaderOverlay.hide();
                     
                    },
                    style:  ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colorutils.letters1),
                    ),
                    child: springlishController.lououtbool.value? Center(
                      child: sprinkFadingCircle,
                    ): Text(
                      "Ok",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    )  ,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 6;
    double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


final sprinkFadingCircle = SpinKitFadingCircle(
  size: 10,
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
        decoration: BoxDecoration(
      color: Colorutils.chatcolor,
      borderRadius: BorderRadius.circular(12)
    ));
  },
);

bool lougoutbool = false;



class SpringlishController extends GetxController{
  RxBool lououtbool = false.obs;
}