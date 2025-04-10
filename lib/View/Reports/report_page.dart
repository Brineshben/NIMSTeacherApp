import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Utils/Colors.dart';
import '../../Utils/api_constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'package:http/http.dart' as http;




class ReportScreen extends StatefulWidget {
  var Empcodee;
  String? teacherName;
  String? image;
  String? HOSID;
  var HOSNAME;
  var loginname;
   ReportScreen({
    this.Empcodee,
    this.loginname,
    this.HOSID,
    this.HOSNAME,
    this.teacherName,
    this.image,
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var committed;
  var callnotAnswred;
  var Invalid;
  var wrong;
  bool isSpinner = false;
  int selected = 0;
  Map<String, dynamic>? loginCredential;
  String? img;
  var duplicateTeacherData = [];
  var teacherData = [];
  var newTeacherData;
  var classB = [];
  var employeeUnderHOS= [];
  final bool _isListening = false;
  final String _textSpeech = "Search Here";
  bool isChecked = true;
  final String _selectedValue = '';
  Map<String, dynamic>? teacherList;

  List newTeacherList = [];
  List newReport = [];
  final _searchController = TextEditingController();
  // var employeeid;
  var loginname;
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  var count;

  getCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
    });
  }

  Timer? timer;

  @override
  void initState() {
    print('Empcodee-----__________________');
    // teacherData();
    // _speech = stt.SpeechToText();
    initialize();
    super.initState();
  }
  Future initialize() async{
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getCount());
    setState(() {
      isSpinner = true;
    });
    await getUserLoginCredentials();
    print('Empcodee--${widget.Empcodee}');
    print('teacherName${widget.teacherName}');
    // print('teacherName${employeeid}');
    // print('teacherName${widget.teacherName}');
    print(count);
    await getTeacherList();
    print("-------dghbdg----------$isSpinner");
    setState(() {
      isSpinner = false;
    });
  }

  Map<String, dynamic>? teacherListdata;

  Future getTeacherList() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    String schoolToken = Get.find<UserAuthController>().schoolToken.value ?? '';
    // employeeid = preferences.getString('employeeNumber');
    print('--widget-----${widget.Empcodee}');
    //isSpinner=true;
    try {
      Map<String, String> headers = {
        'API-Key': '525-777-777',
        'Content-Type': 'application/json'
      };

      final bdy = {
        "action": "getFeedbackTotalSummaryData",
        "token": schoolToken,
        "employee_code": employeeUnderHOS.isEmpty ? widget.Empcodee : employeeUnderHOS
      };

      print("the >>>>>>>>>>>>>>>>>>>>> $bdy");

      final response = await http.post(Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd),
          headers: headers, body: json.encode(bdy));

      //final responseJson = json.decode(response.body);
      print('responserbodybodyesponse${response.body}');
      print(response.statusCode);
      if (response.statusCode == 200) {
        teacherList = json.decode(response.body);
        print('teachteacherListerList$teacherList');

        newTeacherList = teacherList!["data"];
        print("newTeacherList--$newTeacherList");
      } else {

      }
    } finally {
    }
  }
  Future getUserLoginCredentials() async {
    // var result = await Connectivity().checkConnectivity();
    // if (result == ConnectivityResult.none) {
    //   _checkInternet(context);
    // } else {
    try {
      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.workLoad));
      request.body = json.encode({"user_id": widget.HOSID});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      print('----rrreeeqqq${request.body}');
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        loginCredential = json.decode(responseData);
        SharedPreferences preference = await SharedPreferences.getInstance();
        preference.setString('loginCredential', json.encode(loginCredential));
        log("api resss-----$loginCredential");
        print('-------------------role ids-----------------');
        print('array--${loginCredential!["data"]["data"][0]["all_roles_array"]}');

        print('---------------end of----role ids-----------------');
        // print(loginCredential!["data"]["data"][0]["faculty_data"]
        // ["teacherComponent"]["is_class_teacher"]);

        img = loginCredential!["data"]["data"][0]["image"];

        print(">>>>>>>$img<<<<<<<");
        Map<String, dynamic> facultyData =
        loginCredential!["data"]["data"][0]["faculty_data"];
        if (facultyData.containsKey("teacherComponent") ||
            facultyData.containsKey("supervisorComponent") ||
            facultyData.containsKey("hosComponent") ||
            facultyData.containsKey("hodComponent")) {
          if (facultyData.containsKey("teacherComponent")) {
            if (loginCredential!["data"]["data"][0]["faculty_data"]
            ["teacherComponent"]["is_class_teacher"] ==
                true ||
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["teacherComponent"]["is_class_teacher"] ==
                    false) {
              print("-----------------------------------teacher");

              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["teacherComponent"]["own_list"]
                      .length;
              index++) {
                var classBatch = loginCredential!["data"]["data"][0]
                ["faculty_data"]["teacherComponent"]["own_list"][index]
                ["academic"];

                var sessionId = loginCredential!["data"]["data"][0]
                ["faculty_data"]["teacherComponent"]["own_list"][index]
                ["session"]["_id"];

                var curriculumId = loginCredential!["data"]["data"][0]
                ["faculty_data"]["teacherComponent"]["own_list"][index]
                ["curriculum"]["_id"];

                var batchID = loginCredential!["data"]["data"][0]["faculty_data"]
                ["teacherComponent"]["own_list"][index]["batch"]["_id"];

                var classID = loginCredential!["data"]["data"][0]["faculty_data"]
                ["teacherComponent"]["own_list"][index]["class"]["_id"];

                duplicateTeacherData.add({
                  "class": "${classBatch.split("/")[2]} ${classBatch.split("/")[3]}",
                  "session_id": sessionId,
                  "curriculumId": curriculumId,
                  "batch_id": batchID,
                  "class_id": classID,
                  "is_Class_teacher": loginCredential!["data"]["data"][0]
                  ["faculty_data"]["teacherComponent"]["own_list"][index]
                  ["is_class_teacher"]
                });
                print(
                    '${loginCredential!["data"]["data"][0]["faculty_data"]["teacherComponent"]["own_list"][0]["subjects"]}');
                for (var ind = 0;
                ind <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["teacherComponent"]["own_list"][index]
                    ["subjects"]
                        .length;
                ind++) {
                  var subjects = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["teacherComponent"]["own_list"][index]
                  ["subjects"][ind]["name"];

                  teacherData.add({
                    "class": "${classBatch.split("/")[2]} ${classBatch.split("/")[3]}",
                    "subjects": subjects,
                    "session_id": sessionId,
                    "curriculumId": curriculumId,
                    "batch_id": batchID,
                    "class_id": classID,
                    "is_Class_teacher": loginCredential!["data"]["data"][0]
                    ["faculty_data"]["teacherComponent"]["own_list"]
                    [index]["is_class_teacher"]
                  });
                }
              }

              var removeDuplicates = duplicateTeacherData.toSet().toList();
              var newClassTeacherCLass = removeDuplicates
                  .where((element) => element.containsValue(true))
                  .toSet()
                  .toList();

              newTeacherData = newClassTeacherCLass;
              log("tdhdhdhdhdhdbhdhd ${newTeacherData.length}");

              log(">>>>>>>>hoslistingteacherData>>>>>>>>$teacherData");
              // print(" the length of class_group $employeeUnderHOS");

              print(classB);

              print(loginCredential);
            }
          }
          if (facultyData.containsKey("supervisorComponent")) {
            if (loginCredential!["data"]["data"][0]["faculty_data"]
            ["supervisorComponent"]["is_hos"] ==
                true) {
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["supervisorComponent"]["own_list_groups"]
                      .length;
              ind++) {
                for (var index = 0;
                index <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["supervisorComponent"]["own_list_groups"]
                    [ind]["class_group"]
                        .length;
                index++) {
                  if (loginCredential!["data"]["data"][0]["faculty_data"]
                  ["supervisorComponent"]["own_list_groups"][ind]
                  ["class_group"][index]
                      .containsKey("class_teacher")) {
                    var employeeUnderHod = loginCredential!["data"]["data"][0]
                    ["faculty_data"]["supervisorComponent"]
                    ["own_list_groups"][ind]["class_group"][index]
                    ["class_teacher"]["employee_no"];
                    employeeUnderHOS.add(employeeUnderHod);
                  }
                }
              }
              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["supervisorComponent"]["own_list_groups"]
                      .length;
              index++) {
                for (var ind = 0;
                ind <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["supervisorComponent"]["own_list_groups"]
                    [index]["class_group"]
                        .length;
                ind++) {
                  var classBatch = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["supervisorComponent"]
                  ["own_list_groups"][index]["class_group"][ind]["academic"];
                  classB.add("${classBatch.split("/")[2]} ${classBatch.split("/")[3]}");
                }
              }

              print('employeeUnderHOS__---__$employeeUnderHOS');

              print("???????????????????????????????????????????????????$classB");

              print(loginCredential);
            }
          }
          if (facultyData.containsKey("hosComponent")) {
            print("hos Component");
            if (loginCredential!["data"]["data"][0]["faculty_data"]
            ["hosComponent"]["is_hos"] ==
                true) {
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hosComponent"]["own_list_groups"]
                      .length;
              ind++) {
                for (var index = 0;
                index <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["hosComponent"]["own_list_groups"][ind]
                    ["class_group"]
                        .length;
                index++) {
                  if (loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hosComponent"]["own_list_groups"][ind]
                  ["class_group"][index]
                      .containsKey("class_teacher")) {
                    var employeeUnderHod = loginCredential!["data"]["data"][0]
                    ["faculty_data"]["hosComponent"]
                    ["own_list_groups"][ind]["class_group"][index]
                    ["class_teacher"]["employee_no"];

                    print('----empid--$employeeUnderHod');
                    employeeUnderHOS.add(employeeUnderHod);
                  }
                }
              }
              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hosComponent"]["own_list_groups"]
                      .length;
              index++) {
                for (var ind = 0;
                ind <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["hosComponent"]["own_list_groups"][index]
                    ["class_group"]
                        .length;
                ind++) {
                  var classBatch = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["hosComponent"]["own_list_groups"]
                  [index]["class_group"][ind]["academic"];
                  classB.add("${classBatch.split("/")[2]} ${classBatch.split("/")[3]}");
                }
              }

              log("print HOS EMP$employeeUnderHOS");

              print(classB);

              print(loginCredential);
            }
          }

          if (facultyData.containsKey("hodComponent")) {
            if (loginCredential!["data"]["data"][0]["faculty_data"]
            ["hodComponent"]["is_hod"] ==
                true) {
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hodComponent"]["own_list_groups"]
                      .length;
              ind++) {
                for (var index = 0;
                index <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["hodComponent"]["own_list_groups"][ind]
                    ["class_group"]
                        .length;
                index++) {
                  if (loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hodComponent"]["own_list_groups"][ind]
                  ["class_group"][index]
                      .containsKey("class_teacher")) {
                    var employeeUnderHod = loginCredential!["data"]["data"][0]
                    ["faculty_data"]["hodComponent"]
                    ["own_list_groups"][ind]["class_group"][index]
                    ["class_teacher"]["employee_no"];
                    employeeUnderHOS.add(employeeUnderHod);
                  }
                }
              }
              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hodComponent"]["own_list_groups"]
                      .length;
              index++) {
                for (var ind = 0;
                ind <
                    loginCredential!["data"]["data"][0]["faculty_data"]
                    ["hodComponent"]["own_list_groups"][index]
                    ["class_group"]
                        .length;
                ind++) {
                  var classBatch = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["hodComponent"]["own_list_groups"]
                  [index]["class_group"][ind]["academic"];
                  classB.add("${classBatch.split("/")[2]} ${classBatch.split("/")[3]}");
                }
              }

              print('.....employeeUnderHOS....$employeeUnderHOS');

              print('.....classB$classB');

              print('.....$loginCredential');
            }
          }
        }
        //addToLocalDb();
      }
    } finally {}
  }

  Map<String, dynamic>? committedCalls;

  Future commitedCallsDetail(String employeeCode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var school_token = preferences.getString("school_token");
    String schoolToken = Get.find<UserAuthController>().schoolToken.value ?? '';
    // var empid = preferences.getString("employeeNumber");
    print("api worked");
    print("api employeeCode$employeeCode");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
      request.body =
      '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$schoolToken",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [1]\n }\n''';
      print("commitedCallsDetailrequest.body${request.body}");

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        // print(await response.stream.bytesToString());
        var responseJson = await response.stream.bytesToString();
        committedCalls = json.decode(responseJson);
        log('committedCallsresponse-----$committedCalls');
      } else {
        return const Text("Failed to Load Data");
      }
    } finally {
    }
  }

  Map<String, dynamic>? callNotAnswered;

  Future callNotAnswerDetail(String employeeCode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    String schoolToken = Get.find<UserAuthController>().schoolToken.value ?? '';
    print("api worked");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
      request.body =
      '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$schoolToken",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [4]\n }\n''';
      // print(request.body);
      print("callNotAnswerDetailrequest.body${request.body}");

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        // print(await response.stream.bytesToString());
        var responseJson = await response.stream.bytesToString();
        callNotAnswered = json.decode(responseJson);
        log('callNotAnsweredresponse-----$callNotAnswered');
      } else {
        return const Text("Failed to Load Data");
      }
    } finally {
    }
  }

  Map<String, dynamic>? wrongNumber;

  Future wrongNumberDetails(String employeeCode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    String schoolToken = Get.find<UserAuthController>().schoolToken.value ?? '';
    print("api worked");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
      request.body =
      '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$schoolToken",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [2,3]\n }\n''';
      // print(request.body);
      print("wrongNumberDetailsrequest.body${request.body}");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        // print(await response.stream.bytesToString());
        var responseJson = await response.stream.bytesToString();
        wrongNumber = json.decode(responseJson);
        log('wrongNumberresponse-----$wrongNumber');
      } else {
        return const Text("Failed to Load Data");
      }
    } finally {
    }
  }

  Map<String, dynamic>? misbehave;

  Future misbehaveDetails(String employeeCode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    String schoolToken = Get.find<UserAuthController>().schoolToken.value ?? '';
    print("api worked");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
      request.body =
      '''{\n  "action" :"getEmployeeFeedbackById",\n  "token": "$schoolToken",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [5,6,7]\n }\n''';
      // print(request.body);
      print("misbehaveDetailsrequest.body${request.body}");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        // print(await response.stream.bytesToString());
        var responseJson = await response.stream.bytesToString();
        misbehave = json.decode(responseJson);
        log('misbehaveresponse-----$misbehave');
      } else {
        return const Text("Failed to Load Data");
      }
    } finally {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
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
                        shoBackgroundColor: false, isWelcome: false,bellicon: true, notificationcount: true,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 120.h, right: 10.w),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colorutils.Whitecolor,
                    // Container color
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    // Border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colorutils.userdetailcolor.withOpacity(0.3),
                        // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                      // padding: const EdgeInsets.all(5),
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(
                              15, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reports',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Hos: ben',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 10.w, right: 10.w),
                          child: TextFormField(
                            // controller: _searchController,
                            // validator: (val) =>
                            // val!.isEmpty ? 'Enter the Topic' : null,
                            // controller: _textController,
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                // newReport = newTeacherList
                                //     .where((element) => element["employee_name"]
                                //     .contains("${value.toUpperCase()}"))
                                //     .toList();
                                // print(newReport);
                              });
                            },
                            decoration: InputDecoration(
                                hintStyle:
                                    const TextStyle(color: Colors.grey),
                                hintText: _isListening
                                    ? "Listening..."
                                    : "Search Here",
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.cyanAccent,
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
                                      color: Color.fromRGBO(
                                          230, 236, 254, 8),
                                      width: 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(
                                          230, 236, 254, 8),
                                      width: 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                fillColor:
                                    const Color.fromRGBO(230, 236, 254, 0.966),
                                filled: true),
                          ),
                        ),
                        Expanded(
                            child: isSpinner ? const Center(child: CircularProgressIndicator()) : teacherList == null
                                ? Center(
                                child:
                                Image.asset("assets/images/nodata.gif"))
                                : teacherList!["data_status"] == 0
                                ? Center(
                                child:
                                Image.asset("assets/images/nodata.gif"))
                                : teacherList!["message"] ==
                                "employee_code Required"
                                ? Center(
                                child: Image.asset(
                                    "assets/images/nodata.gif"))
                                : ListView.builder(
                              key: Key(
                                  'builder ${selected.toString()}'),
                              itemCount:
                              _searchController.text.isNotEmpty
                                  ? newReport.length
                                  : teacherList!["data"].length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return _getProfileOfStudents(
                                    "assets/images/nancy.png",
                                    _searchController.text.isNotEmpty
                                        ? toBeginningOfSentenceCase(
                                        newReport[index]["employee_name"]
                                            .toString()
                                            .toLowerCase())
                                        .toString()
                                        : toBeginningOfSentenceCase(
                                        teacherList!["data"][index]["employee_name"]
                                            .toString()
                                            .toLowerCase())
                                        .toString(),
                                    _searchController.text.isNotEmpty
                                        ? newReport[index]["total_count"]
                                        .toString()
                                        : teacherList!["data"][index]
                                    ["total_count"]
                                        .toString(),
                                    _searchController.text.isNotEmpty
                                        ? newReport[index]["employee_code"]
                                        .toString()
                                        : teacherList!["data"][index]
                                    ["employee_code"]
                                        .toString(),
                                    index);
                              },
                            )),
                        SizedBox(
                          height: 140.h,
                        )
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget _getProfileOfStudents(String image, String nameOfTeacher,
    String totalProcessed, String employeeCode, int index) {
  return Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      key: Key(index.toString()),
      //attention
      initiallyExpanded: false,
      onExpansionChanged: ((newState) {
        print(newState);
        // if (newState)
        //   setState(() {
        //     Duration(seconds: 20000);
        //     selected = index;
        //     commitedCallsDetail(employeeCode);
        //     wrongNumberDetails(employeeCode);
        //     misbehaveDetails(employeeCode);
        //     callNotAnswerDetail(employeeCode);
        //   });
        // else
        //   setState(() {
        //     selected = -1;
        //   });
      }),
      iconColor: Colors.cyanAccent,
      leading: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.r)),
        ),
        margin: EdgeInsets.only(top: 5.h),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEEF1FF)),
                color: const Color(0xFFEEF1FF)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nameOfTeacher.toString()[0],
                    style: const TextStyle(
                        color: Color(0xFFB1BFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    nameOfTeacher.toString()[1].toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFFB1BFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          SizedBox(
              width: 200.w,
              child: Text(nameOfTeacher,
                  style: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)))),
        ],
      ),
      subtitle: Row(
        children: [
          Text(
            "Total Processed :",
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(fontSize: 12.sp, color: Colors.black)),
          ),
          Text(
            totalProcessed,
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),

    ),
  );
}

