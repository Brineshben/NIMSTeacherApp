import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Utils/Colors.dart';


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



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //shrinkWrap: true,
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
                  "Call Not Answered",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                )
              ],
            ),
          ),
          const SizedBox( height: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: _getRemark(),
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
    );
  }

  Widget _getRemark() => Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
        color:Colors.white,
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
