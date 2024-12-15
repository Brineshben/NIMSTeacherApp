import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Controller/api_controllers/timeTableController.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/View/Home_Page/Home_Widgets/my_class.dart';
import '../../Controller/api_controllers/popUpContoller.dart';
import 'Home_Widgets/class_list.dart';
import 'Home_Widgets/subject_list.dart';
import 'Home_Widgets/time_table.dart';
import 'Home_Widgets/topics.dart';
import 'Home_Widgets/user_details.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  TimeTableController timeTableController = Get.find<TimeTableController>();

  @override
  void initState() {
    print("-------------Arun print-here---");


    initialize();
    Get.find<Popupcontoller>().fetchAllStudentDateList();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    await timeTableController.fetchTimeTable();
    await timeTableController.fetchWorkLoad();
    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  @override
  void dispose() {
    context.loaderOverlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              hSpace(25.h),
              const UserDetails(
                shoBackgroundColor: true,
                isWelcome: true,
                bellicon: true,
                notificationcount: true,
              ),
              GetX<TimeTableController>(
                builder: (TimeTableController controller) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 50).w,
                      children: [
                        if (controller.classTeacherSubjects.isNotEmpty ||
                            controller.teacherSubjects.isNotEmpty)
                          const MyClass(),
                        ClassList(
                          classTeacherSubjects:
                              controller.classTeacherSubjects.value,
                        ),
                        SubjectList(
                            teacherSubjects: controller.teacherSubjects.value),
                        if(controller.teacherTimeTableToday.value.isNotEmpty)
                          AllTimeTable(
                              todaySubjects:
                              controller.teacherTimeTableToday.value),
                        Topic(
                            todaySubjects:
                                controller.teacherTimeTableToday.value),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
