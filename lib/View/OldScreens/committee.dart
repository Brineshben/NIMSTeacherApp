import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';

import '../../Controller/api_controllers/userAuthController.dart';
import '../../Utils/api_constants.dart';

class CommittedPage extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;

  CommittedPage(
      {super.key,
        this.admissionNumber,
        this.employeeCode,
        this.nameOfLoginTeacher,
        this.fees});

  @override
  State<CommittedPage> createState() => _CommittedPageState();
}

class _CommittedPageState extends State<CommittedPage> {
  var remarkController = TextEditingController();
  bool isPresses = false;

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime myDate = DateTime.now();
    DateTime myDateWithSixMonthsAdded = myDate.add(const Duration(days: 180));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: myDateWithSixMonthsAdded);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future SubmitRequest() async {
    UserAuthController userAuthController = Get.find<UserAuthController>();
    print(widget.nameOfLoginTeacher);
    var url = Uri.parse(ApiConstants.docMeUrl + ApiConstants.reportsApiEnd);
    var header = {
      "API-Key": "525-777-777",
      "Content-Type": "application/json",
    };
    final bdy = jsonEncode({
      "action": "addArrearFollowupData",
      "token": userAuthController.schoolToken.value,
      "admn_no": widget.admissionNumber,
      "employee_name": widget.nameOfLoginTeacher,
      "date": getCurrentDate().toString(),
      "feedback": remarkController.text,
      "commited_date": "${selectedDate.toLocal()}".split(' ')[0],
      "status": "1",
      "employee_code": widget.employeeCode,
      "employee_email": userAuthController.userData.value.username,
      "followup_fee_amount": widget.fees
    });
    print(bdy);
    var jsonresponse = await http.post(url, headers: header, body: bdy);
    print(jsonresponse.body);
    if (jsonresponse.statusCode == 200) {
      await snackBar(context: context, message: "Submitted Successfully", color: Colors.green);
      Navigator.of(context).pop();
      // Utils.showToastSuccess("Submitted Successfully").show(context).then((_) {
      //   NavigationUtils.goBack(context);
      // });
      // submitFailed();
      print("success");
    } else {
      await snackBar(context: context, message: "Submit Failed", color: Colors.red);
      Navigator.of(context).pop();
      // Utils.showToastError("Submit Failed").show(context).then((_) {
      //   NavigationUtils.goBack(context);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width(BuildContext context) => MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Committed Date",
                  style: TextStyle(color: Colors.black,fontSize: 16),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),

            child: _getCalendarView(context),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: width(context) * 0.035,
                      right: width(context) * 0.035),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1.0, 3.0), //(x,y)
                          blurRadius: 40),
                    ],
                  ),
                  child: _getRemark(),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: isPresses
                      ? const CircularProgressIndicator(
                    color: Color(0xFF6FDCFF),
                  )
                      :
                    SizedBox(
                      height: 50.w,
                      width: 200.w,
                      child: FloatingActionButton(

                        onPressed: () async {
                          if (remarkController.text.isEmpty) {
                            await snackBar(context: context, message: "Please Fill the Required Field", color: Colors.red);
                            // Utils.showToastError(
                            //     "Please Fill the Required Field")
                            //     .show(context);
                          } else {
                            setState(() {
                              isPresses = true;
                            });
                            await SubmitRequest();
                            Navigator.of(context).pop();
                          }
                        },
                        backgroundColor:Colorutils.userdetailcolor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(


                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child:Text(
                          'SUBMIT',
                          style: GoogleFonts.inter(
                              fontSize: 15,color: Colorutils.chatcolor

                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10.h,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  submitFailed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Warning'),
            content: const Text('Hi this is Flutter Alert Dialog'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ));
  }

  Widget _getRemark() => Container(
    padding: EdgeInsets.symmetric(
        horizontal: 20.w, vertical: 10.w),
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
            maxLength: 100,
            maxLines: null,
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

  Widget _getCalendarView(BuildContext context) => GestureDetector(
    onTap: () => _selectDate(context),
    child: Container(
      height: 60.w,

      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: const BoxDecoration(
          color: Colorutils.chatcolor,
          borderRadius: BorderRadius.all(
            Radius.circular(17),
          )),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: Colors.blue,
          ),
          SizedBox(
            width: 20.w,
          ),
          Text(
            "${selectedDate.toLocal().toString().split(' ')[0].toString().split('-').last}-${selectedDate.toLocal().toString().split(' ')[0].toString().split('-')[1]}-${selectedDate.toLocal().toString().split(' ')[0].toString().split('-').first}",
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );

}
