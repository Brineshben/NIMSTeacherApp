import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Controller/api_controllers/userAuthController.dart';
import '../../Utils/Colors.dart';
import '../../Utils/api_constants.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/TeacherAppPopUps.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class ObsResultdisplay extends StatefulWidget {
  var loginedUserName;
  String? images;
  String? name;
  String? Subject_name = '';
  String? Doneby = '';
  String? Date = '';
  String? Observerid;
  ObsResultdisplay({
    super.key,
    this.loginedUserName,
    this.images,
    this.name,
    this.Date,
    this.Doneby,
    this.Observerid,
    this.Subject_name,
  });
  @override
  State<ObsResultdisplay> createState() => _ObsResultdisplayState();
}

class _ObsResultdisplayState extends State<ObsResultdisplay> {
  bool isSpinner = false;
  final _formKey = GlobalKey<FormState>();
  var nodata = ' ';
  final _reasontextController = TextEditingController();
  final _summarytextController = TextEditingController();
  final _whatwentwelltextController = TextEditingController();
  final _evenbetteriftextController = TextEditingController();
  final _total_percentagetextController = TextEditingController();
  final _total_gradetextController = TextEditingController();
  var _teachertextController = TextEditingController();
  Map<String, dynamic>? ObservationResult;
  // Map<String, dynamic>? ObservationResultList;
  var ObservationResultList = [];
  var Strength;
  var Areasforimprovements;
  var RemedialMeasures;
  var class_id;
  var curriculum_id;
  var loId;
  var class_and_batch = '';
  var topic_lesson;
  var isjoin;
  var total_percentage;
  var total_grade;
  var observer_id;
  var SCHOOL_id;
  var session_id;
  var user_id;
  var username;
  var Type;
  var TeacherComment;
  var count;
  int Count = 0;
  Map<String, dynamic>? notificationResult;

  Timer? timer;
  @override
  void initState() {
    getObservationResultdata();
    super.initState();
  }

  Future getObservationResultdata() async {
    print('callingdetdata');
    setState(() {
      isSpinner = true;
    });
    UserAuthController userAuthController = Get.find<UserAuthController>();
    var userID = userAuthController.userData.value.userId;
    var schoolID = userAuthController.userData.value.schoolId;
    var academicyear = userAuthController.userData.value.academicYear;
    print("____---shared$schoolID");
    print("____---id${widget.Observerid}");
    print("____---academic$academicyear");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };

    print("----------url--------------${ApiConstants.baseUrl}${ApiConstants.obsResultList}${widget.Observerid}");

