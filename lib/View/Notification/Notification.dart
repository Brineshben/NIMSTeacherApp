import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/api_controllers/markAsReadController.dart';
import '../../Controller/api_controllers/notificationController.dart';
import '../../Models/api_models/chat_group_api_model.dart';
import '../../Models/api_models/notification_api_model.dart';
import '../../Utils/Colors.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  get questionData => null;

  get isChecked => null;
  String? dropdownvalue = '1';
  final NotificationController notificationController =
      Get.find<NotificationController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => onDropdownChanged(dropdownvalue));
  }

  onDropdownChanged(String? value) {
    setState(() {
      dropdownvalue = value;
    });

    if (value == '1') {
      dropdownvalue = value;
      notificationController.sort7daystvalue();
      print('value 1');
    } else if (value == '2') {
      print('value 2');
      notificationController.sortAllNotification();
    } else {
      print('value 3');
      notificationController.sortUnreadNotifications();
    }

    print("Dropdown selected: $value");
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                AppBarBackground(),
                Positioned(
                  left: 0,
                  top: -10,
                  child: Container(
                    // height: 100.w,
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: const UserDetails(
                      shoBackgroundColor: false,
                      isWelcome: false,
                      bellicon: false,
                      notificationcount: false,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10.w,
                    top: 130.h,
                    right: 10.w,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colorutils.Whitecolor,
                    // Container color
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r),
                    ),

                    // Border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colorutils.userdetailcolor.withOpacity(0.3),
                        // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                const    Icon(
                                      Icons.notifications_none_sharp,
                                      color: Colors.black,
                                    ),
                                 const   SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Notifications",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 54.w,
                                    ),
                                    Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: Colorutils.chatcolor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(width: 0.1),
                                      ),
                                      child: DropdownButton2(
                                          value: dropdownvalue,
                                          // barrierColor: Colors.grey[200]!.withOpacity(0.4),
                                          dropdownStyleData: DropdownStyleData(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.h))),
                                          underline: const SizedBox(),
                                          style:const TextStyle(color: Colors.black),
                                          items:const [
                                            DropdownMenuItem(
                                              value: '1',
                                              child: Text('Last 7 Days'),
                                            ),
                                            DropdownMenuItem(
                                                value: '2',
                                                child: Text('All ')),
                                            DropdownMenuItem(
                                                value: '3',
                                                child: Text('Unread '))
                                          ],
                                          onChanged: onDropdownChanged),
                                    )
                                  ],
                                ),
                              ),
                              GetX<NotificationController>(
                                builder: (NotificationController controller) {
                                  List<RecentNotifications> messagelist =
                                      []; //controller.Recentnotification.value;
                                  if (controller.dropdownvalue.value == 3) {
                                    messagelist = controller.unreadnotification;
                                  } else if (controller.dropdownvalue.value ==
                                      1) {
                                    messagelist = controller.last7dayslist;
                                  } else {
                                    messagelist = controller.Recentnotification;
                                  }
                                  return SizedBox(
                                    height: 690.h,
                                    child: ListView(
                                      padding: EdgeInsets.only(top: 0.h),
                                      //  mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (messagelist.isEmpty)
                                          Container(
                                            height: 300,
                                            child: Center(
                                              child: Text(
                                                controller.validationmsg.value,
                                                style:const TextStyle(
                                                    color: Colors.red,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          )
                                        else
                                          for (int i = 0;
                                              i < messagelist.length;
                                              i++)
                                            _notifyme(context, messagelist[i]),

                                        // for(int i=0; i < messagelist.length; i++)
                                        //
                                        //   if(messagelist.isNotEmpty)
                                        //     _notifyme(context,messagelist[i])
                                        // else
                                        //   Container(child: Text("No Notifications for you",style: TextStyle(color: Colors.red),))
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  rubrics({required rubricslessonob}) {}
}

Widget _notifyme(BuildContext context, RecentNotifications notification) =>
    Container(
      margin: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
          color: Colorutils.chatcolor.withOpacity(0.2),
          border: Border.all(color: Colorutils.chatcolor),
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${notification.msg}",
              style: TextStyle(color: Colors.blueGrey),
            ),
           const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   margin:  EdgeInsets.all(4),
                //   child: Text(notificationResult!["data"]["details"]["recentNotifications"][index]["status"],
                //     style: TextStyle(color: ColorUtils.SEARCH_TEXT_COLOR),
                //   ),
                // )
                Container(
                  margin: const EdgeInsets.only(left: 4, top: 4),
                  child: Text(
                    "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(notification.genDate.toString()).toLocal())}",
                    style:const  TextStyle(
                        fontSize: 12, color: Colorutils.bottomnaviconcolor),
                  ),
                ),
                notification.status == "active"
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () async {
                          context.loaderOverlay.show();
                          await Get.find<MarkAsReadController>()
                              .fetchmarkasread(
                                  notificationId: notification.sId.toString());
                          context.loaderOverlay.hide();
                        },
                        child: const Text(
                          "Mark as Read",
                          style: TextStyle(color: Colors.red),
                        ))
                    : Text("")

                //
                // notificationResult!["data"][
                // "details"]
                // [
                // "recentNotifications"][index]
                // [
                // "status"] ==
                //     "active"
                //     ? ElevatedButton(
                //     style: ElevatedButton
                //         .styleFrom(
                //         primary:
                //         Color(
                //             0xFFECF1FF)),
                //     onPressed:
                //         () async {
                //       setState(() {
                //         isLoading =
                //         true;
                //         notificationResult!["data"]["details"]["recentNotifications"][index]
                //         [
                //         "status"] =
                //         'inactive';
                //       });
                //       print(
                //           'is Active--->${notificationResult!["data"]["details"]["recentNotifications"][index]["status"]}');
                //       markAsReadNotification(notificationResult!["data"]
                //       [
                //       "details"]
                //       [
                //       "recentNotifications"]
                //       [
                //       index]["_id"]);
                //       SharedPreferences
                //       preference =
                //       await SharedPreferences
                //           .getInstance();
                //       var count =
                //       preference
                //           .getInt(
                //           "count");
                //       var newResult =
                //           count! -
                //               1;
                //       preference.setInt(
                //           "count",
                //           newResult);
                //       print(
                //           newResult);
                //     },
                //     child: Text(
                //       "Mark as Read",
                //       style: TextStyle(
                //           color: ColorUtils
                //               .RED),
                //     ))
                //     : Text("")
              ],
            ),
          ],
        ),
      ),
    );

void dropdownonchenage(String value) {}
