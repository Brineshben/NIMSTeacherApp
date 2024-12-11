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

class CallNotAnswered extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;

  CallNotAnswered(
      {super.key,
      this.employeeCode,
      this.nameOfLoginTeacher,
      this.admissionNumber,
      this.fees});

  @override
  State<CallNotAnswered> createState() => _CallNotAnsweredState();
}

class _CallNotAnsweredState extends State<CallNotAnswered> {
  var remarkController = TextEditingController();
  bool isPresses = false;

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  SubmitRequest() async {
    UserAuthController userAuthController = Get.find<UserAuthController>();
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
      "commited_date": getCurrentDate().toString(),
      "feedback": remarkController.text,
      "status": "4",
      "employee_code": widget.employeeCode,
      "followup_fee_amount": widget.fees
    });
    print(bdy);
    var jsonresponse = await http.post(url, headers: header, body: bdy);
    print(jsonresponse.body);
    if (jsonresponse.statusCode == 200) {
      await snackBar(
          context: context,
          message: "Submitted Successfully",
          color: Colors.green);
      Navigator.of(context).pop();
      // Utils.showToastSuccess("Submitted Successfully").show(context).then((_) {
      //   NavigationUtils.goBack(context);
      // });
      print("submit success");
    } else {
      await snackBar(
          context: context, message: "Submit Failed", color: Colors.red);
      Navigator.of(context).pop();
      // Utils.showToastError("Submit Failed").show(context).then((_) {
      //   NavigationUtils.goBack(context);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //shrinkWrap: true,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Calls Not Answered",
                  style: TextStyle(color: Colors.black,fontSize: 16),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
            child: _getRemark(),
          ),
          SizedBox(
            height: 30.h,
          ),
          Center(
            child: isPresses
                ? const CircularProgressIndicator(
                    color: Color(0xFFFFBF60),
                  )
                : SizedBox(
                    height: 50.w,
                    width: 200.w,
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (remarkController.text.isEmpty) {
                          snackBar(
                              context: context,
                              message: "Please Fill the Required Field",
                              color: Colors.red);
                          // Utils.showToastError("Please Fill the Required Field")
                          //     .show(context);
                        } else {
                          setState(() {
                            isPresses = true;
                          });
                         await SubmitRequest();
                          setState(() {
                            isPresses = false;
                          });
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
      ),
    );
  }

  Widget _getRemark() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colorutils.chatcolor),
            // boxShadow: [
            //   BoxShadow(color: ColorUtils.SHADOW_COLOR, blurRadius: 20)
            // ],
            borderRadius: BorderRadius.all(
              Radius.circular(14.r),
            )),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: remarkController,
                maxLines: null,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: "Remarks",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: false,
                ),
              ),
            ],
          ),
        ),
      );

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
}
