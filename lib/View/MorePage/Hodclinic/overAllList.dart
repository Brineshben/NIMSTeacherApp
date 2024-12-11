import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Controller/api_controllers/hosAllStudentsListController.dart';
import '../../../Models/api_models/hosFullListModel.dart';
import '../../../Utils/Colors.dart';
import '../all_Students.dart';
import '../trackingPage.dart';
import 'HodHistoryTracking.dart';

class Overalllist extends StatefulWidget {
  List<Datas> sendStudentsData;

  Overalllist({super.key, required this.sendStudentsData});

  @override
  State<Overalllist> createState() => _OveralllistState();
}

class _OveralllistState extends State<Overalllist> {
  DateTime initDate = DateTime.now();
  String? currentMonth;

  @override
  void initState() {
    Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
    setState(() {
      currentMonth = DateFormat('MMMM yyyy').format(initDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetX<Hosallstudentslistcontroller>(
            builder: (Hosallstudentslistcontroller controller) {
          List<Datas> sendStudentsData = controller.recentData.value;
          return Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left arrow button
                      InkWell(
                        onTap: () async {
                          setState(() {
                            initDate = subtractOneMonth(initDate);
                            currentMonth =
                                DateFormat('MMMM yyyy').format(initDate);
                            print("---------initDate--------$initDate");
                          });
                          await Get.find<Hosallstudentslistcontroller>()
                              .fetchAllStudentDateList(date: initDate);
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey, width: 0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    // Adjust shadow color and opacity
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ]),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                            )),
                      ),

                      // Month text in the center
                      Text(
                        "$currentMonth".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Right arrow button

                      InkWell(
                        onTap: () async {
                          setState(() {
                            initDate = addOneMonth(initDate);
                            currentMonth =
                                DateFormat('MMMM yyyy').format(initDate);
                            print("---------initDate--------$initDate");
                          });
                          await Get.find<Hosallstudentslistcontroller>()
                              .fetchAllStudentDateList(date: initDate);
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey, width: 0.2),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    // Adjust shadow color and opacity
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ]),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )),
                      ),
                    ],
                  ),
                ),
                EasyDateTimeLine(
                  key: ValueKey(initDate),
                  initialDate: initDate,
                  onDateChange: (selectedDate) async {
                    //`selectedDate` the new date selected.
                    await Get.find<Hosallstudentslistcontroller>()
                        .fetchAllStudentDateList(date: selectedDate);
                  },
                  activeColor: Colorutils.userdetailcolor,
                  headerProps: const EasyHeaderProps(
                      showSelectedDate: false,
                      monthStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      showHeader: false),
                  dayProps: const EasyDayProps(
                    height: 60.0,
                    width: 60.0,
                    activeDayStyle: DayStyle(
                      dayNumStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    inactiveDayStyle: DayStyle(

                      dayStrStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                      monthStrStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      borderRadius: 48.0,
                      dayNumStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    dayStructure: DayStructure.dayNumDayStr,
                  ),
                ),
                sendStudentsData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: Center(
                          child: Text(
                            "No Tracking Data on Selected Date.",
                            style: TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : Expanded(

                        child: ListView.builder(
                            itemCount: sendStudentsData.length,
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: listcontainer(
                                      Sendtrackingdata:
                                          sendStudentsData[index],
                                      startTime: DateTime.parse(
                                              "${sendStudentsData[index].status?.last.addedOn}")
                                          .toLocal()),
                                )))
              ],
            ),
          );
        }),
      ],
    );
  }

  DateTime subtractOneMonth(DateTime date) {
    int year = date.year;
    int month = date.month - 1;

    if (month == 0) {
      month = 12;
      year--;
    }

    return DateTime(year, month, date.day);
  }

  DateTime addOneMonth(DateTime date) {
    int year = date.year;
    int month = date.month + 1;

    if (month == 13) {
      month = 1;
      year++;
    }

    // Handle cases where the added month might not have the same day count (like February 30)
    int day = date.day;
    int daysInNewMonth = DateTime(year, month + 1, 0).day;
    if (day > daysInNewMonth) {
      day = daysInNewMonth;
    }

    return DateTime(year, month, day);
  }
}

class listcontainer extends StatefulWidget {
  final DateTime startTime;
  final Datas Sendtrackingdata;

  const listcontainer({
    super.key,
    required this.Sendtrackingdata,
    required this.startTime,
  });

  @override
  State<listcontainer> createState() => _listcontainerState();
}

class _listcontainerState extends State<listcontainer> {
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  @override
  void initState() {
    super.initState();
    endTime = widget.startTime.add(const Duration(seconds: countdownDuration));
    if (widget.Sendtrackingdata.status?.length == 1 ||
        widget.Sendtrackingdata.status?.length == 3) {
      startTimer();
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   startTimer();      });
    }
  }
  @override
  void didUpdateWidget(covariant listcontainer oldWidget) {
    endTime = widget.startTime.add(const Duration(seconds: countdownDuration));
    if (widget.Sendtrackingdata.status?.length == 1 ||
        widget.Sendtrackingdata.status?.length == 3) {
      startTimer();
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   startTimer();      });
    }    super.didUpdateWidget(oldWidget);
  }

  String? startTimer() {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    bool text = false;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("rebuild...brbgvsdfsgh.....$timer.............");
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
            print("..........................bellssls");
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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int remainingTime = endTime.difference(DateTime.now()).inSeconds;

    double progress = (countdownDuration - remainingTime) / countdownDuration;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 10),
      child: Container(
        height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: (widget.Sendtrackingdata.status?.length == 1 &&  remainingTime < 0||
              widget.Sendtrackingdata.status?.length == 3 && remainingTime < 0)
              ?Colors.red.withOpacity(0.1)
              : Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, top: 8, bottom: 3, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90.h),
                      child: CachedNetworkImage(
                        imageUrl: "${widget.Sendtrackingdata.profile}",
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
                      SizedBox(
                        width: 200.w,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text("${widget.Sendtrackingdata.studentName}",
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
                            color: Colors.redAccent,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 10.w),
                            child: Text("${widget.Sendtrackingdata.visitStatus}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colorutils.white,
                                ))),
                          )),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Sent: ${Converteddate("${widget.Sendtrackingdata.visitDate}")}",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                          child: Text(
                              " From :Grade"
                              " "
                              "${widget.Sendtrackingdata.classs}"
                              " "
                              "${widget.Sendtrackingdata.batch}",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "SENT TO : ",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ))),
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                          "${widget.Sendtrackingdata.sendToName?.toUpperCase()}",
                          // "${widget.Sendtrackingdata.status?.first.sentBy?.toUpperCase()}",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600))),
                    ),
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
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomLinearProgressIndicator(
                        value: (remainingTime > 0 &&
                                (widget.Sendtrackingdata.status?.length == 1 ||
                                    widget.Sendtrackingdata.status?.length ==
                                        3))
                            ? progress
                            : 10,
                        backgroundColor: Colors.white,
                        textColor: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        text: (widget.Sendtrackingdata.status?.length == 1 ||
                                widget.Sendtrackingdata.status?.length == 3)
                            ? remainingTime > 0
                                ? "${formatTime(remainingTime)}" " Min Left"
                                : "Not Yet Reached"
                            : "Student Reached",
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
                                  builder: (context) => HosHistoryTracking(
                                      Studentdats: widget.Sendtrackingdata,
                                      startTime: DateTime.parse(
                                              "${widget.Sendtrackingdata.status?.last.addedOn}")
                                          .toLocal())));
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
