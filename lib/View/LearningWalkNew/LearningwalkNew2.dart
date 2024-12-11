import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:intl/intl.dart';

import '../../Controller/api_controllers/LearningFocusController.dart';
import '../../Controller/api_controllers/LearningwalkController.dart';
import '../../Controller/api_controllers/LearningwalkSubmit.dart';
import '../../Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/LearningwalkSubmit.dart';
import '../../Services/check_connectivity.dart';
import '../../Utils/Colors.dart';
import '../../sqflite_db/LearningWalkDatabase/LwarningwalkDB.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class LearningWalknew2 extends StatefulWidget {
  String teachername;
  String classsbatch;
  String Division;

  LearningWalknew2(
      {super.key,
      required this.teachername,
      required this.classsbatch,
      required this.Division});

  @override
  State<LearningWalknew2> createState() => _LearningWalknew2State();
}

class _LearningWalknew2State extends State<LearningWalknew2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedValue;

  TextEditingController _FocusLWController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  TextEditingController _Questiontopupilontroller = TextEditingController();
  TextEditingController _QuestiontoaskteacherController =
      TextEditingController();
  TextEditingController _evenBetterIfController = TextEditingController();
  TextEditingController _whatWentWellController = TextEditingController();
  bool ischecked = false;

  @override
  void initState() {
    Get.find<Learningfocuscontroller>().fetchfocusdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> nameParts = widget.teachername.split(" ");
    String? placeholderName;
    try {
      placeholderName = nameParts.length > 1
          ? "${nameParts[0].trim().substring(0, 1)}${nameParts[1].trim().substring(0, 1)}"
              .toUpperCase()
          : nameParts[0].trim().substring(0, 2).toUpperCase();
    } catch (e) {}
    DateTime now = DateTime.now();

    // Format the date
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
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
                      shoBackgroundColor: false,
                      isWelcome: false,
                      bellicon: true,
                      notificationcount: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w, top: 120.h, right: 15.w),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: themeCardDecoration,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25.w, top: 30.h),
                              child: Text(
                                "Learning Walk",
                                style: TextStyle(
                                    fontSize: 18.h,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.w,
                                  top: 15.h,
                                  right: 15.w,
                                  bottom: 5.h),
                              child: Container(
                                // height: 80.h,
                                // width: 280.w,
                                decoration: BoxDecoration(
                                    color: Colorutils.userdetailcolor,
                                    borderRadius: BorderRadius.circular(15).r),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 8.w),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  horizontal: 10)
                                              .w,
                                          child: Container(
                                            width: 50.h,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFD6E4FA)),
                                              color: Colors.white,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100).r,
                                              child: CachedNetworkImage(
                                                width: 50.h,
                                                height: 50.h,
                                                fit: BoxFit.fill,
                                                imageUrl: "__",
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: Text(
                                                    placeholderName ?? '--',
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xFFB1BFFF),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22.h),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 180.w,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  "CLASS      : ${widget.classsbatch}",
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xffFFFFFF),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 2.h,
                                            // ),
                                            SizedBox(
                                              width: 180.w,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  "DIVISION  : ${widget.Division}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 2.h,
                                            // ),
                                            SizedBox(
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  "TEACHER : ${widget.teachername}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8.w),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.w,
                                  top: 15.h,
                                  right: 15.w,
                                  bottom: 5.h),
                              child: Container(
                                height: 50.w,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color:
                                        Colorutils.chatcolor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10).r),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_month,
                                        color: Colorutils.userdetailcolor,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        // _selectFromDate(context);
                                      },
                                    ),
                                    Text('$formattedDate',
                                        style: TextStyle(
                                            fontSize: 18.sp,

                                          color: Colorutils.userdetailcolor,)),
                                    // IconButton(icon: Icon(
                                    //   Icons.calendar_month, color: Colors.blue[900], size: 20,),
                                    //   onPressed: () {
                                    //     _selectFromDate(context);
                                    //   },),
                                  ],
                                ),
                              ),
                            ),
                            GetX<Learningfocuscontroller>(
                                builder: (Learningfocuscontroller controller) {
                              List<String> focusdata = controller.focusList;
                              {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, right: 12.w, top: 20.h),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 18.h, horizontal: 20.w),
                                        hintText:
                                            "Select Focus of Learning Walk",
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ).r,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                230, 236, 254, 8),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0))
                                              .r,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                230, 236, 254, 8),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0))
                                              .r,
                                        ),
                                        fillColor: const Color.fromRGBO(
                                            230, 236, 254, 8),
                                        filled: true),
                                    isExpanded: true,
                                    padding:
                                        EdgeInsets.only(left: 10.w, right: 5.w),
                                    hint: const Text(
                                        'Select Focus of Learning Walk'),
                                    validator: (dynamic value) => value == null
                                        ? 'Please Select the Teacher'
                                        : null,
                                    items: focusdata
                                        .map((focus) =>
                                            DropdownMenuItem<String>(
                                              value: focus.toString(),
                                              child: Text(
                                                focus.toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    value: _selectedValue,
                                    onChanged: (teacher) {
                                      setState(() {
                                        _selectedValue = teacher.toString();
                                      });
                                      // controller.getTeacherClassData(
                                      //     teacherName:
                                      //     teacher.toString());
                                    },
                                  ),
                                );
                              }
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 22),
                              child: Text("Focus of learning Walk ",style: TextStyle(

                              ),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w,
                                  top: 3.h,
                                  right: 20.w,
                                  bottom: 5.h),
                              child: TextFormField(
                                maxLength: 1000,
                                validator: (val) => val!.isEmpty
                                    ? 'Please Enter Summary'
                                    : null,
                                controller: _FocusLWController,
                                // focusNode: keyboardController.summaryFocusNode.value,
                                decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.black26),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    hintText: " Enter Focus of Learning Walk",
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ).r,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(22))
                                          .r,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0))
                                          .r,
                                    ),
                                    fillColor:
                                        Colorutils.chatcolor.withOpacity(0.3),
                                    filled: true),
                                maxLines: 5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    value: ischecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        ischecked = value ?? false;
                                      });
                                    },
                                    activeColor: Colors.teal,
                                  ),
                                  Text(
                                    "UnInterrupted CheckBox",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            ischecked == false
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w,
                                            top: 2.h,
                                            right: 20.w,
                                            bottom: 5.h),
                                        child: TextFormField(
                                          maxLength: 1000,
                                          validator: (val) => val!.isEmpty
                                              ? 'Please Enter Question to Ask Pupils'
                                              : null,
                                          controller: _Questiontopupilontroller,
                                          // focusNode: keyboardController.summaryFocusNode.value,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black26),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.h,
                                                      horizontal: 20.w),
                                              hintText:
                                                  "Question to Ask Pupils",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ).r,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                            Radius.circular(22))
                                                        .r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                                borderRadius: const BorderRadius
                                                        .all(
                                                        Radius.circular(30.0))
                                                    .r,
                                              ),
                                              fillColor: Colorutils.chatcolor
                                                  .withOpacity(0.3),
                                              filled: true),
                                          maxLines: 5,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w,
                                            top: 10.h,
                                            right: 20.w,
                                            bottom: 5.h),
                                        child: TextFormField(
                                          maxLength: 1000,
                                          validator: (val) => val!.isEmpty
                                              ? 'Please Enter Question to Ask Teacher'
                                              : null,
                                          controller:
                                              _QuestiontoaskteacherController,
                                          // focusNode: keyboardController.summaryFocusNode.value,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black26),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.h,
                                                      horizontal: 20.w),
                                              hintText:
                                                  "Question to Ask Teacher",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ).r,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                            Radius.circular(22))
                                                        .r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                                borderRadius: const BorderRadius
                                                        .all(
                                                        Radius.circular(30.0))
                                                    .r,
                                              ),
                                              fillColor: Colorutils.chatcolor
                                                  .withOpacity(0.3),
                                              filled: true),
                                          maxLines: 5,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w,
                                  top: 10.h,
                                  right: 20.w,
                                  bottom: 5.h),
                              child: TextFormField(
                                maxLength: 1000,
                                validator: (val) => val!.isEmpty
                                    ? 'Please Enter Summary'
                                    : null,
                                controller: _summaryController,
                                // focusNode: keyboardController.summaryFocusNode.value,
                                decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.black26),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    hintText: " Summary  ",
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ).r,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(22))
                                          .r,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0))
                                          .r,
                                    ),
                                    fillColor:
                                        Colorutils.chatcolor.withOpacity(0.3),
                                    filled: true),
                                maxLines: 5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w,
                                  top: 5.h,
                                  right: 20.w,
                                  bottom: 5.h),
                              child: TextFormField(
                                controller: _whatWentWellController,
                                // focusNode: keyboardController.whatWentWellFocusNode.value,
                                maxLength: 1000,
                                validator: (val) => val!.isEmpty
                                    ? 'Please Enter What went well'
                                    : null,
                                decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.black26),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    hintText: " What went well   ",
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ).r,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(22))
                                          .r,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0))
                                          .r,
                                    ),
                                    fillColor:
                                        Colorutils.chatcolor.withOpacity(0.3),
                                    filled: true),
                                maxLines: 5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 20.w,
                                top: 5.h,
                                right: 20.w,
                                bottom: 5.h,
                              ),
                              child: TextFormField(
                                maxLength: 1000,
                                validator: (val) => val!.isEmpty
                                    ? 'Please Enter Even better if'
                                    : null,
                                controller: _evenBetterIfController,
                                // focusNode: keyboardController.evenBetterIfFocusNode.value,
                                decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.black26),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    hintText: " Even better if   ",
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ).r,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(22))
                                          .r,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(230, 236, 254, 8),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0))
                                          .r,
                                    ),
                                    fillColor:
                                        Colorutils.chatcolor.withOpacity(0.3),
                                    filled: true),
                                maxLines: 5,
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                  child: Container(
                                    height: 50.w,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        color: Colorutils.userdetailcolor,
                                        borderRadius:
                                            BorderRadius.circular(15).r),
                                    child: Center(
                                      child: Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    try {
                                      if (_formKey.currentState!.validate()) {
                                        LearningwalkSubmitModel submitLW =
                                            LearningwalkSubmitModel(
                                          academicYear:
                                              Get.find<UserAuthController>()
                                                      .userData
                                                      .value
                                                      .academicYear ??
                                                  '',
                                          addedBy:
                                              Get.find<UserAuthController>()
                                                      .userData
                                                      .value
                                                      .userId ??
                                                  '',
                                          addedDate: formattedDate,
                                          batchId:
                                              Get.find<LearningWalkController>()
                                                      .batchDetails
                                                      .value
                                                      ?.sId ??
                                                  "",
                                          classId:
                                              Get.find<LearningWalkController>()
                                                      .details
                                                      .value
                                                      ?.sId ??
                                                  "",
                                          curriculumId:
                                              Get.find<LearningWalkController>()
                                                      .batchDetails
                                                      .value
                                                      ?.curriculum ??
                                                  "",
                                          schoolId:
                                              Get.find<UserAuthController>()
                                                  .userData
                                                  .value
                                                  .schoolId,
                                          senderId:
                                              Get.find<UserAuthController>()
                                                      .userData
                                                      .value
                                                      .userId ??
                                                  '',
                                          sessionId:
                                              Get.find<LearningWalkController>()
                                                      .batchDetails
                                                      .value
                                                      ?.session ??
                                                  "",
                                          lwFocus: _FocusLWController.text,
                                          qsToPuple:
                                              _Questiontopupilontroller.text,
                                          qsToTeacher:
                                              _QuestiontoaskteacherController
                                                  .text,
                                          notes: _summaryController.text,
                                          evenBetterIf:
                                              _evenBetterIfController.text,
                                          whatWentWell:
                                              _whatWentWellController.text,
                                          observationDate: formattedDate,
                                          observerRoles: [],
                                        );
                                        bool connection =
                                            await CheckConnectivity().check();
                                        if (connection) {
                                          await Get.find<
                                                  LearningwalksubmitController>()
                                              .Sendlearningwalksubmit(
                                                  data: submitLW);
                                        } else {
                                          final dbHelper = LearningWalkDB();
                                          final result =
                                              await dbHelper.insertLearningWalk(
                                                  submitLW.toMap());
                                          print("brineshDB${result}");

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                                content: Text(
                                                    'Learning Walk saved successfully!')),

                                          );
                                          Navigator.pop(context);
                                        }
                                      }
                                    } catch (e) {
                                      print("Error: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 50.w,
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
