import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:teacherapp/View/CWidgets/AppBarBackground.dart';
import '../../Controller/api_controllers/lessonLearningController.dart';
import '../../Models/api_models/learning_observation_api_model.dart';
import '../../Utils/Colors.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'LessonObs_apply.dart';

class LessonObservation extends StatefulWidget {
  const LessonObservation({
    super.key,
  });

  @override
  State<LessonObservation> createState() => _LessonObservationState();
}

class _LessonObservationState extends State<LessonObservation> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedValue;
  String? selectedValue1;
  String? selectedValue2;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
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
                    margin: EdgeInsets.only(
                        left: 20.w, top: 120.h, right: 20.w, bottom: 10.h),
                    // width: 550.w,
                    // height: 600.h,
                    // height: ScreenUtil().screenHeight * 0.8,
                    decoration: themeCardDecoration,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 25.w, top: 30.h),
                                child: Text(
                                  "Lesson Observation",
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              GetX<LessonLearningController>(
                                builder:
                                    (LessonLearningController controller) {

                                  List<TeacherData> teacherList =
                                      controller.teacherNameList.value;
                                  List<TeacherDetails?> teacherDetails =
                                      controller.teacherClassList.value;
                                  List<SubjectDetail> subList =
                                      controller.teacherSubjectList.value;
                                  if (teacherList.isEmpty) {
                                    return Image.asset(
                                      "assets/images/nodata.gif",
                                    );
                                  } else {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.w, right: 20.w, top: 20.h),
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 18.h,
                                                        horizontal: 20.w),
                                                hintText: "Teacher",
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
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                fillColor: const Color.fromRGBO(
                                                    230, 236, 254, 8),
                                                filled: true),
                                            isExpanded: true,
                                            padding: EdgeInsets.only(
                                                left: 10.w, right: 5.w),
                                            hint: const Text('Teacher'),
                                            validator: (dynamic value) =>
                                                value == null
                                                    ? 'Please Select Teacher'
                                                    : null,
                                            items: teacherList
                                                .map((teacher) =>
                                                    DropdownMenuItem<String>(
                                                      value: teacher.teacherName,
                                                      child: Text(
                                                        teacher.teacherName
                                                            .toString(),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedValue,
                                            onChanged: (teacher) {
                                              setState(() {
                                                selectedValue = teacher;
                                                selectedValue1 = null;
                                                selectedValue2 = null;
                                              });
                                              controller.getTeacherClassData(
                                                  teacherName:
                                                      teacher.toString());
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.w, right: 20.w, top: 20.h),
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 18.h,
                                                        horizontal: 20.w),
                                                hintText: "Class",
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
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                fillColor: const Color.fromRGBO(
                                                    230, 236, 254, 8),
                                                filled: true),
                                            padding: EdgeInsets.only(
                                                left: 10.w, right: 5.w),
                                            hint: const Text('Class'),
                                            validator: (dynamic value) =>
                                                value == null
                                                    ? 'Please Select Class'
                                                    : null,
                                            items:
                                                teacherDetails.map((batchData) {
                                              String uniqueValue =
                                                  "${batchData?.className} ${batchData?.batchName}";
                                              return DropdownMenuItem<String>(
                                                value: uniqueValue,
                                                child: SizedBox(
                                                  width: 190.w,
                                                  child: Text(
                                                    "${batchData?.className} ${batchData?.batchName}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            value: selectedValue1,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedValue1 = newValue;
                                                selectedValue2 = null;
                                              });
                                              controller.getTeacherSubjectData(
                                                  classAndBatch:
                                                      selectedValue1.toString());
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.w, right: 20.w, top: 20.h),
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 18.h,
                                                        horizontal: 20.w),
                                                hintText: "Subject",
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
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                fillColor: const Color.fromRGBO(
                                                    230, 236, 254, 8),
                                                filled: true),
                                            padding: EdgeInsets.only(
                                                left: 10.w, right: 5.w),
                                            hint: const Text('Subject'),
                                            validator: (dynamic value) =>
                                                value == null
                                                    ? 'Please Select Subject'
                                                    : null,
                                            items: subList
                                                .map((sub) =>
                                                    DropdownMenuItem<String>(
                                                      value: sub.subjectName,
                                                      child: SizedBox(
                                                        width: 190.w,
                                                        child: Text(
                                                          sub.subjectName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedValue2,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue2 = value;
                                              });
                                              controller.setTeacherSubjectData(
                                                  subName:
                                                      selectedValue2.toString());
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, right: 20.w, top: 20.h),
                                          child: TextFormField(
                                            controller: _controller,
                                            validator: (dynamic value) =>
                                                value.toString().trim().isEmpty
                                                    ? 'Please Enter the Topic'
                                                    : null,
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 18.h,
                                                        horizontal: 20.w),
                                                hintText: "Topic",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ).r,
                                                ),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          230, 236, 254, 8),
                                                      width: 1.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          230, 236, 254, 8),
                                                      width: 1.0),
                                                  borderRadius: const BorderRadius
                                                          .all(
                                                          Radius.circular(10.0))
                                                      .r,
                                                ),
                                                fillColor: const Color.fromRGBO(
                                                    230, 236, 254, 8),
                                                filled: true),
                                            cursorColor: Colors.grey,
                                            keyboardType: TextInputType.text,
                                            maxLength: 100,
                                            maxLines: 5,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(left: 280, top: 2),
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 25.h),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LessonObservationApply(
                                                                teacherName:
                                                                    selectedValue!,
                                                                classAndBatch:
                                                                    selectedValue1!,
                                                                subjectName:
                                                                    selectedValue2!,
                                                                topic: _controller
                                                                    .text,
                                                              )));
                                                }
                                              },
                                              child: Container(
                                                  height: 50.h,
                                                  width: 220.w,
                                                  decoration: BoxDecoration(
                                                    color: Colorutils
                                                        .userdetailcolor,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                                Radius.circular(
                                                                    15))
                                                            .r,
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 150.h),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
