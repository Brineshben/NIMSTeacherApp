import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/api_constants.dart';
import 'package:teacherapp/View/CWidgets/AppBarBackground.dart';
import 'package:teacherapp/View/Home_Page/Home_Widgets/user_details.dart';

import '../../Utils/Colors.dart';
import '../../Utils/constants.dart';

class NonTeacherStudentList extends StatefulWidget {
  String? name;
  String? ClassAndBatch;
  String? LoginedUserEmployeeCode;
  var LoginedUserDesignation;
  String? subjectName;
  bool? isTeacher;
  bool? isAClassTeacher;
  String? images;
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

  NonTeacherStudentList(
      {super.key,
      this.name,
      this.isAClassTeacher,
      this.isTeacher,
      this.subjectName,
      this.ClassAndBatch,
      this.LoginedUserDesignation,
      this.LoginedUserEmployeeCode,
      this.images,
      this.school_id,
      this.userId,
      this.batchName,
      this.academic_year,
      this.batch_id,

      this.class_id,
      this.className,
      this.curriculam_id,
      this.selectedDate,
      this.session_id,
      this.timeString});

  @override
  _NonTeacherStudentListState createState() => _NonTeacherStudentListState();
}

class _NonTeacherStudentListState extends State<NonTeacherStudentList> {
  bool currentState = true;
  bool isSpinner = false;
  bool newSpinner = false;
  bool disableKey = false;
  final _searchController = TextEditingController();

  // stt.SpeechToText _speech = stt.SpeechToText();
  final bool _isListening = false;
  final String _textSpeech = "Search Here";
  bool attendance_flag = false;

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
    print("------------heudc1");
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
      "att_type": "once",
      "fileServerUrl": "https://teamsqa4000.educore.guru",
      "xclass": widget.className.toString().split(" ")[0],
      "batch": widget.className.toString().split(" ")[1],
      "subject": widget.subjectName,
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

