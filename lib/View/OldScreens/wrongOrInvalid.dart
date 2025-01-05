import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:teacherapp/Services/snackBar.dart';

import '../../Controller/api_controllers/userAuthController.dart';
import '../../Utils/Colors.dart';
import '../../Utils/api_constants.dart';
import 'checkBoxView.dart';

class WrongOrInvalid extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;

  WrongOrInvalid(
      {super.key,
      this.admissionNumber,
      this.nameOfLoginTeacher,
      this.employeeCode,
      this.fees});

  @override
  _WrongOrInvalidState createState() => _WrongOrInvalidState();
}

class _WrongOrInvalidState extends State<WrongOrInvalid> {
  int selectedIndex = -1;
  bool isPresses = false;

  String? _getText(int index) {
    if (index == 0) return "Wrong";
    if (index == 1) return "Invalid";
    return null;
  }

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

 Future SubmitRequest() async {
    UserAuthController userAuthController = Get.find<UserAuthController>();
    int? newValue;
    if (selectedIndex == 0) {
      newValue = 2;
    } else if (selectedIndex == 1) {
      newValue = 3;
    } else {
      newValue = null;
    }
    String remark;
    if (selectedIndex == 0) {
      remark = "Wrong";
    } else if (selectedIndex == 1) {
      remark = "Invalid";
    } else {
      return null;
    }
    var url = Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd);
    var header = {
      "API-Key": "525-777-777",
      "Content-Type": "application/json",
    };
    final bdy = jsonEncode({
      "action": "addArrearFollowupData",
      "token": userAuthController.schoolToken.value,
      "admn_no": widget.admissionNumber,
      "date": getCurrentDate().toString(),
      "employee_name": widget.nameOfLoginTeacher,
      "feedback": remark,
      "commited_date": getCurrentDate().toString(),
      "status": newValue.toString(),
      "employee_code": widget.employeeCode,
      "employee_email": userAuthController.userData.value.username,
      "followup_fee_amount": widget.fees
    });
    print(bdy);
    var jsonresponse = await http.post(url, headers: header, body: bdy);
    print(jsonresponse.statusCode);
    if (jsonresponse.statusCode == 200) {
      snackBar(
          context: context,
          message: "Submitted Successfully",
          color: Colors.green);
      // Utils.showToastSuccess("Submitted Successfully").show(context).then((_) {
      //   NavigationUtils.goBack(context);
      // });
      print("submit success");
    } else {
      snackBar(context: context, message: "Submit Failed", color: Colors.red);
      // Utils.showToastError("Submit Failed").show(context).then((_) {
      //   NavigationUtils.goBack(context);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(left: 20.w),
            child: const Text(
              "Wrong or Invalid",
              style: TextStyle(color: Colors.black, fontSize: 16),
            )),
        SizedBox(
          height: 25.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 20.w),
          height: 66.h,
          width: 326.w,
          decoration: const BoxDecoration(
              color: Colors.white,
              // boxShadow: [
              //   BoxShadow(color: ColorUtils.SHADOW_COLOR, blurRadius: 20)
              // ],
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              )),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Row(
                children: List.generate(
                    2,
                    (index) => Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedIndex == index) {
                                  selectedIndex = -1;
                                } else {
                                  selectedIndex = index;
                                }
                                print(selectedIndex);
                              });
                            },
                            child: Row(
                              children: [
                                CheckBoxView(
                                    size: 25,
                                    borderRadius: 10,
                                    isChecked: index == selectedIndex),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                    child: _text(_getText(index).toString()))
                              ],
                            ),
                          ),
                        ))),
          ),
        ),
        SizedBox(
          height: 120.h,
        ),
        Center(
          child: isPresses
              ? const CircularProgressIndicator(
                  color: Color(0xFFFF83E4),
                )
              : SizedBox(
                  height: 50.w,
                  width: 200.w,
                  child: FloatingActionButton(

                    onPressed: () async {
                      if (selectedIndex == -1) {
                        snackBar(
                            context: context,
                            message: "Please choose one option",
                            color: Colors.red);
                        // Utils.showToastError("Please choose one option")
                        //     .show(context);
                      } else {
                        setState(() {
                          isPresses = true;
                        });
                      await  SubmitRequest();
                        // Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                        setState(() {
                          isPresses = false;
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    },
                    backgroundColor: Colorutils.userdetailcolor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'SUBMIT',
                      style: GoogleFonts.inter(
                          fontSize: 15, color: Colorutils.chatcolor),
                    ),
                  ),
                ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  // _submitFailed(context) {
  //   return Alert(
  //     context: context,
  //     type: AlertType.success,
  //     title: "Submitted Successfully",
  //     style: AlertStyle(
  //         isCloseButton: false,
  //         titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
  //     buttons: [
  //       DialogButton(
  //         color: Colors.white,
  //         child: Text(
  //           "",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () async {
  //           Navigator.pop(context);
  //         },
  //         // print(widget.academicyear);
  //         //width: 120,
  //       )
  //     ],
  //   ).show();
  // }

  Widget _text(String text) => Text(text,
      style: TextStyle(color: Colorutils.userdetailcolor, fontSize: 14.sp));
}
