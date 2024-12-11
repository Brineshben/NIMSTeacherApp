import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/OldScreens/non_teaching_students.dart';
import 'package:teacherapp/View/OldScreens/teaching_students.dart';

import '../../../Controller/api_controllers/userAuthController.dart';
import '../../../Models/api_models/time_table_api_model.dart';

class Topic extends StatelessWidget {
  final List<TimeTable> todaySubjects;
  const Topic({super.key, required this.todaySubjects});

  @override
  Widget build(BuildContext context) {
    TimeTable? timeTable;
    if(todaySubjects.isNotEmpty) {
      print("-------rgbth-------${todaySubjects.length}");
      timeTable = findUpcomingTime(todaySubjects);
      print("-------rgbth-------$timeTable");
      // timeTable ??= todaySubjects.first;
      if(timeTable != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              UserAuthController userAuthController = Get.find<UserAuthController>();
              if(timeTable!.classDetails.isEmpty) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NonTeacherStudentList(
                  className: timeTable!.batchName,
                  curriculam_id: timeTable.curriculumId,
                  session_id: timeTable.sessionId,
                  class_id: timeTable.classId,
                  batch_id: timeTable.batchId,
                  selectedDate: getCurrentDate(),
                  name: userAuthController.userData.value.name,
                  images: userAuthController.userData.value.image,
                  school_id: userAuthController.userData.value.schoolId,
                  academic_year: userAuthController.userData.value.academicYear,
                  userId: userAuthController.userData.value.userId,
                  subjectName: timeTable.subject,
                )));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentListView(
                  className: timeTable!.batchName,
                  curriculam_id: timeTable.curriculumId,
                  session_id: timeTable.sessionId,
                  class_id: timeTable.classId,
                  batch_id: timeTable.batchId,
                  selectedDate: getCurrentDate(),
                  name: userAuthController.userData.value.name,
                  images: userAuthController.userData.value.image,
                  school_id: userAuthController.userData.value.schoolId,
                  academic_year: userAuthController.userData.value.academicYear,
                  userId: userAuthController.userData.value.userId,
                  ClassAndBatch: timeTable.batchName,
                  subjectName: timeTable.subject,
                  LoginedUserEmployeeCode: userAuthController.userData.value.employeeNo,
                )));
              }
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Myclasses()));
            },
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colorutils.topicbackground2,
                border: Border.all(
                  color: Colorutils.letters1.withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              width: double.infinity,
              height: 190.h,
              child: Column(
                children: [
                  Container(
                    height: 160.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colorutils.topicbackground
                          .withOpacity(0.3), // You can change this color as needed
                    ),
                    // margin: EdgeInsets.only(
                    //     bottom:
                    //         23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  height: 55.h,
                                  'assets/images/calculator 1.svg',
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(width: 5.w),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:100,
                                      child: Text(

                                        timeTable.subject ?? '--',
                                        style: TeacherAppFonts.interW400_18sp_timecolortopics,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      timeTable.batchName ?? '--',
                                      style: TeacherAppFonts.interW500_24sp_timecolortopics,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              width: 150,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                     " ",
                                      style: TeacherAppFonts.interW400_14sp_timecolortopicsOp80,                              ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  timeTable.studentCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,fontSize: 16,
                                  ),
                                ),

                                const Text(
                                  ' Students',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5).w,
                          child: Image.asset(
                            "assets/images/book2.png",
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeTable.timeString?.replaceAll("[", "").replaceAll("]", "").replaceAll("-", " - ") ?? '--',
                    style: TeacherAppFonts.interW600_14sp_timecolortopics,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  TimeTable? findUpcomingTime(List<TimeTable> timeTable) {
    final now = DateTime.now();
    DateFormat timeFormat = DateFormat("h:mm a");
    List<TimeTable> upcomingEntries = [];

    for (var entry in timeTable) {
      String? startTime = entry.timeString?.replaceAll("[", "").replaceAll("]", "").split("-").last;
      DateTime time = timeFormat.parse(startTime!);
      DateTime timeTableToday = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      print("==========$timeTableToday");
      if (timeTableToday.isAfter(now)) {
        upcomingEntries.add(entry);
      }
    }

    if (upcomingEntries.isNotEmpty) {
      return upcomingEntries.first; // Return the earliest upcoming entry
    }

    return null; // No upcoming entries found
  }

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }
}
