import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Models/api_models/recent_date_model.dart';
import '../../Utils/Colors.dart';

class trackingDetails3 extends StatefulWidget {
  final ListItem progressCompletedList;

  const trackingDetails3({super.key, required this.progressCompletedList});

  @override
  State<trackingDetails3> createState() => _trackingDetails3State();
}

class _trackingDetails3State extends State<trackingDetails3> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  bool ontap = false;

  @override
  Widget build(BuildContext context) {


    controller1 = TextEditingController(text:"SENDER REMARK : ${widget.progressCompletedList.status?[0].remark}" );
    controller2 = TextEditingController(text:"UPDATED REMARK : ${widget.progressCompletedList.remarks}" );
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                              imageUrl: "${widget.progressCompletedList.profile}",
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
                                child: Text(
                                    "${widget.progressCompletedList.studentName}",
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
                                  color: widget.progressCompletedList.visitStatus ==
                                              "Sent to Clinic" ||
                                          widget.progressCompletedList.visitStatus ==
                                              "Reached Clinic"
                                      ? Colors.red.withOpacity(0.2)
                                      : widget.progressCompletedList.visitStatus ==
                                                  "Sent to Washroom" ||
                                              widget.progressCompletedList
                                                      .visitStatus ==
                                                  "Reached Washroom"
                                          ? Colorutils.washroomcolor2
                                          : widget.progressCompletedList
                                                          .visitStatus ==
                                                      "Sent to Counsellor" ||
                                                  widget.progressCompletedList
                                                          .visitStatus ==
                                                      "Reached Counsellor"
                                              ? Colorutils.councellorcolor2
                                              : widget.progressCompletedList
                                                              .visitStatus ==
                                                          "Back to Class" ||
                                                      widget.progressCompletedList
                                                              .visitStatus ==
                                                          "Reached Class"
                                                  ? Colors.green.withOpacity(0.3)
                                                  : widget.progressCompletedList.visitStatus == "Sent to Isolation Room" ||
                                      widget.progressCompletedList
                                          .visitStatus ==
                                          "Sent to Hospital" ||
                                      widget.progressCompletedList.visitStatus == "Sent Home"
                                      ? Colors.grey
                                      : Colorutils.clinicHOd,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 10.w),
                                  child: Text(
                                      "${widget.progressCompletedList.visitStatus}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                        fontSize: 13.sp,
                                        color: widget.progressCompletedList.visitStatus ==
                                                    "Sent to Clinic" ||
                                                widget.progressCompletedList.visitStatus ==
                                                    "Reached Clinic"
                                            ? Colors.red
                                            : widget.progressCompletedList.visitStatus ==
                                                        "Sent to Washroom" ||
                                                    widget.progressCompletedList
                                                            .visitStatus ==
                                                        "Reached Washroom"
                                                ? Colorutils.washroomcolor
                                                : widget.progressCompletedList
                                                                .visitStatus ==
                                                            "Sent to Counsellor" ||
                                                        widget.progressCompletedList
                                                                .visitStatus ==
                                                            "Reached Counsellor"
                                                    ? Colorutils.councellorcolor
                                                    : widget.progressCompletedList
                                                                    .visitStatus ==
                                                                "Back to Class" ||
                                                            widget.progressCompletedList
                                                                    .visitStatus ==
                                                                "Reached Class"
                                                        ? Colorutils.userdetailcolor
                                                        : widget.progressCompletedList.visitStatus == "Sent to Isolation Room" || widget.progressCompletedList.visitStatus == "Sent to Hospital" || widget.progressCompletedList.visitStatus == "Sent Home"
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
                              Converteddate(
                                  "${widget.progressCompletedList.visitDate}"),
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
                                    "${widget.progressCompletedList.classs}"
                                    " "
                                    "${widget.progressCompletedList.batch}",
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
              Column(
                  children: [
                    (widget.progressCompletedList.status?[0].visitStatus == "Sent to Washroom" ||
                        widget.progressCompletedList.visitStatus == "Sent Home" ||
                        widget.progressCompletedList.visitStatus ==
                            "Sent to Hospital")
                        ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Text(
                                  '${widget.progressCompletedList.status?[0].visitStatus}',
                                  style: TextStyle(
                                      fontSize: 18.w,
                                      fontWeight: FontWeight.bold),
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
                                      child: Image.asset(
                                          "assets/images/icons8-walking-64.png"),
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
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2))
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
                                  padding: const EdgeInsets.only(left: 40, right: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[0].addedOn ?? '--').toLocal())}"
                                              " ("
                                              "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                              ")",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11)),
                                      Text(
                                          "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[1].addedOn ?? '--').toLocal())}"
                                              " "
                                              "("
                                              "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                              ")",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11)),
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
                                                borderRadius:
                                                BorderRadius.circular(10.0),
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
                                                      backgroundColor:
                                                      Colors.green,
                                                      child: Icon(Icons.check,
                                                          size: 16.0,
                                                          color: Colors.white),
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
                                                  backgroundColor:
                                                  Colorutils.progresscolor,
                                                  child: CircleAvatar(
                                                    radius: 14.0,
                                                    backgroundColor: Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 11.0,
                                                      backgroundColor:
                                                      Colors.green,
                                                      child: Icon(Icons.check,
                                                          size: 16.0,
                                                          color: Colors.white),
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
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${widget.progressCompletedList.status?[0].visitStatus}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${widget.progressCompletedList.status?[1].visitStatus}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (widget.progressCompletedList.visitStatus ==
                            "Sent Home" ||
                            widget.progressCompletedList.visitStatus ==
                                "Sent to Hospital")
                            ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.progressCompletedList.status?[2].visitStatus}',
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 3,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 11,
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.1),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${DateFormat('HH : mm').format(DateTime.parse(widget.progressCompletedList.status?[2].addedOn ?? '--').toLocal())}"
                                                " "
                                                "("
                                                "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                ")",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11)),
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
                                                    color: Colorutils
                                                        .progresscolor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                ),
                                                const Positioned(
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Student ${widget.progressCompletedList.status?[2].visitStatus ?? '--'} from Clinic",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            (widget.progressCompletedList.status?[2]
                                .visitStatus ==
                                "Sent to Isolation Room")
                                ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18, right: 18),
                                  child: SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Text(
                                          widget
                                              .progressCompletedList
                                              .status?[3]
                                              .visitStatus ??
                                              "--",
                                          style: TextStyle(
                                              fontSize: 18.w,
                                              fontWeight:
                                              FontWeight.bold),
                                          maxLines: 3,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CircleAvatar(
                                          radius: 11,
                                          backgroundColor: Colors.grey
                                              .withOpacity(0.1),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                2.0),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(
                                            20.0),
                                        border: Border.all(
                                            color: Colors.grey
                                                .withOpacity(0.2))
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
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                                "${DateFormat('HH : mm').format(DateTime.parse(widget.progressCompletedList.status?[3].addedOn ?? '--').toLocal())}"
                                                    " "
                                                    "("
                                                    "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                    ")",
                                                style: const TextStyle(
                                                    color:
                                                    Colors.grey,
                                                    fontSize: 11)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 50.0,
                                                child: Stack(
                                                  alignment: Alignment
                                                      .center,
                                                  children: [
                                                    Container(
                                                      height: 18.0,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: Colorutils
                                                            .progresscolor,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10.0),
                                                      ),
                                                    ),
                                                    const Positioned(
                                                      child:
                                                      CircleAvatar(
                                                        radius: 16.1,
                                                        backgroundColor:
                                                        Colors
                                                            .white,
                                                        child:
                                                        CircleAvatar(
                                                          radius:
                                                          16.0,
                                                          backgroundColor:
                                                          Colorutils
                                                              .progresscolor,
                                                          child:
                                                          CircleAvatar(
                                                            radius:
                                                            14.0,
                                                            backgroundColor:
                                                            Colors
                                                                .white,
                                                            child:
                                                            CircleAvatar(
                                                              radius:
                                                              11.0,
                                                              backgroundColor:
                                                              Colors.green,
                                                              child: Icon(
                                                                  Icons
                                                                      .check,
                                                                  size:
                                                                  16.0,
                                                                  color:
                                                                  Colors.white),
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
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Student ${widget.progressCompletedList.status?[3].visitStatus ?? '--'} from Isolation Room",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle
                                                      .italic),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : const SizedBox(),
                          ],
                        )
                            : const SizedBox()
                      ],
                    )
                        : Column(
                      children: [
                        widget.progressCompletedList.status?.length == 4
                            ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.progressCompletedList.status?[0].visitStatus}',
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 3,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 11,
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.1),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))
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
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[0].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[1].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
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
                                                    color: Colorutils
                                                        .progresscolor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                ),
                                                const Positioned(
                                                  left: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  right: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  child: Text("Reached",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.progressCompletedList.status?[0].visitStatus}",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${widget.progressCompletedList.status?[1].visitStatus}",
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
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      "${widget.progressCompletedList.status?[2].visitStatus}",
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: SvgPicture.asset(
                                          "assets/images/Notebook.svg"),
                                      // child: SvgPicture.asset("assets/images/Frame 849.svg"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))
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
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[2].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[3].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
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
                                                    color: Colorutils
                                                        .progresscolor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                ),
                                                const Positioned(
                                                  left: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  right: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  child: Text("Reached",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.progressCompletedList.status?[2].visitStatus}",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${widget.progressCompletedList.status?[3].visitStatus}",
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
                        )
                            : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.progressCompletedList.status?[0].visitStatus}',
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 3,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 11,
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.1),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))
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
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[0].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[1].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
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
                                                    color: Colorutils
                                                        .progresscolor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                ),
                                                const Positioned(
                                                  left: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  right: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  child: Text("Reached",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.progressCompletedList.status?[0].visitStatus}",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${widget.progressCompletedList.status?[1].visitStatus}",
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
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.progressCompletedList.status?[2].visitStatus}',
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 3,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 11,
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.1),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${DateFormat('HH : mm').format(DateTime.parse(widget.progressCompletedList.status?[2].addedOn ?? '--').toLocal())}"
                                                " "
                                                "("
                                                "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                ")",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11)),
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
                                                    color: Colorutils
                                                        .progresscolor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                ),
                                                const Positioned(
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Student ${widget.progressCompletedList.status?[2].visitStatus ?? '--'} from Clinic",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Text(
                                      "${widget.progressCompletedList.status?[3].visitStatus}",
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: SvgPicture.asset(
                                          "assets/images/Notebook.svg"),
                                      // child: SvgPicture.asset("assets/images/Frame 849.svg"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))
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
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[3].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
                                          Text(
                                              "${DateFormat("HH : mm").format(DateTime.parse(widget.progressCompletedList.status?[4].addedOn ?? '--').toLocal())}"
                                                  " ("
                                                  "${Converteddate("${widget.progressCompletedList.visitDate}")}"
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10)),
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
                                                    color: Colorutils
                                                        .progresscolor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                ),
                                                const Positioned(
                                                  left: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  right: 60,
                                                  child: CircleAvatar(
                                                    radius: 16.1,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor:
                                                      Colorutils
                                                          .progresscolor,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: CircleAvatar(
                                                          radius: 11.0,
                                                          backgroundColor:
                                                          Colors.green,
                                                          child: Icon(
                                                              Icons.check,
                                                              size: 16.0,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned(
                                                  child: Text("Reached",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.progressCompletedList.status?[3].visitStatus}",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${widget.progressCompletedList.status?[4].visitStatus}",
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
                                style: const TextStyle(
                                    fontSize: 12,),
                                readOnly: true,
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
                                          color: Colorutils.chatcolor, width: 1.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.chatcolor, width: 1.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    fillColor: Colorutils.chatcolor.withOpacity(0.2),
                                    filled: true),
                                maxLines: 5,
                              ),
                            ),
                                                ),
                                              ),
                            (widget.progressCompletedList.status?[0].remark?.trim()!=widget.progressCompletedList.remarks?.trim())?

                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: SizedBox(
                                  height: 80,
                                  child: TextFormField(
                                    controller: controller2,
                                    style: const TextStyle(
                                      fontSize: 12,),
                                    readOnly: true,
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
                                              color: Colorutils.chatcolor, width: 1.0),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colorutils.chatcolor, width: 1.0),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(15.0)),
                                        ),
                                        fillColor: Colorutils.chatcolor.withOpacity(0.2),
                                        filled: true),
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                            ):const SizedBox()
                          ],
                        )
                        : const SizedBox()
                  ],
              ),

            ],
          ),
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

String Reachedstatus(String status) {
  List<String> parts = status.split(' ');
  if (parts.length == 3) {
    return parts[2];
  }
  return status;
}
