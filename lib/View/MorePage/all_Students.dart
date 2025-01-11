import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/View/MorePage/scan.dart';
import 'package:teacherapp/View/MorePage/search_page.dart';
import 'package:teacherapp/View/MorePage/tackingDetails.dart';
import 'package:teacherapp/View/MorePage/trackingPage.dart';
import 'package:teacherapp/View/MorePage/trackingdetails2.dart';
import 'package:teacherapp/View/MorePage/viewAll.dart';
import '../../Controller/api_controllers/hosAllStudentsListController.dart';
import '../../Controller/api_controllers/hosStudentListController.dart';
import '../../Controller/api_controllers/recentListApiController.dart';
import '../../Models/api_models/recentlist_model.dart';
import '../../Utils/Colors.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({super.key});

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    // _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<RecentListApiController>().fetchRecentList();
    // });
    // Get.find<RecentListApiController>().fetchRecentList();
    return PopScope(
      onPopInvoked: (didPop) {
        print("Arun vg");
        Get.find<Hosstudentlistcontroller>().fetchHosStudentList(DateTime.now());
        Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SafeArea(
          child: GetX<RecentListApiController>(
            builder: (RecentListApiController controller) {
              List<RecentData> inProgressList = controller.inProgressData.value;
              return Column(
                children: [

                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_outlined,
                                size: 30,
                              ),
                            )),
                        Spacer(
                          flex: 3,
                        ),
                        const Text(
                          "Add Students",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: () async {
                                context.loaderOverlay.show();
                                await Get.find<RecentListApiController>()
                                    .fetchRecentList();
                                context.loaderOverlay.hide();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.refresh_outlined,
                                    size: 22,
                                    color: Colorutils.userdetailcolor,
                                  ),
                                  Text(
                                    "Refresh",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                        color: Colorutils.userdetailcolor),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: double.infinity,
                      child: TextFormField(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchPage()));
                        },
                        readOnly: true,
                        onChanged: (value) {
                          // Get.find<LeaveApprovalController>().filterLeaveList(text: value);
                        },
                        validator: (val) =>
                            val!.isEmpty ? 'Enter the Topic' : null,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: "Student Name or Scan",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                      "assets/images/MagnifyingGlass (1).svg")),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QRViewExample()));
                                  },
                                  child: Container(
                                      height: 25,
                                      width: 25,
                                      child: SvgPicture.asset(
                                          "assets/images/Scanner 3.svg"))),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 25.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.withOpacity(0.2)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 236, 254, 8),
                                  width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            fillColor: Colorutils.Whitecolor,
                            filled: true),
                      ),
                    ),
                  ),
                  inProgressList.isNotEmpty
                      ? Expanded(child: GetX<RecentListApiController>(
                          builder: (RecentListApiController controller) {
                            List<RecentData> inProgressList =
                                controller.inProgressData.value;
                            return inProgressList.isNotEmpty
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18,
                                          right: 18,
                                        ),
                                        child: SizedBox(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Tracking',
                                                style: TextStyle(
                                                    fontSize: 16.w,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Viewall()));
                                                },
                                                child: Text(
                                                  'Recent List',
                                                  style: TextStyle(
                                                      fontSize: 16.w,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colorutils
                                                          .userdetailcolor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: RefreshIndicator(
                                          onRefresh: () async => await Get.find<
                                                  RecentListApiController>()
                                              .fetchRecentList(),
                                          color: Colorutils.userdetailcolor,
                                          backgroundColor: Colors.white,
                                          // Background color of the refresh indicator

                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.only(
                                                  bottom: 70),
                                              itemCount: inProgressList.length,
                                              itemBuilder: (context, index) =>
                                                  TrackingContainer(
                                                    startTime: DateTime.parse(
                                                            "${inProgressList[index].status?.last.addedOn}")
                                                        .toLocal(),
                                                    inProgressList:
                                                        inProgressList[index],
                                                  )),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox();
                          },
                        ))
                      : Expanded(child: GetX<RecentListApiController>(
                          builder: (RecentListApiController controller) {
                            List<RecentData> progressCompletedList =
                                controller.progressCompletedData.value;

                            return progressCompletedList.isNotEmpty
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: Container(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Recent List',
                                                style: TextStyle(
                                                    fontSize: 16.w,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Viewall()));
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: TextStyle(
                                                      fontSize: 16.w,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colorutils
                                                          .userdetailcolor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            padding:
                                                const EdgeInsets.only(bottom: 70),
                                            itemCount:
                                                progressCompletedList.length,
                                            itemBuilder: (context, index) =>
                                                listcontainer(
                                                    progressCompletedList:
                                                        progressCompletedList[
                                                            index])),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text(
                                    "Oops! No Data Found",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic),
                                  ));
                          },
                        ))
                ],
              );
            },
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          width: 150,
          height: 50,
          child: FloatingActionButton.small(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QRViewExample()));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Text(
                    "SCAN QR CODE",
                    style: TextStyle(color: Colors.white,fontSize: 12),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset(
                        "assets/images/Scanner 3.svg",
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            backgroundColor: Colorutils.userdetailcolor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class listcontainer extends StatelessWidget {
  final RecentData progressCompletedList;

  const listcontainer({super.key, required this.progressCompletedList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => trackingDetails2(
                        progressCompletedList: progressCompletedList,
                      )));
        },
        child: Container(
          // height: 70.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 12),
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: 22,
                //   backgroundColor: Colorutils.chatcolor.withOpacity(0.2),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: SvgPicture.asset("assets/images/profileOne.svg"),
                //   ),
                // ),
                CircleAvatar(
                  radius: 25.r,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90.h),
                    child: CachedNetworkImage(
                      imageUrl: "${progressCompletedList.profile}",
                      placeholder: (context, url) => CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colorutils.chatcolor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset("assets/images/profileOne.svg"),
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colorutils.chatcolor.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset("assets/images/profileOne.svg"),
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
                    Container(
                      width: 200.w,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text("${progressCompletedList.studentName}",
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
                          color: progressCompletedList.visitStatus ==
                                      "Sent to Clinic" ||
                                  progressCompletedList.visitStatus ==
                                      "Reached Clinic"
                              ? Colors.red.withOpacity(0.2)
                              : progressCompletedList.visitStatus ==
                                          "Sent to Washroom" ||
                                      progressCompletedList.visitStatus ==
                                          "Reached Washroom"
                                  ? Colorutils.washroomcolor2
                                  : progressCompletedList.visitStatus ==
                                              "Sent to Counsellor" ||
                                          progressCompletedList.visitStatus ==
                                              "Reached Counsellor"
                                      ? Colorutils.councellorcolor2
                                      : progressCompletedList.visitStatus ==
                                                  "Back to Class" ||
                                              progressCompletedList
                                                      .visitStatus ==
                                                  "Reached Class"
                                          ? Colors.green.withOpacity(0.3)
                                          : Colorutils.grey,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 10.w),
                          child: Text("${progressCompletedList.visitStatus}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                fontSize: 13.sp,
                                color: progressCompletedList.visitStatus ==
                                            "Sent to Clinic" ||
                                        progressCompletedList.visitStatus ==
                                            "Reached Clinic"
                                    ? Colors.red
                                    : progressCompletedList.visitStatus ==
                                                "Sent to Washroom" ||
                                            progressCompletedList.visitStatus ==
                                                "Reached Washroom"
                                        ? Colorutils.washroomcolor
                                        : progressCompletedList.visitStatus ==
                                                    "Sent to Counsellor" ||
                                                progressCompletedList
                                                        .visitStatus ==
                                                    "Reached Counsellor"
                                            ? Colorutils.councellorcolor
                                            : progressCompletedList
                                                            .visitStatus ==
                                                        "Back to Class" ||
                                                    progressCompletedList
                                                            .visitStatus ==
                                                        "Reached Class"
                                                ? Colorutils.userdetailcolor
                                                : Colorutils.white,
                              ))),
                        )),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Converteddate("${progressCompletedList.visitDate}"),
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
                            "${progressCompletedList.classs}"
                            " "
                            "${progressCompletedList.batch}",
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
    );
  }
}

