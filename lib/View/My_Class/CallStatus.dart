
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Utils/Colors.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class Callstatus extends StatefulWidget {
  const Callstatus({super.key});

  @override
  State<Callstatus> createState() => _CallstatusState();
}

class _CallstatusState extends State<Callstatus> {
  get questionData => null;

  get isChecked => null;

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(

      value: systemUiOverlayStyleLight,
      child: Scaffold(
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
                    margin: EdgeInsets.only(left: 20.w, top: 120.h, right: 20.w),
                    // width: 550.w,
                    // height: 600.h,
                    // height: ScreenUtil().screenHeight * 0.8,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r), ),
                      // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colorutils.userdetailcolor.withOpacity(0.3),
                          // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
        padding: const EdgeInsets.only(left: 20,top: 20),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,



              ),
              child: Image.asset("assets/images/profile image.png"),
            ),
            SizedBox(
              width: 15.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 200.w,
                    child: Text("Mohhaad Noufal Azad",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)))),
                SizedBox(
                  height: 6.h,
                ),
                // widget.is_fees_paid == false
                //     ? Text("No Pending Fees")
                     Row(
                  children: [
                    SizedBox(
                      child: Text(
                        "AED : ",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        "900",
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      const Divider(
        indent: 20,
        endIndent: 20,

        thickness: 0.3
        ,
      ),
      SizedBox(
        height: 20.h,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: SvgPicture.asset(
                    "assets/images/profileOne.svg",
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 150.w,
                        child: Text("Nelsoomnz",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(
                      height: 6.h,
                    ),
                    SizedBox(
                      child: Text(
                        "9442364463",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: SvgPicture.asset(
                    "assets/images/callButtonTwo.svg",

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: SvgPicture.asset(
                    "assets/images/profileOne.svg",
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 150.w,
                        child: Text("Achuuuzz",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(
                      height: 6.h,
                    ),
                    SizedBox(
                      child: Text(
                        "9442273563",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: SvgPicture.asset(
                    "assets/images/callButtonTwo.svg",

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20,),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context)
              .size
              .width,
          //margin: EdgeInsets.only(left: 20.w, right: 20.w),
          decoration: BoxDecoration(
              color: const Color(0xFFECF1FF),
              border: Border.all(
                  color: const Color(
                      0xFFCAD3FF)),
              borderRadius:
              BorderRadius.all(
                  Radius.circular(
                      10.r))),
          child: Padding(
            padding:
            const EdgeInsets.all(
                10.0),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .start,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                const Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(
                      "Remarks",
                      style: TextStyle(
                          color: Colors
                              .blueGrey),
                    ),
                    Text(
                      "7-09-8782",
                      style: TextStyle(
                          color: Colors
                              .blueGrey),
                    ),
                  ],
                ),
                Container(
                  margin:
                  const EdgeInsets.all(4),
                  child: const Text('dbnhsdhsh'),
                ),
                Container(
                  margin:
                  const EdgeInsets
                      .all(20),
                  child: const Text("bnnhcjhd"),
                ),
                Container(
                  margin:
                  const EdgeInsets
                      .all(20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(
                            0xFFA2ACDE),
                      ),
                      SizedBox(
                          width: 200.w,
                          child: const Text("sjhsjhh",
                            style: TextStyle(
                                color: Color(
                                    0xFFA2ACDE),
                                overflow:
                                TextOverflow.fade),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      SizedBox(
        height: 130.h,
      )
        ],
      ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  rubrics({required rubricslessonob}) {}
}
