import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:badges/badges.dart' as badges;
import '../../Utils/Colors.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'CallStatus.dart';
import 'History_Page.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Myclasses extends StatefulWidget {
   Myclasses({super.key});

  @override
  State<Myclasses> createState() => _MyclassesState();
  bool? is_fees_paid;

}

class _MyclassesState extends State<Myclasses> {
  get isSpinner => null;
  bool status = false;
  final _controller = ValueNotifier<bool>(false);

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400.w,
          child: ListView(
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
                        widget.is_fees_paid == false
                            ? const Text("No Pending Fees")
                            : Row(
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
                      onTap: () {
                        Utils.call("9442364463");
                      },
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
                      onTap: () {
                        Utils.call("9442364463");
                      },
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

             const SizedBox(height: 50,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Callstatus()));},
                    child: Container(

                      width: 150.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color:  Colorutils.bottomnaviconcolor,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color:  Colorutils.bottomnaviconcolor,
                        //
                        //     // Shadow color
                        //     spreadRadius: 0.2,
                        //     blurRadius: 1,
                        //     offset: Offset(0, 1), // Shadow position
                        //   ),
                        // ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(

                              width: 30.w,
                              height: 30.h,
                              child: SvgPicture.asset(
                                "assets/images/icon.svg",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              "Call Status",
                              style: TextStyle(fontSize: 18.sp, color:  Colorutils.Whitecolor),
                            ),
                          ),
                        ],
                      ),
                      // child: ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //       backgroundColor: Colorutils.bottomnaviconcolor, elevation: 1),
                      //   onPressed: () {
                      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Callstatus()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         width: 40.w,
                      //         height: 40.h,
                      //         child: SvgPicture.asset(
                      //           "assets/images/icon.svg",
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 3.w,
                      //       ),
                      //       Text(
                      //         "Call Status",
                      //         style: TextStyle(fontSize: 15.sp, color:  Colorutils.Whitecolor),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  widget.is_fees_paid == false
                      ? const Text("")
                      :

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HistoryPage()));
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colorutils.bottomnaviconcolor,
                      radius: 25,

                      child:Icon(Icons.add,color: Colors.white,shadows: [
                        BoxShadow(blurRadius: 1,color: Colorutils.userdetailcolor)
                      ],)

                    ),
                  )

                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height ,
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
                    margin: EdgeInsets.only(
                      left: 10.w,
                      top: 120.h,
                      right: 10.w,
                    ),
                    height: ScreenUtil().screenHeight,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      // Container color
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r)),
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10,right: 20),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "10 A Biology",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: SvgPicture.asset(
                                            'assets/images/studentCalender.svg',color: Colorutils.userdetailcolor,)),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      const SizedBox(
                                        child: Text('30-08-1997'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: TextFormField(
                              onChanged: (value) {},
                              validator: (val) =>
                              val!.isEmpty ? 'Enter the Topic' : null,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  hintText: "Search Here",
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colorutils.userdetailcolor,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2.0),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colorutils.chatcolor,
                                        width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colorutils.chatcolor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  fillColor: Colorutils.chatcolor.withOpacity(0.15),
                                  filled: true),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 30),
                                child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 50.w),
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        margin: EdgeInsets.only(left: 15.w,top: 10),
                                        child: SwipeTo(
                                          rightSwipeWidget: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(30),
                                              decoration: BoxDecoration(
                                                color: Colorutils.userdetailcolor.withOpacity(0.5),
                                                // Container color
                                                borderRadius: BorderRadius.circular(15),
                                                // Border radius
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colorutils.chatcolor.withOpacity(0.1),

                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: const Offset(0, 2), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                size: 25,
                                                Icons.call,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          onRightSwipe: (detail) {
                                            _showBottomSheet(context);
                                          },
                                          child: Column(
                                            children: [
                                              Theme(
                                                data: ThemeData().copyWith(
                                                    dividerColor:
                                                    Colors.transparent),
                                                child: Row(
                                                  children: [
                                                    badges.Badge(
                                                      position:
                                                      badges.BadgePosition
                                                          .bottomEnd(
                                                          end: 0,
                                                          bottom: -5),
                                                      badgeContent: Text(
                                                        "${index + 1}",
                                                        style: const TextStyle(
                                                            color: Colorutils.userdetailcolor),
                                                      ),
                                                      badgeStyle:
                                                      const badges.BadgeStyle(

                                                        elevation: 0,
                                                        badgeColor: Colorutils.Whitecolor,
                                                        borderSide: BorderSide(
                                                          color: Colorutils.chatcolor, // Replace with your desired border color
                                                          width: 1.0, // Adjust the width of the border
                                                        ),
                                                      ),
                                                      child: Container(
                                                          width: 60.w,
                                                          height: 60.h,
                                                          decoration:
                                                          BoxDecoration(
                                                            border: Border.all(
                                                                color:  Colorutils.chatcolor),
                                                            shape:
                                                            BoxShape.circle,
                                                            // image: DecorationImage(
                                                            //     image: NetworkImage( afterAttendanceTaken != null
                                                            //         ? (afterAttendanceTaken[index]["feeDetails"]["image"] ==
                                                            //                 "avathar"
                                                            //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                            //             :_searchController.text.isNotEmpty
                                                            //         ? ApiConstants.IMAGE_BASE_URL + newResult[index]["feeDetails"]["image"].replaceAll('"', '') : ApiConstants
                                                            //                     .IMAGE_BASE_URL +
                                                            //                 afterAttendanceTaken[index]
                                                            //                         ["feeDetails"][
                                                            //                     "image"].replaceAll('"', ''))
                                                            //         : (ourStudentList[index]["image"].replaceAll('"', '') ==
                                                            //                 null
                                                            //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                            //             : _searchController.text.isNotEmpty
                                                            //         ? ApiConstants.IMAGE_BASE_URL + newResult[index]["image"].replaceAll('"', '') : ApiConstants
                                                            //                     .IMAGE_BASE_URL +
                                                            //                 ourStudentList[index]
                                                            //                     ["image"].replaceAll('"', ''))),
                                                            //     fit: BoxFit.fill),
                                                          ),
                                                          child: ClipRRect(

                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                100),
                                                            child:
                                                            CachedNetworkImage(
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.fill,
                                                              imageUrl: "A",
                                                              errorWidget:
                                                                  (context, url,
                                                                  error) =>
                                                                  const Center(
                                                                    child: Text(
                                                                      'A'
                                                                      // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                      ,
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFFB1BFFF),
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                          20),
                                                                    ),
                                                                  ),
                                                            ),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                            width: 200.w,
                                                            child:
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.horizontal,
                                                              child: Text(
                                                                  "Mohhamad Noufal Azad wefgergt derwf",
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                          FontWeight.bold))),
                                                            )),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: const Text(
                                                                "AED : ",
                                                                style: TextStyle(
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: const Text(
                                                                "900.00",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: AdvancedSwitch(
                                                            width: 80.w,
                                                            height: 40.h,
                                                            initialValue: status,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                status = val;
                                                              });
                                                            },
                                                            controller: _controller,
                                                            thumb: ValueListenableBuilder(
                                                              valueListenable: _controller,
                                                              builder: (_, value, __) {
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: const Color(0xFFD6E4FA),
                                                                      width: 2,
                                                                    ),
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.white,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            activeChild: Text(
                                                                "  P",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                            inactiveChild: Text(
                                                                "A  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                            activeColor: Colorutils.userdetailcolor,
                                                            inactiveColor: Colors.red.withOpacity(0.8),
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            // thumb: Container(
                                                            //   decoration: BoxDecoration(
                                                            //     border: Border.all(
                                                            //         color: const Color(0xFFD6E4FA),
                                                            //         width: 2,
                                                            //     ),
                                                            //     shape: BoxShape.circle,
                                                            //     color: Colors.white,
                                                            //   ),
                                                            // ),
                                                          ),
                                                          // child: FlutterSwitch(
                                                          //     width: 80.w,
                                                          //     height: 40.h,
                                                          //     valueFontSize: 16.sp,
                                                          //     toggleSize: 35.h,
                                                          //     toggleBorder:
                                                          //     Border.all(
                                                          //         color: Color(
                                                          //             0xFFD6E4FA),
                                                          //         width: 2),
                                                          //     activeText: " P",
                                                          //     inactiveText: "A ",
                                                          //     value: status,
                                                          //     borderRadius: 30.0,
                                                          //     padding: 0,
                                                          //     activeColor: Colorutils.userdetailcolor.withOpacity(0.7),
                                                          //     inactiveColor:
                                                          //     Colors.red.withOpacity(0.8),
                                                          //     inactiveTextColor:
                                                          //     Colors.white,
                                                          //     activeTextColor:
                                                          //     Colors.white,
                                                          //     showOnOff: true,
                                                          //     onToggle: (val) {
                                                          //       setState(() {
                                                          //         status = val;
                                                          //       });
                                                          //     }),
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        GestureDetector(
                                                            onTap: () async {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext
                                                                  context) =>
                                                                      AlertDialog(
                                                                          backgroundColor:
                                                                          Colors.blue[
                                                                          50],
                                                                          title:
                                                                          Container(
                                                                            decoration:
                                                                            const BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(50)),
                                                                            ),
                                                                            child:
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      width: 80,
                                                                                    ),
                                                                                    Text(
                                                                                      'Remarks',
                                                                                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 45,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 35,
                                                                                        width: 35,
                                                                                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(100)), border: Border.all(color: Colors.black)),
                                                                                        child: const Icon(
                                                                                          Icons.close_rounded,
                                                                                          size: 25,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height:
                                                                                  10.h,
                                                                                ),
                                                                                Text(
                                                                                  "gjzgs",
                                                                                  style:
                                                                                  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500,color: Colors.red),
                                                                                ),
                                                                                SizedBox(
                                                                                  height:
                                                                                  10.h,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )));
                                                            },
                                                            child: Container(
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .remove_red_eye_outlined,
                                                                      size: 18,
                                                                    ),
                                                                    const SizedBox(width: 5,),
                                                                    Text(
                                                                      'Late',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                          color:
                                                                          Colors.black,
                                                                          fontSize:
                                                                          15.sp),
                                                                    ),
                                                                  ],
                                                                ))
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: EdgeInsets.only(
                                              //       left: 10.w,
                                              //       top: 15.h,
                                              //       bottom: 8.h),
                                              //   child: Row(
                                              //     children: [
                                              //       SizedBox(
                                              //         width: 2870.w,
                                              //       ),
                                              //       GestureDetector(
                                              //           onTap: () async {
                                              //             showDialog(
                                              //                 context: context,
                                              //                 builder: (BuildContext
                                              //                         context) =>
                                              //                     AlertDialog(
                                              //                         backgroundColor:
                                              //                             Colors.blue[
                                              //                                 50],
                                              //                         title:
                                              //                             Container(
                                              //                           decoration:
                                              //                               BoxDecoration(
                                              //                             borderRadius:
                                              //                                 BorderRadius.all(Radius.circular(50)),
                                              //                           ),
                                              //                           child:
                                              //                               Column(
                                              //                             crossAxisAlignment:
                                              //                                 CrossAxisAlignment.start,
                                              //                             children: [
                                              //                               Row(
                                              //                                 children: [
                                              //                                   SizedBox(
                                              //                                     width: 80,
                                              //                                   ),
                                              //                                   Text(
                                              //                                     'Remarks',
                                              //                                     style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
                                              //                                   ),
                                              //                                   SizedBox(
                                              //                                     width: 45,
                                              //                                   ),
                                              //                                   GestureDetector(
                                              //                                     onTap: () {
                                              //                                       Navigator.pop(context);
                                              //                                     },
                                              //                                     child: Container(
                                              //                                       height: 35,
                                              //                                       width: 35,
                                              //                                       decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), border: Border.all(color: Colors.black)),
                                              //                                       child: Icon(
                                              //                                         Icons.close_rounded,
                                              //                                         size: 25,
                                              //                                       ),
                                              //                                     ),
                                              //                                   ),
                                              //                                 ],
                                              //                               ),
                                              //                               SizedBox(
                                              //                                 height:
                                              //                                     10.h,
                                              //                               ),
                                              //                               Text(
                                              //                                 "gjzgs",
                                              //                                 style:
                                              //                                     TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500,color: Colors.red),
                                              //                               ),
                                              //                               SizedBox(
                                              //                                 height:
                                              //                                     10.h,
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         )));
                                              //           },
                                              //           child: Container(
                                              //               child: Row(
                                              //             children: [
                                              //               Icon(
                                              //                 Icons
                                              //                     .remove_red_eye_outlined,
                                              //                 size: 18,
                                              //               ),
                                              //               Text(
                                              //                 'Late',
                                              //                 style: TextStyle(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w900,
                                              //                     color:
                                              //                         Colors.red,
                                              //                     fontSize:
                                              //                         15.sp),
                                              //               ),
                                              //             ],
                                              //           ))
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                thickness: 0.2,
                                                color: Colorutils.chatcolor,
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              )
                          ),


                        ])),
              ],
            ),
          ),
        ),
        floatingActionButton:Positioned(

            bottom: 0,
            right: 200,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.w,
              width: 200.w,
              child: FloatingActionButton(

                onPressed: () {

                },
                backgroundColor:Colorutils.bottomnaviconcolor,
                elevation: 10,
                shape: RoundedRectangleBorder(


                  borderRadius: BorderRadius.circular(20.0),
                ),
                child:Text(
                  'SUBMIT',
                  style: GoogleFonts.inter(
                      fontSize: 15,color: Colorutils.Whitecolor

                  ),
                ),
              ),
            ),
          ],
        ),

        ),
      ),
    );
  }
}
class Utils {
  static void call(String number) {
    UrlLauncher.launch('tel:+$number');
  }
}

