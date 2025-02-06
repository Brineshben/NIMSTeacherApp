
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import '../../../Controller/api_controllers/timeTableController.dart';
import '../../../Controller/api_controllers/userAuthController.dart';
import '../../../Models/api_models/time_table_api_model.dart';
import 'package:teacherapp/Utils/font_util.dart';
import '../../../Utils/Colors.dart';
class AllTimeTable extends StatefulWidget {
  final List<TimeTable> todaySubjects;

   const AllTimeTable({super.key, required this.todaySubjects});

  @override
  State<AllTimeTable> createState() => _AllTimeTableState();

}

class _AllTimeTableState extends State<AllTimeTable> {
  UserAuthController userAuthController = Get.find<UserAuthController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Timetable',
            style: TeacherAppFonts.interW500_18sp_black,
          ),
          TextButton(
            onPressed: () {
              UserRole? userRole = userAuthController.userRole.value;
              if(userRole == UserRole.leader) {
                Get.find<PageIndexController>().changePage(
                    currentPage: 4);
              } else {
                Get.find<PageIndexController>().changePage(
                  currentPage: Get.find<TimeTableController>().classTeacherSubjects.value.isEmpty ? 5 : 6);
              }
            },
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            child: Row(
              children: [
                Text(
                  '${widget.todaySubjects.length} ',
                  style: TeacherAppFonts.interW700_16sp_letters1,
                ),
                Text(
                  widget.todaySubjects.length == 1 || widget.todaySubjects.isEmpty ? 'Class Today' : 'Classes Today',
                  style: TeacherAppFonts.interW400_16sp_letters1,
                ),
                const Icon(Icons.arrow_forward_ios,size: 18,color: Colorutils.userdetailcolor,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
