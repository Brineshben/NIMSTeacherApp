import 'dart:async';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/OldScreens/historyPage.dart';
import '../../Utils/api_constants.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import '../My_Class/Myclass.dart';
import 'historyOfStudentActivity.dart';

class StudentListView extends StatefulWidget {
  String? name;
  String? ClassAndBatch;
  String? LoginedUserEmployeeCode;
  var LoginedUserDesignation;
  String? subjectName;
  String? images;
  bool? isTeacher;
  bool? isAClassTeacher;
  String? school_id;
  String? academic_year;
  String? session_id;
  String? curriculam_id;
  String? class_id;
  String? batch_id;
  String? selectedDate;
  String? className;
  String? batchName;
  String? userId;
  String? timeString;

  StudentListView({this.name,
    this.ClassAndBatch,
    this.LoginedUserEmployeeCode,
    this.LoginedUserDesignation,
    this.subjectName,
    this.images,
    this.isTeacher,
    this.isAClassTeacher,
    this.batch_id,
    this.class_id,
    this.curriculam_id,
    this.session_id,
    this.className,
    this.timeString,
    this.selectedDate,
    this.userId,
    this.academic_year,
    this.school_id,
    this.batchName});

  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  bool currentState = true;
  bool isSpinner = false;
  bool newSpinner = false;
  bool studentFeedbacknull = false;
  bool wiipopup = false;
  bool disableKey = false;
  String text = "  ";
  final _frmKey = GlobalKey<FormState>();
  var _searchController = TextEditingController();

  // stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String? _textSpeech = "Search Here";
  bool attendance_flag = false;
  var lateattendence = false;
  var _reasontextController = new TextEditingController();
  var lateMark = false;
  var lateidreason = '';

