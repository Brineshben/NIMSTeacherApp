import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/View/CWidgets/TeacherAppPopUps.dart';

import '../../../Controller/api_controllers/hosAllStudentsListController.dart';
import '../../../Controller/api_controllers/hosStudentListController.dart';
import '../../../Models/api_models/HosStudentListModel.dart';
import '../../../Models/api_models/hosFullListModel.dart';
import '../../../Utils/Colors.dart';
import 'OwnHistory.dart';
import 'TrackingdetailsHod.dart';
import 'overAllList.dart';

class TrackingpageHod extends StatefulWidget {
  const TrackingpageHod({super.key});

  @override
  State<TrackingpageHod> createState() => _TrackingpageHodState();
}

class _TrackingpageHodState extends State<TrackingpageHod>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int tabValue = 0;


  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Update the tabValue based on tab index when user scrolls
      if (_tabController.indexIsChanging) {
        setState(() {
          tabValue = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<Hosstudentlistcontroller>().fetchHosStudentList(DateTime.now());

    Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
    return PopScope(
      onPopInvoked: (didPop) {
        Get.find<Hosstudentlistcontroller>().fetchHosStudentList(DateTime.now());
        Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SafeArea(
          child: GetX<Hosstudentlistcontroller>(
              builder: (Hosstudentlistcontroller controller) {
            List<SendData> sendStudentsData = controller.sentStudentData.value;

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
                        "Tracking",
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
                            await  Get.find<Hosstudentlistcontroller>().fetchHosStudentList(DateTime.now());
                              await  Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
                              context.loaderOverlay.hide();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh_outlined,
                                  size: 21,
                                  color: Colorutils.userdetailcolor,
                                ),
                                Text(
                                  'Refresh',
                                  style: TextStyle(
                                      fontSize: 15.w,
                                      fontWeight: FontWeight.bold,
                                      color: Colorutils.userdetailcolor),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 60,
                //   child: Row(
                //     children: [
                //       Padding(
                //           padding: const EdgeInsets.only(left: 18),
                //           child: GestureDetector(
                //             onTap: () {
                //               Navigator.of(context).pop();
                //             },
                //             child: const Icon(
                //               Icons.arrow_back_outlined,
                //               size: 30,
                //             ),
                //           )),
                //       const Spacer(
                //         flex: 2,
                //       ),
                //       const Text(
                //         "Tracking",
                //         style:
                //             TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                //       ),
                //       const Spacer(
                //         flex: 3,
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Live Tracking',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500))),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Ownhistory()));
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SvgPicture.asset(
                                  'assets/images/ClockUser.svg',
                                  width: 20.w,
                                  height: 20.w,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.bold,
                                    color: Colorutils.userdetailcolor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(

                      onTap: (value) {

                        // Get.find<Hosstudentlistcontroller>().resetData();



                        setState(() {
                          Get.find<Hosstudentlistcontroller>().resetData();


                        });


                      },
                      dividerHeight: 0,
                      padding: const EdgeInsets.all(5),
                      controller: _tabController,

                      indicator: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelColor: Colorutils.userdetailcolor,
                      unselectedLabelColor: Colors.grey[700],
                      labelPadding: EdgeInsets.symmetric(horizontal: 2), // Adjust tab spacing here

                      tabs: [
                        Tab(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('MY LIST', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: tabValue == 0
                                      ? Colorutils.userdetailcolor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text("${sendStudentsData.length}",
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: GetX<Hosallstudentslistcontroller>(
                            builder: (Hosallstudentslistcontroller controller) {
                              List<Datas> sendStudentsData =
                                  controller.recentData.value;
                              print(".......sdjhhs${sendStudentsData.length}");
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('ALL LIST',
                                      style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: tabValue == 1
                                          ? Colorutils.userdetailcolor
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text("${sendStudentsData.length}",
                                        style: const TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      sendStudentsData.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 30),
                              itemCount: sendStudentsData.length,
                              itemBuilder: (context, index) =>
                                  trackingcontainer(
                                    sendStudentList: sendStudentsData[index],
                                    startTime: DateTime.parse(
                                            "${sendStudentsData[index].status?.last.addedOn}")
                                        .toLocal(),
                                  ))
                          : const Center(
                              child: Text(
                                "Oops..No Tracking Data Found",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red),
                              ),
                            ),
                      GetX<Hosallstudentslistcontroller>(
                        builder: (Hosallstudentslistcontroller controller) {
                          List<Datas> sendStudentsData =
                              controller.recentData.value;

                          return Overalllist(
                            sendStudentsData: sendStudentsData,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class trackingcontainer extends StatefulWidget {
  final SendData sendStudentList;
  final DateTime startTime;

  const trackingcontainer({
    super.key,
    required this.sendStudentList,
    required this.startTime,
  });

  @override
  State<trackingcontainer> createState() => _trackingcontainerState();
}

class _trackingcontainerState extends State<trackingcontainer> {
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  void initState() {
    super.initState();

    endTime = widget.startTime.add(const Duration(seconds: countdownDuration));


    if (widget.sendStudentList.status?.length == 1 ||
        widget.sendStudentList.status?.length == 3) {
      startTimer();
    }
  }
  @override
  void didUpdateWidget(covariant trackingcontainer oldWidget) {
    endTime = widget.startTime.add(const Duration(seconds: countdownDuration));


    if (widget.sendStudentList.status?.length == 1 ||
        widget.sendStudentList.status?.length == 3) {
      startTimer();
    }
    super.didUpdateWidget(oldWidget);
  }


  String? startTimer() {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    bool text = false;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("rebuild...brbggh.....$timer.............");
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
            // _playAlertSoundAndVibrate();
            // TeacherAppPopUps.Trackingpoplate(
            //     title: "Late Alert",
            //     message:
            //         "${widget.sendStudentList.studentName} ${"has not reached yet."}",
            //     actionName: "Track",
            //     iconColor: Colors.green,
            //     timeText: '',
            //     sendername: '${widget.sendStudentList.studentName}');
            print("..........................bellssls");
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
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => Trackingdetailshod(
                        sendStudentList: widget.sendStudentList,
                        starttime: DateTime.parse(
                                "${widget.sendStudentList.status?.last.addedOn}")
                            .toLocal(),
                      )))
              .then((val) {
            setState(() {});
          });
        },
        child: Container(
          height: 110.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: (widget.sendStudentList.status?.length == 1 &&
                        remainingTime < 0 ||
                    widget.sendStudentList.status?.length == 3 &&
                        remainingTime < 0 ||
                    widget.sendStudentList.status?.length == 4 &&
                        remainingTime < 0)
                ? Colors.red.withOpacity(0.1)
                : Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, top: 8, bottom: 8, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          imageUrl: "${widget.sendStudentList.profilePic}",
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
                            child: Text("${widget.sendStudentList.studentName}",
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
                                color: Colorutils.clinicHOd),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 10.w),
                              child: Text(
                                  "${widget.sendStudentList.visitStatus}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.blue))),
                            )),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Sent : ",

                              // "Sent : ${widget.sendStudentList.visitDate}",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              DateFormat('hh : mm a').format(DateTime.parse(widget.sendStudentList.status?[0].addedOn ?? '--').toLocal()),

                              // "Sent : ${widget.sendStudentList.visitDate}",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "From : ",

                              // "Sent : ${widget.sendStudentList.visitDate}",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                                "Grade "
                                "${widget.sendStudentList.classs}"
                                " "
                                "${widget.sendStudentList.batch}",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomLinearProgressIndicator(
                          value: widget.sendStudentList.status!.length == 1 ||
                                  widget.sendStudentList.status!.length == 3
                              ? progress
                              : 10,
                          backgroundColor: Colors.white,
                          textColor: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          text: widget.sendStudentList.status?.length == 2
                              ? "Reached"
                              : (widget.sendStudentList.status?.length == 3 &&
                                      widget.sendStudentList.status?[2]
                                              .visitStatus ==
                                          "Sent to Isolation Room")
                                  ? " Sent to Isolation Room from Clinic"
                                  : remainingTime > 0
                                      ? "On the Way"
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
                          onTap: () {},
                          child: widget.sendStudentList.status?.length == 2
                              ? const Text(
                                  "Reached",
                                  style: TextStyle(color: Colors.orange),
                                )
                              : remainingTime > 0
                                  ? Text(
                                      "${formatTime(remainingTime)}" "Left",
                                      style: const TextStyle(color: Colors.orange),
                                    )
                                  : const Text(
                                      "00:00 Left",
                                      style: TextStyle(color: Colors.orange),
                                    ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackingContainer extends StatefulWidget {
  final Datas sendStudentsData;

  const TrackingContainer({
    super.key,
    required this.sendStudentsData,
  });

  @override
  State<TrackingContainer> createState() => _TrackingContainerState();
}

class _TrackingContainerState extends State<TrackingContainer> {
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
      child: Container(
        height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 12),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          imageUrl: "${widget.sendStudentsData.profile}",
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
                                "${widget.sendStudentsData.studentName}",
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
                              color: Colors.grey,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 10.w),
                              child: Text("Sent Back to Class",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colorutils.white,
                                  ))),
                            )),
                      ],
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Sent : ${widget.sendStudentsData.visitDate}",
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
                                  " From : Grade"
                                  " "
                                  "${widget.sendStudentsData.classs}"
                                  " "
                                  "${widget.sendStudentsData.batch}",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomLinearProgressIndicator(
                        value: 5,
                        backgroundColor: Colors.white,
                        textColor: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        text: "Not Yet Reached",
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
                          TeacherAppPopUps.Trackingpoplate(
                              title: "Late",
                              message:
                                  "Lucas ,from Grade 6D on way!, Sent By Emma Taylor",
                              actionName: "Track",
                              iconColor: Colors.green,
                              timeText: '4.00',
                              sendername: '', image: '');
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

// void _playAlertSoundAndVibrate() async {
//   if (await Vibration.hasVibrator() ?? false) {
//     Vibration.vibrate(duration: 10000);
//   }
//
//   final player = AudioPlayer();
//
//   try {
//     await player
//         .play(AssetSource('assets/alarm.mp3'));
//   } catch (e) {
//     print('Error playing audio: $e');
//   }
//
//   Future.delayed(Duration(seconds: 5), () {
//     Vibration.cancel();
//     player.stop();
//   });
// }

class CustomLinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Gradient gradient;
  final Color textColor;
  final BorderRadius borderRadius;
  final String text;

  const CustomLinearProgressIndicator({super.key,
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
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60; // Calculate minutes
  int remainingSeconds = seconds % 60; // Calculate remaining seconds
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}'; // Format as mm:ss
}
class UpdateController extends GetxController{
  uiUpdate(){
    update();
}
}