import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teacherapp/Controller/api_controllers/leaveRequestController.dart';
import 'package:teacherapp/Utils/api_constants.dart';
import 'package:teacherapp/View/Leave_Page/leave_apply.dart';

import '../../Models/api_models/leave_req_list_api_model.dart';
import '../../Utils/Colors.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({super.key});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest>
    with WidgetsBindingObserver {
  LeaveRequestController leaveRequestController =
      Get.find<LeaveRequestController>();
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  late bool selected;

  @override
  void initState() {
     initialize();

    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Future<void> initialize() async {
    // context.loaderOverlay.show();
    await leaveRequestController.fetchLeaveReqList();
    if (!mounted) return;
    // context.loaderOverlay.hide();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
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
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    top: 120.h,
                    right: 10.w,
                  ),
                  child: Container(
                    // margin: EdgeInsets.only(
                    //   left: 10.w,
                    //   top: 120.h,
                    //   right: 10.w,
                    // ),
                    // width: 550.w,
                    // height: ScreenUtil().screenHeight ,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ).r,

                      boxShadow: [
                        BoxShadow(
                          color: Colorutils.userdetailcolor.withOpacity(0.2),
                          // Shadow color
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1), // Shadow position
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Leave Apply',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      // Text(
                                      //   'My Class',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 15.sp,
                                      //       color: Colors.black),
                                      // ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      SizedBox(
                                        height: 60.h,
                                        width: 150.w,
                                        child: GetX<LeaveRequestController>(
                                          builder: (LeaveRequestController
                                              controller) {
                                            List<ClassData> classlist =
                                                controller.classList.value;
                                            classlist.sort((a, b) =>
                                                "${a.className!}${a.batchName!}"
                                                    .compareTo(
                                                        "${b.className!}${b.batchName!}"));
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: classlist.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      SingleChildScrollView(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              print(
                                                                  "object--------------------------------- $index");
                                                              _currentIndex =
                                                                  index;
                                                              controller.setStudentList(
                                                                  selectedClassData:
                                                                      classlist[
                                                                          index],
                                                                  index: index);
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 55.w,
                                                            height: 55.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    spreadRadius:
                                                                        1,
                                                                    blurRadius:
                                                                        1,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            1),
                                                                  ),
                                                                ],
                                                                    color: _currentIndex ==
                                                                            index
                                                                        ? Colorutils
                                                                            .bottomnaviconcolor
                                                                        : Colors
                                                                            .grey
                                                                            .shade200,
                                                                    // color: controller.currentClassIndex.value == index ? Colors.green : Colors.red,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(50.r))),
                                                            child: Center(
                                                              child: Text(
                                                                "${classlist[index].className}"
                                                                "${classlist[index].batchName}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: _currentIndex ==
                                                                            index
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.w),
                            Container(
                              margin: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: TextFormField(
                                controller: _searchController,
                                onChanged: (value) {
                                  leaveRequestController.filterList(
                                      text: value);
                                },
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    hintText: "Search Student Name or Adm.No",
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colorutils.userdetailcolor,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(2.0),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.chatcolor,
                                          width: 1.0),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.chatcolor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                    fillColor:
                                        Colorutils.chatcolor.withOpacity(0.15),
                                    filled: true),
                              ),
                            ),
                            SizedBox(height: 20.w),
                            GetX<LeaveRequestController>(
                              builder: (LeaveRequestController controller) {
                                List<StudentsData> studentList =
                                    controller.filteredStudentList;
                                studentList.sort(
                                  (a, b) => a.name!
                                      .trim()
                                      .toUpperCase()
                                      .compareTo(b.name!.trim().toUpperCase()),
                                );
                    
                               if(leaveRequestController.isLoading.value){
                                return const LeaveApplyShimmer();
                               }else if(!leaveRequestController.conncetion.value){
                                return SizedBox(
                height: ScreenUtil().screenHeight * 0.6,
                child: RefreshIndicator(
                  onRefresh: () async{
                      await initialize();
                                         
                                        setState(() {
                                          if(leaveRequestController.filteredStudentList.isNotEmpty){
                                            _currentIndex= 0;
                                          }
                                        });
                  },
                  child: ListView(
                    children :[
                      SizedBox(height: 200.h,),
                       Center(
                      child:   Text('Internet Not Connected..',style: TextStyle(
                                color:  Colors.red,fontSize: 19.h
                              )
                    ),
                                    )]
                  ),
                ));
                               }else if(leaveRequestController.isError.value){
                                 return SizedBox(
                height: ScreenUtil().screenHeight * 0.6,
                child: RefreshIndicator(
                  onRefresh: () async{
                      await initialize();
                                         
                                        setState(() {
                                          if(leaveRequestController.filteredStudentList.isNotEmpty){
                                            _currentIndex= 0;
                                          }
                                        });
                  },
                  child: ListView(
                    children :[
                      SizedBox(height: 200.h,),
                       Center(
                      child:  Text('Somthing Went Wrong',style: TextStyle(
                                    color:  Colors.red,fontSize: 19.h
                                  ),
                    ),
                                    )]
                  ),
                ));
                               }else if (studentList.isNotEmpty) {
                                  return SizedBox(
                                    height: ScreenUtil().screenHeight * 0.7,
                                    child: RefreshIndicator(
                                      onRefresh: () async{
                                        await initialize();
                                         
                                        setState(() {
                                          if(leaveRequestController.filteredStudentList.isNotEmpty){
                                            _currentIndex= 0;
                                          }
                                        });
                                      },
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                                bottom: View.of(context)
                                                            .viewInsets
                                                            .bottom ==
                                                        0
                                                    ? 200
                                                    : 400)
                                            .h,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (int i = 0;
                                                i < studentList.length;
                                                i++)
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LeaveApply(
                                                        studentsData:
                                                            studentList[i],
                                                        claas: controller
                                                            .claass.value,
                                                        batch: controller
                                                            .batch.value,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10,
                                                      left: 15,
                                                      right: 15,
                                                      bottom: 5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        color: Colorutils
                                                            .chatcolor
                                                            .withOpacity(0.05),
                                                        border: Border.all(
                                                            color: Colorutils
                                                                .chatcolor)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 50.w,
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              border: Border.all(
                                                                  color: Colorutils
                                                                      .chatcolor),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                          .circular(
                                                                              100)
                                                                      .r,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    "${ApiConstants.downloadUrl}${studentList[i].profileImage}",
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        Center(
                                                                  child: Text(
                                                                    studentList[i]
                                                                            .name
                                                                            ?.substring(
                                                                                0,
                                                                                1) ??
                                                                        '',
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFFB1BFFF),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                errorWidget:
                                                                    (context, url,
                                                                            error) =>
                                                                        Center(
                                                                  child: Text(
                                                                    studentList[i]
                                                                            .name
                                                                            ?.substring(
                                                                                0,
                                                                                1) ??
                                                                        '',
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFFB1BFFF),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 250.w,
                                                                  child: Text(
                                                                    studentList[i]
                                                                            .name
                                                                            ?.toUpperCase() ??
                                                                        '--',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 250.w,
                                                                  child: Text(
                                                                    "Adm. No. : ${studentList[i].admissionNumber ?? '--'}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return RefreshIndicator(
                                    onRefresh: ()  async{
                                     await initialize();
                                    },
                                    child: SingleChildScrollView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      child: SizedBox(
                                        height: ScreenUtil().screenHeight * 0.7,
                                        child: SizedBox(
                                          height: 250.h,
                                          child: Center(
                                            child: Image.asset(
                                                "assets/images/nodata.gif"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

String capitalizeFirstLetterOfEachWord(String input) {
  return input
      .trim()
      .split(' ')
      .where((word) => word.isNotEmpty) // Filter out empty strings
      .map((word) {
    print("$input...........input..............");
    String removeSpace = word.trim();
    print("$removeSpace...........removeSpace..............");
    return removeSpace[0].toUpperCase() + removeSpace.substring(1);
  }).join(' ');
}


class LeaveApplyShimmer extends StatelessWidget {
  const LeaveApplyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: ScreenUtil().screenHeight * 0.7,
         child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(height: 4.h,);
          },
       padding: const EdgeInsets.only(
                                                      top: 10,
                                                      left: 15,
                                                      right: 15,
                                                      bottom: 5),
          itemCount: 10,
          itemBuilder: (context,indext){
          return Container(
           decoration:  BoxDecoration(
             borderRadius:
                                                            BorderRadius.circular(
                                                                10),
            color: Colors.grey[50]
           ),
            child: Shimmer.fromColors(
              baseColor:  Colors.grey[200]!,
              highlightColor: Colors.grey[300]!,
              child: ListTile(
                leading: Container(
                   height:  45.h,
                   width: 45.w,
                  decoration:  BoxDecoration(
                    color:  Colors.blue,
                     borderRadius: BorderRadius.circular(30.r)
                    
                  ),
                ),
                trailing: const Text(''),
                  title: Container(height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Colors.blue),
                  ),
                  subtitle:   Container(height: 8.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Colors.blue),
                  ),
              ),
            ),
          );
         }), 
      );
  }
}