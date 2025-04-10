import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherapp/View/MorePage/scan.dart';
import 'package:teacherapp/View/MorePage/search_page.dart';

import '../../Utils/Colors.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Container(
                height: 50.h,
                decoration: const BoxDecoration(
                    border: Border(),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                child: TextFormField(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));

                  },
                  readOnly: true,
                  onChanged: (value) {
                    // Get.find<LeaveApprovalController>().filterLeaveList(text: value);
                  },
                  validator: (val) => val!.isEmpty ? 'Enter the Topic' : null,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: "Student Nameee or Scan",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset(
                                "assets/images/MagnifyingGlass (1).svg")),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const QRViewExample()));
                            },
                            child: SizedBox(
                                height: 30,
                                width: 30,
                                child: SvgPicture.asset(
                                    "assets/images/Scanner 3.svg"))),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:Color.fromRGBO(230, 236, 254, 0.966),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      fillColor: Colorutils.Whitecolor,
                      filled: true),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Tracking",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5,top: 8,bottom: 8,right: 5),
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colorutils.chatcolor.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset("assets/images/profileOne.svg"),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text("Brinesh Elmore martin",
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Container(
                                  // width: 130.w,
                                  // height: 18.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.red.withOpacity(0.3),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 10.w),
                                      child: Text("Sent to Clinic ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.red,
                                              ))),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "10-December-2024",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Container(
                                    child: Text("Grade 2-B",
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: SizedBox(
                       width: double.infinity,
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomLinearProgressIndicator(
                                value: 0.8,
                                backgroundColor: Colors.white,
                                textColor: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                text:"formatTime(remainingTime)", gradient: const LinearGradient(
                                colors: [Colorutils.gradientColor1,Colorutils.gradientColor2],
                              ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => trackingDetails()));
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colorutils.userdetailcolor,
                                child: SvgPicture.asset("assets/images/arrow.svg")
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18,right: 18),
              child: SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent List',style: TextStyle(
                        fontSize: 18.w,fontWeight: FontWeight.bold
                    ),),
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder:  (context) => Viewall()));
                      },
                      child: Text('View All',style: TextStyle(
                          fontSize: 18.w,fontWeight: FontWeight.bold,color: Colorutils.userdetailcolor
                      ),),
                    ),


                  ],
                ),
              ),
            ),
            Expanded(child: ListView.builder(  itemCount: 10,  itemBuilder: (context, index) =>  const listcontainer()))
          ],
        ),
      ),
    );
  }
}



class CustomLinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Gradient gradient;
  final Color textColor;
  final BorderRadius borderRadius;
  final String text;

  const CustomLinearProgressIndicator({super.key, 
    required this.value,
    required this.backgroundColor,
    required this.gradient,
    required this.textColor,
    required this.borderRadius,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 25,
          decoration: BoxDecoration(
            
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(15),
                value: value,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class listcontainer extends StatelessWidget {
  const listcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
      child: Container(
        // height: 70.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colorutils.chatcolor.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset("assets/images/profileOne.svg"),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text("Brinesh Elmore martin",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      // width: 130.w,
                      // height: 18.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.red.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 10.w),
                          child: Text("Sent to Clinic",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.red,
                                  ))),
                        )),
                  ],
                ),
                const SizedBox(
                  width: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "10-December-2024",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                        child: Text("Grade 2-B",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
