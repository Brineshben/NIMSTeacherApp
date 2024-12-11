// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../Utils/Colors.dart';
// import '../../Utils/font_util.dart';
//
// class Leaveapply extends StatefulWidget {
//   const Leaveapply({super.key});
//
//   @override
//   State<Leaveapply> createState() => _LeaveapplyState();
// }
//
// class _LeaveapplyState extends State<Leaveapply> {
//   get questionData => null;
//
//   get isChecked => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             backgroundColor: Colors.white,
//             body: SingleChildScrollView(
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.95,
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: 180.w,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(12.w),
//                               bottomRight: Radius.circular(12.w)),
//                           color: Colorutils.userdetailcolor,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 0,
//                       top: 40,
//                       child: SvgPicture.asset(
//                         'assets/images/pencil2.svg',
//                         width: 100.w,
//                         color: Colorutils.Whitecolor.withOpacity(0.1),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     Positioned(
//                       left: 240,
//                       top: 25,
//                       child: Transform.rotate(
//                         angle: 0.5,
//                         child: SvgPicture.asset(
//                           'assets/images/stars1.svg',
//                           width: 20.w,
//                           color: Colorutils.Whitecolor.withOpacity(0.5),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 220,
//                       top: 65,
//                       child: SvgPicture.asset(
//                         'assets/images/graduation-cap-icon.svg',
//                         width: 30.w,
//                         color: Colorutils.Whitecolor.withOpacity(0.07),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     Positioned(
//                       left: 140,
//                       top: 10,
//                       child: SvgPicture.asset(
//                         'assets/images/read-book-icon.svg',
//                         width: 30.w,
//                         color: Colorutils.Whitecolor.withOpacity(0.07),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     Positioned(
//                       left: 115,
//                       top: 65,
//                       child: SvgPicture.asset(
//                         'assets/images/stars1.svg',
//                         width: 20.w,
//                         color: Colorutils.Whitecolor.withOpacity(0.5),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     Positioned(
//                       left: 5,
//                       top: 10,
//                       child: SvgPicture.asset(
//                         'assets/images/stars1.svg',
//                         width: 20.w,
//                         color: Colorutils.Whitecolor.withOpacity(0.5),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     Positioned(
//                       right: 10,
//                       top: 140,
//                       child: SvgPicture.asset(
//                         'assets/images/stars1.svg',
//                         color: Colorutils.Whitecolor.withOpacity(0.9),
//                         width: 25.w,
//                         fit: BoxFit.fitHeight,
//                       ),
//                     ),
//                     Positioned(
//                       right: 0,
//                       top: -90,
//                       child: SvgPicture.asset(
//                         'assets/images/pencil3.svg',
//                         color: Colorutils.Whitecolor.withOpacity(0.2),
//                         height: 180.w,
//                         fit: BoxFit.fitHeight,
//                       ),
//                     ),
//                     Positioned(
//                       left: 0,
//                       top: 0,
//                       child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 7, right: 10, bottom: 3),
//                           child: Container(
//                             height: 80.w,
//                             width: 330,
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               borderRadius: BorderRadius.circular(17.0),
//                             ),
//                             child: Row(
//                               children: [
//                                 SizedBox(width: 12.w),
//                                 Container(
//                                   height: 45.w,
//                                   width: 45.w,
//                                   padding:
//                                   const EdgeInsets.symmetric(horizontal: 9)
//                                       .w,
//                                   child: Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Hello!',
//                                         style: TeacherAppFonts
//                                             .interW400_14sp_textWhiteOp60,
//                                       ),
//                                       SingleChildScrollView(
//                                         scrollDirection: Axis.horizontal,
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               'Fathima Nourin',
//                                               style: TeacherAppFonts
//                                                   .interW600_18sp_textWhite,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 Stack(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           right: 5, top: 5)
//                                           .w,
//                                       child: SvgPicture.asset(
//                                         'assets/images/bell 1.svg',
//                                         width: 30.w,
//                                         fit: BoxFit.fitWidth,
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 0,
//                                       right: 0,
//                                       child: Container(
//                                         width: 18.w,
//                                         height: 18.w,
//                                         padding: const EdgeInsets.all(2).w,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colorutils.Whitecolor,
//                                         ),
//                                         child: FittedBox(
//                                           child: Text(
//                                             "4",
//                                             style: TeacherAppFonts
//                                                 .interW500_11sp_userdetailcolor,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 CircleAvatar(
//                                   radius: 25.r,
//                                   backgroundColor: Colorutils.Whitecolor,
//                                   child: CircleAvatar(
//                                     radius: 24.r,
//                                     backgroundImage: AssetImage(
//                                         'assets/images/profile image.png'),
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),
//                               ],
//                             ),
//                           )),
//                     ),
//                     Container(
//                       margin:
//                       EdgeInsets.only(left: 10.w, top: 85.h, right: 10.w,bottom: 5),
//                       width: 500.w,
//                       height: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colorutils.Whitecolor,
//                         // Container color
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(20.r),
//                             topLeft: Radius.circular(20.r),bottomRight:Radius.circular(20.r),bottomLeft: Radius.circular(20.r) ),
//                         // Border radius
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colorutils.userdetailcolor.withOpacity(0.3),
//                             // Shadow color
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 3), // Shadow position
//                           ),
//                         ],
//                       ),
//                       child: ListView(
//                         //crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   height: 20.h,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 20),
//                                   child: Row(
//                                     children: [
//                                       Text('Leave Apply',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
//                                       SizedBox(
//                                         width: 120.w,
//                                       ),
//                                       // Row(
//                                       //   children: [
//                                       //     SizedBox(
//                                       //       width: 20.w,
//                                       //       height: 20.h,
//                                       //       child: Image.asset(
//                                       //           "assets/images/studentCalender.png"),
//                                       //     ),
//                                       // SizedBox(
//                                       //   width: 5.w,
//                                       // ),
//                                       // Text(
//                                       //   widget.selectedDate.toString(),
//                                       //   style: TextStyle(fontSize: 12.sp),
//                                       // ),
//                                       // SizedBox(
//                                       //   width: 5.w,
//                                       // ),
//                                       // widget.timeString == null ? Text(" ") : Text(
//                                       //     widget.timeString.toString().split("-")[0],
//                                       //     style: TextStyle(fontSize: 12.sp))
//                                       //   ],
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.fromLTRB(5,0,20,10),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         height: 20.h,
//                                       ),
//                                       Center(
//                                         child: Container(
//                                           width: 150.w,
//                                           height: 150.h,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             border: Border.all(color: Color(0xFFD6E4FA)),
//
//                                           ),
//                                           child:ClipRRect(
//                                             borderRadius: BorderRadius.circular(100),
//                                             child: CachedNetworkImage(
//                                               width: 50,
//                                               height: 50,
//                                               fit: BoxFit.fill,
//                                               imageUrl: "ksjk",
//                                               placeholder: (context, url) => Center(
//                                                 child: Text(
//                                                   'ben',
//                                                   style: TextStyle(
//                                                       color: Color(0xFFB1BFFF),
//                                                       fontWeight: FontWeight.bold,
//                                                       fontSize: 20),
//                                                 ),
//                                               ),
//                                               errorWidget: (context, url, error) =>   Center(
//                                                 child: Text(
//                                                   'bebbbbbb',
//                                                   style: TextStyle(
//                                                       color: Color(0xFFB1BFFF),
//                                                       fontWeight: FontWeight.bold,
//                                                       fontSize: 20),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20.h,
//                                       ),
//                                       Center(child: Text("jasj")),
//                                       SizedBox(
//                                         height: 10.h,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 5),
//                                         child: Text("admission numvber"
//                                         ),),
//                                       SizedBox(
//                                         height: 15.h,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 5),
//                                         child: Text("class"
//                                         ),),
//                                       SizedBox(
//                                         height: 5.h,
//                                       ),
//                                       Padding(
//                                         padding:  EdgeInsets.only(left: 5.w),
//                                         child: Row(
//                                           children: [
//                                             Text('From : 7-9-0',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600)),
//                                             IconButton( icon: Icon(Icons.calendar_month,color: Colors.blue[900],size: 20,),
//                                               onPressed: (){
//
//                                               },),
//                                             // SizedBox(
//                                             //   width: 5.w,
//                                             // ),
//                                             Text('To : 8-0-9',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600)),
//                                             IconButton( icon: Icon(Icons.calendar_month,color: Colors.blue[900],size: 20,),
//                                               onPressed: (){
//                                               },)
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10.h,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 5),
//                                         child: Text('Reason',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
//                                       ),
//                                       SizedBox(
//                                         height: 5.h,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 5),
//                                         child: TextFormField(
//                                           maxLength: 60,
//                                           validator: (val) =>
//                                           val!.isEmpty ? '  *Enter the Reason' : null,
//                                           cursorColor: Colors.grey,
//                                           keyboardType: TextInputType.text,
//                                           maxLines: 5,
//                                         ),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 5,right: 0),
//                                             child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(primary: Colors.grey,),
//                                               onPressed: () async{
//                                                 setState(() {
//                                                 });
//                                                 result = await FilePicker.platform.pickFiles(allowMultiple: true );
//                                                 if (result == null) {
//                                                   print("No file selected");
//                                                 } else {
//                                                   setState(() {
//                                                   });
//                                                   print("No file selected${result}");
//                                                   file = io.File(result.files.single.path);
//                                                   fileName = file.path.split('/').last;
//                                                   print('file.path${file.path}');
//                                                   print('file.fileNameh${fileName}');
//                                                   print(lookupMimeType('${file.path}'));
//                                                   if (file != null){
//                                                     await filesaver();
//                                                     // uploadFile();
//                                                     // fileimageupload();
//                                                   }
//                                                   // result?.files.forEach((element) {
//                                                   //   print('elementttname${element.name}');
//                                                   //   print('elementttname${element}');
//                                                   //   File file = File(element);
//                                                   //   print(file.path);
//                                                   // });
//                                                 }
//                                                 setState(() {
//                                                   _buttonloading = false;
//                                                 });
//                                               },
//                                               child:  Container(
//                                                 width: 90.w,
//                                                 child: Row(
//                                                   children: [
//                                                     Icon(Icons.attach_file_outlined,size: 20,),
//                                                     SizedBox(width: 2.w,),
//                                                     Text('Attach File',style: TextStyle(fontSize: 12),)
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10.w,
//                                           ),
//                                           (fileloading = true) ?Container(
//                                               width: 180.w,
//                                               child:  Text(fileName,style: TextStyle(fontSize: 12),)):
//                                           Container(
//                                               width: 180.w,
//                                               child:  Text('No File Selected',style: TextStyle(fontSize: 12),)),
//                                         ],
//                                       ),
//                                       SizedBox(height: 20.h,),
//                                       Row(
//                                         children: [
//                                           SizedBox(
//                                             width: 75.w,
//                                           ),
//                                           _buttonloading? Container(
//                                               height: 40.h,
//                                               width: 80.w,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.green,
//                                                 borderRadius: BorderRadius.all(Radius.circular(50)),
//                                               ),
//                                               child: Center(
//                                                 child: SizedBox(
//                                                   width: 20,
//                                                   height: 20,
//                                                   child: CircularProgressIndicator(color: Colors.red,),
//                                                 ),
//                                               )) :  GestureDetector(
//                                             onTap:(){
//                                               if(pickedFrom == null){
//                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select From Date'),backgroundColor: Colors.red,));
//                                               }else if(pickedTo == null){
//                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select To Date'),backgroundColor: Colors.red,));
//                                               }else
//                                               if(_leaveReasonController.text.isEmpty){
//                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter the reason'),backgroundColor: Colors.red,));
//                                               }else{
//                                                 if (result == null) {
//                                                   print("No file selected");
//                                                   submitleavestudents();
//                                                 }else if(result != null && filepathname == null){
//                                                   return;
//                                                 }else{
//                                                   submitleavestudents();
//                                                 }
//                                                 print('..............$fileloading');
//
//                                               }
//                                             },
//                                             child: Container(
//                                                 height: 40.h,
//                                                 width: 80.w,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.green,
//                                                   borderRadius: BorderRadius.all(Radius.circular(50)),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     'Apply',
//                                                     style:
//                                                     TextStyle(color: Colors.white, fontSize: 12),
//                                                   ),
//                                                 )),
//                                           ),
//                                           SizedBox(
//                                             width: 20.w,
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: Container(
//                                                 height: 40.h,
//                                                 width: 80.w,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.red,
//                                                   borderRadius: BorderRadius.all(Radius.circular(50)),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     'Cancel',
//                                                     style:
//                                                     TextStyle(color: Colors.white, fontSize: 12),
//                                                   ),
//                                                 )),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 // SizedBox(
//                                 //   height: 250.h,
//                                 // ),
//                               ],
//                             )
//
//                           ]),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
//
//   rubrics({required rubricslessonob}) {}
// }
