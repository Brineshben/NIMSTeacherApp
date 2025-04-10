
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Controller/api_controllers/lessonLearningController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/View/CWidgets/TeacherAppPopUps.dart';
import 'package:teacherapp/View/Learning_Walk/Learning_walk.dart';
import 'package:teacherapp/View/Leave_Page/Leave_Request.dart';
import 'package:teacherapp/View/Lesson_Observation/Lesson_Observation.dart';
import '../../Controller/api_controllers/popUpContoller.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../LearningWalkNew/Learningwalknew1.dart';
import 'Home_Widgets/user_details.dart';

class Leader extends StatefulWidget {
  const Leader({super.key});

  @override
  State<Leader> createState() => _LeaderState();
}

class _LeaderState extends State<Leader> {
  LessonLearningController lessonObservationController = Get.find<LessonLearningController>();

  @override
  void initState() {
    initialize();
    Get.find<Popupcontoller>().fetchAllStudentDateList();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    await lessonObservationController.fetchLessonObservation();
    await lessonObservationController.refreshLessLearnData();
    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  @override
  void dispose() {
    if(!mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String? hosName = Get.find<UserAuthController>().selectedHos.value?.hosName;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Stack(
            children: [
              const AppBarBackground(),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  // height: 100.w,
                  width: ScreenUtil().screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child: const UserDetails(shoBackgroundColor: false, isWelcome: true, bellicon: true, notificationcount: true,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.w, top: 140.h, right: 20.w),
                // width: 550.w,
                // height: 545.h,
                // height: ScreenUtil().screenHeight * 0.8,
                decoration: themeCardDecoration,
                child: RefreshIndicator(
                  onRefresh: () async{
                    await lessonObservationController.fetchLessonObservation();
    await lessonObservationController.refreshLessLearnData();
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Leadership',
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w600),
                                ),
                                // if(hosName != null)
                                
                                //   SizedBox(
                                //       width: 150.w,
                                //       child: SingleChildScrollView(
                                //         scrollDirection: Axis.horizontal,
                                //         child: Row(
                                //           children: [
                                //             Text(
                                //               "HOS : $hosName",
                                //               style: TextStyle(fontSize: 17.h,fontWeight: FontWeight.bold),
                                //             ),
                                
                                //           ],
                                //         ),
                                //       ))
                  
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, top: 20.h),
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Cannot fetch teacher data')));
                              },
                              child: GestureDetector(
                                onTap: () {
                  
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LessonObservation()));
                                },
                                child: Container(
                                  height: 130.h,
                  
                  
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(255, 102, 63, 244),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 65.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 25.w),
                                          child: const Image(
                                              image: AssetImage(
                                                  'assets/images/notebook 1.png')),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: Container(
                                            // height:0.h,
                                            child: Text(
                                              "Lesson  \nObservation ",
                                              style: TextStyle(
                                                  fontSize: 23.h,
                                                  color: const Color.fromARGB(247, 240, 236, 254)),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, top: 35.h),
                            child: GestureDetector(
                              onTap: () {
                                Get.find<LessonLearningController>().resetLearningWalkDropdownData();
                  
                  
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LearningWalknew1()));
                              },
                              child: Container(
                                height: 130.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff14C6C6),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 65.h,
                                      width: 85.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 25.w),
                                        child: const Image(
                                            image: AssetImage(
                                                'assets/images/journalist 1.png' )),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Container(
                                          // height: 50.h,
                                          child: Text(
                                            "Learning  \nWalk",
                                            style: TextStyle(
                                                fontSize: 23.h,
                                                color: const Color.fromARGB(248, 240, 236, 254)),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 100.h),
                          GetX<LessonLearningController>(
                            builder: (LessonLearningController controller) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                  
                                  if(controller.lessonData.isNotEmpty)
                                    GestureDetector(
                                      onTap: () async {
                                        context.loaderOverlay.show();
                                        if(controller.lessonData.isEmpty){
                                          TeacherAppPopUps.submitFailed(
                                            title: "Message",
                                            message: "No Data to Upload",
                                            actionName: "Ok",
                                            iconData: Icons.info_outline,
                                            iconColor: Colors.yellow.shade900,
                                          );
                                        } else {
                                          await controller.lessonSubmit(context);
                                        }
                                        context.loaderOverlay.hide();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8).w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: const Color.fromARGB(248, 0, 136, 170),
                                        ),
                                        // height: 28,
                                        // width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/Synclesson.png",
                                              height: 22.h,
                                              // width: 20,
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              "Sync Lesson",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 14.h),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    SizedBox(height: 24.h),
                                  SizedBox(width: 20.w),
                                  if(controller.learningData.isNotEmpty)
                                    GestureDetector(
                                      onTap: () async {
                                        context.loaderOverlay.show();
                                        if(controller.learningData.isEmpty){
                                          print('-----notes1${controller.learningData}');
                                          TeacherAppPopUps.submitFailed(
                                            title: "No Data to Upload",
                                            message: "",
                                            actionName: "Ok",
                                            iconData: Icons.info_outline,
                                            iconColor: Colors.yellow.shade900,
                                          );
                                        }else{
                                          await controller.learningSubmit(context);
                                          print('-----noteefefes${controller.learningData}');
                  
                                        }
                                        context.loaderOverlay.hide();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8).w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: const Color.fromRGBO(0, 136, 170, 8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/Synclearning.png",
                                              height: 22.h,
                                              // width: 20,
                                            ),
                                            SizedBox(width: 5.w),
                                            Center(
                                                child: Text(
                                                  "Sync Learning",
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 14.h),
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    SizedBox(height: 24.h),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 160.h),
                          // const Spacer(),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