class TrackingContainer extends StatefulWidget {
  final RecentData inProgressList;
  final DateTime startTime;

  const TrackingContainer(
      {super.key, required this.inProgressList, required this.startTime});

  @override
  State<TrackingContainer> createState() => _TrackingContainerState();
}

class _TrackingContainerState extends State<TrackingContainer> {

  late Timer timer1;
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  void initState() {
    super.initState();
    endTime = widget.startTime.add(Duration(seconds: countdownDuration));
    if (widget.inProgressList.status?.length == 1) {
      startTimer1(); // Start the timer when the screen is initialized
    } else if (widget.inProgressList.status?.length == 3 ||
        widget.inProgressList.status!.length == 4) {
      startTimer1();
    } else if (widget.inProgressList.status?.length == 2) {
    }

  }

  @override
  void didUpdateWidget(covariant TrackingContainer oldWidget) {
    endTime = widget.startTime.add(Duration(seconds: countdownDuration));
    if (widget.inProgressList.status?.length == 1) {
      startTimer1(); // Start the timer when the screen is initialized
    } else if (widget.inProgressList.status?.length == 3 ||
        widget.inProgressList.status!.length == 4) {
      startTimer1();
    } else if (widget.inProgressList.status?.length == 2) {
    }
    super.didUpdateWidget(oldWidget);
  }

