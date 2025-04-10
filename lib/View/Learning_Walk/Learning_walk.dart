
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/api_controllers/lessonLearningController.dart';
import '../../Models/api_models/learning_observation_api_model.dart';
import '../../Utils/Colors.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'Learningwalk_apply.dart';

class LearningWalk extends StatefulWidget {
  const LearningWalk({super.key});

  @override
  State<LearningWalk> createState() => _LearningWalkState();
}

class _LearningWalkState extends State<LearningWalk> {
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  String? selectedValue1;
  String? selectedValue2;

  @override
  Widget build(BuildContext context) {
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
                    child: const UserDetails(shoBackgroundColor: false, isWelcome: false, bellicon: true, notificationcount: true,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20.w, top: 120.h, right: 20.w, bottom: 10.h),
                  // width: 550.w,
                  // height: ScreenUtil().screenHeight * 0.8,
                    decoration: themeCardDecoration,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25.w, top: 30.h),
                            child: Text(
                              "Learning Walk",
                              style: TextStyle(
                                  fontSize: 18.h, fontWeight: FontWeight.w600),
                            ),
                          ),
                          GetX<LessonLearningController>(
                            builder: (LessonLearningController controller) {
                              List<TeacherData> teacherList = controller.teacherNameList.value;
                              List<TeacherDetails?> teacherDetails = controller.teacherClassList.value;
                              List<SubjectDetail> subList = controller.teacherSubjectList.value;
                              if(teacherList.isEmpty) {
                                return Image.asset(
                                    "assets/images/nodata.gif",
                                );
                              } else {
                                return Form(
                                  key: _formKey,
                                  child: Column(
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
                                                  color: Color.fromRGBO(230, 236, 254, 0.966),
                                                  width: 1.0,
                                                ),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(10.0))
                                                    .r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(230, 236, 254, 0.966),
                                                  width: 1.0,
                                                ),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(10.0))
                                                    .r,
                                              ),
                                              fillColor: Color.fromRGBO(230, 236, 254, 0.966),
                                              filled: true),
                                          isExpanded: true,
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 5.w),
                                          hint: const Text('Teacher'),
                                          validator: (dynamic value) =>
                                          value == null
                                              ? 'Please Select the Teacher'
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
                                                  color: Color.fromRGBO(230, 236, 254, 0.966),
                                                  width: 1.0,
                                                ),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(10.0))
                                                    .r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(230, 236, 254, 0.966),
                                                  width: 1.0,
                                                ),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(10.0))
                                                    .r,
                                              ),
                                              fillColor: const Color.fromRGBO(230, 236, 254, 0.966),
                                              filled: true),
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 5.w),
                                          hint: const Text('Class'),
                                          validator: (dynamic value) =>
                                          value == null
                                              ? 'Please Select the Class'
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
                                                  color: Color.fromRGBO(230, 236, 254, 0.966),
                                                  width: 1.0,
                                                ),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(10.0))
                                                    .r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(230, 236, 254, 0.966),
                                                  width: 1.0,
                                                ),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(10.0))
                                                    .r,
                                              ),
                                              fillColor: const Color.fromRGBO(230, 236, 254, 0.966),
                                              filled: true),
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 5.w),
                                          hint: const Text('Subject'),
                                          validator: (dynamic value) =>
                                          value == null
                                              ? 'Please Select the Subject'
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
                                      SizedBox(
                                        height: 70.h,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 25.h),
                                          child: GestureDetector(
                                            onTap: () {

                                              if(_formKey.currentState!.validate()) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LessonWalkApply(

                                                          teacherName: selectedValue!,
                                                          classAndBatch: selectedValue1!,
                                                          subjectName: selectedValue2!,
                                                        ),
                                                  ),
                                                );
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
                                      SizedBox(height: 300.h),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
