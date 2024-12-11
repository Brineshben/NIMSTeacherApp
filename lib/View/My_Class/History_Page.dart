
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Utils/Colors.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'CallNot_Answered.dart';
import 'Committed_Page.dart';
import 'Mis_behav.dart';
import 'Wrong_OrInvalid.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  get questionData => null;
  bool calender = true;
  bool call = false;
  bool invalid = false;
  bool misbe = false;
  get isChecked => null;
  int? selectedbutton;
  Widget _getMenuItem() {

    if (selectedbutton == 0) {
      return CommittedPage(
        admissionNumber: "ME677",
        employeeCode:"EMP1090",
        nameOfLoginTeacher: "Saptikaa",
        fees: "900",
      );
    } else if (selectedbutton == 1)
      return CallNotAnswered(
        admissionNumber: "ME677",
        employeeCode:"EMP1090",
        nameOfLoginTeacher: "Saptikaa",
        fees: "900",
      );
    else if (selectedbutton == 2)
      return WrongOrInvalid(
        admissionNumber: "ME677",
        employeeCode:"EMP1090",
        nameOfLoginTeacher: "Saptikaa",
        fees: "900",
      );
    else if (selectedbutton == 3)
      return misbehav(
        admissionNumber: "ME677",
        employeeCode:"EMP1090",
        nameOfLoginTeacher: "Saptikaa",
        fees: "900",
      );
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height ,
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
                    child: const UserDetails(shoBackgroundColor: false, isWelcome: false, bellicon: true, notificationcount: true,),
                  ),
                ),

                Container(
                    margin: EdgeInsets.only(top: 300.h,),
                    width: double.infinity,

                     height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(17.r),
                        topLeft: Radius.circular(17.r),

                      ),
                      // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colorutils.userdetailcolor.withOpacity(0.5),
                          // Shadow color
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1), // Shadow position
                        ),
                      ],
                    ),
                    child:Container(


                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60.h,
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                              
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(), backgroundColor: calender ? Colors.blueAccent : Colors.white,
                                    ),
                                    child: Container(
                                        width:  70.w,
                                        height: 70.h,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/vectorthree.png",
                                          ),
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        call = false;
                                        invalid = false;
                                        misbe = false;
                                        if (calender == false) {
                                          calender = true;
                                        }
                                        selectedbutton = 0;
                                      });
                                    },
                                  ),
                              
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(), backgroundColor: call ? Colors.blueAccent : Colors.white,
                                    ),
                                    child: Container(
                                        width:  70.w,
                                        height: 70.h,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/vectortwo.png",
                                          ),
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        calender = false;
                                        invalid = false;
                                        misbe = false;
                                        if (call == false) {
                                          call = true;
                                        }
                                        selectedbutton = 1;
                                      });
                                    },
                                  ),
                              
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(), backgroundColor: invalid ? Colors.blueAccent : Colors.white,
                                    ),
                                    child: Container(
                                        width:  70.w,
                                        height: 70.h,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/vectorfour.png",
                                          ),
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        call = false;
                                        calender = false;
                                        misbe = false;
                                        if (invalid == false) {
                                          invalid = true;
                                        }
                                        selectedbutton = 2;
                                      });
                                    },
                                  ),
                              
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(), backgroundColor: misbe ? Colors.blueAccent : Colors.white,
                                    ),
                                    child: Container(
                                        width:  70.w,
                                        height: 70.h,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/vectorone.png",
                                          ),
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        call = false;
                                        invalid = false;
                                        calender = false;
                                        if (misbe == false) {
                                          misbe = true;
                                        }
                                        selectedbutton = 3;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _getMenuItem(),
                          ],
                        ))
                ),
                Container(
                    margin: EdgeInsets.only(left: 10.w, top: 120.h, right: 10.w),
                    // width: 550.w,
                    // height: 230.h,
                    // height: ScreenUtil().screenHeight * 0.8,
                    // height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                      // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colorutils.userdetailcolor.withOpacity(0.1),
                          // Shadow color
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1), // Shadow position
                        ),
                      ],
                    ),
                    child:Container(


                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 14.h, left: 20.w),
                              child: Text(
                                "Call Status Update",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp,fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 5,),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(50.r)),
                                        side: BorderSide(
                                            width: 2.w, color: Colors.white)),
                                    margin: const EdgeInsets.only(top: 10,left: 8),
                                    child:
                                    Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFEEF1FF)),
                                      child: Image.asset(
                                          "assets/images/profile image.png"),
                                    )

                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 240.w,
                                        child: Text(
                                          "Brineshben",
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Text(
                                            "Pending Fees:",
                                            style:
                                            TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          const Text(
                                            "300",
                                            style: TextStyle(
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Text(
                                            "Class:",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          const Text(
                                            "3B",
                                            style:
                                            TextStyle(color: Color(0xFF587298)),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Text(
                                            "Parent Name:",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          SizedBox(
                                            width: 155.w,
                                            child: const Text(
                                              "huishcdas nhasdi",
                                              style: TextStyle(
                                                  color: Color(0xFF587298)),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Text(
                                            "Mobile No:",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          const Text(
                                            "98872635",
                                            style:
                                            TextStyle(color: Color(0xFF587298)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ))
                ),

              ],
            ),
          ),
        ));
  }

  rubrics({required rubricslessonob}) {}
}
