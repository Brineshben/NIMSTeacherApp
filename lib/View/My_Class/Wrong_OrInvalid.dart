

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Utils/Colors.dart';


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
  bool isChecked = false;
  bool isChecked1 = false;
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



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w,top: 10),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wrong or Invalid",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
              )
            ],
          ),
        ),
        SizedBox(
          height: 35.h,
        ),
        Padding(

          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Container(
            height: 60,
            color: Colorutils.chatcolor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text('Wrong'),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked1,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked1 = value!;
                          });
                        },
                      ),
                      const Text('Invalid'),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    );
  }



  Widget _text(String text) => Text(text,
      style:
      const TextStyle(color: Colors.blue, fontSize: 14));
}


