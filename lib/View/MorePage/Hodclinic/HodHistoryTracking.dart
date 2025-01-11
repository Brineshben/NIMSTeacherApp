import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Models/api_models/hosFullListModel.dart';
import '../../../Utils/Colors.dart';
import '../all_Students.dart';
import '../trackingPage.dart';

class HosHistoryTracking extends StatefulWidget {
  final DateTime startTime;
  final Datas Studentdats;

  const HosHistoryTracking(
      {super.key, required this.Studentdats, required this.startTime});

  @override
  State<HosHistoryTracking> createState() => _HosHistoryTrackingState();
}

class _HosHistoryTrackingState extends State<HosHistoryTracking> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  bool ontap = false;

  @override
  Widget build(BuildContext context) {
    controller1 = TextEditingController(
        text: "SENDER REMARK : ${widget.Studentdats.status?[0].remark}");
    controller2 = TextEditingController(
        text: "UPDATED REMARK : ${widget.Studentdats.remarks}");
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Column(
          children: [
            Column(
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 8, top: 4),
                  child: Container(
                    // height: 70.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 12, top: 8, bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90.h),
                                  child: CachedNetworkImage(
                                    imageUrl: "${widget.Studentdats.profile}",
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
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 190.w,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                          "${widget.Studentdats.studentName}",
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.w600))),
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
                                            vertical: 1.h, horizontal: 10.w),
                                        child: Text(
                                            "${widget.Studentdats.visitStatus}",
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
                                    "Sent : ${Converteddate("${widget.Studentdats.visitDate}")}",
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
                                          "From : Grade"
                                          " "
                                          "${widget.Studentdats.classs}"
                                          " "
                                          "${widget.Studentdats.batch}",
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 57, bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "SENT BY : ",
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
                                      "${widget.Studentdats.status?.first.sentBy?.toUpperCase()}",
                                      // "${widget.Studentdats.sendToName?.toUpperCase()}",
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
                      ],
                    ),
                  ),
                ),
                if (widget.Studentdats.status?.length == 1)
                  Container1(
                    Studentdata1: widget.Studentdats,
                    startTime: DateTime.parse(
                            "${widget.Studentdats.status?.last.addedOn}")
                        .toLocal(),
                  ),
                if (widget.Studentdats.status?.length == 2)
                  Container2(
                    Studentdata2: widget.Studentdats,
                  ),
                if (widget.Studentdats.status?.length == 3)
                  Container3(
                    Studentdata3: widget.Studentdats,
                    startTime: DateTime.parse(
                            "${widget.Studentdats.status?.last.addedOn}")
                        .toLocal(),
                  ),
                if (widget.Studentdats.status?.length == 4)
                  Container4(
                    Studentsdetail4: widget.Studentdats,
                  )
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
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            height: 80,
                            child: TextFormField(
                              controller: controller1,
                              readOnly: true,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.black26),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colorutils.chatcolor,
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colorutils.chatcolor,
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  fillColor:
                                      Colorutils.chatcolor.withOpacity(0.2),
                                  filled: true),
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ),
                      (widget.Studentdats.status?[0].remark?.trim() !=
                              widget.Studentdats.remarks?.trim())
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: SizedBox(
                                  height: 80,
                                  child: TextFormField(
                                    controller: controller2,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintStyle:
                                            const TextStyle(color: Colors.black26),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colorutils.chatcolor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
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
                            )
                          : const SizedBox()
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class Container1 extends StatefulWidget {
  final Datas Studentdata1;
  final DateTime startTime;

  const Container1({
    super.key,
    required this.Studentdata1,
    required this.startTime,
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
    endTime = widget.startTime.add(const Duration(
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
                  widget.Studentdata1.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset("assets/images/noun-boy-2055992 1.svg", height: 16,width: 16,),
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
                                  widget.Studentdata1.status?[0].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                                margin: const EdgeInsets.only(left: 70, right: 70),
                                color: Colors.white,
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 18,
                                margin: const EdgeInsets.only(left: 80, right: 80),
                                child: CustomLinearProgressIndicator1(
                                  value: progress,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  text: remainingTime > 0
                                      ? "${formatTime(remainingTime)}"
                                          " Min Left"
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
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.Studentdata1.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Reached ""${Reachedstatus("${widget.Studentdata1.status?[0].visitStatus}")}",
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

class Container2 extends StatelessWidget {
  final Datas Studentdata2;

  const Container2({super.key, required this.Studentdata2});

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
                  Studentdata2.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset("assets/images/noun-boy-2055992 1.svg", height: 16,width: 16,),
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
                                  Studentdata2.status?[0].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  Studentdata2.status?[1].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Studentdata2.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Reached ${Reachedstatus("${Studentdata2.status?[0].visitStatus}")}",
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
  final Datas Studentdata3;
  final DateTime startTime;

  const Container3({
    super.key,
    required this.Studentdata3,
    required this.startTime,
  });

  @override
  State<Container3> createState() => _Container3State();
}

class _Container3State extends State<Container3> {
  static const int countdownDuration = 15 * 60; // 5 minutes in seconds

  late DateTime endTime; // The end time for the countdown
  late Timer timer;

  @override
  void initState() {
    super.initState();
    endTime = widget.startTime.add(const Duration(
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
    // StudentAddModel sentData = StudentAddModel();
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
                  widget.Studentdata3.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset("assets/images/noun-boy-2055992 1.svg", height: 16,width: 16,),
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
                                  widget.Studentdata3.status?[0].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  widget.Studentdata3.status?[1].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                                      color: Colors.white,
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
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.Studentdata3.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Reached ${Reachedstatus("${widget.Studentdata3.status?[0].visitStatus}")}",
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
                  widget.Studentdata3.status?[2].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  child: SvgPicture.asset("assets/images/Notebook1.svg"),
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
                                  widget.Studentdata3.status?[2].addedOn ??
                                      '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                                margin: const EdgeInsets.only(left: 70, right: 70),
                                color: Colors.white,
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 18,
                                margin: const EdgeInsets.only(left: 80, right: 80),
                                child: CustomLinearProgressIndicator1(
                                  value: progress,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  text: remainingTime > 0
                                      ? "${formatTime(remainingTime)}"
                                          " Min Left"
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
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.Studentdata3.status?[2].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Reached ${Reachedstatus("${widget.Studentdata3.status?[2].visitStatus}")}",
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

class Container4 extends StatelessWidget {
  final Datas Studentsdetail4;

  const Container4({super.key, required this.Studentsdetail4});

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
                  Studentsdetail4.status?[0].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset("assets/images/noun-boy-2055992 1.svg", height: 16,width: 16,),
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
                                  Studentsdetail4.status?[0].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  Studentsdetail4.status?[1].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Studentsdetail4.status?[0].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        Reachedstatus("${Studentsdetail4.status?[1].visitStatus}"),
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
                  Studentsdetail4.status?[2].visitStatus ?? '--',
                  style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  child: SvgPicture.asset("assets/images/Notebook1.svg"),
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
                                  Studentsdetail4.status?[2].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                          DateFormat('HH : mm').format(DateTime.parse(
                                  Studentsdetail4.status?[3].addedOn ?? '--')
                              .toLocal()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                        "${Studentsdetail4.status?[2].visitStatus}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        Reachedstatus("${Studentsdetail4.status?[3].visitStatus}"),
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

String Reachedstatus(String status) {
  List<String> parts = status.split(' ');
  if (parts.length == 3) {
    return parts[2];
  }
  return status;
}
class CustomLinearProgressIndicator1 extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Gradient gradient;
  final Color textColor;
  final BorderRadius borderRadius;
  final String text;

  const CustomLinearProgressIndicator1({super.key,
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
