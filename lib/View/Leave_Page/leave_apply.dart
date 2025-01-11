import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Controller/api_controllers/leaveRequestController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Services/api_services.dart';
import 'package:teacherapp/Services/check_connectivity.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/api_constants.dart';
import '../../Models/api_models/leave_req_list_api_model.dart';
import '../../Utils/Colors.dart';
import '../../Utils/constants.dart';
import '../../Utils/font_util.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class LeaveApply extends StatefulWidget {
  final StudentsData studentsData;
  final String claas;
  final String batch;
  const LeaveApply({super.key, required this.studentsData, required this.claas, required this.batch});

  @override
  State<LeaveApply> createState() => _ObsResultState();
}

class _ObsResultState extends State<LeaveApply> {
  get questionData => null;

  get isChecked => null;
  var fromDate = 'DD-MM-YYYY';
  var toDate = 'DD-MM-YYYY';
  final DateFormat _examformatter = DateFormat('dd-MM-yyyy');
  final DateFormat _examFFormatter1 = DateFormat('dd-MM-yyyy');
  DateTime? pickedFrom;
  DateTime? pickedTo;
  String? _fileName;
  String? _filePath;
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectFromDate(BuildContext context) async
  {
    pickedFrom = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),
      firstDate: DateTime.now(),