  getlateattendance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool? repeat = prefs.getBool('lateattendance');
      lateattendence = repeat!;
      print('late attendance pref--->$lateattendence');
    } catch (e) {}
  }

  // void onListen() async {
  //   if (!_isListening) {
  //     bool available = await _speech.initialize(
  //         debugLogging: true,
  //         onStatus: (val) => print("the onStatus $val"),
  //         onError: (val) => print("onerror $val"));
  //     if (available) {
  //       setState(() {
  //         _isListening = true;
  //       });
  //       _speech.listen(
  //           onResult: (val) => setState(() {
  //             _textSpeech = val.recognizedWords;
  //             _searchController.text = _textSpeech!;
  //             newResult = isStudentListnull
  //                 .where((element) => element["username"]
  //                 .contains("${_textSpeech!.toUpperCase()}"))
  //                 .toList();
  //           }));
  //     }
  //   } else {
  //     setState(() {
  //       _isListening = false;
  //       _speech.stop();
  //     });
  //   }
  // }

  List searchedStudentName = [];
  List newResult = [];
  var newStudentList = [];

  // Timer? timer;
  List forSearch = [];
  var absenties = [];
  var StudentIds = [];
  List ourStudentList = [];
  var newStudendList;
  var modifiedStudentList = [];
  var isStudentListnull = [];
  List<Map> latestudents = [];

  @override
  void initState() {
    getlateattendance();
    getStudentAttendanceList();

    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    // print(count);
    // getNotification();
    // _speech = stt.SpeechToText();
    super.initState();
  }

  var afterAttendanceTaken;

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
        ),
      );
    },
  );

  var SubjectIds = [
    "subject123456",
    "subjectArtEdu6",
    "765d8gfheHJNt",
    "subjectDesc",
    "subject123",
    "subjectGenKnwi",
    "5d08b782035c5c68be840d43",
    "subject1234",
    "3h2S6noQZiAkP",
    "subject12345",
    "765d8gfhNVVert",
    "yj6wZhLmLWAtb",
    "subjectHealthAndPE",
    "5d0f0eb1a0a6ad1dc97a61d0",
    "c4A25ahdFonzb",
    "hnAttZHatyQRA",
    "7658gfhNNBVVert"
  ];

  Map<String, dynamic>? StudentList;

  Future getStudentAttendanceList() async {
    setState(() {
      isSpinner = true;
    });
    try {
      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.studentListApi));
      request.body = json.encode({
        "school_id": widget.school_id,
        "academic_year": widget.academic_year,
        "session_id": widget.session_id,
        "curriculum_id": widget.curriculam_id,
        "class_id": widget.class_id,
        "batch_id": widget.batch_id,
        "for_attendance": true,
        "selected_date":
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        // "selected_date": "2022-03-10T00:00:00.000Z",
        "att_type": "once",
        "fileServerUrl": ApiConstants.downloadUrl,
        "xclass": widget.className.toString().split(" ")[0],
        "batch": widget.className.toString().split(" ")[1],
        "is_report": false,
        "date": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        "user_id": widget.userId,
        "selected_period": {
          "_id": "once",
          "name": "Full Day - Lite",
          "period_number": false,
          "lite": true
        }
      });
      request.headers.addAll(headers);

      print("--------url---------${ApiConstants.baseUrl +
          ApiConstants.studentListApi}");
      print('-----new----bodyyy${request.body}');

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        log('student  list-------->${jsonResponse}->>>>endddddd');
        setState(() {
          StudentList = json.decode(jsonResponse);
        });
        for (var i = 0;
        i < StudentList!["data"]["attendance_settings"].length;
        i++) {
          if (StudentList!["data"]["attendance_settings"][i]["taken_status"] ==
              false) {
            newStudentList.add(
                StudentList!["data"]["attendance_settings"][i]["full_students"]);
            if (newStudentList != null && newStudentList.length != 0) {
              ourStudentList = newStudentList[0]["feeDetails"];
              ourStudentList.sort((a, b) => a['username'].compareTo(b['username']));
              // You can safely access the element here.
              // modifiedStudentList = newStudentList[0]['feeDetails'];
            }
            log(
                '--qqqqqqgtguutqqq----${StudentList!["data"]["attendance_settings"]}');
            for (var index = 0; index < ourStudentList.length; index++) {
              ourStudentList[index].addAll({"is_present": true});
            }
            setState(() {
              isStudentListnull = ourStudentList;
              newResult = isStudentListnull;
            });
            for (var ind = 0; ind < ourStudentList.length; ind++) {
              modifiedStudentList.add({
                "_id": ourStudentList[ind]["_id"],
                "user_id": ourStudentList[ind]["user_id"],
                "roll_number": ourStudentList[ind].containsValue("roll_number")
                    ? ourStudentList[ind]["roll_number"]
                    : " ",
                "subjects": json.encode(SubjectIds),
                "user_name": ourStudentList[ind]["username"],
                "admission_number": ourStudentList[ind]["admission_number"],
                "gender": ourStudentList[ind]["gender"],
                "birth_date": ourStudentList[ind]["birth_date"]
              });
            }
          } else {
            lateMark = true;
            print("attendance taken");
            snackBar(context: context,
                message: "Attendance Taken",
                color: Colors.green);
            // Utils.showToastSuccess("Attendance Taken").show(context);
            newStudentList.add(
                StudentList!["data"]["attendance_settings"][i]["full_students"]);
            log('--qqqqqqqqq----$newStudentList');
            if (newStudentList != null && newStudentList.length != 0) {
              afterAttendanceTaken =
              newStudentList[0]; //
              // afterAttendanceTaken
              //     .sort((a, b) => a['username'].compareTo(b['username']));
              // You can safely access the element here.
              // modifiedStudentList = newStudentList[0]['feeDetails'];
              print(">>>>>>>>>>>>>>>>>>newstudentlist>>>>>>>>> $afterAttendanceTaken");
            }
            print(">>>>>>>>>>>>>>>>>>ourStudentList>>>>>>>>> $ourStudentList");
            for (var index = 0; index < afterAttendanceTaken.length; index++) {
              afterAttendanceTaken[index].addAll({"is_present": true});
            }

            log("the after taken $afterAttendanceTaken");
            setState(() {
              isStudentListnull = afterAttendanceTaken;
              newResult = isStudentListnull;
            });
            for (var ind = 0; ind < afterAttendanceTaken.length; ind++) {
              modifiedStudentList.add({
                "_id": afterAttendanceTaken[ind]["_id"],
                "user_id": afterAttendanceTaken[ind]["user_id"],
                "roll_number": afterAttendanceTaken[ind].containsValue(
                    "roll_number")
                    ? afterAttendanceTaken[ind]["roll_number"]
                    : " ",
                "subjects": json.encode(SubjectIds),
                "user_name": afterAttendanceTaken[ind]["username"],
                "admission_number": afterAttendanceTaken[ind]["admission_number"],
                "gender": afterAttendanceTaken[ind]["gender"],
                "birth_date": afterAttendanceTaken[ind]["birth_date"]
              });
            }
            // setState(() {
            //   isStudentListnull = afterAttendanceTaken;
            //   for (var j = 0; j < isStudentListnull.length; j++) {
            //     if (isStudentListnull[j]["feeDetails"].containsKey(
            //         "roll_number")) {
            //       try {
            //         isStudentListnull.sort((a, b) {
            //           return
            //             a["feeDetails"]["roll_number"]
            //                 .compareTo(b["feeDetails"]["roll_number"]);
            //         });
            //       } catch(e) {}
            //     } else {
            //       print("jjjjjjjjjjjjjjjjjjjjjjjjjj");
            //     }
            //   }
            // });
            // setState(() {
            //   newResult = afterAttendanceTaken;
            // });
          }
          print('newResult------------1$newResult');
        }

        log("the modified list is $modifiedStudentList");

        print("the student list is $ourStudentList");
      } else {
        print(response.reasonPhrase);
      }
    } catch(e) {}
    setState(() {
      isSpinner = false;
    });
  }

  var StudentListOnAttendance;

  Future SubmitAttendance(List<dynamic> late) async {
    //attendance_flag = true;
    print(
        'aaaaaaaaaaaaaatttttttttttttttttttendanceeeeee>>>>>>>>$attendance_flag');
    for (var i = 0;
    i < StudentList!["data"]["attendance_settings"].length;
    i++) {
      if (StudentList!["data"]["attendance_settings"][i]["taken_status"] ==
          false) {
        for (var index = 0; index < ourStudentList.length; index++) {
          if (ourStudentList[index]["is_present"] == true) {
            StudentIds.add(ourStudentList[index]["user_id"]);
          }
          if (ourStudentList[index]["is_present"] == false) {
            absenties.add({
              "_id": ourStudentList[index]["_id"],
              "user_id": ourStudentList[index]["user_id"],
              "username": ourStudentList[index]["username"],
              "user_name": ourStudentList[index]["username"],
              "contact_no": ourStudentList[index]["contact_no"],
              "admission_number": ourStudentList[index]["admission_number"],
              "image": ourStudentList[index]["image"],
              "joined_date": ourStudentList[index]["joined_date"],
              "selected": ourStudentList[index]["selected"],
              "parent_name": ourStudentList[index]["parent_name"],
              "parent_email": ourStudentList[index]["parent_email"],
              "parent_phone": ourStudentList[index]["parent_phone"],
              "fee_arrear": ourStudentList[index]["fee_arrear"],
              "fee_amount": ourStudentList[index]["fee_amount"],
              "roll_number": ourStudentList[index]["roll_number"],
              "reason": "absent"
            });
          }
        }
      } else {
        for (var index = 0; index < afterAttendanceTaken.length; index++) {
          if (afterAttendanceTaken[index]["selected"] == true) {
            StudentIds.add(afterAttendanceTaken[index]["user_id"]);
          }
          if (afterAttendanceTaken[index]["selected"] == false) {
            absenties.add({
              "_id": afterAttendanceTaken[index]["feeDetails"]["_id"],
              "user_id": afterAttendanceTaken[index]["feeDetails"]["user_id"],
              "username": afterAttendanceTaken[index]["feeDetails"]["username"],
              "user_name": afterAttendanceTaken[index]["feeDetails"]
              ["username"],
              "contact_no": afterAttendanceTaken[index]["feeDetails"]
              ["contact_no"],
              "admission_number": afterAttendanceTaken[index]["feeDetails"]
              ["admission_number"],
              "image": afterAttendanceTaken[index]["feeDetails"]["image"],
              "joined_date": afterAttendanceTaken[index]["feeDetails"]
              ["joined_date"],
              "selected": afterAttendanceTaken[index]["feeDetails"]["selected"],
              "parent_name": afterAttendanceTaken[index]["feeDetails"]
              ["parent_name"],
              "parent_email": afterAttendanceTaken[index]["feeDetails"]
              ["parent_email"],
              "parent_phone": afterAttendanceTaken[index]["feeDetails"]
              ["parent_phone"],
              "fee_arrear": afterAttendanceTaken[index]["feeDetails"]
              ["fee_arrear"],
              "fee_amount": afterAttendanceTaken[index]["feeDetails"]
              ["fee_amount"],
              "roll_number": afterAttendanceTaken[index]["feeDetails"]
              ["roll_number"],
              "reason": "absent"
            });
          }
        }
      }
    }

    print('-s-t-u-d-e-n-t-s-i-d');
    print('a-b-s-e-n-t-i-e-s$absenties');

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };

    print('---------url-----------${ApiConstants.baseUrl + ApiConstants.attendanceSubmit}');

    var request =
    http.Request('POST',
        Uri.parse(ApiConstants.baseUrl + ApiConstants.attendanceSubmit));
    request.body = json.encode({
      "selections": {
        "school_id": widget.school_id,
        "academic_year": widget.academic_year,
        "user_id": widget.userId,
        "user_role_id": "role12123rqwer",
        "date":
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        "is_attendance": "attendance",
        "class_batch_obj": {
          "class_id": widget.class_id,
          "batch_id": widget.batch_id,
          "class_name": widget.batchName,
          "class_batch_name": widget.batchName,
          "curriculum_id": widget.curriculam_id,
          "session_id": widget.session_id,
          "batch": widget.className.toString().split(" ")[1],
          "xclass": widget.className.toString().split(" ")[0],
        },
        "students": StudentIds,
        "absentees": absenties,
        "att_type": "once",
        "session": widget.session_id,
        "curriculum": widget.curriculam_id,
        "selected_period": {
          "_id": "once",
          "name": "Full Day - Lite",
          "period_number": false,
          "lite": true
        }
      },
      "att_setttings": {
        "periods_to_client": [
          {
            "_id": "once",
            "name": "Full Day - Lite",
            "period_number": false,
            "lite": true
          }
        ],
        "attendance_colln_id": "61ef791f88fd93072241ded5"
      },
      "students": modifiedStudentList,
      "student_attendence": late
    });
    log("_______________-----------the result of attendance is ${request
        .body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Successfully submitted");
      // lateattendence = true;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('lateattendance', true);
      print('late marked--$lateattendence');
      log('boddyyyyyyyattendence---${request.body}--------------end');

      await snackBar(context: context,
          message: "Attendance Submitted Successfully",
          color: Colors.green);
      // .show(context).then((_){
      Navigator.of(context).pop();
      // });
      setState(() {
        newSpinner = false;
      });

      log('--------------b-o-d-d-y-y-r-e-s-p-n-c-e--------${await response
          .stream.bytesToString()}------------------enddddd');
    } else {
      await snackBar(
          context: context,
          message: "Failed to submit.",
          color: Colors.red);
      print(response.reasonPhrase);

      // print('------------<<<absent>>>>>>><<<>>><><><><><$')
    }
  }

  bool showLoader = false;
  Map<String, dynamic>? studentFeebackList;


  Map<String, dynamic>? notificationResult;
  int Count = 0;


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  const AppBarBackground(),
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
                        bellicon: true,
                        notificationcount: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 10.w, top: 120.h, right: 10.w),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r)),
                      // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colorutils.userdetailcolor.withOpacity(0.2),
                          // Shadow color
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20, bottom: 20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(

                                    child: widget.subjectName == null
                                        ? Text(
                                      widget.ClassAndBatch.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    )
                                        : Text(
                                      "${widget.ClassAndBatch?.replaceAll(
                                          " ", "")}  ${widget.subjectName}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: Image.asset(
                                    "assets/images/studentCalender.png",
                                    color: Colorutils.userdetailcolor
                                        .withOpacity(0.4),),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    widget.selectedDate.toString(),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                widget.timeString == null ? Text(" ") : Text(
                                    widget.timeString.toString().split("-")[0],
                                    style: TextStyle(fontSize: 14.sp))
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                print(
                                    'isStudentListnull.....--------$isStudentListnull');
                                print(
                                    'afterAttendanceTaken.....--------$afterAttendanceTaken');
                                newResult = isStudentListnull
                                    .where((element) =>
                                    element["username"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                // newResult = afterAttendanceTaken.where((element) => element["feeDetails"]["username"].contains("${value.toUpperCase()}")).toList();
                                //print(_searchController.text.toString());
                                log("the new result is   $newResult");
                              });
                            },
                            validator: (val) =>
                            val!.isEmpty ? 'Enter the Topic' : null,
                            cursorColor: Colorutils.userdetailcolor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText:
                                _isListening
                                    ? "Listening..."
                                    : "Search Students",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colorutils.userdetailcolor,
                                ),

                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(230, 236, 254, 8),
                                      width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colorutils.chatcolor.withOpacity(
                                          0.3),
                                      width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                ),
                                fillColor: Colorutils.chatcolor.withOpacity(
                                    0.2),
                                filled: true),
                          ),
                        ),
                        afterAttendanceTaken == null
                            ? Text("")
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              margin: EdgeInsets.only(top: 4, left: 8),
                              child: Text(
                                "Note: Attendance has already been taken.",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,

                                    color: Colors.red),
                              )),
                        ),

                        isSpinner
                            ? Expanded(
                          child: Center(
                            child: Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colorutils.chatcolor),
                                  backgroundColor: Colorutils.userdetailcolor,
                                  strokeWidth: 5.0,
                                ),
                              ),
                            ),

                          ),
                        )
                            : newResult.isEmpty
                            ? Center(child: Container(height: 300,
                            child: Image.asset("assets/images/nodata.gif")))
                            : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 2, bottom: 150),
                              // Sort in ascending order
                              itemCount:
                              _searchController.text
                                  .toString()
                                  .isNotEmpty
                                  ? newResult.length
                                  : afterAttendanceTaken == null
                                  ? ourStudentList.length
                                  : afterAttendanceTaken.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SwipeTo(
                                  rightSwipeWidget: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 12, left: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colorutils.userdetailcolor
                                            .withOpacity(0.5),
                                        // Container color
                                        borderRadius: BorderRadius.circular(15),
                                        // Border radius
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colorutils.chatcolor
                                                .withOpacity(0.1),

                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(
                                                0, 2), // Shadow position
                                          ),
                                        ],
                                      ), // Container color

                                      padding: EdgeInsets.all(30),
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  onRightSwipe: (_) {
                                    if (_searchController.text
                                        .toString()
                                        .isEmpty) {
                                      if (afterAttendanceTaken == null) {
                                        if (ourStudentList[index].containsKey(
                                            "mother_details") &&
                                            ourStudentList[index]["mother_details"]
                                                .isNotEmpty &&
                                            ourStudentList[index]["mother_details"]
                                                .containsKey("mother_name") &&
                                            ourStudentList[index]["mother_details"]
                                                .containsKey("mother_mobile")) {
                                          Dialogbox(
                                            context,
                                            _searchController.text.isNotEmpty


                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                : ourStudentList[index]
                                            ["fee_amount"] ?? " "
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_name"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_mobile"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"]
                                            ["mother_mobile"] ?? '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index].containsKey(
                                                "mother_details")
                                                : ourStudentList[index]
                                                .containsKey("mother_details")
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]
                                                .containsKey("mother_details")
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"].containsKey(
                                                "mother_details"),
                                          );
                                        } else {
                                          DialogboxWithoutMotherDetails(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                : ourStudentList[index]
                                            ["fee_amount"] ?? " "
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                          );
                                        }
                                      } else {
                                        if (afterAttendanceTaken[index]
                                        ["feeDetails"].containsKey(
                                            "mother_details") &&
                                            afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"].isNotEmpty &&
                                            afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"]["mother_name"]
                                                .toString()
                                                .isNotEmpty &&
                                            afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"]["mother_mobile"]
                                                .toString()
                                                .isNotEmpty) {
                                          Dialogbox(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                : ourStudentList[index]
                                            ["fee_amount"] ?? " "
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_name"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_name"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_mobile"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"]
                                            ["mother_mobile"] ?? '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index].containsKey(
                                                "mother_details")
                                                : ourStudentList[index]
                                                .containsKey("mother_details")
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]
                                                .containsKey("mother_details")
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"].containsKey(
                                                "mother_details"),
                                          );
                                        } else {
                                          DialogboxWithoutMotherDetails(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                : ourStudentList[index]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : ourStudentList[index]
                                            ["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                          );
                                        }
                                      }
                                    } else {
                                      if (afterAttendanceTaken == null) {
                                        if (newResult[index].containsKey(
                                            "mother_details") &&
                                            newResult[index]["mother_details"]
                                                .isNotEmpty &&
                                            newResult[index]["mother_details"]
                                                .containsKey("mother_name") &&
                                            newResult[index]["mother_details"]
                                                .containsKey("mother_mobile")) {
                                          Dialogbox(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                : ourStudentList[index]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : ourStudentList[index]
                                            ["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_name"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_name"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_mobile"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"]
                                            ["mother_mobile"] ?? '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index].containsKey(
                                                "mother_details")
                                                : ourStudentList[index]
                                                .containsKey("mother_details")
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]
                                                .containsKey("mother_details")
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"].containsKey(
                                                "mother_details"),
                                          );
                                        } else {
                                          DialogboxWithoutMotherDetails(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : ourStudentList[index]
                                            ["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                .toString()
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                          );
                                        }
                                      } else {
                                        if (newResult[index]
                                        ["feeDetails"].containsKey(
                                            "mother_details") &&
                                            newResult[index]
                                            ["feeDetails"]
                                            ["mother_details"].isNotEmpty &&
                                            newResult[index]
                                            ["feeDetails"]
                                            ["mother_details"].containsKey(
                                                "mother_name") &&
                                            newResult[index]
                                            ["feeDetails"]
                                            ["mother_details"].containsKey(
                                                "mother_mobile")) {
                                          Dialogbox(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : ourStudentList[index]
                                            ["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                .toString()
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_name"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_name"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["mother_details"]["mother_name"] ??
                                                '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : ourStudentList[index]["mother_details"]
                                            ["mother_mobile"] ?? '--'
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["mother_details"]["mother_mobile"] ??
                                                '--'
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["mother_details"]
                                            ["mother_mobile"] ?? '--',
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index].containsKey(
                                                "mother_details")
                                                : ourStudentList[index]
                                                .containsKey("mother_details")
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]
                                                .containsKey("mother_details")
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"].containsKey(
                                                "mother_details"),
                                          );
                                        } else {
                                          DialogboxWithoutMotherDetails(
                                            context,
                                            _searchController.text.isNotEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                newResult[index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : afterAttendanceTaken ==
                                                null ||
                                                afterAttendanceTaken.isEmpty
                                                ? capitalizeFirstLetterOfEachWord(
                                                ourStudentList[index]
                                                ["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString()
                                                : capitalizeFirstLetterOfEachWord(
                                                afterAttendanceTaken[
                                                index]["username"]
                                                    .toString()
                                                    .toLowerCase())
                                                .toString(),
                                            afterAttendanceTaken != null
                                                ? (_searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["feeDetails"]["image"]
                                                    .replaceAll('"', '')
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["image"].replaceAll(
                                                '"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                afterAttendanceTaken[index]
                                                ["feeDetails"]["image"]
                                                    .replaceAll('"', ''))
                                                : _searchController.text
                                                .isNotEmpty
                                                ? ApiConstants.downloadUrl +
                                                newResult[index]["image"]
                                                    .replaceAll('"', '')
                                                : ourStudentList[index]["image"]
                                                .replaceAll('"', '') ==
                                                null
                                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                : ApiConstants.downloadUrl +
                                                ourStudentList[index]
                                                ["image"].replaceAll('"', ''),
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_amount"]
                                                : ourStudentList[index]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : ourStudentList[index]
                                            ["fee_amount"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["fee_amount"] ==
                                                null
                                                ? " "
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_amount"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_amount"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["fee_arrear"]
                                                : ourStudentList[index]["fee_arrear"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["fee_arrear"]
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["fee_arrear"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_name"]
                                                .toString()
                                                : ourStudentList[index]["parent_name"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_name"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_name"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["parent_phone"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["parent_phone"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["parent_phone"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]["parent_phone"],
                                            afterAttendanceTaken == null
                                                ? _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["admission_number"]
                                                .toString()
                                                : ourStudentList[index]
                                            ["admission_number"]
                                                : _searchController.text
                                                .isNotEmpty
                                                ? newResult[index]["feeDetails"]["admission_number"]
                                                .toString()
                                                : afterAttendanceTaken[index]
                                            ["feeDetails"]
                                            ["admission_number"],
                                            studentFeebackList,
                                            widget.name.toString(),
                                            widget.LoginedUserEmployeeCode
                                                .toString(),
                                            widget.images.toString(),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  // leftSwipeWidget:  Container(
                                  //   padding: EdgeInsets.all(30),
                                  //   color: ColorUtils.LOGIN_BUTTON,
                                  //   child: Icon(
                                  //     Icons.contacts,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  // onLeftSwipe: () {
                                  //   Container(
                                  //     height: 200,
                                  //     color: Colors.red,
                                  //   );
                                  // },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: Column(
                                        children: [
                                          Theme(
                                            data: ThemeData().copyWith(
                                                dividerColor:
                                                Colors.transparent),
                                            child: Row(
                                              children: [
                                                badges.Badge(

                                                  position: badges.BadgePosition
                                                      .bottomEnd(
                                                      end: 0, bottom: -10),

                                                  badgeContent: Text(
                                                    "${index + 1}",
                                                    style: TextStyle(
                                                        color: Colorutils
                                                            .userdetailcolor),
                                                  ),
                                                  badgeStyle:
                                                  badges.BadgeStyle(

                                                    elevation: 0,
                                                    badgeColor: Colorutils
                                                        .Whitecolor,
                                                    borderSide: BorderSide(
                                                      color: Colorutils
                                                          .chatcolor,
                                                      // Replace with your desired border color
                                                      width: 1.0, // Adjust the width of the border
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 60.w,
                                                    height: 60.h,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFD6E4FA)),
                                                      shape: BoxShape.circle,
                                                      // image: DecorationImage(
                                                      //     image: NetworkImage( afterAttendanceTaken != null
                                                      //         ? (afterAttendanceTaken[index]["feeDetails"]["image"] ==
                                                      //                 "avathar"
                                                      //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                      //             :_searchController.text.isNotEmpty
                                                      //         ? ApiConstants.downloadUrl + newResult[index]["feeDetails"]["image"].replaceAll('"', '') : ApiConstants
                                                      //                     .downloadUrl +
                                                      //                 afterAttendanceTaken[index]
                                                      //                         ["feeDetails"][
                                                      //                     "image"].replaceAll('"', ''))
                                                      //         : (ourStudentList[index]["image"].replaceAll('"', '') ==
                                                      //                 null
                                                      //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                      //             : _searchController.text.isNotEmpty
                                                      //         ? ApiConstants.downloadUrl + newResult[index]["image"].replaceAll('"', '') : ApiConstants
                                                      //                     .downloadUrl +
                                                      //                 ourStudentList[index]
                                                      //                     ["image"].replaceAll('"', ''))),
                                                      //     fit: BoxFit.fill),
                                                    ),
                                                    child:
                                                    afterAttendanceTaken == null
                                                        ?
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(100),
                                                      child: CachedNetworkImage(
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.fill,
                                                        imageUrl: "${ApiConstants.downloadUrl}${ourStudentList[index]['feeDetails']?["image"] ?? ''}",
                                                        placeholder: (context,
                                                            url) =>
                                                            Center(
                                                              child: Text(
                                                                '${ourStudentList[index]["username"]!
                                                                    .split(
                                                                    ' ')[0]
                                                                    .toString()[0]}'
                                                                // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                ,
                                                                style: TextStyle(
                                                                    color: Colorutils
                                                                        .chatcolor,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 20),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                            Center(
                                                              child: Text(
                                                                '${ourStudentList[index]["username"]!
                                                                    .split(
                                                                    ' ')[0]
                                                                    .toString()[0]}'
                                                                // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                ,
                                                                style: TextStyle(
                                                                    color: Colorutils
                                                                        .chatcolor,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 20),
                                                              ),
                                                            ),
                                                      ),
                                                    )
                                                        : ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(100),
                                                      child: CachedNetworkImage(
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.fill,
                                                        imageUrl: "${ApiConstants.downloadUrl}${afterAttendanceTaken[index]['feeDetails']["image"]}",
                                                        placeholder: (context,
                                                            url) =>
                                                            Center(
                                                              child: Text(
                                                                '${afterAttendanceTaken[index]["username"]!
                                                                    .split(
                                                                    ' ')[0]
                                                                    .toString()[0]}'
                                                                // '${afterAttendanceTaken[index]["username"].split(' ')[1].toString()[0]}'
                                                                ,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFB1BFFF),
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 20),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                            Center(
                                                              child: Text(
                                                                '${afterAttendanceTaken[index]["username"]!
                                                                    .split(
                                                                    ' ')[0]
                                                                    .toString()[0]}'
                                                                // '${afterAttendanceTaken[index]["username"].split(' ')[1].toString()[0]}'
                                                                ,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFB1BFFF),
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 20),
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 14.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: 200.w,
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis
                                                              .horizontal,
                                                          child: Text(
                                                              _searchController
                                                                  .text
                                                                  .isNotEmpty
                                                                  ? capitalizeFirstLetterOfEachWord(
                                                                  newResult[index]["username"]
                                                                      .toString()
                                                                      .toLowerCase())
                                                                  .toString()
                                                                  : afterAttendanceTaken ==
                                                                  null ||
                                                                  afterAttendanceTaken
                                                                      .isEmpty
                                                                  ? capitalizeFirstLetterOfEachWord(
                                                                  ourStudentList[index]["username"]
                                                                      .toString()
                                                                      .toLowerCase())
                                                                  .toString()
                                                                  : capitalizeFirstLetterOfEachWord(
                                                                  afterAttendanceTaken[index]["username"]
                                                                      .toString()
                                                                      .toLowerCase())
                                                                  .toString(),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                      16.sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                        )),
                                                    SizedBox(
                                                      height: 6.h,
                                                    ),
                                                    _searchController.text.isNotEmpty
                                                        ? (afterAttendanceTaken == null ||
                                                        afterAttendanceTaken.isEmpty)
                                                        ? newResult[index]["fee_arrear"] == false
                                                        ? Text("No Pending Fees")
                                                        : ((double.tryParse(
                                                        newResult[index]["fee_amount"]
                                                            .toString()
                                                            .replaceAll(
                                                            ',', '')) ?? 0) < 1) ? Text("No Pending Fees")
                                                        : Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "AED : ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            newResult[index]["fee_amount"]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .red,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),

                                                      ],
                                                    )
                                                        : newResult[index]['feeDetails']["fee_arrear"] == false
                                                        ? Text("No Pending Fees") : ((double.tryParse(
                                                        newResult[index]['feeDetails']["fee_amount"]
                                                            .toString()
                                                            .replaceAll(
                                                            ',', '')) ?? 0) < 1) ? Text("No Pending Fees")
                                                        : Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "AED : ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            newResult[index]['feeDetails']["fee_amount"]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .red,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),

                                                      ],
                                                    )
                                                        :
                                                    afterAttendanceTaken ==
                                                        null ||
                                                        afterAttendanceTaken
                                                            .isEmpty
                                                        ? ourStudentList[index]["fee_arrear"] == false
                                                        ? ((double.tryParse(
                                                        newResult[index]["fee_amount"]
                                                            .toString()
                                                            .replaceAll(
                                                            ',', '')) ?? 0) < 1) ? Text("No Pending Fees") : Text(
                                                      "No Pending Fees",)
                                                        : Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "AED : ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            ourStudentList[index]
                                                            ["fee_amount"]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .red,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),

                                                      ],
                                                    )
                                                        : afterAttendanceTaken[index]["feeDetails"]["fee_arrear"] == false
                                                        ? ((double.tryParse(
                                                        newResult[index]["fee_amount"]
                                                            .toString()
                                                            .replaceAll(
                                                            ',', '')) ?? 0) < 1) ? Text("No Pending Fees") : Row(
                                                      children: [
                                                        Text(
                                                            "No Pending Fees"),
                                                        SizedBox(width: 34.w,),

                                                      ],
                                                    )
                                                        : Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: 40.w,
                                                          child: Text(
                                                            "AED : ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 90.w,
                                                          child: Text(
                                                            afterAttendanceTaken[index]["feeDetails"]["fee_amount"].toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .red,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),

                                                        SizedBox(width: 40.w,),

                                                      ],
                                                    ),

                                                  ],
                                                ),
                                                Spacer(),

                                                // SizedBox(
                                                //   width: 15.w,
                                                // ),
                                                Container(
                                                  child: FlutterSwitch(
                                                      width: 80.w,
                                                      height: 35.h,
                                                      valueFontSize: 16.sp,
                                                      toggleSize: 35.h,
                                                      toggleBorder: Border.all(
                                                          color: Color(
                                                              0xFFD6E4FA),
                                                          width: 2),
                                                      activeText: "P",
                                                      inactiveText: "A",
                                                      value: afterAttendanceTaken ==
                                                          null ||
                                                          afterAttendanceTaken
                                                              .isEmpty
                                                          ? _searchController
                                                          .text.isNotEmpty
                                                          ? newResult[index]["is_present"]
                                                          : ourStudentList[index]
                                                      ["is_present"]
                                                          : _searchController
                                                          .text.isNotEmpty
                                                          ? newResult[index]["selected"]
                                                          : afterAttendanceTaken[
                                                      index]["selected"],
                                                      borderRadius: 30.0,
                                                      padding: 0,
                                                      activeColor: Colorutils
                                                          .userdetailcolor
                                                          .withOpacity(0.8),
                                                      inactiveColor: Colors.red,
                                                      inactiveTextColor:
                                                      Colors.white,
                                                      activeTextColor:
                                                      Colors.white,
                                                      showOnOff: true,
                                                      onToggle: (val) {
                                                        bool? isTaken = isStudentListnull[index]["late"];
                                                        if (isTaken != null &&
                                                            isTaken == true) {
                                                          snackBar(
                                                              context: context,
                                                              message: "Attendance already taken for this student",
                                                              color: Colors
                                                                  .red);
                                                        } else {
                                                          attendance_flag = val;
                                                          // print('remarks------uuu------${afterAttendanceTaken[index]["remarks"]}');
                                                          //  print('username------uuu------${afterAttendanceTaken[index]["username"]}');
                                                          // print('selected------uuu------${afterAttendanceTaken[index]["selected"]}');
                                                          // print('late------uuu------${afterAttendanceTaken[index]["late"]}');
                                                          // print('user_id------uuu------${afterAttendanceTaken[index]["user_id"]}');
                                                          // print('reason------uuu------${afterAttendanceTaken[index]["reason"]}');


                                                          // if (attendance_flag ==
                                                          //     true) {
                                                          //   attendance_flag =
                                                          //   false;
                                                          // }
                                                          print(
                                                              'attendance fl0-----$attendance_flag');
                                                          //print('toggle value--->$val');
                                                          if (lateMark) {
                                                            if (attendance_flag ==
                                                                true) {
                                                              print(
                                                                  'late attendance><><><><><><><><><><>$lateattendence');
                                                              //_showMyDialog;
                                                              showDialog(
                                                                  barrierDismissible: false,
                                                                  context: context,
                                                                  builder: (
                                                                      BuildContext context) =>
                                                                      AlertDialog(
                                                                        title: Container(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    50)),
                                                                          ),
                                                                          child: Form(
                                                                            key: _frmKey,
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Text(
                                                                                  afterAttendanceTaken[index]["feeDetails"]["username"]
                                                                                      .toString()
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                    fontSize: 16
                                                                                        .sp,
                                                                                    fontWeight: FontWeight
                                                                                        .w800,),),
                                                                                SizedBox(
                                                                                  height: 15
                                                                                      .h,),
                                                                                Text(
                                                                                  'Remarks',
                                                                                  style: TextStyle(
                                                                                      fontSize: 14
                                                                                          .sp),),
                                                                                SizedBox(
                                                                                  height: 10
                                                                                      .h,),
                                                                                TextFormField(
                                                                                  maxLength: 32,
                                                                                  validator: (
                                                                                      val) =>
                                                                                  val!
                                                                                      .trim()
                                                                                      .isEmpty
                                                                                      ? '*Enter the Reason'
                                                                                      : null,
                                                                                  controller: _reasontextController,
                                                                                  cursorColor: Colors
                                                                                      .grey,
                                                                                  decoration: InputDecoration(
                                                                                      hintStyle: TextStyle(
                                                                                          color: Colors
                                                                                              .grey),
                                                                                      contentPadding: EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 10.0,
                                                                                          horizontal: 20.0),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius
                                                                                            .all(
                                                                                          Radius
                                                                                              .circular(
                                                                                              0),
                                                                                        ),
                                                                                      ),
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderSide:
                                                                                        BorderSide(
                                                                                            color: Color
                                                                                                .fromRGBO(
                                                                                                230,
                                                                                                236,
                                                                                                254,
                                                                                                8),
                                                                                            width: 1.0),
                                                                                        borderRadius: BorderRadius
                                                                                            .all(
                                                                                            Radius
                                                                                                .circular(
                                                                                                10)),
                                                                                      ),
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderSide:
                                                                                        BorderSide(
                                                                                            color: Color
                                                                                                .fromRGBO(
                                                                                                230,
                                                                                                236,
                                                                                                254,
                                                                                                8),
                                                                                            width: 1.0),
                                                                                        borderRadius: BorderRadius
                                                                                            .all(
                                                                                            Radius
                                                                                                .circular(
                                                                                                5)),
                                                                                      ),
                                                                                      fillColor: Colorutils
                                                                                          .chatcolor
                                                                                          .withOpacity(
                                                                                          0.2),
                                                                                      filled: true),
                                                                                  keyboardType: TextInputType
                                                                                      .text,
                                                                                  maxLines: 5,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10
                                                                                      .h,),
                                                                                Center(
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      if (_frmKey
                                                                                          .currentState!
                                                                                          .validate()) {
                                                                                        setState(() {
                                                                                          _reasontextController;
                                                                                          lateidreason =
                                                                                          afterAttendanceTaken[index]["feeDetails"]["username"];
                                                                                        });
                                                                                        // if(afterAttendanceTaken[index]["late"] == true) {
                                                                                        latestudents
                                                                                            .add(
                                                                                            {
                                                                                              "_id": afterAttendanceTaken[index]["user_id"],
                                                                                              "username": afterAttendanceTaken[index]["username"],
                                                                                              "selected": afterAttendanceTaken[index]["selected"],
                                                                                              // "reason": afterAttendanceTaken[index]["reason"],
                                                                                              "reason": "Late",
                                                                                              "remarks": _reasontextController
                                                                                                  .text,
                                                                                              "late": true,
                                                                                            });
                                                                                        // };
                                                                                        // latestudents.add({
                                                                                        //
                                                                                        // });
                                                                                        Navigator
                                                                                            .pop(
                                                                                            context);
                                                                                        _reasontextController
                                                                                            .clear();
                                                                                        print(
                                                                                            '------>>>>latestudnts<<<<<<<$latestudents');
                                                                                        print(
                                                                                            'attendance----late----students----${ afterAttendanceTaken[index]["late"]}');
                                                                                        print(
                                                                                            'attendance----late----students----${StudentList}');
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                        height: 40
                                                                                            .h,
                                                                                        width: 120
                                                                                            .w,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colorutils
                                                                                              .bottomnaviconcolor,
                                                                                          borderRadius:
                                                                                          BorderRadius
                                                                                              .all(
                                                                                              Radius
                                                                                                  .circular(
                                                                                                  50)),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Mark as Late',
                                                                                            style: TextStyle(
                                                                                                color: Colors
                                                                                                    .white,
                                                                                                fontSize: 12),
                                                                                          ),
                                                                                        )),

                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ));
                                                            }
                                                          }
                                                          setState(() {
                                                            afterAttendanceTaken ==
                                                                null ||
                                                                afterAttendanceTaken
                                                                    .isEmpty
                                                                ?
                                                            _searchController
                                                                .text
                                                                .isNotEmpty
                                                                ?
                                                            newResult[index]["is_present"] =
                                                                val
                                                                : ourStudentList[
                                                            index][
                                                            "is_present"] =
                                                                val
                                                                : _searchController
                                                                .text.isNotEmpty
                                                                ?
                                                            newResult[index]["selected"] =
                                                                val
                                                                : afterAttendanceTaken[
                                                            index][
                                                            "selected"] =
                                                                val;
                                                            print(
                                                                'searcharrayselecyted${newResult[index]["selected"]}');
                                                            print(
                                                                'searcharrayispresent${newResult[index]["is_present"]}');
                                                            // if (attendance_flag ==
                                                            //     true) {
                                                            //   attendance_flag =
                                                            //   false;
                                                            // }
                                                          });
                                                        }
                                                      }
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end,
                                            children: [
                                              _searchController.text.isNotEmpty
                                                  ? newResult[index]["late"] ==
                                                  true ? GestureDetector(
                                                  onTap: () async {
                                                    showDialog(

                                                      context: context,
                                                      builder: (
                                                          BuildContext context) =>
                                                          AlertDialog(
                                                            backgroundColor: Colors
                                                                .transparent,
                                                            title: Container(
                                                              width: 300,
                                                              height: 150,
                                                              margin: EdgeInsets
                                                                  .only(top: 40,
                                                                  bottom: 10),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        20)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.2),
                                                                    spreadRadius: 2,
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 4),
                                                                  ),
                                                                ],
                                                              ),

                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Row(

                                                                    children: [

                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top: 10,
                                                                            left: 40),
                                                                        child: Text(
                                                                          'Remarks ',
                                                                          style: TextStyle(
                                                                              fontSize: 18
                                                                                  .sp,
                                                                              fontWeight: FontWeight
                                                                                  .bold),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width: 45),

                                                                    ],
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height: 15),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                      left: 10,
                                                                      right: 10,),
                                                                    child: Container(
                                                                      height: 60,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        color: Colorutils
                                                                            .chatcolor
                                                                            .withOpacity(
                                                                            0.2),
                                                                      ),

                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .only(
                                                                                left: 3,
                                                                                right: 3),
                                                                            child: Text(
                                                                              newResult[index]["remarks"] ??
                                                                                  "No Remarks Added",
                                                                              style: TextStyle(
                                                                                  fontSize: 16
                                                                                      .sp,
                                                                                  fontWeight: FontWeight
                                                                                      .w500),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: 10),
                                                                  Center(
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        Navigator
                                                                            .pop(
                                                                            context);
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius: BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  10)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors
                                                                                  .grey
                                                                                  .withOpacity(
                                                                                  0.1),
                                                                              spreadRadius: 1,
                                                                              blurRadius: 1,
                                                                              offset: Offset(
                                                                                  0,
                                                                                  1),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        height: 25,
                                                                        width: 50,
                                                                        child: Center(
                                                                          child: Text(
                                                                            "Close",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                color: Colors
                                                                                    .white
                                                                            ),),
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 15),
                                                    child: Container(child: Row(

                                                      children: [
                                                        Icon(Icons
                                                            .remove_red_eye_outlined,
                                                          size: 18,),
                                                        SizedBox(width: 5.w,),
                                                        Text('Late',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .w900,
                                                              color: Colors.red,
                                                              fontSize: 15
                                                                  .sp),),
                                                      ],
                                                    )),
                                                  )) : Text('') :
                                              isStudentListnull[index]["late"] ==
                                                  true ?
                                              GestureDetector(
                                                  onTap: () async {
                                                showDialog(

                                                  context: context,
                                                  builder: (
                                                      BuildContext context) =>
                                                      AlertDialog(
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        title: Container(
                                                          width: 300,
                                                          height: 150,
                                                          margin: EdgeInsets
                                                              .only(top: 40,
                                                              bottom: 10),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    20)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                    0.2),
                                                                spreadRadius: 2,
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                              ),
                                                            ],
                                                          ),

                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(

                                                                children: [

                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 10,
                                                                        left: 40),
                                                                    child: Text(
                                                                      'Remarks ',
                                                                      style: TextStyle(
                                                                          fontSize: 18
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 45),

                                                                ],
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                              ),
                                                              SizedBox(
                                                                  height: 15),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                  left: 10,
                                                                  right: 10,),
                                                                child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        10),
                                                                    color: Colorutils
                                                                        .chatcolor
                                                                        .withOpacity(
                                                                        0.2),
                                                                  ),

                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left: 3,
                                                                            right: 3),
                                                                        child: Text(
                                                                          afterAttendanceTaken[index]["remarks"] ??
                                                                              "No Remarks Added",
                                                                          style: TextStyle(
                                                                              fontSize: 16
                                                                                  .sp,
                                                                              fontWeight: FontWeight
                                                                                  .w500),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Center(
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius: BorderRadius
                                                                          .all(
                                                                          Radius
                                                                              .circular(
                                                                              10)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(
                                                                              0.1),
                                                                          spreadRadius: 1,
                                                                          blurRadius: 1,
                                                                          offset: Offset(
                                                                              0,
                                                                              1),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    height: 25,
                                                                    width: 50,
                                                                    child: Center(
                                                                      child: Text(
                                                                        "Close",
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            color: Colors
                                                                                .white
                                                                        ),),
                                                                    ),

                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                );
                                              },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 15),
                                                    child: Container(child: Row(

                                                      children: [
                                                        Icon(Icons
                                                            .remove_red_eye_outlined,
                                                          size: 18,),
                                                        SizedBox(width: 5.w,),
                                                        Text('Late',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .w900,
                                                              color: Colors.red,
                                                              fontSize: 15
                                                                  .sp),),
                                                      ],
                                                    )),
                                                  )) : Text(''),
                                            ],
                                          ),
                                          Divider(
                                            indent: 20,
                                            endIndent: 20,
                                            height: 20,
                                            color: Colors.blue.shade50,
                                          )

                                        ],
                                      )),
                                );
                              },
                            )),

                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50.w,
          width: 200.w,
          child: FloatingActionButton.extended(
            elevation: isStudentListnull.isEmpty || disableKey || newSpinner
                ? 0
                : 8,
            onPressed: isStudentListnull.isEmpty || disableKey
                ? () {}
                : () async {
              try {
                if (_searchController.text.isNotEmpty && newResult.isEmpty) {
                  snackBar(context: context,
                      message: "No Data Available to Submit",
                      color: Colors.red);
                  // Utils.showToastError("No Data Available to Submit").show(context);
                } else {
                  context.loaderOverlay.show();
                  setState(() {
                    newSpinner = true;
                    disableKey = true;
                  });
                  print('--latestudents--$latestudents');
                  if (afterAttendanceTaken != null) {
                    for (int i = 0; i < afterAttendanceTaken.length; i++) {
                      if (afterAttendanceTaken[i]['late'] == true) {
                        print(
                            '-----lat---------${afterAttendanceTaken[i]["username"]}');
                        latestudents.add({
                          "_id": afterAttendanceTaken[i]["user_id"],
                          "username": afterAttendanceTaken[i]["username"],
                          "selected": afterAttendanceTaken[i]["selected"],
                          // "reason": afterAttendanceTaken[index]["reason"],
                          "reason": "Late",
                          "remarks": afterAttendanceTaken[i]["remarks"],
                          "late": true,
                        });
                      }
                    }
                  }
                  try {
                    await SubmitAttendance(latestudents);
                  } catch(e) {}
                  context.loaderOverlay.hide();
                }
              } catch(e) {}
            },
            backgroundColor:
            isStudentListnull.isEmpty ? Colors.transparent : Colorutils
                .bottomnaviconcolor,
            label: Text("SUBMIT", style: TextStyle(
                color: isStudentListnull.isEmpty ? Colors.transparent : Colors
                    .white),),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // Widget _getCallButton(String phoneNumber) => GestureDetector(
  //       onTap: () {
  //         Utils.call(phoneNumber);
  //         print("button presses");
  //       },
  //       child: Container(
  //         child: Image.asset("assets/images/callbutton.png"),
  //       ),
  //     );

  Future Dialogbox(BuildContext context,
      String studentName,
      String image,
      String Fees,
      bool is_fees_paid,
      String parentName,
      String ParentContact,
      String AdmissionNumber,
      var result,
      String name,
      var employeeCode,
      String teacherimage,
      String motherName,
      String motherPhone,
      bool isMotherDetailExist) {
    print(employeeCode);
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
        ),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
            height: 430.w,
            // height: MediaQuery.of(context).size.height / 2.2,
            margin: EdgeInsets.all(20),
            child: ListView(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(100.h),

                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colorutils.chatcolor.withOpacity(0.2)),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          placeholder: (context, url) =>
                              Center(
                                child: Text(
                                  studentName
                                      ?.substring(0, 1) ??
                                      '',
                                  style: TextStyle(
                                      color: Color(0xFFB1BFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) =>
                              Center(
                                child: Text(
                                  studentName
                                      ?.substring(0, 1) ??
                                      '',
                                  style: TextStyle(
                                      color: Color(0xFFB1BFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                        ),
                      ),
                    ),
                    // ClipRRect(
                    //   borderRadius:
                    //   BorderRadius.circular(100.h),
                    //   child: Container(
                    //     width: 60.w,
                    //     height: 60.w,
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle,color: Colorutils.chatcolor),
                    //     child: CachedNetworkImage(
                    //
                    //
                    //       imageUrl: image,
                    //       errorWidget: (context, url, error) =>
                    //           Center(
                    //             child: Text(
                    //               studentName.split(' ')[0].toString()[0]
                    //               // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                    //               ,
                    //               style: TextStyle(
                    //
                    //                   color: Colorutils.userdetailcolor,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 20),
                    //             ),
                    //           ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: 50.w,
                    //   height: 50.h,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //         image: NetworkImage(image), fit: BoxFit.fill),
                    //   ),
                    // ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 200.w,
                            child: Text(studentName,
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                          height: 6.h,
                        ),
                        is_fees_paid == false
                            ? Text("No Pending Fees", style: TextStyle(
                            fontSize: 12
                        ),)
                            : Row(
                          children: [
                            SizedBox(
                              child: Text(
                                "AED : ",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                Fees,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
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
                  endIndent: 10,
                  height: 15,
                  thickness: 0.2,
                ),
                SizedBox(
                  height: 25.h,
                ),
                parentName.isEmpty ? Text("") : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            child: SvgPicture.asset(
                              "assets/images/profileOne.svg",
                              color: Color(0xFFB1BFFF),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 150.w,
                                  child: Text(capitalizeFirstLetterOfEachWord(
                                      parentName).toUpperCase(),
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                height: 6.h,
                              ),
                              SizedBox(
                                child: Text(
                                  ParentContact,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Utils.call(ParentContact),
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        child: SvgPicture.asset(
                          "assets/images/callButtonTwo.svg",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 150.w,
                                child: Text(
                                    capitalizeFirstLetterOfEachWord(motherName)
                                        .toUpperCase(),
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)))),
                            SizedBox(
                              height: 6.h,
                            ),
                            SizedBox(
                              child: Text(
                                motherPhone,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Utils.call(motherPhone),
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        child: SvgPicture.asset(
                          "assets/images/callButtonOne.svg",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 55.h,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        {
                          Navigator.pop(context);

                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return HistoryOfStudentActivity(
                                  mobileNumber: ParentContact,
                                  loginUserName: widget.name.toString(),
                                  classOfStudent: widget.ClassAndBatch,
                                  parentName: parentName,
                                  TeacherProfile: widget.images,
                                  studentName: studentName,
                                  logedinEmployeecode: employeeCode,
                                  admissionNumber: AdmissionNumber,
                                  studentFees: Fees,
                                  StudentImage: image,
                                  motherName: motherName,
                                  motherPhone: motherPhone,
                                );
                              })
                          );
                        };
                      },
                      child: Container(
                        width: 150.w,
                        height: 55.h,
                        decoration: BoxDecoration(
                          color: Colorutils.bottomnaviconcolor,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color:  Colorutils.bottomnaviconcolor,
                          //
                          //     // Shadow color
                          //     spreadRadius: 0.2,
                          //     blurRadius: 1,
                          //     offset: Offset(0, 1), // Shadow position
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/icon.svg",
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                "Call Status",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    is_fees_paid == false
                        ? Text("") :
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return HistoryPage(
                                mobileNumber: ParentContact,
                                loginUserName: widget.name.toString(),
                                classOfStudent: widget.ClassAndBatch,
                                parentName: parentName,
                                TeacherProfile: teacherimage,
                                studentName: studentName,
                                logedinEmployeecode: employeeCode,
                                admissionNumber: AdmissionNumber,
                                studentFees: Fees,
                                StudentImage: image,
                              );
                            }));
                      },
                      child: CircleAvatar(
                          backgroundColor: Colorutils.bottomnaviconcolor,
                          radius: 25,

                          child: Icon(Icons.add, color: Colors.white, shadows: [
                            BoxShadow(blurRadius: 1,
                                color: Colorutils.userdetailcolor)
                          ],)

                      ),
                    )

                  ],
                )
              ],
            ),
          );
        });
  }

  Future DialogboxWithoutMotherDetails(BuildContext context,
      String studentName,
      String image,
      String Fees,
      bool is_fees_paid,
      String parentName,
      String ParentContact,
      String AdmissionNumber,
      var result,
      String name,
      var employeeCode,
      String teacherimage,) {
    print(employeeCode);
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
        ),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
            height: 300,
            // height: MediaQuery.of(context).size.height / 3,
            margin: EdgeInsets.all(20),
            child: ListView(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(100.h),

                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colorutils.chatcolor.withOpacity(0.2)),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          placeholder: (context, url) =>
                              Center(
                                child: Text(
                                  studentName
                                      ?.substring(0, 1) ??
                                      '',
                                  style: TextStyle(
                                      color: Color(0xFFB1BFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) =>
                              Center(
                                child: Text(
                                  studentName
                                      ?.substring(0, 1) ??
                                      '',
                                  style: TextStyle(
                                      color: Color(0xFFB1BFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 200.w,
                            child: Text(studentName,
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                          height: 6.h,
                        ),
                        is_fees_paid == false
                            ? Text(
                          "No Pending Fees", style: TextStyle(fontSize: 12),)
                            : Row(
                          children: [
                            SizedBox(
                              child: Text(
                                "AED : ",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                Fees,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
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
                  endIndent: 10,
                  height: 15,
                  thickness: 0.2,
                ),
                SizedBox(
                  height: 25.h,
                ),
                parentName.isEmpty ? Text("") : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            child: SvgPicture.asset(
                              "assets/images/profileOne.svg",
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 150.w,
                                  child: Text(capitalizeFirstLetterOfEachWord(
                                      parentName).toUpperCase(),
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                height: 6.h,
                              ),
                              SizedBox(
                                child: Text(
                                  ParentContact,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Utils.call(ParentContact),
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        child: SvgPicture.asset(
                          "assets/images/callButtonTwo.svg",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return HistoryOfStudentActivity(
                                mobileNumber: ParentContact,
                                loginUserName: widget.name.toString(),
                                classOfStudent: widget.ClassAndBatch,
                                parentName: parentName,
                                TeacherProfile: widget.images,
                                studentName: studentName,
                                logedinEmployeecode: employeeCode,
                                admissionNumber: AdmissionNumber,
                                studentFees: Fees,
                                StudentImage: image,
                              );
                            })
                        );
                      },
                      child: Container(
                        width: 150.w,
                        height: 55.h,
                        decoration: BoxDecoration(
                          color: Colorutils.bottomnaviconcolor,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color:  Colorutils.bottomnaviconcolor,
                          //
                          //     // Shadow color
                          //     spreadRadius: 0.2,
                          //     blurRadius: 1,
                          //     offset: Offset(0, 1), // Shadow position
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/icon.svg",
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                "Call Status",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                    SizedBox(width: 10,),
                    is_fees_paid == false
                        ? Text("")
                        : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return HistoryPage(
                                mobileNumber: ParentContact,
                                loginUserName: widget.name.toString(),
                                classOfStudent: widget.ClassAndBatch,
                                parentName: parentName,
                                TeacherProfile: teacherimage,
                                studentName: studentName,
                                logedinEmployeecode: employeeCode,
                                admissionNumber: AdmissionNumber,
                                studentFees: Fees,
                                StudentImage: image,
                              );
                            }));
                      },
                      child: CircleAvatar(
                          backgroundColor: Colorutils.bottomnaviconcolor,
                          radius: 25,

                          child: Icon(Icons.add, color: Colors.white, shadows: [
                            BoxShadow(blurRadius: 1,
                                color: Colorutils.userdetailcolor)
                          ],)

                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
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
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Widget weeklyAttendence() =>
//   Container(
//     height: 18.h,
//     width: 18.w,
//     decoration: BoxDecoration(
//       color: Colors.red[400],
//     borderRadius: BorderRadius.circular(100),
//       border: Border.all(color: Colors.black),
//     ),
//     child:Center(child: Text('M',style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500,color: Colors.white),))
//   );


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
  })
      .join(' ');
}

