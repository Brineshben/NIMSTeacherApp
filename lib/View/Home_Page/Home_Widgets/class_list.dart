import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import '../../../Models/api_models/time_table_api_model.dart';
import '../../../Models/api_models/work_load_api_model.dart';
import '../../OldScreens/teaching_students.dart';

class ClassList extends StatelessWidget {
  List<TeacherSubject> classTeacherSubjects;
  List<OwnList>? ownList;
   ClassList({super.key, required this.classTeacherSubjects, this.ownList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(classTeacherSubjects.length, (index) {

          classTeacherSubjects.sort((a, b) => "${a.classs!}${a.batch!}".compareTo("${b.classs!}${b.batch!}"));

          List<Color> colors = [
            Colorutils.Classcolour1,
            Colorutils.Classcolour2,
            Colorutils.Classcolour3,
          ];
          Color color = colors[index % colors.length];

          return GestureDetector(
            onTap: () {
              UserAuthController userAuthController = Get.find<UserAuthController>();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentListView(
                className: "${classTeacherSubjects[index].classs} ${classTeacherSubjects[index].batch}",
                curriculam_id: classTeacherSubjects[index].curriculumId,
                session_id: classTeacherSubjects[index].sessionId,
                class_id: classTeacherSubjects[index].classId,
                batch_id: classTeacherSubjects[index].batchId,
                selectedDate: getCurrentDate(),
                name: userAuthController.userData.value.name,
                images: userAuthController.userData.value.image,
                school_id: userAuthController.userData.value.schoolId,
                academic_year: userAuthController.userData.value.academicYear,
                userId: userAuthController.userData.value.userId,
                ClassAndBatch: "${classTeacherSubjects[index].classs} ${classTeacherSubjects[index].batch}",
                subjectName: classTeacherSubjects[index].sub,
                LoginedUserEmployeeCode: userAuthController.userData.value.employeeNo,
              )));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Myclasses()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25).r,
                color: color,
              ),
              margin: const EdgeInsets.only(top: 3, bottom: 4, left: 6, right: 4),
              width: 160.w,
              height: 130.w,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 13, left: 13, bottom: 13, right: 6).w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${classTeacherSubjects[index].classs?.replaceAll(" ", "") ?? '--'}""${classTeacherSubjects[index].batch?.replaceAll(" ", "") ?? '--'}",
                          style: TeacherAppFonts.interW500_32sp_textWhite,
                        ),
                        const Spacer(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                classTeacherSubjects[index].sub ?? '--',
                                style: const TextStyle(
                                   fontSize: 15,
                                  color: Colors.white
                                ),

                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${classTeacherSubjects[index].studentCount ?? '0'}"" ""Students",
                          style: TeacherAppFonts.interW400_14sp_textWhiteOp75,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(25)).r,
                      child: SvgPicture.asset(
                        index % 2 == 0
                            ? 'assets/images/svggui.svg'
                            : "assets/images/svgui2.svg",
                        // width: 95.w,
                        height: 50.w,
                        color: index % 2 == 0
                            ? Colorutils.svguicolour
                            : Colorutils.svguicolour2,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }
}
