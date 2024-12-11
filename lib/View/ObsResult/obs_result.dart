import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/View/ObsResult/obs_result_widgets/obs_result_listTile.dart';
import '../../Controller/api_controllers/obsResultController.dart';
import '../../Models/api_models/obs_result_api_model.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class ObsResult extends StatefulWidget {
  const ObsResult({super.key});

  @override
  State<ObsResult> createState() => _ObsResultState();
}

class _ObsResultState extends State<ObsResult> {
  ObsResultController obsResultController = Get.find<ObsResultController>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    await obsResultController.fetchObsResultList();
    if (!mounted) return;
    context.loaderOverlay.hide();
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
                      shoBackgroundColor: false,
                      isWelcome: true,
                      bellicon: true,
                      notificationcount: true,
                    ),
                  ),
                ),
                Container(

                  margin: EdgeInsets.only(
                      left: 10.w, top: 120.h, right: 10.w),
                  height: ScreenUtil().screenHeight,
                  decoration: themeCardDecoration2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, top: 20.w),
                          child: Row(
                            children: [
                              Text(
                                'Observation Result',
                                style: TextStyle(
                                    fontSize: 20.h,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        GetX<ObsResultController>(
                          builder: (ObsResultController controller) {
                            List<ObsResultData> obsList =
                                controller.obsResultList.value;
                            // (controller.isLoading.value) {
                            //   return const Center(child: CircularProgressIndicator(color: Colors.teal));
                            // } else if
                            if (!controller.isLoading.value &&
                                obsList.isEmpty) {
                              return Center(child: Image.asset("assets/images/nodata.gif"));
                            } else if (!controller.isLoading.value &&
                                obsList.isNotEmpty) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < obsList.length; i++)
                                    ObsResultListTile(obsData: obsList[i]),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
