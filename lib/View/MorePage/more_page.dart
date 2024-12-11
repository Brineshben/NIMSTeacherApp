import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/api_controllers/hosAllStudentsListController.dart';
import '../../Controller/api_controllers/hosStudentListController.dart';
import '../../Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/HosStudentListModel.dart';
import '../../Models/api_models/hosFullListModel.dart';
import '../../Utils/Colors.dart';
import 'Hodclinic/TrackingPageHod.dart';
import 'all_Students.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  void initState() {
    super.initState();
    Get.find<Hosstudentlistcontroller>().fetchHosStudentList(DateTime.now());
    Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
  }

  // @override
  // void didUpdateWidget(covariant MorePage oldWidget) {
  //   Get.find<Hosstudentlistcontroller>().fetchHosStudentList(DateTime.now());
  //   Get.find<Hosallstudentslistcontroller>().fetchAllStudentDateList();
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    UserAuthController userAuthController = Get.find<UserAuthController>();
    UserRole? userRole = userAuthController.userRole.value;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              ZoomDrawer.of(context)?.toggle();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
              child: Container(
                height: 50.h,
                width: 50.h,
                padding: const EdgeInsets.symmetric(horizontal: 9).h,
                decoration: BoxDecoration(
                  color: Colorutils.chatcolor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8).r,
                ),
                child: SvgPicture.asset(
                  // width: 50.h,
                  "assets/images/menu_icon.svg",
                  fit: BoxFit.contain,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 80),
            child: Text(
              "More",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            if (userRole == UserRole.bothTeacherAndLeader ||
                userRole == UserRole.teacher)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllStudents()));
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colorutils.morebrown,
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                'assets/images/Routing 4.svg',
                                width: 42.w,
                                color: Colorutils.Whitecolor,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: const Text(
                                  'Student Tracking',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset(
                          'assets/images/Union.svg',
                          width: 100.w,
                          color: Colorutils.Whitecolor,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (userRole == UserRole.bothTeacherAndLeader ||
                userRole == UserRole.leader )
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TrackingpageHod()));
                  },
                  child: Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colorutils.userdetailcolor,

                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Student Tracking',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  'assets/images/Routing 4.svg',
                                  width: 42.w,
                                  color: Colorutils.Whitecolor,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                              height: 90.w,
                              width: 85.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.red.withOpacity(0.22),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.red,
                                              size: 12,
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: GetX<Hosstudentlistcontroller>(
                                          builder: (Hosstudentlistcontroller
                                              controller) {
                                            List<SendData> sendStudentsData =
                                                controller
                                                    .sentStudentData.value;
                                            print("-------efvrgv--------${sendStudentsData.length}");
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'MY LIST',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colorutils
                                                          .userdetailcolor,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${sendStudentsData.length}",
                                                  style: const TextStyle(
                                                      color: Colorutils.green,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                              height: 90.w,
                              width: 85.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.red.withOpacity(0.22),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.red,
                                              size: 12,
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child:
                                            GetX<Hosallstudentslistcontroller>(
                                          builder: (Hosallstudentslistcontroller
                                              controller) {
                                            List<Datas> sendStudentsData =
                                                controller.recentData.value;
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'ALL LIST',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colorutils
                                                          .userdetailcolor,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${sendStudentsData.length}',
                                                  style: const TextStyle(
                                                      color: Colorutils.green,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
