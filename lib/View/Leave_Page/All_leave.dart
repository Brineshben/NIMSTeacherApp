import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/Leave_Page/Approved_leave.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../Controller/api_controllers/leaveApprovalController.dart';
import '../../Models/api_models/leave_approval_api_model.dart';
import '../../Utils/api_constants.dart';

class allleave extends StatefulWidget {
  const allleave({super.key});

  @override
  State<allleave> createState() => _allleaveState();
}

class _allleaveState extends State<allleave> {
  final TextEditingController _reasontextController = TextEditingController();
  final FocusNode _reasonFocusNode = FocusNode();
 LeaveApprovalController leaveApprovalController = Get.find<LeaveApprovalController>();
  @override
  Widget build(BuildContext context) {
      Future<void> initialize() async {
    // context.loaderOverlay.show();
    // leaveApprovalController.resetStatus();
    await leaveApprovalController.fetchLeaveReqList();
    if(!mounted) return;
    // context.loaderOverlay.hide();
  }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 6.w, right: 6.w),
          child: TextFormField(
            onChanged: (value) {
              Get.find<LeaveApprovalController>().filterLeaveList(text: value);
            },
            validator: (val) => val!.isEmpty ? 'Enter the Topic' : null,
            cursorColor: Colors.grey,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                hintText: "Search Here",
                prefixIcon: Icon(
                  Icons.search,
                  color:Colors.grey,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.all(

                    Radius.circular(2.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(230, 236, 254, 0.966), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                fillColor: Colorutils.Whitecolor,
                filled: true),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: SizedBox(
            width: ScreenUtil().screenWidth,
            height: 600.h,
            child: GetX<LeaveApprovalController>(
              builder: (LeaveApprovalController controller) {
                List<AllLeaves> leaveList = controller.filteredAllLeaves.value.reversed.toList();
                if(leaveApprovalController.isLoading.value){
                  return LeaveApprovelShimmer();
                }else if(leaveApprovalController.isError.value){
                  return RefreshIndicator(
                    onRefresh: () async{
                            initialize();
                  leaveApprovalController.setCurrentLeaveTab(index: 2);
                    },
                    child: ListView(
                      children: [
                        SizedBox(
                           height:  450.h,
                           child: Center(
                            child: Text('Somthing Went Wrong.',style: TextStyle(
                                      color:  Colors.red,fontSize: 19.h
                                    )
                                                        ),
                           ),
                        ),
                      ],
                    ),
                  );
                }else if(!leaveApprovalController.connection.value){
                  return RefreshIndicator(
                    onRefresh: () async{
                              initialize();
                  leaveApprovalController.setCurrentLeaveTab(index: 2);
                    },
                    child: ListView(
                      children: [
                        SizedBox(
                           height:  450.h,
                           child: Center(
                            child: Text('Internet Not Connected...',style: TextStyle(
                                      color:  Colors.red,fontSize: 19.h
                                    )
                                                        ),
                           ),
                        ),
                      ],
                    ),
                  );
                } else if(leaveList.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async{
                                initialize();
                  leaveApprovalController.setCurrentLeaveTab(index: 2);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 80.h, top: 0, right: 0, left: 0),
                      itemCount: leaveList.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 2, 10, 5),
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
                          width: MediaQuery.of(context).size.width,
                          // height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color:Colorutils.chatcolor),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2,left: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color:Colorutils.chatcolor),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.fill,
                                                imageUrl: "${ApiConstants.downloadUrl}${leaveList[i].profileImage}",
                                                errorWidget: (context, url, error) => Center(
                                                  child: Text(
                                                    "${leaveList[i].studentName?.substring(0, 2).toUpperCase()}",
                                                    style: const TextStyle(
                                                        color: Color(0xFFB1BFFF),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(
                                width: 8.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 230.w,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  leaveList[i].studentName ?? '--',
                                                  style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                                                ),
                              
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      // Container(
                                      //   height: 25,
                                      //   width: 25,
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     border: Border.all(color: Colors.red),
                                      //   ),
                                      //   child: Center(
                                      //       child: Text(
                                      //         "${leaveList[i].days ?? '--'}",
                                      //         style: TextStyle(
                                      //             color: Colors.red, fontSize: 12.sp),
                                      //       )),
                                      // )
                                    ],
                              
                                  ),
                              
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 210.w, child: Text("Adm.No: ${leaveList[i].admissionNumber ?? '--'}")),
                                      SizedBox(width:210.w,child: Text('Class: ${leaveList[i].classs ?? '-'} ${leaveList[i].batch ?? '-'}')),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 130.w,
                                        child: Text(
                                          "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Text(
                                        "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                              
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.w,
                                  ),
                                  SizedBox(
                                    width: 210.w,child: Text("No.of Days: ${leaveList[i].days ?? '--'}", style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),),
                                  SizedBox(
                                    height: 8.w,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.60,
                                    height: 40.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Flexible(flex: 1, child: Container()),
                                        Text(
                                          "Status: ${capitalizeEachWord(leaveList[i].status) ?? '--'}",
                                          style: TextStyle(
                                            color: _leaveStatus(leaveList[i].status?.toLowerCase() ?? ''),
                                            // color: statusleave == "Approved"
                                            //     ? Colors.green
                                            //     : Colors.red,
                                          ),
                                        ),
                              
                                        (leaveList[i].myPending == true)
                                            ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Icon(Icons.arrow_back_outlined)),
                                                    SizedBox(
                                                      width: 35.w,
                                                    ),
                                                    Text(
                                                      'Leave Approval',
                                                      style: TextStyle(fontSize: 22.sp),
                                                    ),
                                                  ],
                                                ),
                                                content: SizedBox(
                                                  height: attchIconsize(type: leaveList[i].documentPath.toString().split(".").last),
                                                  // width: 300.w,
                                                  child: SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(leaveList[i].studentName ?? '--', style: TextStyle(fontSize: 18.sp)),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text('Class: ${leaveList[i].classs} ${leaveList[i].batch}',
                                                            style: const TextStyle(fontSize: 14)),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text('Reason : ${leaveList[i].reason}',
                                                            style: const TextStyle(fontSize: 14)),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text(
                                                            "Applied On: ${leaveList[i].applyDate.toString().split('T')[0].split('-').last}-${leaveList[i].applyDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].applyDate.toString().split('T')[0].split('-').first}",
                                                            style: const TextStyle(fontSize: 14)),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text(
                                                          // "From: ${fromdate!.split('T')[0]}",
                                                          "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                                                          style: const TextStyle(fontSize: 14),
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text(
                                                          "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                                                          style: const TextStyle(fontSize: 14),
                                                        ),
                              
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        (leaveList[i].documentPath != null)
                                                            ? Row(
                                                          children: [
                                                            const Row(
                                                              children: [
                                                                Text('Document :',
                                                                    style: TextStyle(fontSize: 14)),
                              
                                                              ],
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                try {
                                                                  await launchUrl(Uri.parse("${ApiConstants.downloadUrl}${leaveList[i].documentPath}"));
                                                                } catch(e) {
                                                                  print("--------vrgvg-------${e.toString()}");
                                                                }
                                                              },
                                                              child: attchIcon(
                                                                  type: leaveList[i].documentPath.toString().split(".").last,
                                                                  document: leaveList[i].documentPath.toString().toString()),
                                                            ),
                                                          ],
                                                        )
                                                            : Container(),
                                                        // if(int.parse(totaldays!) < 4)
                                                        Text(
                                                          'Remarks',
                                                          style: TextStyle(fontSize: 14.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        // if(int.parse(totaldays) < 4)
                                                        TextFormField(
                                                          maxLength: 150,
                                                          focusNode: _reasonFocusNode,
                                                          validator: (val) =>
                                                          val!.isEmpty ? '  *Enter the Reason' : null,
                                                          controller: _reasontextController,
                                                          cursorColor: Colors.grey,
                                                          decoration: const InputDecoration(
                                                              hintStyle: TextStyle(color: Colors.grey),
                                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(0),
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: Color.fromRGBO(230, 236, 254, 0.966), width: 1.0),
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: Color.fromRGBO(230, 236, 254, 0.966), width: 1.0),
                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                              ),
                                                              fillColor: Color.fromRGBO(230, 236, 254, 0.966),
                                                              filled: true),
                                                          keyboardType: TextInputType.text,
                                                          maxLines: 5,
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 40.w,
                                                            ),
                                                            // if(int.parse(totaldays!) < 4)
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                context.loaderOverlay.show();
                                                                UserAuthController userAuthController = Get.find<UserAuthController>();
                                                                submitleavedata(
                                                                    acadYEAR: userAuthController.userData.value.academicYear,
                                                                    leaveIds: leaveList[i].sId,
                                                                    apprve: 'Approve',
                                                                    userId: userAuthController.userData.value.userId,
                                                                    schoolId: userAuthController.userData.value.schoolId,
                                                                    approved: 'Approved')
                                                                    .then((_) async => await Get.find<LeaveApprovalController>().fetchLeaveReqList());
                                                                context.loaderOverlay.hide();
                                                                // Navigator.push(
                                                                //     context,
                                                                //     MaterialPageRoute(
                                                                //         builder: (context) => leaveApproval(
                                                                //           images: widget.images,
                                                                //           name: widget.name,
                                                                //         )));
                                                              },
                                                              child: Container(
                                                                  height: 40.h,
                                                                  width: 80.w,
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.green,
                                                                    borderRadius:
                                                                    BorderRadius.all(Radius.circular(50)),
                                                                  ),
                                                                  child: const Center(
                                                                    child: Text(
                                                                      'Approve',
                                                                      style: TextStyle(
                                                                          color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            // if(int.parse(totaldays) < 4)
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(context).pop();
                                                                context.loaderOverlay.show();
                                                                UserAuthController userAuthController = Get.find<UserAuthController>();
                                                                submitleavedata(
                                                                    acadYEAR: userAuthController.userData.value.academicYear,
                                                                    leaveIds: leaveList[i].sId,
                                                                    userId: userAuthController.userData.value.userId,
                                                                    schoolId: userAuthController.userData.value.schoolId,
                                                                    apprve: 'Reject',
                                                                    approved: 'Rejected')
                                                                    .then((_) async => await Get.find<LeaveApprovalController>().fetchLeaveReqList());
                                                                context.loaderOverlay.hide();
                                                                // Navigator.push(
                                                                //     context,
                                                                //     MaterialPageRoute(
                                                                //         builder: (context) => leaveApproval(
                                                                //           images: widget.images,
                                                                //           name: widget.name,
                                                                //         )));
                                                              },
                                                              child: Container(
                                                                  height: 40.h,
                                                                  width: 80.w,
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius:
                                                                    BorderRadius.all(Radius.circular(50)),
                                                                  ),
                                                                  child: const Center(
                                                                    child: Text(
                                                                      'Reject',
                                                                      style: TextStyle(
                                                                          color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                              height: 40.h,
                                              width: 90.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.red[500],
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Center(
                                                  child: Text(
                                                    'Update',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.sp,
                                                        color: Colors.white),
                                                  ))),
                                        )
                                            : GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                              
                                                  AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Icon(
                                                                Icons.arrow_back_outlined)),
                                                        SizedBox(
                                                          width: 35.w,
                                                        ),
                                                        Text(
                                                          'Leave Approval',
                                                          style: TextStyle(fontSize: 22.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    content: SizedBox(
                                                      height: 300,                                                // width: 300.w,
                                                      child: SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(leaveList[i].studentName ?? '--',
                                                                style: TextStyle(
                                                                    fontSize: 18.sp,fontWeight: FontWeight.bold)),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Text(
                                                                'Class: ${leaveList[i].classs ?? '-'} ${leaveList[i].batch ?? '-'}',
                                                                style:
                                                                const TextStyle(fontSize: 14)),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Text('Reason : ${leaveList[i].reason ?? '--'}',
                                                                style:
                                                                const TextStyle(fontSize: 14)),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Text(
                                                                "Applied On: ${leaveList[i].applyDate.toString().split('T')[0].split('-').last}-${leaveList[i].applyDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].applyDate.toString().split('T')[0].split('-').first}",
                                                                style:
                                                                const TextStyle(fontSize: 14)),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Text(
                                                              // "From: ${fromdate!.split('T')[0]}",
                                                              "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                                                              style:
                                                              const TextStyle(fontSize: 14),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Text(
                                                              "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                                                              style:
                                                              const TextStyle(fontSize: 14),
                                                            ),
                              
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            (leaveList[i].documentPath != null)
                                                                ? Row(
                                                              children: [
                                                                const Text('Document :',
                                                                    style: TextStyle(
                                                                        fontSize: 14)),
                                                                GestureDetector(
                                                                  onTap: () async {
                                                                    try {
                                                                      await launchUrl(Uri.parse("${ApiConstants.downloadUrl}${leaveList[i].documentPath}"));
                                                                    } catch(e) {}
                                                                  },
                                                                  child: attchIcon(
                                                                      type: leaveList[i].documentPath.toString().split(".").last,
                                                                      document: leaveList[i].documentPath.toString()),
                                                                ),
                                                              ],
                                                            )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              // AlertDialog(
                                              //   title: Row(
                                              //     children: [
                                              //       GestureDetector(
                                              //           onTap: () {
                                              //             Navigator.of(context)
                                              //                 .pop();
                                              //           },
                                              //           child: Icon(Icons
                                              //               .arrow_back_outlined)),
                                              //       SizedBox(
                                              //         width: 35.w,
                                              //       ),
                                              //       Text(
                                              //         'Leave Approval',
                                              //         style: TextStyle(
                                              //             fontSize: 22.sp),
                                              //       ),
                                              //     ],
                                              //   ),
                                              //   content: Container(
                                              //     height: 80,
                                              //     // width: 300.w,
                                              //     child: SingleChildScrollView(
                                              //       child: ListBody(
                                              //         children: <Widget>[
                                              //           Text(leaveList[i].studentName ?? '--',
                                              //               style: TextStyle(
                                              //                   fontSize: 18.sp)),
                                              //           SizedBox(
                                              //             height: 8.h,
                                              //           ),
                                              //           Text(
                                              //               'Class: ${leaveList[i].classs ?? '-'} ${leaveList[i].batch ?? '-'}',
                                              //               style: TextStyle(
                                              //                   fontSize: 14)),
                                              //           SizedBox(
                                              //             height: 8.h,
                                              //           ),
                                              //           Text(
                                              //               'Reason : ${leaveList[i].reason ?? '--'}',
                                              //               style: TextStyle(
                                              //                   fontSize: 14)),
                                              //           SizedBox(
                                              //             height: 8.h,
                                              //           ),
                                              //           Text(
                                              //               "Applied On: ${leaveList[i].applyDate.toString().split('T')[0].split('-').last}-${leaveList[i].applyDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].applyDate.toString().split('T')[0].split('-').first}",
                                              //               style: TextStyle(
                                              //                   fontSize: 14)),
                                              //           SizedBox(
                                              //             height: 8.h,
                                              //           ),
                                              //           Row(
                                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //             children: [
                                              //               Text(
                                              //                 // "From: ${fromdate!.split('T')[0]}",
                                              //                 "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                                              //                 style: TextStyle(
                                              //                     fontSize: 14),
                                              //               ),
                                              //               Text(
                                              //                 "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                                              //                 style: TextStyle(
                                              //                     fontSize: 14),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //           SizedBox(
                                              //             height: 10.h,
                                              //           ),
                                              //           (leaveList[i].documentPath != null)
                                              //               ? Row(
                                              //             children: [
                                              //               Text('Document :',
                                              //                   style: TextStyle(
                                              //                       fontSize: 14)),
                                              //               GestureDetector(
                                              //                 onTap: () async {
                                              //                   try {
                                              //                     await launchUrl(Uri.parse("${ApiConstants.baseUrl}${leaveList[i].documentPath}"));
                                              //                   } catch(e) {}
                                              //                 },
                                              //                 child: attchIcon(
                                              //                     type: leaveList[i].documentPath.toString().split(".").last,
                                              //                     document: leaveList[i].documentPath.toString().toString()),
                                              //               ),
                                              //             ],
                                              //           )
                                              //               : Container(),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            );
                                          },
                                          child: Container(
                                              height: 40.h,
                                              width: 90.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Center(
                                                  child: Text(
                                                    'Details',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.sp,
                                                        color: Colors.white),
                                                  ))),
                                        ),
                                        // Flexible(flex: 1, child: Container()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async{
                                initialize();
                  leaveApprovalController.setCurrentLeaveTab(index: 2);
                    },
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                      return SizedBox(
                        height: 400.h,
                        child: Center(
                          child: Image.asset("assets/images/nodata.gif"),
                        ),
                      );  
                      },
                      
                    ),
                  );
                }
                // return Column(
                //   children: [
                //     SizedBox(
                //       height: 20.h,
                //     ),
                //     // Divider(color: Colors.black26,height: 2.h,),
                //     for (int i = 0; i < leaveList.length; i++)
                //       Container(
                //         margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                //         padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
                //         width: MediaQuery.of(context).size.width,
                //         // height: 120.h,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10.r),
                //           border: Border.all(color:Colorutils.chatcolor),
                //         ),
                //         child: Row(
                //           children: [
                //             Column(
                //               children: [
                //                 Container(
                //                   height: 120,
                //                   child: Padding(
                //                     padding: const EdgeInsets.only(top: 2,left: 4),
                //                     child: Row(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         Container(
                //
                //                           decoration: BoxDecoration(
                //                             shape: BoxShape.circle,
                //                             border: Border.all(color:Colorutils.chatcolor),
                //                           ),
                //                           child: ClipRRect(
                //                             borderRadius: BorderRadius.circular(100),
                //                             child: CachedNetworkImage(
                //                               width: 40,
                //                               height: 40,
                //                               fit: BoxFit.fill,
                //                               imageUrl: leaveList[i].profileImage ?? '',
                //                               errorWidget: (context, url, error) => Center(
                //                                 child: Text(
                //                                   "${leaveList[i].studentName?.substring(0, 2).toUpperCase()}",
                //                                   style: TextStyle(
                //                                       color: Color(0xFFB1BFFF),
                //                                       fontWeight: FontWeight.bold,
                //                                       fontSize: 20),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //
                //             SizedBox(
                //               width: 8.w,
                //             ),
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Row(
                //                   children: [
                //                     Container(
                //                         width: 230.w,
                //                         child: SingleChildScrollView(
                //                           scrollDirection: Axis.horizontal,
                //                           child: Row(
                //                             children: [
                //                               Text(
                //                                 leaveList[i].studentName ?? '--',
                //                                 style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                //                               ),
                //
                //                             ],
                //                           ),
                //                         )),
                //                     SizedBox(
                //                       width: 5,
                //                     ),
                //                     Container(
                //                       height: 25,
                //                       width: 25,
                //                       decoration: BoxDecoration(
                //                         shape: BoxShape.circle,
                //                         border: Border.all(color: Colors.red),
                //                       ),
                //                       child: Center(
                //                           child: Text(
                //                             "${leaveList[i].days ?? '--'}",
                //                             style: TextStyle(
                //                                 color: Colors.red, fontSize: 12.sp),
                //                           )),
                //                     )
                //                   ],
                //
                //                 ),
                //
                //                 Column(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Container(
                //                         width: 140.w, child: Text("Adm.No: ${leaveList[i].admissionNumber ?? '--'}")),
                //                     Text('Class: ${leaveList[i].classs ?? '-'} ${leaveList[i].batch ?? '-'}'),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5.h,
                //                 ),
                //                 Row(
                //                   children: [
                //                     Container(
                //                       width: 130.w,
                //                       child: Text(
                //                         "From: ${leaveList[i].startDate}",
                //                         style: TextStyle(fontSize: 12),
                //                       ),
                //                     ),
                //                     Text(
                //                       "To: ${leaveList[i].endDate}",
                //                       style: TextStyle(fontSize: 12),
                //                     ),
                //
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 8.w,
                //                 ),
                //                 Container(
                //                   width: MediaQuery.of(context).size.width * 0.60,
                //                   height: 40.h,
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       // Flexible(flex: 1, child: Container()),
                //                       Text(
                //                         "Status: ${leaveList[i].status ?? '--'}",
                //                         style: TextStyle(
                //                           color: _leaveStatus(leaveList[i].status?.toLowerCase() ?? ''),
                //                           // color: statusleave == "Approved"
                //                           //     ? Colors.green
                //                           //     : Colors.red,
                //                         ),
                //                       ),
                //
                //                       (leaveList[i].myPending == true)
                //                           ? GestureDetector(
                //                         onTap: () {
                //                             showDialog(
                //                               barrierDismissible: false,
                //                               context: context,
                //                               builder: (BuildContext context) => AlertDialog(
                //                                 title: Row(
                //                                   children: [
                //                                     GestureDetector(
                //                                         onTap: () {
                //                                           Navigator.of(context).pop();
                //                                         },
                //                                         child: Icon(Icons.arrow_back_outlined)),
                //                                     SizedBox(
                //                                       width: 35.w,
                //                                     ),
                //                                     Text(
                //                                       'Leave Approval',
                //                                       style: TextStyle(fontSize: 22.sp),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 content: Container(
                //                                   height: attchIconsize(type: leaveList[i].documentPath.toString().split(".").last),
                //                                   // width: 300.w,
                //                                   child: SingleChildScrollView(
                //                                     child: ListBody(
                //                                       children: <Widget>[
                //                                         Text(leaveList[i].studentName ?? '--', style: TextStyle(fontSize: 18.sp)),
                //                                         SizedBox(
                //                                           height: 8.h,
                //                                         ),
                //                                         Text('Class: ${leaveList[i].classs} ${leaveList[i].batch}',
                //                                             style: TextStyle(fontSize: 14)),
                //                                         SizedBox(
                //                                           height: 8.h,
                //                                         ),
                //                                         Text('Reason : ${leaveList[i].reason}',
                //                                             style: TextStyle(fontSize: 14)),
                //                                         SizedBox(
                //                                           height: 8.h,
                //                                         ),
                //                                         Text(
                //                                             "Applied On: ${leaveList[i].applyDate.toString().split('T')[0].split('-').last}-${leaveList[i].applyDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].applyDate.toString().split('T')[0].split('-').first}",
                //                                             style: TextStyle(fontSize: 14)),
                //                                         SizedBox(
                //                                           height: 8.h,
                //                                         ),
                //                                         Row(
                //                                           children: [
                //                                             Text(
                //                                               // "From: ${fromdate!.split('T')[0]}",
                //                                               "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                //                                               style: TextStyle(fontSize: 14),
                //                                             ),
                //                                             SizedBox(
                //                                               width: 40.w,
                //                                             ),
                //                                             Text(
                //                                               "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                //                                               style: TextStyle(fontSize: 14),
                //                                             ),
                //                                           ],
                //                                         ),
                //                                         SizedBox(
                //                                           height: 10.h,
                //                                         ),
                //                                         (leaveList[i].documentPath != null)
                //                                             ? Row(
                //                                           children: [
                //                                             Text('Document :',
                //                                                 style: TextStyle(fontSize: 14)),
                //                                             GestureDetector(
                //                                               onTap: () async {
                //                                                 await launchUrl(Uri.parse("${ApiConstants.IMAGE_BASE_URL}${leaveList[i].documentPath}"));
                //                                               },
                //                                               child: attchIcon(type: leaveList[i].documentPath.toString().split(".").last, document: leaveList[i].documentPath.toString()),
                //                                             ),
                //                                           ],
                //                                         )
                //                                             : Container(),
                //                                         // if(int.parse(totaldays!) < 4)
                //                                         Text(
                //                                           'Remarks',
                //                                           style: TextStyle(fontSize: 14.sp),
                //                                         ),
                //                                         SizedBox(
                //                                           height: 10.h,
                //                                         ),
                //                                         // if(int.parse(totaldays) < 4)
                //                                         TextFormField(
                //                                           maxLength: 150,
                //                                           focusNode: _reasonFocusNode,
                //                                           validator: (val) =>
                //                                           val!.isEmpty ? '  *Enter the Reason' : null,
                //                                           controller: _reasontextController,
                //                                           cursorColor: Colors.grey,
                //                                           decoration: const InputDecoration(
                //                                               hintStyle: TextStyle(color: Colors.grey),
                //                                               contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                //                                               border: OutlineInputBorder(
                //                                                 borderRadius: BorderRadius.all(
                //                                                   Radius.circular(0),
                //                                                 ),
                //                                               ),
                //                                               enabledBorder: OutlineInputBorder(
                //                                                 borderSide:
                //                                                 BorderSide(color:Color.fromRGBO(230, 236, 254, 0.966),, width: 1.0),
                //                                                 borderRadius: BorderRadius.all(Radius.circular(10)),
                //                                               ),
                //                                               focusedBorder: OutlineInputBorder(
                //                                                 borderSide:
                //                                                 BorderSide(color:Color.fromRGBO(230, 236, 254, 0.966),, width: 1.0),
                //                                                 borderRadius: BorderRadius.all(Radius.circular(5)),
                //                                               ),
                //                                               fillColor:Color.fromRGBO(230, 236, 254, 0.966),,
                //                                               filled: true),
                //                                           keyboardType: TextInputType.text,
                //                                           maxLines: 5,
                //                                         ),
                //                                         SizedBox(
                //                                           height: 10.h,
                //                                         ),
                //                                         Row(
                //                                           children: [
                //                                             SizedBox(
                //                                               width: 40.w,
                //                                             ),
                //                                             // if(int.parse(totaldays!) < 4)
                //                                             GestureDetector(
                //                                               onTap: () {
                //                                                 Navigator.pop(context);
                //                                                 context.loaderOverlay.show();
                //                                                 UserAuthController userAuthController = Get.find<UserAuthController>();
                //                                                 submitleavedata(
                //                                                     acadYEAR: userAuthController.userData.value.academicYear,
                //                                                     leaveIds: leaveList[i].sId,
                //                                                     apprve: 'Approve',
                //                                                     userId: userAuthController.userData.value.userId,
                //                                                     schoolId: userAuthController.userData.value.schoolId,
                //                                                     approved: 'Approved')
                //                                                     .then((_) async => await Get.find<LeaveApprovalController>().fetchLeaveReqList());
                //                                                 context.loaderOverlay.hide();
                //                                                 // Navigator.push(
                //                                                 //     context,
                //                                                 //     MaterialPageRoute(
                //                                                 //         builder: (context) => leaveApproval(
                //                                                 //           images: widget.images,
                //                                                 //           name: widget.name,
                //                                                 //         )));
                //                                               },
                //                                               child: Container(
                //                                                   height: 40.h,
                //                                                   width: 80.w,
                //                                                   decoration: BoxDecoration(
                //                                                     color: Colors.green,
                //                                                     borderRadius:
                //                                                     BorderRadius.all(Radius.circular(50)),
                //                                                   ),
                //                                                   child: Center(
                //                                                     child: Text(
                //                                                       'Approve',
                //                                                       style: TextStyle(
                //                                                           color: Colors.white, fontSize: 12),
                //                                                     ),
                //                                                   )),
                //                                             ),
                //                                             SizedBox(
                //                                               width: 10.w,
                //                                             ),
                //                                             // if(int.parse(totaldays) < 4)
                //                                             GestureDetector(
                //                                               onTap: () {
                //                                                 Navigator.of(context).pop();
                //                                                 context.loaderOverlay.show();
                //                                                 UserAuthController userAuthController = Get.find<UserAuthController>();
                //                                                 submitleavedata(
                //                                                     acadYEAR: userAuthController.userData.value.academicYear,
                //                                                     leaveIds: leaveList[i].sId,
                //                                                     userId: userAuthController.userData.value.userId,
                //                                                     schoolId: userAuthController.userData.value.schoolId,
                //                                                     apprve: 'Reject',
                //                                                     approved: 'Rejected')
                //                                                     .then((_) async => await Get.find<LeaveApprovalController>().fetchLeaveReqList());
                //                                                 context.loaderOverlay.hide();
                //                                                 // Navigator.push(
                //                                                 //     context,
                //                                                 //     MaterialPageRoute(
                //                                                 //         builder: (context) => leaveApproval(
                //                                                 //           images: widget.images,
                //                                                 //           name: widget.name,
                //                                                 //         )));
                //                                               },
                //                                               child: Container(
                //                                                   height: 40.h,
                //                                                   width: 80.w,
                //                                                   decoration: BoxDecoration(
                //                                                     color: Colors.red,
                //                                                     borderRadius:
                //                                                     BorderRadius.all(Radius.circular(50)),
                //                                                   ),
                //                                                   child: Center(
                //                                                     child: Text(
                //                                                       'Reject',
                //                                                       style: TextStyle(
                //                                                           color: Colors.white, fontSize: 12),
                //                                                     ),
                //                                                   )),
                //                                             ),
                //                                           ],
                //                                         )
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             );
                //                         },
                //                             child: Container(
                //                             height: 30.h,
                //                             width: 70.w,
                //                             decoration: BoxDecoration(
                //                                 color: Colors.red[500],
                //                                 borderRadius:
                //                                 BorderRadius.circular(10)),
                //                             child: Center(
                //                                 child: Text(
                //                                   'Update',
                //                                   style: TextStyle(
                //                                       fontWeight: FontWeight.bold,
                //                                       fontSize: 12.sp,
                //                                       color: Colors.white),
                //                                 ))),
                //                           )
                //                           : GestureDetector(
                //                         onTap: () async {
                //                           showDialog(
                //                             barrierDismissible: false,
                //                             context: context,
                //                             builder: (BuildContext context) =>
                //
                //                                 AlertDialog(
                //                                   title: Row(
                //                                     children: [
                //                                       GestureDetector(
                //                                           onTap: () {
                //                                             Navigator.of(context).pop();
                //                                           },
                //                                           child: Icon(
                //                                               Icons.arrow_back_outlined)),
                //                                       SizedBox(
                //                                         width: 35.w,
                //                                       ),
                //                                       Text(
                //                                         'Leave Approval',
                //                                         style: TextStyle(fontSize: 22.sp),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                   content: Container(
                //                                     height: 300,                                                // width: 300.w,
                //                                     child: SingleChildScrollView(
                //                                       child: ListBody(
                //                                         children: <Widget>[
                //                                           Text(leaveList[i].studentName ?? '--',
                //                                               style: TextStyle(
                //                                                   fontSize: 18.sp,fontWeight: FontWeight.bold)),
                //                                           SizedBox(
                //                                             height: 8.h,
                //                                           ),
                //                                           Text(
                //                                               'Class: ${leaveList[i].classs ?? '-'} ${leaveList[i].batch ?? '-'}',
                //                                               style:
                //                                               TextStyle(fontSize: 14)),
                //                                           SizedBox(
                //                                             height: 8.h,
                //                                           ),
                //                                           Text('Reason : ${leaveList[i].reason ?? '--'}',
                //                                               style:
                //                                               TextStyle(fontSize: 14)),
                //                                           SizedBox(
                //                                             height: 8.h,
                //                                           ),
                //                                           Text(
                //                                               "Applied On: ${leaveList[i].applyDate.toString().split('T')[0].split('-').last}-${leaveList[i].applyDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].applyDate.toString().split('T')[0].split('-').first}",
                //                                               style:
                //                                               TextStyle(fontSize: 14)),
                //                                           SizedBox(
                //                                             height: 8.h,
                //                                           ),
                //                                           Row(
                //                                             children: [
                //                                               Text(
                //                                                 // "From: ${fromdate!.split('T')[0]}",
                //                                                 "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                //                                                 style:
                //                                                 TextStyle(fontSize: 14),
                //                                               ),
                //                                               SizedBox(
                //                                                 width: 40.w,
                //                                               ),
                //                                               Text(
                //                                                 "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                //                                                 style:
                //                                                 TextStyle(fontSize: 14),
                //                                               ),
                //                                             ],
                //                                           ),
                //                                           SizedBox(
                //                                             height: 10.h,
                //                                           ),
                //                                           (leaveList[i].documentPath != null)
                //                                               ? Row(
                //                                             children: [
                //                                               Text('Document :',
                //                                                   style: TextStyle(
                //                                                       fontSize: 14)),
                //                                               GestureDetector(
                //                                                 onTap: () async {
                //                                                   try {
                //                                                     await launchUrl(Uri.parse("${ApiConstants.baseUrl}${leaveList[i].documentPath}"));
                //                                                   } catch(e) {}
                //                                                 },
                //                                                 child: attchIcon(
                //                                                     type: leaveList[i].documentPath.toString().split(".").last,
                //                                                     document: leaveList[i].documentPath.toString().toString()),
                //                                               ),
                //                                             ],
                //                                           )
                //                                               : Container(),
                //                                         ],
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 // AlertDialog(
                //                                 //   title: Row(
                //                                 //     children: [
                //                                 //       GestureDetector(
                //                                 //           onTap: () {
                //                                 //             Navigator.of(context)
                //                                 //                 .pop();
                //                                 //           },
                //                                 //           child: Icon(Icons
                //                                 //               .arrow_back_outlined)),
                //                                 //       SizedBox(
                //                                 //         width: 35.w,
                //                                 //       ),
                //                                 //       Text(
                //                                 //         'Leave Approval',
                //                                 //         style: TextStyle(
                //                                 //             fontSize: 22.sp),
                //                                 //       ),
                //                                 //     ],
                //                                 //   ),
                //                                 //   content: Container(
                //                                 //     height: 80,
                //                                 //     // width: 300.w,
                //                                 //     child: SingleChildScrollView(
                //                                 //       child: ListBody(
                //                                 //         children: <Widget>[
                //                                 //           Text(leaveList[i].studentName ?? '--',
                //                                 //               style: TextStyle(
                //                                 //                   fontSize: 18.sp)),
                //                                 //           SizedBox(
                //                                 //             height: 8.h,
                //                                 //           ),
                //                                 //           Text(
                //                                 //               'Class: ${leaveList[i].classs ?? '-'} ${leaveList[i].batch ?? '-'}',
                //                                 //               style: TextStyle(
                //                                 //                   fontSize: 14)),
                //                                 //           SizedBox(
                //                                 //             height: 8.h,
                //                                 //           ),
                //                                 //           Text(
                //                                 //               'Reason : ${leaveList[i].reason ?? '--'}',
                //                                 //               style: TextStyle(
                //                                 //                   fontSize: 14)),
                //                                 //           SizedBox(
                //                                 //             height: 8.h,
                //                                 //           ),
                //                                 //           Text(
                //                                 //               "Applied On: ${leaveList[i].applyDate.toString().split('T')[0].split('-').last}-${leaveList[i].applyDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].applyDate.toString().split('T')[0].split('-').first}",
                //                                 //               style: TextStyle(
                //                                 //                   fontSize: 14)),
                //                                 //           SizedBox(
                //                                 //             height: 8.h,
                //                                 //           ),
                //                                 //           Row(
                //                                 //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                                 //             children: [
                //                                 //               Text(
                //                                 //                 // "From: ${fromdate!.split('T')[0]}",
                //                                 //                 "From: ${leaveList[i].startDate.toString().split('T')[0].split('-').last}-${leaveList[i].startDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].startDate.toString().split('T')[0].split('-').first}",
                //                                 //                 style: TextStyle(
                //                                 //                     fontSize: 14),
                //                                 //               ),
                //                                 //               Text(
                //                                 //                 "To: ${leaveList[i].endDate.toString().split('T')[0].split('-').last}-${leaveList[i].endDate.toString().split('T')[0].split('-')[1]}-${leaveList[i].endDate.toString().split('T')[0].split('-').first}",
                //                                 //                 style: TextStyle(
                //                                 //                     fontSize: 14),
                //                                 //               ),
                //                                 //             ],
                //                                 //           ),
                //                                 //           SizedBox(
                //                                 //             height: 10.h,
                //                                 //           ),
                //                                 //           (leaveList[i].documentPath != null)
                //                                 //               ? Row(
                //                                 //             children: [
                //                                 //               Text('Document :',
                //                                 //                   style: TextStyle(
                //                                 //                       fontSize: 14)),
                //                                 //               GestureDetector(
                //                                 //                 onTap: () async {
                //                                 //                   try {
                //                                 //                     await launchUrl(Uri.parse("${ApiConstants.baseUrl}${leaveList[i].documentPath}"));
                //                                 //                   } catch(e) {}
                //                                 //                 },
                //                                 //                 child: attchIcon(
                //                                 //                     type: leaveList[i].documentPath.toString().split(".").last,
                //                                 //                     document: leaveList[i].documentPath.toString().toString()),
                //                                 //               ),
                //                                 //             ],
                //                                 //           )
                //                                 //               : Container(),
                //                                 //         ],
                //                                 //       ),
                //                                 //     ),
                //                                 //   ),
                //                                 // ),
                //                           );
                //                         },
                //                         child: Container(
                //                             height: 40.h,
                //                             width: 90.w,
                //                             decoration: BoxDecoration(
                //                                 color: Colors.blue,
                //                                 borderRadius:
                //                                 BorderRadius.circular(10)),
                //                             child: Center(
                //                                 child: Text(
                //                                   'Details',
                //                                   style: TextStyle(
                //                                       fontWeight: FontWeight.bold,
                //                                       fontSize: 12.sp,
                //                                       color: Colors.white),
                //                                 ))),
                //                       ),
                //                       // Flexible(flex: 1, child: Container()),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //   ],
                // );
              },
            ),
          ),
        ),

      ],
    );
  }

  // Widget _allleave(
  Color _leaveStatus(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.yellow.shade800;
      default:
        return Colors.grey;
    }
  }

  Widget attchIcon({String? type, String? document}) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("${ApiConstants.downloadUrl}$document")),
            borderRadius: BorderRadius.circular(10)),
      );
    } else if (type == 'pdf') {
      return const Icon(Icons.picture_as_pdf, color: Colors.red,);
    } else {
      return Icon(Icons.attach_file, color: Colors.lightBlue.shade100,);
    }
  }

  double attchIconsize({String? type, String? document}) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return 500.h;
    } else if (type == 'pdf') {
      return 400.h;
    } else {
      return 400.h;
    }
  }

  Future submitleavedata(
      {String? acadYEAR,
        String? leaveIds,
        String? userId,
        String? schoolId,
        String? apprve,
        String? approved}) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var userID = preferences.getString('userID');
    // var schoolID = preferences.getString('school_id');
    // var academicyear = preferences.getString('academic_year');
    // print("____---shared$schoolID");
    // print("____---user$userID");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "user_id": userId,
      "school_id": schoolId,
      "academic_year": acadYEAR,
      "leaveID": leaveIds,
      "approvedBy": userId,
      "actionItem": {
        "actionItem": apprve,
        // "actionItem": "Reject / Approve",
        // "actionstatus": "Rejected / Approved",
        "actionstatus": approved,
        "commentItem": _reasontextController.text
      },
      "commentItem": _reasontextController.text
    };
    print('---b-o-d-y-lleeaavve--$body');
    var request = await http.post(Uri.parse(ApiConstants.baseUrl + ApiConstants.leaveRequestApproval),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),backgroundColor: Colors.green,
      ));
    }

    //log('----------reqbdyy${request.body}');
    log('----------rsssssbdyy$response');
    // setState(() {
    //   isSpinner = false;
    // });
  }
}
