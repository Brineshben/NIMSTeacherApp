import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';

showChatWarningDialog(
    {required BuildContext context, required Function() function}) {
  showDialog(
    context: context,
    builder: (context) {
      ValueNotifier<bool> isShow = ValueNotifier(false);

      return FittedBox(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colorutils.white),
            width: 250.h,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  height: 50.h,
                  child: Center(
                    child: Text(
                      "Alert!!",
                      style: TeacherAppFonts.interW600_18sp_textWhite,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70.h,
                        width: 70.h,
                        child: Image.asset("assets/images/warning.png"),
                      ),
                      hSpace(10.h),
                      Text(
                        "The message is sent to all parents",
                        textAlign: TextAlign.center,
                        style: TeacherAppFonts.interW600_16sp_black
                            .copyWith(color: Colorutils.black),
                      ),
                      hSpace(10.h),
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: isShow,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onTap: () {
                                  isShow.value = !isShow.value;
                                },
                                child: Icon(
                                  isShow.value
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank,
                                  size: 25.h,
                                ),
                              );
                            },
                          ),
                          wSpace(10.w),
                          Text(
                            "Do not show again",
                            style: TeacherAppFonts.interW400_14sp_textWhite
                                .copyWith(color: Colorutils.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 50.h,
                          child: const Center(
                            child: Text("Cancel"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                      child: const VerticalDivider(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          SharedPreferences sharedPre =
                              await SharedPreferences.getInstance();
                          if (isShow.value) {
                            await sharedPre.setBool("MsgSentAlert", true);
                          } else {
                            await sharedPre.setBool("MsgSentAlert", false);
                          }
                          Navigator.pop(context);
                          function();
                        },
                        child: SizedBox(
                          height: 50.h,
                          child: const Center(
                            child: Text("Ok"),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

showParentRemoveWarningDialog(
    {required BuildContext context, required Function() function}) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.2),
    context: context,
    builder: (context) {
      ValueNotifier<bool> isShow = ValueNotifier(false);

      return FittedBox(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colorutils.grey.withOpacity(0.4),
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
                color: Colorutils.white),
            width: 335.w,
            // height: 140.h,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Text(
                    "Are you sure you want to remove the selected parents from this chat?",
                    style: TeacherAppFonts.interW400_16sp_letters1
                        .copyWith(color: Colorutils.black),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: Column(
                //     children: [
                //       SizedBox(
                //         height: 70.h,
                //         width: 70.h,
                //         child: Image.asset("assets/images/warning.png"),
                //       ),
                //       hSpace(10.h),
                //       Text(
                //         "The message is sent to all parents",
                //         textAlign: TextAlign.center,
                //         style: TeacherAppFonts.interW600_16sp_black
                //             .copyWith(color: Colorutils.black),
                //       ),
                //       hSpace(10.h),
                //       Row(
                //         children: [
                //           ValueListenableBuilder(
                //             valueListenable: isShow,
                //             builder: (context, value, child) {
                //               return GestureDetector(
                //                 onTap: () {
                //                   isShow.value = !isShow.value;
                //                 },
                //                 child: Icon(
                //                   isShow.value
                //                       ? Icons.check_box_outlined
                //                       : Icons.check_box_outline_blank,
                //                   size: 25.h,
                //                 ),
                //               );
                //             },
                //           ),
                //           wSpace(10.w),
                //           Text(
                //             "Do not show again",
                //             style: TeacherAppFonts.interW400_14sp_textWhite
                //                 .copyWith(color: Colorutils.black),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                const Divider(
                  height: 0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 50.h,
                          child: Center(
                            child: Text("Cancel",
                                style: TeacherAppFonts.interW600_16sp_black
                                    .copyWith(color: Colorutils.iconColor)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                      child: const VerticalDivider(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          SharedPreferences sharedPre =
                              await SharedPreferences.getInstance();
                          if (isShow.value) {
                            await sharedPre.setBool("MsgSentAlert", true);
                          } else {
                            await sharedPre.setBool("MsgSentAlert", false);
                          }
                          Navigator.pop(context);
                          function();
                        },
                        child: SizedBox(
                          height: 50.h,
                          child: Center(
                            child: Text(
                              "Remove",
                              style: TeacherAppFonts.interW600_16sp_black
                                  .copyWith(color: Colorutils.iconColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
