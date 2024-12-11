import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:slider_button/slider_button.dart';
import 'package:teacherapp/Models/api_models/student_add_Model.dart';
import 'package:teacherapp/View/MorePage/scanData.dart';
import 'package:teacherapp/View/MorePage/trackingPage.dart';

import '../../Controller/api_controllers/notificationClinicController.dart';
import '../../Controller/api_controllers/recentListApiController.dart';
import '../../Controller/api_controllers/studentUpdateController.dart';
import '../../Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/notificationModel.dart';
import '../../Models/api_models/recentlist_model.dart';
import '../../Models/api_models/student_updateModel.dart';
import '../../Utils/Colors.dart';

class trackingDetails extends StatefulWidget {
  final DateTime starttime;
  final RecentData inProgressList;

  const trackingDetails(
      {super.key, required this.inProgressList, required this.starttime});

  @override
  State<trackingDetails> createState() => _trackingDetailsState();
}

class _trackingDetailsState extends State<trackingDetails> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  bool ontap = false;

  @override
  void initState() {
    controller1 = TextEditingController(
        text: "SENDER REMARK : ${widget.inProgressList.status?[0].remark}");
    controller2 = TextEditingController(
        text: "UPDATED REMARK : ${widget.inProgressList.remarks}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_outlined,
                          size: 30,
                        ),
                      )),
                  const Spacer(
                    flex: 2,
                  ),
                  const Text(
                    "Tracking",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
              child: Container(
                // height: 70.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 12, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90.h),
                          child: CachedNetworkImage(
                            imageUrl: "${widget.inProgressList.profile}",
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
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 25.r,
                              backgroundColor:
                                  Colorutils.chatcolor.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    "assets/images/profileOne.svg"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200.w,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  "${widget.inProgressList.studentName}",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                              // width: 130.w,
                              // height: 18.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: widget.inProgressList.visitStatus ==
                                            "Sent to Clinic" ||
                                        widget.inProgressList.visitStatus ==
                                            "Reached Clinic"
                                    ? Colors.red.withOpacity(0.2)
                                    : widget.inProgressList.visitStatus == "Sent to Washroom" ||
                                            widget.inProgressList.visitStatus ==
                                                "Reached Washroom"
                                        ? Colorutils.washroomcolor2
                                        : widget.inProgressList.visitStatus ==
                                                    "Sent to Counsellor" ||
                                                widget.inProgressList.visitStatus ==
                                                    "Reached Counsellor"
                                            ? Colorutils.councellorcolor2
                                            : widget.inProgressList.visitStatus ==
                                                        "Back to Class" ||
                                                    widget.inProgressList.visitStatus ==
                                                        "Reached Class"
                                                ? Colors.green.withOpacity(0.3)
                                                : widget.inProgressList.visitStatus ==
                                                            "Sent to Isolation Room" ||
                                                        widget.inProgressList
                                                                .visitStatus ==
                                                            "Sent to Hospital" ||
                                                        widget.inProgressList
                                                                .visitStatus ==
                                                            "Sent Home"
                                                    ? Colors.grey
                                                    : Colorutils.clinicHOd,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 10.w),
                                child:
                                    Text("${widget.inProgressList.visitStatus}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                          fontSize: 13.sp,
                                          color: widget.inProgressList.visitStatus ==
                                                      "Sent to Clinic" ||
                                                  widget.inProgressList.visitStatus ==
                                                      "Reached Clinic"
                                              ? Colors.red
                                              : widget.inProgressList.visitStatus ==
                                                          "Sent to Washroom" ||
                                                      widget.inProgressList.visitStatus ==
                                                          "Reached Washroom"
                                                  ? Colorutils.washroomcolor
                                                  : widget.inProgressList.visitStatus ==
                                                              "Sent to Counsellor" ||
                                                          widget.inProgressList
                                                                  .visitStatus ==
                                                              "Reached Counsellor"
                                                      ? Colorutils
                                                          .councellorcolor
                                                      : widget.inProgressList.visitStatus ==
                                                                  "Back to Class" ||
                                                              widget.inProgressList.visitStatus ==
                                                                  "Reached Class"
                                                          ? Colorutils
                                                              .userdetailcolor
                                                          : widget.inProgressList.visitStatus == "Sent to Isolation Room" ||
                                                                  widget.inProgressList.visitStatus == "Sent to Hospital" ||
                                                                  widget.inProgressList.visitStatus == "Sent Home"
                                                              ? Colorutils.white
                                                              : Colors.blue,
                                        ))),
                              )),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Converteddate("${widget.inProgressList.visitDate}"),
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Container(
                              child: Text(
                                  "Grade"
                                  " "
                                  "${widget.inProgressList.classs}"
                                  " "
                                  "${widget.inProgressList.batch}",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GetX<RecentListApiController>(
              builder: (RecentListApiController controller) {
                RecentData data = widget.inProgressList;
                for (var progressData in controller.inProgressData.value) {
                  if (progressData.id == widget.inProgressList.id) {
                    print("....datazzzzzz ....${progressData.status?.length}");
                    data = progressData;
                  }
                }
                print("....datazzzzzz222 ....${data.status?.length}");
                print("....datazzzzzz222 ....${data.id}");
                print("....datazzzzzz222 ....${data.studentName}");
                return Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            if (data.status?.length == 1)
                              Container1(
                                  inProgressData: data,
                                  starttime: widget.starttime),
                            if (data.status?.length == 2)
                              Container2(
                                starttime: widget.starttime,
                                inProgressData: data,
                              ),
                            if (data.status?.length == 3)
                              Container3(
                                starttime: widget.starttime,
                                inProgressData: data,
                              ),
                            if (data.status?.length == 4 &&
                                data.status?[2].visitStatus ==
                                    "Sent to Isolation Room")
                              Container4(
                                starttime: widget.starttime,
                                inProgressData: data,
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ontap = !ontap;
                              });
                            },
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Remarks",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colorutils.userdetailcolor,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      ontap == true
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_drop_up,
                                      // Change icon based on ontap value
                                      color: Colorutils.userdetailcolor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ontap == true
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: SizedBox(
                                        height: 80,
                                        child: TextFormField(
                                          controller: controller1,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black26),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colorutils.chatcolor,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colorutils.chatcolor,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                              ),
                                              fillColor: Colorutils.chatcolor
                                                  .withOpacity(0.2),
                                              filled: true),
                                          maxLines: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  (widget.inProgressList.status?[0].remark
                                              ?.trim() !=
                                          widget.inProgressList.remarks?.trim())
                                      ?
                                      // (widget.inProgressList.status!.length ==2 ||widget.inProgressList.status!.length ==3||widget.inProgressList.status!.length ==4)?
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: SizedBox(
                                              height: 80,
                                              child: TextFormField(
                                                controller: controller2,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black26),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 10.0),
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colorutils
                                                              .chatcolor,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colorutils
                                                              .chatcolor,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0)),
                                                    ),
                                                    fillColor: Colorutils
                                                        .chatcolor
                                                        .withOpacity(0.2),
                                                    filled: true),
                                                maxLines: 5,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Container1 extends StatefulWidget {
  final DateTime starttime;
  final RecentData inProgressData;

  const Container1({
    super.key,
    required this.inProgressData,
    required this.starttime,
  });

  @override
  State<Container1> createState() => _Container1State();
}