  String? startTimer1() {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    bool text = false;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(",,,,,,sdfgsdfgsfgdfgstartTimer1,,,,$timer");
      setState(() {
        // if (DateTime.now().isBefore(endTime)) {
        //   text = false;
        // } else {
        //   timer.cancel();
        //   text = true;
        // }

        if (DateTime.now().isBefore(endTime)) {
          text = false;
        } else {
          if (DateTime.now().isAfter(endTime) &&
              DateTime.now()
                  .isBefore(endTime.add(const Duration(seconds: 1)))) {
            // UserAuthController userAuthController = Get.find<UserAuthController>();
            // widget.inProgressList.visitStatus != "Sent to Isolation Room"?
            //
            //
            // widget.inProgressList.status![0].sentById ==  userAuthController.userData.value.userId?
            // _playAlertSoundAndVibrate():_playAlertSoundAndVibrate2()
            //
            //
            //
            //     : _playAlertSoundAndVibrate2();
          }
          timer.cancel();
          text = true;
        }
      });
    });

    // Return status based on the timer status
    if (!text) {
      return "Not Yet Reached";
    } else {
      return "Timer Reached";
    }
  }

  String? startTimer() {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    bool text = false;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(",,,,,,sdfgsdfgsfgdfgstartTimer2,,,,$timer");
      setState(() {
        // if (DateTime.now().isBefore(endTime)) {
        //   text = false;
        // } else {
        //   timer.cancel();
        //   text = true;
        // }

        if (DateTime.now().isBefore(endTime)) {
          text = false;
        } else {
          if (DateTime.now().isAfter(endTime) &&
              DateTime.now()
                  .isBefore(endTime.add(const Duration(seconds: 1)))) {
            // playAlarm();
            // _playAlertSoundAndVibrate();
            // _playAlertSoundAndVibrate();
          }
          timer.cancel();
          text = true;
        }
      });
    });

    // Return status based on the timer status
    if (!text) {
      return "Not Yet Reached";
    } else {
      return "Timer Reached";
    }
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    double progress = (countdownDuration - remainingTime) / countdownDuration;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
      child: Container(
        height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: (widget.inProgressList.status?.length == 1 &&  remainingTime < 0||
                  widget.inProgressList.status?.length == 3 && remainingTime < 0||
                  widget.inProgressList.status?.length == 4 &&  remainingTime <0)
              ?Colors.red.withOpacity(0.1)
              : Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // CircleAvatar(
                  //   radius: 22,
                  //   backgroundColor: Colorutils.chatcolor.withOpacity(0.2),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: SvgPicture.asset("assets/images/profileOne.svg"),
                  //   ),
                  // ),
                  CircleAvatar(
                    radius: 25.r,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90.h),
                      child: CachedNetworkImage(
                        imageUrl: "${widget.inProgressList.profile}",
                        placeholder: (context, url) => CircleAvatar(
                          radius: 25.r,
                          backgroundColor: Colorutils.chatcolor.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset("assets/images/profileOne.svg"),
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 25.r,
                          backgroundColor: Colorutils.chatcolor.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset("assets/images/profileOne.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.w,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text("${widget.inProgressList.studentName}",
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
                                : widget.inProgressList.visitStatus ==
                                            "Sent to Washroom" ||
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
                                                widget.inProgressList
                                                        .visitStatus ==
                                                    "Reached Class"
                                            ? Colors.green.withOpacity(0.3)
                                            : widget.inProgressList
                                                        .visitStatus ==
                                                    "Sent to Isolation Room"
                                                ? Colors.grey
                                                : Colorutils.clinicHOd,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 10.w),
                            child: Text("${widget.inProgressList.visitStatus}",
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
                                              widget.inProgressList
                                                      .visitStatus ==
                                                  "Reached Washroom"
                                          ? Colorutils.washroomcolor
                                          : widget.inProgressList.visitStatus ==
                                                      "Sent to Counsellor" ||
                                                  widget.inProgressList
                                                          .visitStatus ==
                                                      "Reached Counsellor"
                                              ? Colorutils.councellorcolor
                                              : widget.inProgressList
                                                              .visitStatus ==
                                                          "Back to Class" ||
                                                      widget.inProgressList
                                                              .visitStatus ==
                                                          "Reached Class"
                                                  ? Colorutils.userdetailcolor
                                                  : widget.inProgressList
                                                              .visitStatus ==
                                                          "Sent to Isolation Room"
                                                      ? Colorutils.white
                                                      : Colors.blue,
                                ))),
                          )),
                    ],
                  ),
                  Spacer(),
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: double.infinity,
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomLinearProgressIndicator(
                        value: (widget.inProgressList.status?.length == 1 ||
                                widget.inProgressList.status?.length == 4 ||
                                (widget.inProgressList.status?.length == 3 &&
                                    widget.inProgressList.status?[2]
                                            .visitStatus !=
                                        "Sent to Isolation Room"))
                            ? progress
                            : 10,
                        backgroundColor: Colors.white,
                        textColor: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        text: widget.inProgressList.status?.length == 2
                            ? "Reached"
                            : (widget.inProgressList.status?.length == 3 &&
                                    widget.inProgressList.status?[2]
                                            .visitStatus ==
                                        "Sent to Isolation Room")
                                ? " Sent to Isolation Room from Clinic"
                                : remainingTime > 0
                                    ? "${formatTime(remainingTime)}" " Left"
                                    : "Not Yet Reached",
                        gradient: const LinearGradient(
                          colors: [
                            Colorutils.gradientColor1,
                            Colorutils.gradientColor2
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => trackingDetails(
                                        inProgressList: widget.inProgressList,
                                        starttime: DateTime.parse(
                                                "${widget.inProgressList.status?.last.addedOn}")
                                            .toLocal(),
                                      )));
                        },
                        child: CircleAvatar(

                          radius: 20,
                          backgroundColor: Colorutils.userdetailcolor,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: SvgPicture.asset("assets/images/arrow.svg"),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

// void _playAlertSoundAndVibrate() async {
//   if (await Vibration.hasVibrator() ?? false) {
//     Vibration.vibrate(duration: 10000);
//   }
//
//   final player = AudioPlayer();
//
//   try {
//     // await player
//     //     .play(AssetSource('images/alarmnew.mp3'));
//   } catch (e) {
//     print('Error playing audio: $e');
//   }
//
//   Future.delayed(Duration(seconds: 5), () {
//     Vibration.cancel();
//     player.stop();
//   });
// }
// void _playAlertSoundAndVibrate2() async {
//
//
//   final player = AudioPlayer();
//
//   try {
//     await player
//         .play(AssetSource('assets/alarm.sssmp3'));
//   } catch (e) {
//     print('Error playing audio: $e');
//   }
//
//   Future.delayed(Duration(seconds: 5), () {
//     Vibration.cancel();
//     player.stop();
//   });
// }
// playAlarm() async {
//   await Alarm.init();
//   DateTime alarmTime = DateTime.now().add(const Duration(seconds: 60));
//   final alarmSettings = AlarmSettings(
//     id: 1,
//     dateTime: alarmTime,
//     assetAudioPath: 'assets/alarm.mp3',
//     loopAudio: false,
//     vibrate: false,
//     volume: 0.5,
//     fadeDuration: 5.0,
//     // warningNotificationOnKill: Platform.isIOS,
//     notificationSettings: const NotificationSettings(
//       title: 'This is the title',
//       body: 'This is the body',
//       stopButton: "true",
//       icon: 'notification_icon',
//     ),
//   );
//   Alarm.set(alarmSettings: alarmSettings);
// }

String formatTime(int seconds) {
  int minutes = seconds ~/ 60; // Calculate minutes
  int remainingSeconds = seconds % 60; // Calculate remaining seconds
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}'; // Format as mm:ss
}

void showSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Colorutils.chatcolor,
    content: const Text('Page Refreshed'),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height * 0.5, // Center vertically
      left: 20.0,
      right: 20.0,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}