    print('-----------------sssssss${request.body}');

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      print('std list-------->$jsonResponse');
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
          if (newStudentList.isNotEmpty) {
            ourStudentList = newStudentList[0]
                ["feeDetails"]; // You can safely access the element here.
            // modifiedStudentList = newStudentList[0]['feeDetails'];
            ourStudentList
                .sort((a, b) => a['username'].compareTo(b['username']));
          }
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
              "roll_number": ourStudentList[ind]["roll_number"],
              "subjects": json.encode(SubjectIds),
              "user_name": ourStudentList[ind]["username"],
              "admission_number": ourStudentList[ind]["admission_number"],
              "gender": ourStudentList[ind]["gender"],
              "birth_date": ourStudentList[ind]["birth_date"]
            });
          }
        } else {
          print("attendance taken");
          snackBar(
              context: context,
              message: "Attendance Taken",
              color: Colors.green);
          // Utils.showToastSuccess("Attendance Taken").show(context);
          newStudentList.add(
              StudentList!["data"]["attendance_settings"][i]["full_students"]);
          if (newStudentList.isNotEmpty) {
            afterAttendanceTaken =
                newStudentList[0]; // You can safely access the element here.
            // modifiedStudentList = newStudentList[0]['feeDetails'];
          }
          for (var index = 0; index < afterAttendanceTaken.length; index++) {
            afterAttendanceTaken[index].addAll({"is_present": true});
          }
          log("the after taken $afterAttendanceTaken");
          setState(() {
            newResult = afterAttendanceTaken;
          });
          log("the after takennnn $isStudentListnull");
          for (var ind = 0; ind < afterAttendanceTaken.length; ind++) {
            modifiedStudentList.add({
              "_id": afterAttendanceTaken[ind]["_id"],
              "user_id": afterAttendanceTaken[ind]["user_id"],
              "roll_number": afterAttendanceTaken[ind]["roll_number"],
              "subjects": json.encode(SubjectIds),
              "user_name": afterAttendanceTaken[ind]["username"],
              "admission_number": afterAttendanceTaken[ind]["admission_number"],
              "gender": afterAttendanceTaken[ind]["gender"],
              "birth_date": afterAttendanceTaken[ind]["birth_date"]
            });
          }
          setState(() {
            isStudentListnull = afterAttendanceTaken;
            for (var j = 0; j < isStudentListnull.length; j++) {
              if (isStudentListnull[j]["feeDetails"]
                  .containsKey("roll_number")) {
                isStudentListnull.sort((a, b) => a["feeDetails"]["roll_number"]
                    .compareTo(b["feeDetails"]["roll_number"]));
              }
            }
            log("the after taken $isStudentListnull");
            newResult = afterAttendanceTaken;
          });
        }
      }

      log("the modified list is $modifiedStudentList");

      print("the student list is $ourStudentList");
    } else {
      print(response.reasonPhrase);
    }
    setState(() {
      isSpinner = false;
    });
  }

  var StudentListOnAttendance;

  Future SubmitAttendance() async {
    attendance_flag = true;
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

    log('-------StudentIds--------$StudentIds');
    log('-------absenties--------$absenties');

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST',
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
      "student_attendence": []
    });
    log("the result of attendance is ${request.body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Successfully submitted");
      await snackBar(
          context: context,
          message: "Attendance Submitted Successfully",
          color: Colors.green);
      // Utils.showToastSuccess("Attendance Submitted Successfully")
      //     .show(context)
      Navigator.of(context).pop();
      //     .then((_) {
      //   Navigator.of(context).pop();
      // });
      setState(() {
        newSpinner = false;
      });
      log(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Map<String, dynamic>? notificationResult;
  int Count = 0;

  @override
  void initState() {
    getStudentAttendanceList();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    // print(count);
    // getNotification();
    // _speech = stt.SpeechToText();
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
          child: Stack(
            children: [
              const AppBarBackground(),
              // SizedBox(
              //     width: MediaQuery.of(context).size.width,
              //     child: Image.asset(
              //       "assets/images/header.png",
              //       fit: BoxFit.fill,
              //     )),
              const UserDetails(
                  shoBackgroundColor: false,
                  isWelcome: false,
                  bellicon: true,
                  notificationcount: true),

              Container(
                margin: EdgeInsets.only(left: 10.w, top: 128.h, right: 10.w),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.lightBlue.shade50),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                     
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(

                                child: Text(
                                  "${widget.className.toString()}"
                                  " "
                                  "${widget.subjectName.toString()}",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
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
                                color:
                                    Colorutils.userdetailcolor.withOpacity(0.4),
                              ),
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
                            widget.timeString == null
                                ? const Text(" ")
                                : Text(
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
                          setState(() {
                            print(
                                'isStudentListnull.....--------$isStudentListnull');
                            print(
                                'afterAttendanceTaken.....--------$afterAttendanceTaken');
                            print(isStudentListnull);
                            newResult = isStudentListnull
                                .where((element) => element["username"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(value))
                                .toList();
                            print(
                                'NON_TEACHER_STUDENTLIST____newResult$newResult');
                            print(_searchController.text);
                          });
                        },
                        validator: (val) =>
                            val!.isEmpty ? 'Enter the Topic' : null,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText:
                                _isListening ? "Listening..." : "Search Here",
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            // suffixIcon: GestureDetector(
                            //   onTap: () => onListen(),
                            //   child: AvatarGlow(
                            //     animate: _isListening,
                            //     glowColor: Colors.blue,
                            //     endRadius: 20.0,
                            //     duration: Duration(milliseconds: 2000),
                            //     repeat: true,
                            //     showTwoGlows: true,
                            //     repeatPauseDuration:
                            //         Duration(milliseconds: 100),
                            //     child: Icon(
                            //       _isListening == false
                            //           ? Icons.keyboard_voice_outlined
                            //           : Icons.keyboard_voice_sharp,
                            //       color: ColorUtils.SEARCH_TEXT_COLOR,
                            //     ),
                            //   ),
                            // ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 236, 254, 8),
                                  width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 236, 254, 8),
                                  width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            fillColor: const Color.fromRGBO(230, 236, 254, 8),
                            filled: true),
                      ),
                    ),
                    afterAttendanceTaken == null
                        ? const Text("")
                        : Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 20,
                                    margin: const EdgeInsets.all(8),
                                    child: Text(
                                      "Note: Attendance has already been taken.",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 8.h,
                    ),
                    isSpinner
                        ? Expanded(
                            child: Center(
                              child: Container(
                                child: const Center(
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
                            ? Center(
                                child: Image.asset("assets/images/nodata.gif"))
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 150),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: _searchController.text
                                              .toString()
                                              .isNotEmpty
                                          ? newResult.length
                                          : afterAttendanceTaken == null
                                              ? ourStudentList.length
                                              : afterAttendanceTaken.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
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
                                                        position:
                                                            badges.BadgePosition
                                                                .bottomEnd(
                                                                    end: 0,
                                                                    bottom: -10),
                                                        badgeContent: Text(
                                                          "${index + 1}",
                                                          style: const TextStyle(
                                                              color: Colorutils
                                                                  .userdetailcolor),
                                                        ),
                                                        badgeStyle:
                                                            const badges.BadgeStyle(
                                                          elevation: 0,
                                                          badgeColor:
                                                              Colors.white,
                                                          borderSide: BorderSide(
                                                            color: Colorutils
                                                                .chatcolor,
                                                            // Replace with your desired border color
                                                            width:
                                                                1.0, // Adjust the width of the border
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 50.w,
                                                          height: 50.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colorutils
                                                                    .chatcolor),
                                                            // image: DecorationImage(
                                                            //     image: NetworkImage(afterAttendanceTaken !=
                                                            //             null
                                                            //         ? (afterAttendanceTaken[index]["feeDetails"]["image"] ==
                                                            //                 "avathar"
                                                            //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                            //             : _searchController
                                                            //                     .text
                                                            //                     .isNotEmpty
                                                            //                 ? ApiConstants.IMAGE_BASE_URL +
                                                            //                     newResult[index]["feeDetails"]["image"].replaceAll(
                                                            //                         '"', '')
                                                            //                 : ApiConstants.IMAGE_BASE_URL +
                                                            //                     afterAttendanceTaken[index]["feeDetails"]["image"].replaceAll(
                                                            //                         '"', ''))
                                                            //         : (ourStudentList[index]["image"].replaceAll(
                                                            //                     '"',
                                                            //                     '') ==
                                                            //                 null
                                                            //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                            //             : _searchController
                                                            //                     .text
                                                            //                     .isNotEmpty
                                                            //                 ? ApiConstants.IMAGE_BASE_URL + newResult[index]["image"].replaceAll('"', '')
                                                            //                 : ApiConstants.IMAGE_BASE_URL + ourStudentList[index]["image"].replaceAll('"', ''))),
                                                            //     fit: BoxFit.fill),
                                                          ),
                                                          child:
                                                              afterAttendanceTaken ==
                                                                      null
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        width: 50,
                                                                        height:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        imageUrl:
                                                                            "${ApiConstants.downloadUrl}${ourStudentList[index]["image"]}",
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Center(
                                                                          child:
                                                                              Text(
                                                                            ourStudentList[index]["username"]!.split(' ')[0].toString()[0]
                                                                            // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                            ,
                                                                            style: const TextStyle(
                                                                                color: Colorutils.chatcolor,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            ourStudentList[index]["username"]!.split(' ')[0].toString()[0]
                                                                            // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                            ,
                                                                            style: const TextStyle(
                                                                                color: Colorutils.chatcolor,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      child: CachedNetworkImage(
                                                                          width: 50,
                                                                          height: 50,
                                                                          fit: BoxFit.fill,
                                                                          imageUrl: "${ApiConstants.downloadUrl}${afterAttendanceTaken[index]["image"]}",
                                                                          placeholder: (context, url) => Center(
                                                                                child: Text(
                                                                                  afterAttendanceTaken[index]["username"]!.split(' ')[0].toString()[0]
                                                                                  // '${afterAttendanceTaken[index]["username"].split(' ')[1].toString()[0]}'
                                                                                  ,
                                                                                  style: const TextStyle(color: Color(0xFFB1BFFF), fontWeight: FontWeight.bold, fontSize: 20),
                                                                                ),
                                                                              ),
                                                                          errorWidget: (context, url, error) {
                                                                            return Center(
                                                                              child:
                                                                                  Text(
                                                                                afterAttendanceTaken[index]["username"]!.trim().toString()[0]
                                                                                // '${afterAttendanceTaken[index]["username"].split(' ')[1].toString()[0]}'
                                                                                ,
                                                                                style: const TextStyle(color: Color(0xFFB1BFFF), fontWeight: FontWeight.bold, fontSize: 20),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                    width: 180.w,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child: Text(
                                                                          _searchController.text.toString().isNotEmpty
                                                                              ? capitalizeFirstLetterOfEachWord(newResult[index]["username"].toString().toLowerCase()).toString()
                                                                              : afterAttendanceTaken == null || afterAttendanceTaken.isEmpty
                                                                                  ? capitalizeFirstLetterOfEachWord(ourStudentList[index]["username"].toString().toLowerCase()).toString()
                                                                                  : capitalizeFirstLetterOfEachWord(afterAttendanceTaken[index]["username"].toString().toLowerCase()).toString(),
                                                                          style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold))),
                                                                    )),
                                                              ],
                                                            ),

                                                            // SizedBox(
                                                            //   width: 40.w,
                                                            // ),

                                                            const Spacer(),
                                                            Container(
                                                              child:
                                                                  FlutterSwitch(
                                                                width: 80.w,
                                                                height: 35.h,
                                                                valueFontSize:
                                                                    16.sp,
                                                                toggleSize: 35.h,
                                                                toggleBorder: Border.all(
                                                                    color: const Color(
                                                                        0xFFD6E4FA),
                                                                    width: 2),
                                                                value: afterAttendanceTaken ==
                                                                            null ||
                                                                        afterAttendanceTaken
                                                                            .isEmpty
                                                                    ? _searchController
                                                                            .text
                                                                            .isNotEmpty
                                                                        ? newResult[
                                                                                index]
                                                                            [
                                                                            "is_present"]
                                                                        : ourStudentList[
                                                                                index]
                                                                            [
                                                                            "is_present"]
                                                                    : _searchController
                                                                            .text
                                                                            .isNotEmpty
                                                                        ? newResult[
                                                                                index]
                                                                            [
                                                                            "selected"]
                                                                        : afterAttendanceTaken[
                                                                                index]
                                                                            [
                                                                            "selected"],
                                                                borderRadius:
                                                                    30.0,
                                                                padding: 0,
                                                                activeColor: Colorutils
                                                                    .userdetailcolor
                                                                    .withOpacity(
                                                                        0.8),
                                                                inactiveColor:
                                                                    Colors.red,
                                                                activeText: "P",
                                                                inactiveText: "A",
                                                                inactiveTextColor:
                                                                    Colors.white,
                                                                activeTextColor:
                                                                    Colors.white,
                                                                showOnOff: true,
                                                                onToggle: (val) {
                                                                  setState(() {
                                                                    afterAttendanceTaken == null ||
                                                                            afterAttendanceTaken
                                                                                .isEmpty
                                                                        ? _searchController
                                                                                .text
                                                                                .isNotEmpty
                                                                            ? newResult[index]["is_present"] =
                                                                                val
                                                                            : ourStudentList[index]["is_present"] =
                                                                                val
                                                                        : _searchController
                                                                                .text
                                                                                .isNotEmpty
                                                                            ? newResult[index]["selected"] =
                                                                                val
                                                                            : afterAttendanceTaken[index]["selected"] =
                                                                                val;

                                                                    if (attendance_flag ==
                                                                        true) {
                                                                      attendance_flag =
                                                                          false;
                                                                    }
                                                                  });

                                                                  print(
                                                                      "the selected value is $ourStudentList");
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 15.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  indent: 20,
                                                  endIndent: 20,
                                                  height: 20,
                                                  color: Colors.lightBlue.shade50,
                                                )
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                  ],
                ),
              )
            ],
          ),
        ),
        // floatingActionButton: button(),
        floatingActionButton: SizedBox(
          height: 50.w,
          width: 200.w,
          child: FloatingActionButton.extended(
            elevation:
                isStudentListnull.isEmpty || disableKey || newSpinner ? 0 : 8,
            onPressed: isStudentListnull.isEmpty || disableKey
                ? () {}
                : () {
                    if (_searchController.text.isNotEmpty &&
                        newResult.isEmpty) {
                      snackBar(
                          context: context,
                          message: "No Data Available to Submit",
                          color: Colors.red);
                      // Utils.showToastError("No Data Available to Submit")
                      //     .show(context);
                    } else {
                      context.loaderOverlay.show();
                      setState(() {
                        newSpinner = true;
                        disableKey = true;
                      });
                      if (attendance_flag == true) {
                        print("kckkckckckkkckc");
                        snackBar(
                            context: context,
                            message: "Please wait the data is uploading",
                            color: Colors.red);
                        // Utils.showToastError(
                        //     "Please wait the data is uploading")
                        //     .show(context);
                      } else {
                        SubmitAttendance();
                        context.loaderOverlay.hide();
                      }
                    }
                  },
            backgroundColor: isStudentListnull.isEmpty || disableKey
                ? Colors.transparent
                : Colorutils.bottomnaviconcolor,
            label: const Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget NonTeacherStudentList(
          String images, String nameOfStudent, var attendanceArray) =>
      Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(ApiConstants.downloadUrl + images),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 150.w,
                        child: Text(nameOfStudent,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      child: FlutterSwitch(
                        width: 80.w,
                        height: 34.h,
                        valueFontSize: 16.sp,
                        toggleSize: 30.h,
                        value: ourStudentList[0]["fee_arrear"],
                        borderRadius: 30.0,
                        padding: 8.0,
                        activeColor: Colors.green,
                        inactiveColor: Colors.red,
                        activeText: "P",
                        inactiveText: "A",
                        inactiveTextColor: Colors.white,
                        activeTextColor: Colors.white,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            ourStudentList[0]["fee_arrear"] = val;
                          });
                          print("the selected value is $attendanceArray");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            height: 20,
          )
        ],
      );

  // @override
  // void dispose() {
  //   timer!.cancel();
  //   super.dispose();
  // }

  Widget button() {
    if (isStudentListnull.isEmpty || disableKey || newSpinner) {
      // return FloatingActionButton.extended(
      //     elevation: 0,
      //     onPressed: () {},
      //     backgroundColor: Colors.white,
      //     label: CircularProgressIndicator(color: ColorUtils.BLUE,));
      return const SizedBox();
    } else {
      return FloatingActionButton.extended(
        elevation:
            isStudentListnull.isEmpty || disableKey || newSpinner ? 0 : 8,
        onPressed: isStudentListnull.isEmpty || disableKey
            ? () {}
            : () {
                if (_searchController.text.isNotEmpty && newResult.isEmpty) {
                  snackBar(
                      context: context,
                      message: "No Data Available to Submit",
                      color: Colors.red);
                  // Utils.showToastError("No Data Available to Submit")
                  //     .show(context);
                } else {
                  setState(() {
                    newSpinner = true;
                    disableKey = true;
                  });
                  if (attendance_flag == true) {
                    print("kckkckckckkkckc");
                    snackBar(
                        context: context,
                        message: "Please wait the data is uploading",
                        color: Colors.red);
                    // Utils.showToastError("Please wait the data is uploading")
                    //     .show(context);
                  } else {
                    SubmitAttendance();
                  }
                }
              },
        backgroundColor: isStudentListnull.isEmpty || disableKey
            ? Colors.transparent
            : Colors.blue,
        label: const Text("SUBMIT"),
      );
    }
  }
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
