// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
// import 'package:teacherapp/View/CWidgets/TeacherAppPopUps.dart';
// import 'package:teacherapp/View/Menu/drawer.dart';
// import '../../Utils/Colors.dart';
// import '../CWidgets/AppBarBackground.dart';
// import '../CWidgets/commons.dart';
//
// class HosListing extends StatefulWidget {
//   const HosListing({super.key});
//
//   @override
//   State<HosListing> createState() => _HosListingState();
// }
//
// class _HosListingState extends State<HosListing> {
//   // String? _hosNameSelected;
//   final ValueNotifier<String?> _hosNameSelected = ValueNotifier(null);
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     initialize();
//     super.initState();
//   }
//
//   Future<void> initialize() async {
//     context.loaderOverlay.show();
//     await Get.find<UserAuthController>().fetchHosList();
//     if (!mounted) return;
//     context.loaderOverlay.hide();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SizedBox(
//         height: ScreenUtil().screenHeight,
//         width: ScreenUtil().screenWidth,
//         child: SingleChildScrollView(
//           child: Stack(
//             children: [
//               const AppBarBackground(),
//               Container(
//                 margin: EdgeInsets.only(
//                     left: 20.w, top: 100.h, right: 20.w, bottom: 10.h),
//                 // width: 550.w,
//                 // height: ScreenUtil().screenHeight * 0.8,
//                 decoration: themeCardDecoration,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 200.h,
//                       ),
//                       const Center(
//                           child: Text(
//                         'SELECT HOS',
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.w500),
//                       )),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(left: 15.w, right: 20.w, top: 20.h),
//                         child: GetX<UserAuthController>(
//                           builder: (UserAuthController controller) {
//                             return DropdownButtonFormField(
//                               decoration: InputDecoration(
//                                   hintStyle: TextStyle(
//                                       color: Colors.black.withOpacity(0.3)),
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 15.0, horizontal: 20.0),
//                                   hintText: " Select a HOS ",
//                                   counterText: "",
//                                   border: const OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(10.0),
//                                     ),
//                                   ),
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Color.fromRGBO(230, 236, 254, 8),
//                                       width: 1.0,
//                                     ),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10.0)),
//                                   ),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Color.fromRGBO(230, 236, 254, 8),
//                                       width: 1.0,
//                                     ),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10.0)),
//                                   ),
//                                   fillColor: const Color.fromRGBO(230, 236, 254, 8),
//                                   filled: true),
//                               padding:
//                                   const EdgeInsets.only(left: 10, right: 5).w,
//                               hint: const Text(" Select a HOS "),
//                               validator: (dynamic value) =>
//                                   value == null ? 'Field Required' : null,
//                               items: controller.hosList
//                                   .map<DropdownMenuItem<dynamic>>((item) {
//                                 return DropdownMenuItem<dynamic>(
//                                   value:
//                                       '${item.hosName}-${item.userId.toString()}',
//                                   // Row(
//                                   //   children: [
//                                   //     Icon(
//                                   //       Icons.circle,
//                                   //       size: 8,
//                                   //       color: Colorutils.userdetailcolor,
//                                   //     ),
//                                   //     SizedBox(
//                                   //       width: 10,
//                                   //     ),
//                                   //     Container(
//                                   //       width: 270.w,
//                                   //       child: SingleChildScrollView(
//                                   //         scrollDirection: Axis.horizontal,
//                                   //         child: Center(
//                                   //           child: Text("${HosList.name?.toUpperCase()}",
//                                   //               style: GoogleFonts.inter(
//                                   //                   textStyle: TextStyle(
//                                   //                       fontSize: 16.sp,
//                                   //                       color: Colors.black,
//                                   //                       fontWeight: FontWeight.w600))),
//                                   //         ),
//                                   //       ),
//                                   //     ),
//                                   //   ],
//                                   // ),
//                                   child: Text(
//                                     item.hosName?.toUpperCase() ?? '--',
//                                     style: const TextStyle(fontSize: 14),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                   ),
//                                 );
//                               }).toList(),
//                               value: _hosNameSelected.value,
//                               isExpanded: true,
//                               onChanged: (dynamic newVal) {
//                                 _hosNameSelected.value = newVal;
//                                 controller.setSelectedHosData(
//                                     hosName: _hosNameSelected.value ?? '--',
//                                   isHos: false,
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: 80.h,
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(left: 75.w, right: 75.w, top: 20.h),
//                         child: GestureDetector(
//                           onTap: () async {
//                             // await getUserLoginCredentials();
//                             if (_formKey.currentState!.validate()) {
//                               print('validation success');
//                               // if (_formKey.currentState!.validate()) {
//                               //   print('validation success');
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => const DrawerScreen()));
//                               // } else {
//                               //   print('validation failed');
//                               // }
//                             } else {
//                               print('validation failed');
//                             }
//                           },
//                           child: Container(
//                               height: 60.h,
//                               width: 220.w,
//                               decoration: const BoxDecoration(
//                                 color: Colorutils.userdetailcolor,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Continue',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 16.h),
//                                 ),
//                               )),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 240.h,
//                       ),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Padding(
//                           padding:
//                               const EdgeInsets.only(bottom: 15, right: 15).w,
//                           child: FloatingActionButton(
//                             backgroundColor: Colors.white,
//                             elevation: 0,
//                             child: Center(
//                               child: SvgPicture.asset(
//                                 "assets/images/logout.svg",
//                                 width: 30.h,
//                                 height: 30.h,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             onPressed: () {
//                               TeacherAppPopUps.logOutPopUp(context: context);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