Widget ProfileContainer(
    final int committed,
    final int callnot,
    final int wrong,
    final int misbehave,
    var name,
    var image,
    var employeecode,
    var teachername,
    var processed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFF4F6FB)),
              child: Image.asset("assets/images/vectorthree.png")),
          Text(
            committed.toString(),
            style: const TextStyle(
                color: Colors.cyanAccent, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
      SizedBox(
        width: 10.w,
        height: 10.h,
      ),
      Column(
        children: [
          Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFF4F6FB)),
              child: Image.asset("assets/images/vectortwo.png")),
          Text(
            callnot.toString(),
            style: const TextStyle(
                color: Colors.cyanAccent, fontWeight: FontWeight.bold),
          )
        ],
      ),
      SizedBox(
        width: 20.w,
        height: 10.h,
      ),
      Column(
        children: [
          Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFF4F6FB)),
              child: Image.asset("assets/images/vectorfour.png")),
          Text(
            wrong.toString(),
            style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
          )
        ],
      ),
      SizedBox(
        width: 20.w,
        height: 10.h,
      ),
      Column(
        children: [
          Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFF4F6FB)),
              child: Image.asset("assets/images/vectorone.png")),
          Text(
            misbehave.toString(),
            style: const TextStyle(
                color: Colors.cyanAccent, fontWeight: FontWeight.bold),
          )
        ],
      ),
      SizedBox(
        width: 10.w,
        height: 15.h,
      ),
      GestureDetector(
        onTap: () {},
        child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFF4F6FB)),
            child: SvgPicture.asset("assets/images/next.svg")),
      ),
      SizedBox(
        height: 10.h,
      ),
    ],
  );
}
