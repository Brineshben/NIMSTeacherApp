import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import 'package:teacherapp/Controller/update_controller/update_controller.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/Menu/drawer.dart';
import 'package:teacherapp/View/MorePage/Hodclinic/TrackingPageHod.dart';
import 'package:teacherapp/View/RoleNavigation/choice_page.dart';
import 'package:teacherapp/View/Login_page/login.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/controller_handling.dart';
import '../Services/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // navigate();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showUpdateDialog(context);
      },
    );
  }

  Future<void> navigate() async {
    UserAuthController userAuthController = Get.find<UserAuthController>();
    Get.find<PageIndexController>().changePage(currentPage: 0);
    await userAuthController.getUserData();
    String? userId = userAuthController.userData.value.userId;
    // await Future.delayed(const Duration(seconds: 1));
    if (userId != null) {
      UserRole? userRole = userAuthController.userRole.value;
      if (userRole != null) {
        if (userRole == UserRole.leader) {
          List<String>? rolIds =
              userAuthController.userData.value.roleIds ?? [];
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DrawerScreen()));
          // if ((rolIds.contains("rolepri12") || rolIds.contains("role12123")) &&
          //     !rolIds.contains("role121234")) {
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => const HosListing()));
          // } else {
          //   userAuthController.setSelectedHosData(
          //
          //     hosName: userAuthController.userData.value.name ?? '--',
          //     hosId: userAuthController.userData.value.userId ?? '--',
          //     isHos: true,
          //   );
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => const DrawerScreen()));
          // }
        }
        if (userRole == UserRole.bothTeacherAndLeader) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChoicePage()));
        }
        if (userRole == UserRole.teacher) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DrawerScreen()));
        }
      } else {
        HandleControllers.deleteAllGetControllers();
        await SharedPrefs().removeLoginData();
        await SharedPrefs().removeLoginCreds();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (_) => false);
        HandleControllers.createGetControllers();
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colorutils.userdetailcolor,
        body: Center(
          child: SizedBox(
            width: 150.w,
            height: 150.h,
            child: SvgPicture.asset("assets/images/splashscreenmainlogo.svg"),
          ),
        ));
  }

  void showUpdateDialog(BuildContext context) async {
    await Get.find<AppUpdateController>().getUpdate().then(
      (value) {
        if (value) {
          showDialog(
            context: context,
            builder: (context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  backgroundColor: Colorutils.transparent,
                  content: Container(
                    height: 400.h,
                    width: 200.h,
                    decoration: BoxDecoration(
                        color: Colorutils.white,
                        borderRadius: BorderRadius.circular(15.h)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 25.h),
                      child: GetBuilder<AppUpdateController>(
                          builder: (controller) {
                        if (controller.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (controller.isError) {
                          return InkWell(
                            onTap: () async {
                              await Get.find<AppUpdateController>().getUpdate();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Something went wrong. Please try again.",
                                  textAlign: TextAlign.center,
                                  style: TeacherAppFonts.interW400_20sp
                                      .copyWith(color: Colorutils.black),
                                ),
                                hSpace(20.h),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.h),
                                    color: Colorutils.blue,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    child: Text("Retry",
                                        style: TeacherAppFonts
                                            .interW500_16sp_letters1),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 100.h,
                                  width: 100.h,
                                  child: FittedBox(
                                      child: Image.asset(
                                          "assets/images/update_warning.png"))),
                              Text(
                                "Update Now",
                                style: TeacherAppFonts.interW600_25sp_textWhite
                                    .copyWith(color: Colorutils.black),
                              ),
                              controller.isAfterUpdate
                                  ? Text(
                                      "Latest version of School Diary available. Please update to "
                                      "continue.",
                                      style: TeacherAppFonts.interW400_20sp
                                          .copyWith(color: Colorutils.black),
                                      textAlign: TextAlign.center,
                                    )
                                  : RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "Latest version of School Diary available. Please update before ",
                                          style: TeacherAppFonts.interW400_20sp
                                              .copyWith(
                                                  color: Colorutils.black),
                                        ),
                                        TextSpan(
                                          text: controller.finalDate,
                                          style: TeacherAppFonts
                                              .interW600_20sp_textWhite
                                              .copyWith(
                                                  color: Colorutils.black),
                                        ),
                                      ]),
                                    ),
                              // Text(
                              //   "Latest version of School Diary available. Please update before.",
                              //   style: FontsStyle()
                              //       .interW400_20sp
                              //       .copyWith(color: ColorUtil.black),
                              //   textAlign: TextAlign.center,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.isAfterUpdate
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            Navigator.pop(context);

                                            navigate();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.h),
                                              color: Colorutils.red,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w,
                                                  vertical: 10.h),
                                              child: Text("Cancel",
                                                  style: TeacherAppFonts
                                                      .interW500_16sp_letters1
                                                      .copyWith(
                                                          color: Colorutils
                                                              .white)),
                                            ),
                                          ),
                                        ),
                                  controller.isAfterUpdate
                                      ? SizedBox()
                                      : wSpace(20.h),
                                  InkWell(
                                    onTap: () async {
                                      await launchUrl(
                                          Uri.parse(controller.link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.h),
                                        color: Colorutils.green,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 10.h),
                                        child: Text("Update",
                                            style: TeacherAppFonts
                                                .interW500_16sp_letters1
                                                .copyWith(
                                                    color: Colorutils.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      }),
                    ),
                  ),
                ),
              );
            },
          ).then(
            (value) {
              // navigation(true);
              navigate();
            },
          );
        } else {
          // navigation(true);
          navigate();
        }
      },
    );
  }
}
