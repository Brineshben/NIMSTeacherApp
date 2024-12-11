import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Utils/Colors.dart';
import '../../Utils/api_constants.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import '../My_Class/Myclass.dart';

class HistoryOfStudentActivity extends StatefulWidget {
  String? studentName;
  String? parentName;
  String? mobileNumber;
  String? classOfStudent;
  String? loginUserName;
  String? studentFees;
  String? admissionNumber;
  String? logedinEmployeecode;
  String? loginTeacherName;
  String? TeacherProfile;
  String? StudentImage;
  String? motherName;
  String? motherPhone;

  HistoryOfStudentActivity(
      {super.key,
      this.parentName,
      this.studentName,
      this.classOfStudent,
      this.mobileNumber,
      this.loginUserName,
      this.studentFees,
      this.admissionNumber,
      this.logedinEmployeecode,
      this.loginTeacherName,
      this.TeacherProfile,
      this.StudentImage,
      this.motherPhone,
      this.motherName});

  @override
  _HistoryOfStudentActivityState createState() =>
      _HistoryOfStudentActivityState();
}

class _HistoryOfStudentActivityState extends State<HistoryOfStudentActivity> {
  Map<String, dynamic>? studentFeebackList;

  List newList = [];
  List reversedFeedbackList = [];

  studentActivities() async {
    UserAuthController userAuthController = Get.find<UserAuthController>();
    var headers = {
      'API-Key': '525-777-777',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
    request.body = json.encode({
      "action": "getStudentFeedbackData",
      "token": userAuthController.schoolToken.value,
      "admn_no": "${widget.admissionNumber}"
    });
    log("studentActivitiesrequest.body-----${request.body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      setState(() {
        studentFeebackList = json.decode(responseJson);
      });

      // getString() {
      //   if (studentFeebackList!.containsKey("data_status") == 1) {
      //     print("shshshshsh");
      //     for (var index = 0;
      //         index < studentFeebackList!["data"].length;
      //         index++) {
      //       if (studentFeebackList!["data"][index]["Feeback_type"] == 1) {
      //         return "Committed Date";
      //       } else if (studentFeebackList!["data"][index]["Feeback_type"] ==
      //               2 ||
      //           studentFeebackList!["data"][index]["Feeback_type"] == 3) {
      //         return "Wrong or Invalid";
      //       } else if (studentFeebackList!["data"][index]["Feeback_type"] ==
      //           4) {
      //         return "Call Not Answered";
      //       } else if (studentFeebackList!["data"][index]["Feeback_type"] ==
      //               5 ||
      //           studentFeebackList!["data"][index]["Feeback_type"] == 6 ||
      //           studentFeebackList!["data"][index]["Feeback_type"] == 7) {
      //         return "Misbehavior";
      //       }
      //     }
      //   }
      //   return "";
      // }

      log("the reveresed list is $studentFeebackList");
      newList.add(studentFeebackList!["data"]);

      setState(() {
        reversedFeedbackList = newList[0].reversed.toList();
      });

      print(request.body);
      log("the reveresed list is $reversedFeedbackList");
    } else {
      print(response.reasonPhrase);
    }
  }

  Map<String, dynamic>? notificationResult;

  @override
  void initState() {
    studentActivities();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    // print(">>>>studentFeesstudentFees>>>>>>widgetwidget>>>>>>>>>${widget.studentFees}");
    // print(">>>>loginTeacherName>>>>>>>>>${widget.loginTeacherName}");
    // getNotification();
    //print(getString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    const AppBarBackground(),
                    Positioned(
                      left: 0,
                      top: -10,
                      child: Container(
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                          child: const UserDetails(
                              shoBackgroundColor: false,
                              isWelcome: false,
                              bellicon: true,
                              notificationcount: true)),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 10.w, top: 125.h, right: 10.w),
                      width: 500.w,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue.shade50),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25.w,
                                      width: 25.w,
                                      child: SvgPicture.asset(
                                        "assets/images/icon.svg",
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "History",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Column(
                              // shrinkWrap: true,
                              // scrollDirection: Axis.vertical,
                              children: [
                                SizedBox(
                                  height: 25.h,
                                ),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color:
                                                    Colors.lightBlue.shade50)),
                                        child: CachedNetworkImage(
                                          width: 50.h,
                                          height: 50.h,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              widget.StudentImage.toString(),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Text(
                                              widget.studentName.toString()[0],
                                              style: const TextStyle(
                                                  color: Colorutils
                                                      .userdetailcolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 230.w,
                                            child: Text(
                                                capitalizeFirstLetterOfEachWord(
                                                        widget.studentName
                                                            .toString()
                                                            .toLowerCase())
                                                    .toString(),
                                                style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        (widget.studentFees == null ||
                                                widget.studentFees
                                                    .toString()
                                                    .trim()
                                                    .isEmpty)
                                            ? const Text("No Pending Fees")
                                            : Row(
                                                children: [
                                                  SizedBox(
                                                    child: Text(
                                                      "AED :",
                                                      style: TextStyle(
                                                          fontSize: 14.sp),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      widget.studentFees
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 20,
                                  height: 15,
                                  thickness: 0.5,
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 50.w,
                                            height: 50.h,
                                            child: SvgPicture.asset(
                                              "assets/images/profileOne.svg",
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: 230.w,
                                                    child: Text(
                                                        widget.parentName
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: GoogleFonts.roboto(
                                                            textStyle: TextStyle(
                                                                fontSize: 16.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))),
                                                SizedBox(
                                                  height: 6.h,
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                    widget.mobileNumber
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => Utils.call(
                                            widget.mobileNumber.toString()),
                                        child: SizedBox(
                                          width: 50.w,
                                          height: 50.h,
                                          child: SvgPicture.asset(
                                            "assets/images/callButtonTwo.svg",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                widget.motherName == null
                                    ? const Text("")
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 50.w,
                                                height: 50.h,
                                                child: SvgPicture.asset(
                                                  "assets/images/profileTwo.svg",
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      // width: 150.w,
                                                      child: Text(
                                                          widget.motherName
                                                              .toString(),
                                                          style: GoogleFonts.roboto(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))),
                                                  SizedBox(
                                                    height: 6.h,
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      widget.motherPhone
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () => Utils.call(
                                                widget.motherPhone.toString()),
                                            child: SizedBox(
                                              width: 50.w,
                                              height: 50.h,
                                              child: SvgPicture.asset(
                                                "assets/images/callButtonOne.svg",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                studentFeebackList == null
                                    ? const CircularProgressIndicator(
                                        color: Colorutils.chatcolor,
                                      )
                                    : studentFeebackList!["data_status"] == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 40),
                                            child: const Text(
                                              "Oops...No Data Found.",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          )
                                        : Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                            child: ListView.builder(
                                              padding: EdgeInsets.only(bottom: 10),
                                                shrinkWrap: true,
                                                itemCount:
                                                    reversedFeedbackList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              reversedFeedbackList[
                                                                              index]
                                                                          [
                                                                          "Feeback_type"] ==
                                                                      1
                                                                  ? "Committed Date"
                                                                  : reversedFeedbackList[index]["Feeback_type"] ==
                                                                              2 ||
                                                                          reversedFeedbackList[index]["Feeback_type"] ==
                                                                              3
                                                                      ? "Invalid or Wrong Number"
                                                                      : reversedFeedbackList[index]["Feeback_type"] ==
                                                                              4
                                                                          ? "Call Not Answered"
                                                                          : "Misbehaved",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blueGrey)),
                                                          Image.asset(
                                                            reversedFeedbackList[
                                                                            index]
                                                                        [
                                                                        "Feeback_type"] ==
                                                                    1
                                                                ? "assets/images/committed.png"
                                                                : reversedFeedbackList[index]["Feeback_type"] ==
                                                                            2 ||
                                                                        reversedFeedbackList[index]["Feeback_type"] ==
                                                                            3
                                                                    ? "assets/images/invalidcall.png"
                                                                    : reversedFeedbackList[index]["Feeback_type"] ==
                                                                            4
                                                                        ? "assets/images/callnotanswered.png"
                                                                        : "assets/images/mis.png",
                                                            height: 50.h,
                                                            width: 50.h,
                                                          )
                                                        ],
                                                      ),
                                                      // SizedBox(height: 5.h,),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        //margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xFFECF1FF),
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xFFCAD3FF)),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.r))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  top: 10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Remarks",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey),
                                                                  ),
                                                                  Text(
                                                                    "${reversedFeedbackList[index]["Feeback_committed_date"]}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .blueGrey),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  reversedFeedbackList[index]
                                                                              [
                                                                              "Feeback_type"] ==
                                                                          5
                                                                      ? "Abusive Language"
                                                                      : reversedFeedbackList[index]["Feeback_type"] ==
                                                                              6
                                                                          ? "Did not agree to pay fees"
                                                                          : reversedFeedbackList[index]["Feeback_type"] == 7
                                                                              ? "Advised a call from higher authority"
                                                                              : "",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 10,
                                                                        bottom:
                                                                            15),
                                                                child: Text(
                                                                    reversedFeedbackList[
                                                                            index]
                                                                        [
                                                                        "Feeback_comment"]),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Color(
                                                                          0xFFA2ACDE),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 200
                                                                            .w,
                                                                        child:
                                                                            Text(
                                                                          reversedFeedbackList[index]["Employee_name"]
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              color: Color(0xFFA2ACDE),
                                                                              overflow: TextOverflow.fade),
                                                                        )),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 130.h,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

// _logout(context) {
//   return Alert(
//     context: context,
//     type: AlertType.info,
//     title: "Are you sure you want to logout",
//     style: const AlertStyle(
//         isCloseButton: false,
//         titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
//     buttons: [
//       DialogButton(
//         color: ColorUtils.BLUE,
//         child: const Text(
//           "yes",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         onPressed: () async {
//           await TimeTableDatabase.instance.delete();
//           SharedPreferences preferences =
//           await SharedPreferences.getInstance();
//           preferences.remove("email");
//           preferences.remove('userID');
//           preferences.remove('employeeNumber');
//           preferences.remove('name');
//           preferences.remove('designation');
//           preferences.remove("classData");
//           preferences.remove("employeeData");
//           preferences.remove("teacherData");
//           preferences.remove("school_id");
//           preferences.remove("images");
//           preferences.remove("teacher");
//           preferences.remove("hos");
//           preferences.remove("wallpaper");
//           NavigationUtils.goNextFinishAll(context, LoginPage());
//         },
//         // print(widget.academicyear);
//         //width: 120,
//       ),
//       DialogButton(
//         color: ColorUtils.BLUE,
//         child: const Text(
//           "No",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         // print(widget.academicyear);
//         //width: 120,
//       )
//     ],
//   ).show();
// }

// @override
// void dispose() {
//   timer!.cancel();
//   super.dispose();
// }
}

String capitalizeFirstLetterOfEachWord(String input) {
  return input
      .trim()
      .split(' ')
      .where((word) => word.isNotEmpty) // Filter out empty strings
      .map((word) {
    print("$input...........input..............");
    String removeSpace = word.trim();
    print("$removeSpace...........removeSpace..............");
    return removeSpace[0].toUpperCase() + removeSpace.substring(1);
  }).join(' ');
}
