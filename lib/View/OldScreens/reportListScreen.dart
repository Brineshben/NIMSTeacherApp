import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:shimmer/shimmer.dart';
import 'package:teacherapp/View/OldScreens/studentListForHos.dart';

import '../../Controller/api_controllers/userAuthController.dart';
import '../../Utils/Colors.dart';
import '../../Utils/api_constants.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class ReportListView extends StatefulWidget {
  const ReportListView({super.key});

  @override
  _ReportListViewState createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  UserAuthController userAuthController = Get.find<UserAuthController>();
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
  var employeeUnderHOS = [];
  var employeeEmailUnderHOS = [];
  final bool _isListening = false;
  final String _textSpeech = "Search Here";

  List newTeacherList = [];
  List newReport = [];
  final _searchController = TextEditingController();
  var loginname;
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  bool loading  = false;
  bool loaded = false;

  @override
  void initState() {
    print('Empcodee-----__________________');
    // teacherData();
    // _speech = stt.SpeechToText();
    initialize();
    super.initState();
  }

  Future initialize() async {
    await getUserLoginCredentials();
    // print('teacherName${widget.teacherName}');
    await getTeacherList();
  }

  Map<String, dynamic>? teacherList;

  Future getTeacherList() async {

    context.loaderOverlay.show();
      loaded  = false;
  try{
    Map<String, String> headers = {
      'API-Key': '525-777-777',
      'Content-Type': 'application/json'
    };

    final bdy = {
      "action": "getFeedbackTotalSummaryData",
      "token": userAuthController.schoolToken.value,
      "employee_code": json.encode(employeeUnderHOS.isEmpty ? [userAuthController.userData.value.employeeNo] : employeeUnderHOS),
      "employee_email": json.encode(employeeEmailUnderHOS.isEmpty ? [userAuthController.userData.value.username] : employeeEmailUnderHOS),
    };

    log("the >>>>>>>>>>>>>>>>>>>>> $bdy");

    var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));

    request.body = (json.encode(bdy));

    request.headers.addAll(headers);
    log('responserbodybodyesponse${request.body}');
    http.StreamedResponse response = await request.send();

    var respString = await response.stream.bytesToString();

    // final response = await http.post(Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd),
    //     headers: headers, body: json.encode(bdy));

    //final responseJson = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        teacherList = json.decode(respString);
        if(teacherList?["data"] != null && teacherList?["data"] != true && teacherList?["data"] != false) {
          newTeacherList = teacherList?["data"] ?? [];
        }
      });
      print('teachteacherListerList.........................$teacherList');
      print("newTeacherList--$newTeacherList");
    } else {
      setState(() {
        // isSpinner=false;
      });
    }
  } catch (e) {

  }
     loaded = true;
    context.loaderOverlay.hide();

  }

  Future getUserLoginCredentials() async {
    // var result = await Connectivity().checkConnectivity();
    // if (result == ConnectivityResult.none) {
    //   _checkInternet(context);
    // } else {
    String url = "${ApiConstants.baseUrl}${ApiConstants.workLoad}";
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    try {
      var request = http.Request(
          'POST', Uri.parse(url));
      // request.body = json.encode(
      //     {"user_id": userAuthController.selectedHos.value?.userId ?? '--'});
      request.body = json.encode(
          {"user_id": userAuthController.userData.value.userId ?? '--'});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      print('------url------$url');
      print('----rrreeeqqq${request.body}');
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          isSpinner = false;
        });
        loginCredential = json.decode(responseData);
        SharedPreferences preference = await SharedPreferences.getInstance();
        preference.setString('loginCredential', json.encode(loginCredential));
        log("api resss-----$loginCredential");
        print('--------------c----------');
        print('array--${loginCredential?["data"]["data"][0]["all_roles_array"]}');

        print('---------------end of----role ids-----------------');
        // print(loginCredential!["data"]["data"][0]["faculty_data"]
        // ["teacherComponent"]["is_class_teacher"]);

        img = loginCredential?["data"]["data"][0]["image"];

        print(">>>>>>>$img<<<<<<<");
        Map<String, dynamic> facultyData =
        loginCredential!["data"]["data"][0]["faculty_data"];
        if (facultyData.containsKey("teacherComponent") ||
            facultyData.containsKey("supervisorComponent") ||
            facultyData.containsKey("hosComponent") ||
            facultyData.containsKey("hodComponent") ||
            facultyData.containsKey("principalComponent")) {
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

              setState(() {
                isSpinner = false;
              });
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
                    var employeeEmailUnderHod = loginCredential!["data"]["data"][0]
                    ["faculty_data"]["supervisorComponent"]
                    ["own_list_groups"][ind]["class_group"][index]
                    ["class_teacher"]["username"];
                    employeeUnderHOS.add(employeeUnderHod);
                    employeeEmailUnderHOS.add(employeeEmailUnderHod);
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

              setState(() {
                isSpinner = false;
              });
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
                    var employeeEmailUnderHod = loginCredential!["data"]["data"][0]
                    ["faculty_data"]["hosComponent"]
                    ["own_list_groups"][ind]["class_group"][index]
                    ["class_teacher"]["username"];

                    print('----empid--$employeeUnderHod');
                    employeeUnderHOS.add(employeeUnderHod);
                    employeeEmailUnderHOS.add(employeeEmailUnderHod);
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

              setState(() {
                isSpinner = false;
              });
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
                    var employeeEmailUnderHod = loginCredential!["data"]["data"][0]
                    ["faculty_data"]["hodComponent"]
                    ["own_list_groups"][ind]["class_group"][index]
                    ["class_teacher"]["username"];
                    employeeUnderHOS.add(employeeUnderHod);
                    employeeEmailUnderHOS.add(employeeEmailUnderHod);
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

              print('..c...$employeeUnderHOS');

              print('.....classB$classB');

              print('.....$loginCredential');

              setState(() {
                isSpinner = false;
              });
            }
          }

          if (facultyData.containsKey("principalComponent")) {
            if (loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["is_hos"] == true) {
              for (var ind = 0; ind < loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"].length; ind++) {
                for (var index = 0; index < loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"][ind]["class_group"].length; index++) {
                  if (loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"][ind]["class_group"][index].containsKey("class_teacher")) {
                    var employeeUnderHod = loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"][ind]["class_group"][index]["class_teacher"]["employee_no"];
                    var employeeEmailUnderHod = loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"][ind]["class_group"][index]["class_teacher"]["username"];
                    employeeUnderHOS.add(employeeUnderHod);
                    employeeEmailUnderHOS.add(employeeEmailUnderHod);
                  }
                }
              }
              for (var index = 0; index < loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"].length; index++) {
                for (var ind = 0; ind < loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"][index]["class_group"].length; ind++) {
                  var classBatch = loginCredential!["data"]["data"][0]["faculty_data"]["principalComponent"]["own_list_groups"][index]["class_group"][ind]["academic"];
                  classB.add("${classBatch.split("/")[2]} ${classBatch.split("/")[3]}");
                }
              }

              print('..c...$employeeUnderHOS');

              print('.....classB$classB');

              print('.....$loginCredential');

              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        //addToLocalDb();
      }
    } catch(e) {
      print("-----teacher list error------");
    }
  }

  Map<String, dynamic>? committedCalls;

  Future commitedCallsDetail(String employeeCode) async {
    print("api worked");
    print("api employeeCode$employeeCode");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"${userAuthController.schoolToken.value}",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [1]\n }\n''';
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
      if (mounted) {
        setState(() {
          isSpinner = false;
        });
      }
    } else {
      return const Text("Failed to Load Data");
    }
  }

  Map<String, dynamic>? callNotAnswered;

  Future callNotAnswerDetail(String employeeCode) async {
    print("api worked");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"${userAuthController.schoolToken.value}",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [4]\n }\n''';
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
      if (mounted) {
        setState(() {
          isSpinner = false;
        });
      }
    } else {
      return const Text("Failed to Load Data");
    }
  }

  Map<String, dynamic>? wrongNumber;

  Future wrongNumberDetails(String employeeCode) async {
    print("api worked");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"${userAuthController.schoolToken.value}",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [2,3]\n }\n''';
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
      if (mounted) {
        setState(() {
          isSpinner = false;
        });
      }
    } else {
      return const Text("Failed to Load Data");
    }
  }

  Map<String, dynamic>? misbehave;

  Future misbehaveDetails(String employeeCode) async {
    print("api worked");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token": "${userAuthController.schoolToken.value}",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [5,6,7]\n }\n''';
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
      if (mounted) {
        setState(() {
          isSpinner = false;
        });
      }
    } else {
      return const Text("Failed to Load Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleDark,
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
                      // height: 100.w,
                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      child: const UserDetails(
                        shoBackgroundColor: false, isWelcome: true,bellicon: true, notificationcount: true,),
                    ),
                  ),