    var request = http.Request('GET',
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.obsResultList}${widget.Observerid}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseJson = await response.stream.bytesToString();
      setState(() {
        ObservationResult = json.decode(responseJson);
        print('....ObservationResult$ObservationResult');
        ObservationResultList = ObservationResult!['data']['details']
        ['remarks_data'][0]['Indicators'];
        log('....ObservationResultList$ObservationResultList');
        Strength = ObservationResult!['data']['details']['strengths'][0];
        Areasforimprovements =
        ObservationResult!['data']['details']['areas_for_improvement'][0];
        RemedialMeasures =
        ObservationResult!['data']['details']['remedial_measures'];
        class_id = ObservationResult!['data']['details']['class_id'];
        curriculum_id = ObservationResult!['data']['details']['curriculum_id'];
        loId = ObservationResult!['data']['details']['_id'];
        observer_id = ObservationResult!['data']['details']['observer_id'];
        SCHOOL_id = ObservationResult!['data']['details']['school_id'];
        session_id = ObservationResult!['data']['details']['session_id'];
        user_id = ObservationResult!['data']['details']['teacher_id'];
        username = ObservationResult!['data']['details']['teacher_name'];
        Type = ObservationResult!['data']['details']['type'];
        class_and_batch =
        ObservationResult!['data']['details']['class_batch_name'];
        topic_lesson = ObservationResult!['data']['details']['topic'];
        isjoin = ObservationResult!['data']['details']['isJoin'];
        total_percentage = ObservationResult!['data']['details']['evaluation']['total_percentage'];
        if(ObservationResult!['data']['details']['updated_grade'] != null) {
          total_grade = 'Updated Grade : ${ObservationResult!['data']['details']['updated_grade'].toString()[0].toUpperCase()}${ObservationResult!['data']['details']['updated_grade'].toString().substring(1, ObservationResult!['data']['details']['updated_grade'].toString().length)}';
          total_percentage = "";
        } else {
          total_grade = 'Grade : ${ObservationResult!['data']['details']['evaluation']['total_grade'].toString()[0].toUpperCase()}${ObservationResult!['data']['details']['evaluation']['total_grade'].toString().substring(1, ObservationResult!['data']['details']['evaluation']['total_grade'].toString().length)}';
        }
        // total_grade = ObservationResult!['data']['details']['evaluation']['total_grade'];
        TeacherComment =
            ObservationResult!['data']['details']['teacherComment'];
        _teachertextController = TextEditingController(text: TeacherComment);
        print('....Strength$Strength');
        print('....total_percentage$total_percentage');
        print('....total_grade$total_grade');
        print('....Areasforimprovements$Areasforimprovements');
        print('....RemedialMeasures$RemedialMeasures');
        print('isjoind type is bool or null$isjoin');
      });
      _summarytextController.text = Strength;
      _whatwentwelltextController.text = Areasforimprovements;
      _evenbetteriftextController.text = RemedialMeasures;
      setState(() {
        isSpinner = false;
      });
    } else {
      setState(() {
        isSpinner = false;
      });
      nodata = 'No Data';
    }
    // print('------------api response---------------$response');
    // ObservationData = response;
    // ObservationDataList = response['data']['details'];
    // print('------------api response---------------$ObservationData');
    // print('------------ObservationDataList---------------$ObservationDataList');
    // if (ObservationData!.isEmpty ) {
    //   setState(() {
    //     isSpinner = false;
    //   });
    //   nodata = 'No Data';
    // }
  }

  Future submitRemarksLesonObservation() async {
    setState(() {
      isSpinner = true;
    });
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "class_id": class_id,
      "comment": _teachertextController.text,
      "curriculum_id": curriculum_id,
      "loId": loId,
      "observer_id": observer_id,
      "school_id": SCHOOL_id,
      "session_id": session_id,
      "user_id": user_id,
      "username": username
    };
    print('---b-o-d-y-obsubmitLessonObservation--$body');
    var request = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.submitLessonObservationRemarks),
        headers: headers,
        body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      log('----------rsssssobsubmitLessonObservation$response');
      print('----------rsssssobsubmitLessonObservation${response['data']}');
      print(
          '----------rsssssobsubmitLessonObservation${response['data']['message']}');

      TeacherAppPopUps.submitFailedTwoBack(
        title: "Success",
        message: response['data']['message'] ?? "Something went wrong.",
        actionName: "Close",
        iconData: Icons.check_circle_outline_sharp,
        iconColor: Colors.green,
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('${response['data']['message']}'),
      //   backgroundColor: Colors.green,
      // ));
    }
    setState(() {
      isSpinner = false;
    });
    Navigator.of(context).pop();

  }

  Future submitRemarksLearningWalk() async {
    setState(() {
      isSpinner = true;
    });

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "class_id": class_id,
      "comment": _teachertextController.text,
      "curriculum_id": curriculum_id,
      "loId": loId,
      "observer_id": observer_id,
      "school_id": SCHOOL_id,
      "session_id": session_id,
      "user_id": user_id,
      "username": username
    };
    print('---b-o-d-y-obsubmitLearningwalk--$body');
    var request = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.submitLearningWalkRemarks),
        headers: headers,
        body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),
        backgroundColor: Colors.green,
      ));
    }

    //log('----------reqbdyy${request.body}');
    log('----------rsssssbdyy$response');
    setState(() {
      isSpinner = false;
    });
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(

      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                        shoBackgroundColor: false, isWelcome: false, bellicon: true, notificationcount: true,),
                  ),
                ),
                Container(
                  margin:
                  EdgeInsets.only(left: 10.w, top: 120.h, right: 5.w,),
                  width: double.infinity,
                  height:700,
                  decoration: BoxDecoration(
                    color: Colorutils.Whitecolor,
                    // Container color
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r),
                    ),

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


                  child: SingleChildScrollView(

                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                          Padding(
                            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 30),
                            child:SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                    '${widget.Subject_name}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue[800]),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '- $class_and_batch',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue[800]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                      
                                                width: 300.w,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 60.w,
                                                      child: Text(
                                                        'NAME',
                                                        // 'Observer Name',
                                                        style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                      child: Text(
                                                        ':',
                                                        // 'Observer',
                                                        style: TextStyle(fontSize: 14.sp,),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 230.w,
                                                      child: Text(
                                                        '${widget.Doneby}',
                                                        // 'Observer',
                                                        style: TextStyle(fontSize: 14.sp,),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            // SizedBox(
                                            //   width: 150.w,
                                            // ),
                      
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        SizedBox(
                      
                                            width: 300.w,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 60.w,
                                                  child: Text(
                                                    'DATE',
                                                    // 'Observer Name',
                                                    style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                  child: Text(
                                                    ':',
                                                    // 'Observer',
                                                    style: TextStyle(fontSize: 14.sp,),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 230.w,
                                                  child: Text(
                                                    '${widget.Date!.split('T')[0].split('-').last}-${widget.Date!.split('T')[0].split('-')[1]}-${widget.Date!.split('T')[0].split('-').first}',
                      
                                                    // 'Observer',
                                                    style: TextStyle(fontSize: 14.sp,),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        // Container(
                                        //
                                        //     width: 300.w,
                                        //     child: Row(
                                        //       crossAxisAlignment: CrossAxisAlignment.start,
                                        //       children: [
                                        //         Container(
                                        //           width: 60.w,
                                        //           child: Text(
                                        //             'TOPIC',
                                        //             // 'Observer Name',
                                        //             style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),
                                        //           ),
                                        //         ),
                                        //         Container(
                                        //           width: 10.w,
                                        //           child: Text(
                                        //             ':',
                                        //             // 'Observer',
                                        //             style: TextStyle(fontSize: 14.sp,),
                                        //           ),
                                        //         ),
                                        //         SingleChildScrollView(
                                        //           scrollDirection: Axis.horizontal,
                                        //           child: Row(
                                        //             children: [
                                        //               Container(
                                        //                 width: 230.w,
                                        //                 child: Text(
                                        //                   maxLines: 1,
                                        //                   'Arts and Science Eductaion wefgergh werqghdfgfbger4b',
                                        //                   // 'Observer',
                                        //                   style: TextStyle(fontSize: 14.sp,),
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     )),
                                        topic_lesson != null
                                            ? Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                      
                                          children: [
                                            Type == 'lesson_observation'
                                                ? Container(
                      
                      
                                              child: Text(
                                                'TOPIC    : ${topic_lesson.toString()[0].toUpperCase()}${topic_lesson.toString().substring(1, topic_lesson.toString().length)}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueAccent),
                                              ),
                      
                                            )
                                                : const Text(''),
                                            const SizedBox(height: 3,),
                                            isjoin != null
                                                ? Text(
                                            //  'JOINED  : ${isjoin.toString()[0].toUpperCase()}${isjoin.toString().substring(1, isjoin.toString().length)}',
                                             'JOINED :  ${isjoin?'Yes':'No'}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueAccent),
                                            )
                                                : const Text(
      
                                             '',
                                              
                                            )
                                          ],
                                        )
                                            : Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Joined:${isjoin.toString()[0].toUpperCase()}${isjoin.toString().substring(1, isjoin.toString().length)}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueAccent),
                                            )
                                          ],
                                        ),
                      
                      
                                        // Container(
                                        //
                                        //     width: 300.w,
                                        //     child: Row(
                                        //       crossAxisAlignment: CrossAxisAlignment.start,
                                        //       children: [
                                        //         Container(
                                        //           width: 60.w,
                                        //           child: Text(
                                        //             'JOINED',
                                        //             // 'Observer Name',
                                        //             style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,color: Colors.blue),
                                        //           ),
                                        //         ),
                                        //         Container(
                                        //           width: 10.w,
                                        //           child: Text(
                                        //             ':',
                                        //             // 'Observer',
                                        //             style: TextStyle(fontSize: 14.sp,color: Colors.blue),
                                        //           ),
                                        //         ),
                                        //         Container(
                                        //           width: 230.w,
                                        //           child: Text(
                                        //             'NO',
                                        //             // 'Observer',
                                        //             style: TextStyle(fontSize: 14.sp,color: Colors.blue),
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     )),
                      
                      
                      
                                        //     ? Row(
                                        //   mainAxisAlignment:
                                        //   MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Type == 'lesson_observation'
                                        //         ? Container(
                                        //       width: 200.w,
                                        //       child: Text(
                                        //         'Topic:${topic_lesson.toString()[0].toUpperCase()}${topic_lesson.toString().substring(1, topic_lesson.toString().length)}',
                                        //         style: TextStyle(
                                        //             fontSize: 16,
                                        //             fontWeight: FontWeight.w600,
                                        //             color: Colors.blueAccent),
                                        //       ),
                                        //     )
                                        //         : Text(''),
                                        //     isjoin != null
                                        //         ? Text(
                                        //       'Joined:${isjoin.toString()[0].toUpperCase()}${isjoin.toString().substring(1, isjoin.toString().length)}',
                                        //       style: TextStyle(
                                        //           fontSize: 16,
                                        //           fontWeight: FontWeight.w600,
                                        //           color: Colors.blueAccent),
                                        //     )
                                        //         : Text('')
                                        //   ],
                                        // )
                                        //     : Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   children: [
                                        //     Text(
                                        //       'Joined:${isjoin.toString()[0].toUpperCase()}${isjoin.toString().substring(1, isjoin.toString().length)}',
                                        //       style: TextStyle(
                                        //           fontSize: 16,
                                        //           fontWeight: FontWeight.w600,
                                        //           color: Colors.blueAccent),
                                        //     )
                                        //   ],
                                        // ),
                                        SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if(ObservationResultList.isNotEmpty)
                                                Container(
                                                  // height: ObservationResultList.length * 110.h,
                                                  child: ListView.builder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: ObservationResultList.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context, int index) {
                                                      return _resultlist(index,
                                                          Observation:
                                                          ObservationResultList[index]
                                                          ['name'],
                                                          Result: ObservationResultList[index]
                                                          ['remark']);
                                                    },
                                                  ),
                                                ),
                                              const SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: 30.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.3),
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                          )),child: const Center(child: Text('Score %',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),))),
                                                  Container(
                                                      height: 30.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.3),
                                                          borderRadius: const BorderRadius.only(
                                                            topRight: Radius.circular(10),
                                                          )),child: const Center(child: Text('Rating',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),))),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                                                children: [
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.1)),child: const Center(child: Text('100-95',style: TextStyle(fontSize: 12)))),
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border:
                                                          Border.all(color: Colors.grey,width: 0.1)),child: const Center(child: Text('Outstanding',style: TextStyle(fontSize: 12)))
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                                                children: [
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.1)),child: const Center(child: Text('94-85',style: TextStyle(fontSize: 12)))),
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border:
                                                          Border.all(color: Colors.grey,width: 0.1)),child: const Center(child: Text('Very Good',style: TextStyle(fontSize: 12)))
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                                                children: [
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.1)),child: const Center(child: Text('84-66',style: TextStyle(fontSize: 12)))),
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border:
                                                          Border.all(color: Colors.grey,width: 0.1)),child: const Center(child: Text('Good',style: TextStyle(fontSize: 12)))
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                                                children: [
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.1)),child: const Center(child: Text('65-41',style: TextStyle(fontSize: 12)))),
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border:
                                                          Border.all(color: Colors.grey,width: 0.1)),child: const Center(child: Text('Acceptable',style: TextStyle(fontSize: 12)))
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                                                children: [
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.1),
                                                          borderRadius: const BorderRadius.only(
                                                            bottomLeft: Radius.circular(10),
                                                          )),child: const Center(child: Text('40-0',style: TextStyle(fontSize: 12)))),
                                                  Container(
                                                      height: 25.h,
                                                      width: 150.w,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(230, 236, 254, 8),
                                                          border: Border.all(
                                                              color: Colors.grey,width: 0.1),
                                                          borderRadius: const BorderRadius.only(
                                                            bottomRight:
                                                            Radius.circular(10),
                                                          )),child: const Center(child: Text('Weak',style: TextStyle(fontSize: 12)))),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  'Summary',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              TextFormField(
                      
                                                readOnly: true,
                                                controller: _summarytextController,
                      
                                                decoration: InputDecoration(
                                                    hintStyle:
                                                    const TextStyle(color: Colors.black26),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                      
                                                    border: const OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              230, 236, 254, 8),
                                                          width: 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15)),
                                                    ),
                                                    focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              230, 236, 254, 8),
                                                          width: 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15.0)),
                                                    ),
                                                    fillColor: Colorutils.chatcolor
                                                        .withOpacity(0.3),
                                                    filled: true),
                                                maxLines: 5,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  'What Went Well',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: _whatwentwelltextController,
                      
                                                readOnly: true,
                      
                                                decoration: InputDecoration(
                                                    hintStyle:
                                                    const TextStyle(color: Colors.black26),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                      
                                                    border: const OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              230, 236, 254, 8),
                                                          width: 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15)),
                                                    ),
                                                    focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              230, 236, 254, 8),
                                                          width: 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15.0)),
                                                    ),
                                                    fillColor: Colorutils.chatcolor
                                                        .withOpacity(0.3),
                                                    filled: true),
                                                maxLines: 5,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  'Even Better If',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              const SizedBox(height: 10,),
                                              TextFormField(
                                                controller: _evenbetteriftextController,
                      
                                                readOnly: true,
                      
                                                decoration: InputDecoration(
                                                    hintStyle:
                                                    const TextStyle(color: Colors.black26),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 20.0),
                      
                                                    border: const OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              230, 236, 254, 8),
                                                          width: 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15)),
                                                    ),
                                                    focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              230, 236, 254, 8),
                                                          width: 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15.0)),
                                                    ),
                                                    fillColor: Colorutils.chatcolor
                                                        .withOpacity(0.3),
                                                    filled: true),
                                                maxLines: 5,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      
                                                height: 60.h,
                                                decoration: BoxDecoration(color: Colorutils.chatcolor.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text( total_grade ?? '--',style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.bold),),
                                                    // SizedBox(
                                                    //   height: 5.h,
                                                    // ),
                                                    Text('  ${_percentage(total_percentage)}',style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w500),),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  'Teacher Comment',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              // (TeacherComment.toString().isEmpty)?
                                              Focus(
                                                autofocus: true,
                                                child: TextFormField(
                                                  controller: _teachertextController,
                                                readOnly: TeacherComment != null,
                                                  maxLength: 1000,
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  validator: (teachnercomment){
                                                   if(teachnercomment==null||teachnercomment.isEmpty){
                                                    return 'Commets is Required';
                                                   }
                                                   return null;
                                                  },

                                                  decoration:  const InputDecoration(
                                                    
                                                      hintStyle:
                                                      TextStyle(color: Colors.black26),
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 10.0, horizontal: 20.0),
                                                                                          
                                                      border: OutlineInputBorder(
                                                      
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(15.0),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colorutils.chatcolor,
                                                            width: 1.0),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(15)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colorutils.chatcolor,
                                                            width: 1.0),
                                                            
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(15.0)),
                                                      ),
                                                      fillColor: Colors.white,
                                                      filled: true),
                                                  maxLines: 5,
                                                ),
                                              ),
                      
                      
                          //         : TextFormField(
                          // readOnly: true,
                          // controller: _teachertextController,
                          //     cursorColor: Colors.grey,
                          //     decoration: InputDecoration(
                          //         hintStyle: TextStyle(color: Colors.grey),
                          //         contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          //         border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.all(
                          //             Radius.circular(0),
                          //           ),
                          //         ),
                          //         enabledBorder: OutlineInputBorder(
                          //           borderSide:
                          //           BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
                          //           borderRadius: BorderRadius.all(Radius.circular(10)),
                          //         ),
                          //         focusedBorder: OutlineInputBorder(
                          //           borderSide:
                          //           BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
                          //           borderRadius: BorderRadius.all(Radius.circular(5)),
                          //         ),
                          //         fillColor: Color.fromRGBO(230, 236, 254, 8),
                          //         filled: true),
                          //     keyboardType: TextInputType.text,
                          //     maxLines: 5,
                          // ),
                                              if(TeacherComment == null)
                                                GestureDetector(
                                                onTap: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    if (Type ==
                                                        'lesson_observation') {
                                                
                                                       await submitRemarksLesonObservation(
                      
                      
                                                      );
                                                        Navigator.of(context).pop();
                      
                                                    } else {
                                                      if (Type == 'learning_walk') {
                                                      
                                                        await submitRemarksLearningWalk();
                                                      }
                                                    }
                                                  
                                                  }
                                                },
                      
                      
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 40.h,
                                                        width: 100.w,
                                                        // width: 220.w,
                                                        decoration: const BoxDecoration(
                                                          color: Colorutils.userdetailcolor,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10)),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Submit',
                                                            style: TextStyle(
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                      ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                      
                      
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }


  Widget _resultlist(
      int index, {
        String? Observation,
        // int? index,
        String? Result,
      }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
      margin:EdgeInsets.only(left: 2.w,  right: 2.w,bottom: 5),
            // height: 100.h,
           width: 380.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Result == 'NA'
                  ? Colors.red[300]
                  : Result == 'Weak'
                  ? Colors.yellow[600]
                  : Result == 'Acceptable'
                  ? Colors.yellow[800]
                  : Result == 'Good'
                  ? Colors.green[300]
                  : Result == 'Very Good'
                  ? Colors.green
                  : Result == 'Outstanding'
                  ? Colors.green[700]
                  : Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // width: 300.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Observation:',
                                style:
                                TextStyle(fontSize: 15.sp, color: Colors.black,fontWeight: FontWeight.bold),
                              ),
                              Container(
                                // width: 350.w,
                                child: Text(
                                  '$Observation',
                                  style: TextStyle(
                                      fontSize: 15.sp, color: Colors.white),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                          width: 240.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Result:',
                                // 'Result:',
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.black,fontWeight:FontWeight.bold ),
                              ),
                              Text(
                                '$Result',
                                // 'Result:',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  // color: Result == 'NA'
                                  //     ? Colors.red[300]
                                  //     : Result == 'Weak'
                                  //         ? Colors.yellow[700]
                                  //         : Result == 'Acceptable'
                                  //             ? Colors.yellow[400]
                                  //             : Result == 'Good'
                                  //                 ? Colors.green[200]
                                  //                 : Result == 'Very Good'
                                  //                     ? Colors.green[400]
                                  //                     : Result ==
                                  //                             'Outstanding'
                                  //                         ? Colors.green[600]
                                  //                         : Colors.blue[50]
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      );
  String _percentage(percent){
    if (percent == "") return "";
    if(percent.toString().contains('.')){
      if(percent.toString().length>5){
        return '${percent.toString().split('.').first}.${percent.toString().split('.').last.substring(0,2)}%';
      }else{
        return '${percent.toString()}%';
      }
    }else{
      return '${percent.toString()}%';
    }
  }
}