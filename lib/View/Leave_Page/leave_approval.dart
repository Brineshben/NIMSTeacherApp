
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Controller/api_controllers/leaveApprovalController.dart';
import 'package:teacherapp/View/Leave_Page/Approve_Rejected.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'All_leave.dart';
import 'Approved_leave.dart';

class LeaveApproval extends StatefulWidget {
  const LeaveApproval({super.key});

  @override
  State<LeaveApproval> createState() => _LeaveApprovalState();
}

class _LeaveApprovalState extends State<LeaveApproval> with SingleTickerProviderStateMixin  {
  late TabController _tabController1;
  LeaveApprovalController leaveApprovalController = Get.find<LeaveApprovalController>();

  @override
  void initState() {
    super.initState();
    _tabController1 = TabController(length: 3, vsync: this);
    initialize();
    _tabController1.addListener(() {
      leaveApprovalController.currentTab.value = _tabController1.index;
    });
  }

  @override
  void dispose() {
    _tabController1.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    // context.loaderOverlay.show();
    // leaveApprovalController.resetStatus();
    await leaveApprovalController.fetchLeaveReqList();
    if(!mounted) return;
    // context.loaderOverlay.hide();
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
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
                      shoBackgroundColor: false, isWelcome: true, bellicon: true, notificationcount: true,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 120.h, right: 10.w),
                  child: Container(
                    // margin: EdgeInsets.only(left: 10.w, top: 120.h, right: 10.w),
                    // width: 500.w,
                    height: double.infinity,
                    decoration: themeCardDecoration2,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 8.w, right: 8.w),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GetX<LeaveApprovalController>(
                            builder: (LeaveApprovalController controller) {
                              return TabBar(padding: EdgeInsets.zero,
                                indicator: const BoxDecoration(),dividerHeight: 0,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,indicatorPadding: EdgeInsets.zero,
                                // indicator: BoxDecoration(),
                                controller: _tabController1,
                                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                                tabs: [
                                  Tab(
                                    child: Container(
                                      height: 40.h,
                                      width: (ScreenUtil().screenWidth-66)*2/6,
                                      decoration: BoxDecoration(
                                        color: controller.currentTab.value == 0 ? Colors.red[500] : Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Approval',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      height: 40.h,
                                      width: (ScreenUtil().screenWidth-66)*3/6,
                                      decoration: BoxDecoration(
                                        color: controller.currentTab.value == 1 ? Colors.red[500] : Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Approved/Rejected",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      height: 40.h,
                                      width: (ScreenUtil().screenWidth-66)*1/6,
                                      decoration: BoxDecoration(
                                        color: controller.currentTab.value == 2 ? Colors.red[500] : Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "All",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),


                          SizedBox(
                            height: 10.h,
                          ),

                          Expanded(
                            child: TabBarView(
                              controller: _tabController1,
                              children: [
                                Container(
                                    color: Colors.white,
                                    child: PendingLeave()
                                ),

                                Container(
                                    color: Colors.white,
                                    child: ApproveRejected()
                                ),
                                Container(
                                    color: Colors.white,
                                    child: allleave()
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
          )),
    );
  }

}



