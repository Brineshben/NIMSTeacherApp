import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Utils/Colors.dart';

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



  @override
  Widget build(BuildContext context) {
    double width(BuildContext context) => MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w,top: 10),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Committed Date",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 22.w, right: 22.w),
            child: _getCalendarView(context),
          ),
          const SizedBox(height: 10,),
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
                  child:  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal:20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color:Colorutils.chatcolor),
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
                  )
                ),
                SizedBox(
                  height: 60.h,
                ),
                Center(
                  child: isPresses
                      ? const CircularProgressIndicator(
                    color: Color(0xFF6FDCFF),
                  )
                      : GestureDetector(
                    onTap: () async {},
                    child:  SizedBox(
                      height: 50.w,
                      width: 200.w,
                      child: FloatingActionButton(

                        onPressed: () {

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
                )
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

                  })
            ],
          ),
        ));
  }



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
            color:Colorutils.Whitecolor,
          ),
          SizedBox(
            width: 20.w,
          ),
          Text(
            "${selectedDate.toLocal().toString().split(' ')[0].toString().split('-').last}-${selectedDate.toLocal().toString().split(' ')[0].toString().split('-')[1]}-${selectedDate.toLocal().toString().split(' ')[0].toString().split('-').first}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          )
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