      // lastDate: new DateTime(2025),
      lastDate: DateTime(DateTime
          .now()
          .year + 1),

    );
    setState(() {
      fromDate = _examformatter.format(pickedFrom!);
      toDate = 'DD-MM-YYYY';
    });
    print(fromDate);

  }

  Future<Null> _selectToDate(BuildContext context) async
  {
    if(fromDate != 'DD-MM-YYYY') {
      pickedTo = await showDatePicker(
        context: context,
        initialDate: pickedFrom ?? DateTime.now(),
        firstDate: pickedFrom ?? DateTime.now(),
        // lastDate: new DateTime(2025),
        lastDate: DateTime(DateTime
            .now()
            .year + 1),
      );
      setState(() {
        toDate = _examFFormatter1.format(pickedTo!);
      });
      print(toDate);
    } else {
      snackBar(context: context, message: "Please select from date", color: Colors.red);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      // If the user picked a file
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
      setState(() {
        _fileName = null;
        _filePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(

      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.98,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  const AppBarBackground(),
                  Positioned(
                    left: 0,
                    top: -10,
                    child: Container(

                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      child: const UserDetails(
                        shoBackgroundColor: false, isWelcome: false, bellicon: true, notificationcount: true,),
                    ),
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(left: 15.w, top: 120.h, right: 15.w,),
                    // width: 500.w,
                    height: ScreenUtil().screenHeight * 0.8,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: const BorderRadius.all(Radius.circular(17)),
                      // Border radius
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
                    child: ListView(
                        padding: const EdgeInsets.only(top: 10),
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    const Text('Leave Apply', style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),),
                                    SizedBox(
                                      width: 120.w,
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 20, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          width: 120.w,
                                          height: 120.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFFD6E4FA)),

                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.fill,
                                              imageUrl: "${ApiConstants.downloadUrl}${widget.studentsData.profileImage}",
                                              placeholder: (context, url) =>
                                                  Center(
                                                    child: Text(
                                                      widget.studentsData.name?.substring(0, 1) ?? '',
                                                      style: const TextStyle(
                                                          color: Color(0xFFB1BFFF),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                              errorWidget: (context, url, error) =>
                                                  Center(
                                                    child: Text(
                                                      widget.studentsData.name?.substring(0, 1) ?? '',
                                                      style: const TextStyle(
                                                          color: Color(0xFFB1BFFF),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Center(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(
                                              widget.studentsData.name ?? '--',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),

                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                            child: Text('Admission No'),

                                          ),
                                          const SizedBox(
                                            width: 10,
                                            child: Text(':'),

                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(widget.studentsData.admissionNumber ?? '--'),

                                          )

                                        ],
                                      ),),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                            child: Text('Class'),

                                          ),
                                          const SizedBox(
                                            width: 10,
                                            child: Text(':'),

                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text("${widget.claas}${widget.batch}"),

                                          )

                                        ],
                                      ),),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.w,right: 2.w),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('FROM : $fromDate', style: TextStyle(
                                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                                            IconButton(icon: Icon(
                                              Icons.calendar_month, color: Colors.blue[900], size: 20,),
                                              onPressed: () {
                                                _selectFromDate(context);
                                              },),
                                            // SizedBox(
                                            //   width: 5.w,
                                            // ),
                                            Text('TO : $toDate', style: TextStyle(
                                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                                            IconButton(icon: Icon(
                                              Icons.calendar_month, color: Colors.blue[900], size: 20,),
                                              onPressed: () {
                                                _selectToDate(context);
                                              },)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text('Reason', style: TextStyle(
                                          fontSize: 15.sp, fontWeight: FontWeight.w600)),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.w,
                                          top: 5.h,
                                          right: 5.w,
                                          bottom: 5),
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _reasonController,
                                          maxLength: 1000,
                                          validator: (val) =>
                                          val!.trim().isEmpty
                                              ? '  *Fill the Field to Submit'
                                              : null,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black26),
                                              contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 10.0),
                                              hintText: "Please Enter the reason  ",

                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              fillColor: Colorutils.chatcolor
                                                  .withOpacity(0.3),
                                              filled: true),
                                          maxLines: 5,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 0),
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              _pickFile();
                                            },
                                            icon: const Icon(Icons.attach_file_outlined, size: 15,color: Colorutils.userdetailcolor ,),
                                            label: const Text('Attach File', style: TextStyle(fontSize: 10,color:Colorutils.userdetailcolor ),),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(width: 1.0, color: Colorutils.chatcolor), // Customize the border color and width
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0), // Customize the border radius if needed
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 5.w,
                                        ),

                                        Row(
                                          children: [
                                            const SizedBox(height: 20),
                                            if (_fileName != null) ...[
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  '$_fileName',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _fileName = null;
                                                    _filePath = null;
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.close,
                                                ),
                                              ),

                                                                                       // Text('File Path: $_filePath'),
                                            ] else
                                              const Text('No File Selected'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 25.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap:() async {
                                            await submitLeave(context: context);

                                          },
                                          child: Container(
                                              height: 40.h,
                                              width: 80.w,
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Apply',
                                                  style:
                                                  TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              height: 40.h,
                                              width: 80.w,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Cancel',
                                                  style:
                                                  TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 250.h,
                              // ),
                            ],
                          )

                        ]),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> submitLeave({required BuildContext context}) async {
    context.loaderOverlay.show();
    String userId = Get.find<UserAuthController>().userData.value.userId ?? '';
    String accYr = Get.find<UserAuthController>().userData.value.academicYear ?? '';
    String schoolId = Get.find<UserAuthController>().userData.value.schoolId ?? '';
    ClassData studentData = Get.find<LeaveRequestController>().classData.value;
    String? docPath;
    if(_filePath != null) {
      var resp = await ApiServices.leaveFileUpload(
        userId: userId,
        filePath: _filePath!,
      );
      docPath = resp.toString();
    }
    if(fromDate != 'DD-MM-YYYY') {
      if(toDate != 'DD-MM-YYYY') {
        if(_formKey.currentState!.validate()) {
          bool connection = await CheckConnectivity().check();
          if(connection) {
            LeaveRequestModel leaveRequestData = LeaveRequestModel(
              classes: Classes(
                sessionId: studentData.sessionId ?? '',
                sessionName: studentData.sessionName ?? '',
                curriculumId: studentData.curriculumId ?? '',
                curriculumName: studentData.curriculumName ?? '',
                classId: studentData.classId ?? '',
                className: studentData.className ?? '',
                batchId: studentData.batchId ?? '',
                batchName: studentData.batchName ?? '',
              ),
              student: Student(
                id: widget.studentsData.studentId ?? '',
                name: widget.studentsData.name ?? '',
              ),
              reason: _reasonController.text,
              academicYear: accYr,
              startDate: fromDate,
              endDate: toDate,
              schoolId: schoolId,
              submittedBy: userId,
              submittedRoleId: "teacher",
              studentId: widget.studentsData.studentId ?? '',
              documentPath: docPath,
            );
            try {
              Map<String, dynamic> resp = await ApiServices.leaveReqSubmit(reqData: leaveRequestData);
              if(resp['status']['code'] == 200) {
                setState(() {
                  fromDate = 'DD-MM-YYYY';
                  toDate = 'DD-MM-YYYY';
                  _filePath = null;
                  _reasonController.clear();
                });
                if(resp['data']['message'] == "Leave Applied Successfully"){submitFailed(
                  // title: resp['status']['message'],
                  title: "Success",
                  message: resp['data']['message'],
                  actionName: "Close",
                  iconData: Icons.check_circle_outline_sharp,
                  iconColor: Colors.green,

                );} else {submitFailed(
                  // title: resp['status']['message'],
                  title: "Error",
                  message: resp['data']['message'],
                  actionName: "Close",
                  iconData: Icons.error_outline,
                  iconColor: Colors.red,

                );}

              } else {
                submitFailed(
                  title: "Failed",
                  message: "Failed to submit.",
                  actionName: "Close",
                  iconData: Icons.info_outline,
                  iconColor: Colors.red,
                );
              }
            } on SocketException {
              snackBar(context: context, message: "Internet connection is not stable", color: Colors.red);
            } catch(e) {
              submitFailed(
                title: "Failed",
                message: "Failed to submit.",
                actionName: "Close",
                iconData: Icons.info_outline,
                iconColor: Colors.red,
              );
            }
          } else {
            snackBar(context: context, message: "No internet connection", color: Colors.red);
          }
        }
      } else {
        snackBar(context: context, message: "Please select to date", color: Colors.red);
      }
    } else {
      snackBar(context: context, message: "Please select from date", color: Colors.red);
    }
    if(!mounted) return;
    context.loaderOverlay.hide();
  }

  static submitFailed({
    required String title,
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Column(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 50.w,
            ),
            SizedBox(height: 10.w),
            Text(
              title,
              style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionName,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