class _Container1State extends State<Container1> {
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  void initState() {
    super.initState();
    endTime = widget.starttime.add(const Duration(
        seconds:
            countdownDuration)); // Calculate the end time based on the start time
    startTimer(); // Start the timer when the screen is initialized
  }

  String? startTimer() {
    bool text = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (DateTime.now().isBefore(endTime)) {
          // Countdown is still in progress
        } else {
          timer.cancel();

          text =
              true; // Stop the timer when the current time reaches or exceeds the end time
        }
      });
    });
    if (text = true) {
      return "Not Yet Reached";
    }
    return null;
  }

  bool spinner1 = false;

  final spinkitNew1 = SpinKitWave(
    itemBuilder: (BuildContext context, int index) {
      return const DecoratedBox(
          decoration: BoxDecoration(
        color: Colorutils.chatcolor,
      ));
    },
  );

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;
    // remainingTime = remainingTime > 0
    //     ? remainingTime
    //     : 0;
    StudentAddModel sentData = StudentAddModel();
    double progress = (countdownDuration - remainingTime) / countdownDuration;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.inProgressData.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: Image.asset("assets/images/icons8-walking-64.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.withOpacity(0.2))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 0.4,
                //     offset: Offset(0, 1),
                //   ),
                // ],
                ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 65),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.inProgressData.status?[0].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const Text("-- : --",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colorutils.progresscolor),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 18,
                                margin:
                                    const EdgeInsets.only(left: 70, right: 70),
                                color: Colors.white,
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 18,
                                margin:
                                    const EdgeInsets.only(left: 80, right: 80),
                                child: CustomLinearProgressIndicator1(
                                  value: progress,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  text: remainingTime > 0
                                      ? "${formatTime(remainingTime)}"
                                          " Left"
                                      : "Not Yet Reached",
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colorutils.progresscolor,
                                      Colorutils.progresscolor
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  child: const CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.yellow,
                                      child: Icon(Icons.more_horiz_sharp,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.inProgressData.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      widget.inProgressData.visitStatus != 'Sent to Washroom'
                          ? Text(
                              "Reached "
                              "${Reachedstatus("${widget.inProgressData.status?[0].visitStatus}")}",
                              style: const TextStyle(fontSize: 12),
                            )
                          : const Text(
                              "Reached Class",
                              style: TextStyle(fontSize: 12),
                            ),
                    ],
                  ),
                ),
                if (widget.inProgressData.visitStatus == 'Sent to Washroom')
                  Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                                child: spinner1
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10.h),
                                        child: Center(child: spinkitNew))
                                    : SliderButton(
                                        height: 50,
                                        width: ScreenUtil().screenWidth * 0.9,
                                        backgroundColor:
                                            Colorutils.userdetailcolor,
                                        radius: 50,
                                        buttonSize: 50,
                                        action: () async {
                                          setState(() {
                                            spinner1 = true;
                                          });
                                          StudentUpdateModel updateData =
                                              StudentUpdateModel(
                                                  user: Get.find<
                                                              UserAuthController>()
                                                          .userData
                                                          .value
                                                          .name ??
                                                      '',
                                                  userId: Get.find<
                                                              UserAuthController>()
                                                          .userData
                                                          .value
                                                          .userId ??
                                                      '',
                                                  userToken: "",
                                                  visitId:
                                                      widget.inProgressData.id);
                                          await Get.find<
                                                  Studentupdatecontroller>()
                                              .sendStudentDatas(
                                                  data: updateData);
                                          await Get.find<
                                                  RecentListApiController>()
                                              .fetchRecentList();
                                          return null;
                                        },
                                        shimmer: false,
                                        label: Center(
                                          child: Text(
                                            "Slide to Confirm Arrival",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.w),
                                          ),
                                        ),
                                        icon: Center(
                                          child: SvgPicture.asset(
                                            'assets/images/Double Alt Arrow Right.svg',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        boxShadow: BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 4,
                                        ),
                                      )),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Container2 extends StatelessWidget {
  final DateTime starttime;
  final RecentData inProgressData;

  const Container2(
      {super.key, required this.starttime, required this.inProgressData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  inProgressData.status?[1].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: Image.asset("assets/images/icons8-walking-64.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.withOpacity(0.2))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 0.4,
                //     offset: Offset(0, 1),
                //   ),
                // ],
                ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  inProgressData.status?[0].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  inProgressData.status?[1].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: Colorutils.progresscolor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            const Positioned(
                              left: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              child: Text("Reached",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${inProgressData.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        Reachedstatus(
                            "${inProgressData.status?[1].visitStatus}"),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Container3 extends StatefulWidget {
  final DateTime starttime;
  final RecentData inProgressData;

  const Container3(
      {super.key, required this.starttime, required this.inProgressData});

  @override
  State<Container3> createState() => _Container3State();
}

class _Container3State extends State<Container3> {
  UserAuthController userAuthController = Get.find<UserAuthController>();

  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  void initState() {
    super.initState();
    endTime = widget.starttime.add(const Duration(
        seconds:
            countdownDuration)); // Calculate the end time based on the start time
    startTimer(); // Start the timer when the screen is initialized
  }

  String? startTimer() {
    bool text = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (DateTime.now().isBefore(endTime)) {
          // Countdown is still in progress
        } else {
          timer.cancel();

          text =
              true; // Stop the timer when the current time reaches or exceeds the end time
        }
      });
    });
    if (text = true) {
      return "Not Yet Reached";
    }
    return null;
  }

  bool spinner = false;

  final spinkitNew = SpinKitWave(
    itemBuilder: (BuildContext context, int index) {
      return const DecoratedBox(
          decoration: BoxDecoration(
        color: Colorutils.chatcolor,
      ));
    },
  );

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;
    // remainingTime = remainingTime > 0
    //     ? remainingTime
    //     : 0;

    double progress = (countdownDuration - remainingTime) / countdownDuration;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.inProgressData.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: Image.asset("assets/images/icons8-walking-64.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.withOpacity(0.2))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 0.4,
                //     offset: Offset(0, 1),
                //   ),
                // ],
                ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.inProgressData.status?[0].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.inProgressData.status?[1].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: Colorutils.progresscolor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            const Positioned(
                              left: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colorutils.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              child: Text("Reached",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.inProgressData.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Reached ${Reachedstatus("${widget.inProgressData.status?[0].visitStatus}")}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.inProgressData.status?[2].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                widget.inProgressData.visitStatus != "Sent to Isolation Room"
                    ? Container(
                        child: SvgPicture.asset("assets/images/Notebook.svg"),
                      )
                    : CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            child: Image.asset(
                                "assets/images/icons8-walking-64.png"),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        widget.inProgressData.status?[2].visitStatus == "Back to Class"
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey.withOpacity(0.2))
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey,
                      //     blurRadius: 0.4,
                      //     offset: Offset(0, 1),
                      //   ),
                      // ],
                      ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                DateFormat('HH : mm').format(DateTime.parse(
                                        widget.inProgressData.status?[2]
                                                .addedOn ??
                                            '--')
                                    .toLocal()),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            const Text("-- : -- ",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 18,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colorutils.progresscolor),
                                        )),
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      height: 18,
                                      margin: const EdgeInsets.only(
                                          left: 70, right: 70),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      height: 18,
                                      margin: const EdgeInsets.only(
                                          left: 80, right: 80),
                                      child: CustomLinearProgressIndicator1(
                                        value: progress,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                        textColor: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        text: remainingTime > 0
                                            ? "${formatTime(remainingTime)}"
                                            " Left"
                                            : "Not Yet Reached",
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colorutils.progresscolor,
                                            Colorutils.progresscolor
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    left: 60,
                                    child: CircleAvatar(
                                      radius: 16.1,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor:
                                            Colorutils.progresscolor,
                                        child: CircleAvatar(
                                          radius: 14.0,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 11.0,
                                            backgroundColor: Colors.green,
                                            child: Icon(Icons.check,
                                                size: 16.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 60,
                                    child: CircleAvatar(
                                      radius: 16.1,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                        child: const CircleAvatar(
                                          radius: 14.0,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 11.0,
                                            backgroundColor: Colors.yellow,
                                            child: Icon(Icons.more_horiz_sharp,
                                                size: 16.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.inProgressData.status?[2].visitStatus}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Reached "
                              "${Reachedstatus("${widget.inProgressData.status?[2].visitStatus}")}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                                child: spinner
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10.h),
                                        child: Center(child: spinkitNew))
                                    : SliderButton(
                                        shimmer: false,
                                        height: 50,
                                        width: ScreenUtil().screenWidth * 0.9,
                                        backgroundColor:
                                            Colorutils.userdetailcolor,
                                        radius: 50,
                                        buttonSize: 50,
                                        action: () async {
                                          setState(() {
                                            spinner = true;
                                          });
                                          StudentUpdateModel updateData =
                                              StudentUpdateModel(
                                                  user: Get.find<
                                                              UserAuthController>()
                                                          .userData
                                                          .value
                                                          .name ??
                                                      '',
                                                  userId: Get.find<
                                                              UserAuthController>()
                                                          .userData
                                                          .value
                                                          .userId ??
                                                      '',
                                                  userToken: "",
                                                  visitId:
                                                      widget.inProgressData.id);
                                          (widget.inProgressData.status?[0]
                                                  .visitStatus !=
                                              "Sent to Washroom");
                                          NotificationModel sendnotification =
                                              NotificationModel(
                                            sound: "",
                                            admissionNo: widget
                                                .inProgressData.admissionNo,
                                            batch: widget.inProgressData.batch,
                                            classs:
                                                widget.inProgressData.classs,
                                            id: 0,
                                            isprogress: true,
                                            remarks: " ",
                                            roleOfSender: "",

                                            schoolId: userAuthController
                                                .userData.value.schoolId,
                                            sentById: widget.inProgressData
                                                .status?[1].sentById,
                                            // sound: "alarm",
                                            studentName: widget
                                                .inProgressData.studentName,
                                            visitDate: "",
                                            visitStatus: "Reached Class",

                                            // visitStatus:
                                            // "Sent to ${type[0].toUpperCase()}${type.substring(1, type.length)}",
                                          );
                                          await Get.find<
                                                  Notificationcliniccontroller>()
                                              .sentnotificationData(
                                                  data: sendnotification);
                                          await Get.find<
                                                  Studentupdatecontroller>()
                                              .sendStudentDatas(
                                                  data: updateData);
                                          await Get.find<
                                                  RecentListApiController>()
                                              .fetchRecentList();
                                          print(
                                              "njjjjjjjjjjjjjsbevbebg.Reached ${widget.inProgressData.status?.first.sentById}..");
                                          return null;
                                        },
                                        label: Center(
                                          child: Text(
                                            "Slide to Confirm Arrival",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.w),
                                          ),
                                        ),
                                        icon: Center(
                                          child: SvgPicture.asset(
                                            'assets/images/Double Alt Arrow Right.svg',
                                            fit: BoxFit.fitWidth,
                                          ),

                                          //     child: Icon(
                                          //       Icons.keyboard_double_arrow_right_outlined,
                                          //   color: Colorutils.userdetailcolor,
                                          //   size: 30.0,
                                          // )
                                        ),
                                        boxShadow: BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 4,
                                        ),
                                      )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey.withOpacity(0.2))
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey,
                      //     blurRadius: 0.4,
                      //     offset: Offset(0, 1),
                      //   ),
                      // ],
                      ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              DateFormat('HH : mm').format(DateTime.parse(widget
                                          .inProgressData.status?[2].addedOn ??
                                      '--')
                                  .toLocal()),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 18.0,
                                    decoration: BoxDecoration(
                                      color: Colorutils.progresscolor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  const Positioned(
                                    child: CircleAvatar(
                                      radius: 16.1,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor:
                                            Colorutils.progresscolor,
                                        child: CircleAvatar(
                                          radius: 14.0,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 11.0,
                                            backgroundColor: Colors.green,
                                            child: Icon(Icons.check,
                                                size: 16.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Positioned(
                                  //   child: Text("00:00",
                                  //       style: TextStyle(
                                  //           color: Colors.white, fontSize: 10)),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Student ${widget.inProgressData.status?[2].visitStatus ?? '--'} from Clinic",
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}

class Container4 extends StatefulWidget {
  final DateTime starttime;
  final RecentData inProgressData;

  const Container4(
      {super.key, required this.starttime, required this.inProgressData});

  @override
  State<Container4> createState() => _Container4State();
}

class _Container4State extends State<Container4> {
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  void initState() {
    super.initState();
    endTime = widget.starttime.add(const Duration(
        seconds:
            countdownDuration)); // Calculate the end time based on the start time
    startTimer(); // Start the timer when the screen is initialized
  }

  String? startTimer() {
    bool text = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (DateTime.now().isBefore(endTime)) {
          // Countdown is still in progress
        } else {
          timer.cancel();

          text =
              true; // Stop the timer when the current time reaches or exceeds the end time
        }
      });
    });
    if (text = true) {
      return "Not Yet Reached";
    }
    return null;
  }

  bool spinner3 = false;

  final spinkitNew = SpinKitWave(
    itemBuilder: (BuildContext context, int index) {
      return const DecoratedBox(
          decoration: BoxDecoration(
        color: Colorutils.chatcolor,
      ));
    },
  );

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    double progress = (countdownDuration - remainingTime) / countdownDuration;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.inProgressData.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: Image.asset("assets/images/icons8-walking-64.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.withOpacity(0.2))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 0.4,
                //     offset: Offset(0, 1),
                //   ),
                // ],
                ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.inProgressData.status?[0].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.inProgressData.status?[1].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: Colorutils.progresscolor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            const Positioned(
                              left: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colorutils.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              child: Text("Reached",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.inProgressData.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        Reachedstatus(
                            "${widget.inProgressData.status?[1].visitStatus}"),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.inProgressData.status?[2].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: Image.asset("assets/images/icons8-walking-64.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.withOpacity(0.2))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 0.4,
                //     offset: Offset(0, 1),
                //   ),
                // ],
                ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        DateFormat('HH : mm').format(DateTime.parse(
                                widget.inProgressData.status?[2].addedOn ??
                                    '--')
                            .toLocal()),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: Colorutils.progresscolor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            const Positioned(
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Positioned(
                            //   child: Text("00:00",
                            //       style: TextStyle(
                            //           color: Colors.white, fontSize: 10)),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Student ${widget.inProgressData.status?[2].visitStatus ?? '--'} from Clinic",
                      style: const TextStyle(
                          fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.inProgressData.status?[3].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  child: SvgPicture.asset("assets/images/Notebook.svg"),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.withOpacity(0.2))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 0.4,
                //     offset: Offset(0, 1),
                //   ),
                // ],
                ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.inProgressData.status?[3].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const Text("-- : -- ",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colorutils.progresscolor),
                                  )),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 18,
                                margin:
                                    const EdgeInsets.only(left: 70, right: 70),
                                color: Colors.white,
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 18,
                                margin:
                                    const EdgeInsets.only(left: 80, right: 80),
                                child: CustomLinearProgressIndicator1(
                                  value: progress,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  text: remainingTime > 0
                                      ? "${formatTime(remainingTime)}"
                                      " Left"
                                      : "Not Yet Reached",
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colorutils.progresscolor,
                                      Colorutils.progresscolor
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colorutils.progresscolor,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(Icons.check,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 60,
                              child: CircleAvatar(
                                radius: 16.1,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  child: const CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 11.0,
                                      backgroundColor: Colors.yellow,
                                      child: Icon(Icons.more_horiz_sharp,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.inProgressData.status?[3].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Reached "
                        "${Reachedstatus("${widget.inProgressData.status?[3].visitStatus}")}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: spinner3
                              ? Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  child: Center(child: spinkitNew))
                              : SliderButton(
                                  height: 50,
                                  width: ScreenUtil().screenWidth * 0.9,
                                  backgroundColor: Colorutils.userdetailcolor,
                                  radius: 50,
                                  buttonSize: 50,
                                  action: () async {
                                    setState(() {
                                      spinner3 = true;
                                    });
                                    StudentUpdateModel updateData =
                                        StudentUpdateModel(
                                            user: Get.find<UserAuthController>()
                                                    .userData
                                                    .value
                                                    .name ??
                                                '',
                                            userId:
                                                Get.find<UserAuthController>()
                                                        .userData
                                                        .value
                                                        .userId ??
                                                    '',
                                            userToken: "",
                                            visitId: widget.inProgressData.id);
                                    await Get.find<Studentupdatecontroller>()
                                        .sendStudentDatas(data: updateData);
                                    await Get.find<RecentListApiController>()
                                        .fetchRecentList();
                                    return null;
                                  },
                                  shimmer: false,
                                  label: Center(
                                    child: Text(
                                      "Slide to Confirm Arrival",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.w),
                                    ),
                                  ),
                                  icon: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/Double Alt Arrow Right.svg',
                                      fit: BoxFit.fitWidth,
                                    ),

                                    //     child: Icon(
                                    //       Icons.keyboard_double_arrow_right_outlined,
                                    //   color: Colorutils.userdetailcolor,
                                    //   size: 30.0,
                                    // )
                                  ),
                                  boxShadow: BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                  ),
                                )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

String Converteddate(String Date) {
  List<String> parts = Date.split('-');
  if (parts.length == 3) {
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }
  return Date;
}

String Reachedstatus(String status) {
  List<String> parts = status.split(' ');
  if (parts.length == 3) {
    return parts[2];
  }
  return status;
}

String Reachedstatus2(String status) {
  List<String> parts = status.split('/');
  if (parts.length == 3) {
    return parts[2];
  }
  return status;
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60; // Calculate minutes
  int remainingSeconds = seconds % 60; // Calculate remaining seconds
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}'; // Format as mm:ss
}

class CustomLinearProgressIndicator1 extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Gradient gradient;
  final Color textColor;
  final BorderRadius borderRadius;
  final String text;

  const CustomLinearProgressIndicator1({
    super.key,
    required this.value,
    required this.backgroundColor,
    required this.gradient,
    required this.textColor,
    required this.borderRadius,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 25,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(15),
                value: value,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