//                   Positioned(
// top: 1,
//                       child: const UserDetails(
//                           shoBackgroundColor: false,
//                           isWelcome: true,
//                           bellicon: true,
//                           notificationcount: true)),
                  Container(
                    margin:
                        EdgeInsets.only(left: 10.w, top: 120.h, right: 10.w),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade50),
                        boxShadow: [
                          BoxShadow(
                            color: Colorutils.userdetailcolor.withOpacity(0.2),
                            // Shadow color
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Reports",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              // userAuthController.selectedHos.value?.hosName !=
                              //         null
                              //     ? Container(
                              //         constraints: const BoxConstraints(
                              //           maxWidth: 200,
                              //         ),
                              //         child: SingleChildScrollView(
                              //           scrollDirection: Axis.horizontal,
                              //           child: Row(
                              //             children: [
                              //               Text(
                              //                 'Hos: ${userAuthController.selectedHos.value?.hosName}',
                              //                 style: const TextStyle(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color: Colors.blueAccent),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     : Container()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: TextFormField(
                            controller: _searchController,
                            // validator: (val) =>
                            // val!.isEmpty ? 'Enter the Topic' : null,
                            // controller: _textController,
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                newReport = newTeacherList
                                    .where((element) => element["employee_name"]
                                        .contains(value.toUpperCase()))
                                    .toList();
                                print(newReport);
                              });
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colorutils.userdetailcolor.withOpacity(0.5)),
                                hintText: _isListening
                                    ? "Listening..."
                                    : "Search Here",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colorutils.userdetailcolor.withOpacity(0.5),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colorutils.userdetailcolor.withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colorutils.userdetailcolor.withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                fillColor: Colorutils.userdetailcolor.withOpacity(0.1),
                                filled: true),
                          ),
                        ),
                        Expanded(
                        
                            child: !loaded? 
                                      ReportsShimmer():teacherList== null
                                ? RefreshIndicator(
                                  onRefresh: ()  async{
                                    await initialize();
                                  },
                                  child: SingleChildScrollView(
                                    physics:const  AlwaysScrollableScrollPhysics(),
                                    child: Center(
                                    child: Image.asset(
                                        "assets/images/nodata.gif")),
                                  ),
                                )
                                : teacherList!["data_status"] == 0
                                    ? RefreshIndicator(
                                      onRefresh: () async{
                                        await initialize();
                                      },
                                      child: SingleChildScrollView(
                                         physics: const AlwaysScrollableScrollPhysics(),
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/nodata.gif")),
                                      ),
                                    )
                                    : teacherList!["message"] ==
                                            "employee_code Required"
                                        ? Center(
                                            child: Image.asset(
                                                "assets/images/nodata.gif"))
                                        : RefreshIndicator(
                                          onRefresh: () async{
                                            await  initialize();
                                          },
                                          child: ListView.builder(
                                              // key: Key(
                                              //     'builder ${selected.toString()}'),
                                              itemCount: _searchController
                                                      .text.isNotEmpty
                                                  ? newReport.length
                                                  : teacherList!["data"].length,
                                              itemBuilder: (BuildContext context,
                                                  int index) {
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
                                                        ? newReport[index]
                                                                ["total_count"]
                                                            .toString()
                                                        : teacherList!["data"][index]
                                                                ["total_count"]
                                                            .toString(),
                                                    _searchController.text.isNotEmpty
                                                        ? newReport[index]
                                                                ["employee_code"]
                                                            .toString()
                                                        : teacherList!["data"][index]["employee_code"].toString(),
                                                    index);
                                              },
                                            ),
                                        )),
                        SizedBox(
                          height: 140.h,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
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
          if (newState) {
            setState(() {
              const Duration(seconds: 20);
              selected = index;
              commitedCallsDetail(employeeCode);
              wrongNumberDetails(employeeCode);
              misbehaveDetails(employeeCode);
              callNotAnswerDetail(employeeCode);
            });
          } else {
            setState(() {
              selected = -1;
            });
          }
        }),
        iconColor: const Color(0xFFE4EFFF),
        leading: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.r)),
          ),
          margin: EdgeInsets.only(top: 5.h),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return StudentListForHOS(
                  name: userAuthController.userData.value.name,
                  image: userAuthController.userData.value.image,
                  LoginedUserEmployeeCode: employeeCode,
                  classTeacherName: nameOfTeacher.toString(),
                  totalProcessed: totalProcessed,
                  CustomeImageContainer: Center(
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
                );
              }));
            },
            child: Container(
              width: 55.w,
              height: 55.h,
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
                    style: GoogleFonts.inter(
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
                  textStyle:
                      TextStyle(fontSize: 12.sp, color: const Color(0xFF495566))),
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
        children: [
          ProfileContainer(
            committedCalls == null || committedCalls!["data"] == false
                ? 0
                : committedCalls!["data"].length,
            callNotAnswered == null || callNotAnswered!["data"] == false
                ? 0
                : callNotAnswered!["data"].length,
            wrongNumber == null || wrongNumber!["data"] == false
                ? 0
                : wrongNumber!["data"].length,
            misbehave == null || misbehave!["data"] == false
                ? 0
                : misbehave!["data"].length,
            userAuthController.userData.value.name,
            userAuthController.userData.value.image,
            employeeCode,
            nameOfTeacher.toString(),
            totalProcessed,
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    color: Color(0xFF8AD2FA), fontWeight: FontWeight.bold),
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
                    color: Color(0xFFF9C577), fontWeight: FontWeight.bold),
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
                style: const TextStyle(
                    color: Color(0xFFFA8BE1), fontWeight: FontWeight.bold),
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
                    color: Color(0xFFFC8F8F), fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            width: 20.w,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StudentListForHOS(
                    name: userAuthController.userData.value.name,
                    image: userAuthController.userData.value.image,
                    LoginedUserEmployeeCode: employeecode,
                    classTeacherName: teachername,
                    totalProcessed: processed,
                    CustomeImageContainer: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            teachername.toString()[0],
                            style: const TextStyle(
                                color: Color(0xFFB1BFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            teachername.toString()[1].toUpperCase(),
                            style: const TextStyle(
                                color: Color(0xFFB1BFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
              },
              child: Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFF4F6FB)),
                  child: SvgPicture.asset("assets/images/next.svg")),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

// @override
// void dispose() {
//   timer!.cancel();
//   super.dispose();
// }
}

class ReportsShimmer extends StatelessWidget {
  const ReportsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 500.h,
     child: ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10.h,),
        itemCount: 10,
        itemBuilder: (context, indext){
         return Shimmer.fromColors(
          baseColor: Colors.grey[200]!, highlightColor: Colors.grey[300]!,
           child:  ListTile(
           leading: Container(
            decoration: BoxDecoration(
              color: Colors.white,
               borderRadius: BorderRadius.circular(30)
            ),
      
              width: 65.w,
              height: 65.h,
            ),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              width: 2.w,height:15.h,),
            subtitle: Container( decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ), width: 2.w,height: 5.h,),
            trailing: Container(
            decoration: BoxDecoration(
              color: Colors.white,
               borderRadius: BorderRadius.circular(30)
            ),
      
              width: 25.w,
              height: 25.h,
            ),
           ),
         );
       })
    );
  }
}