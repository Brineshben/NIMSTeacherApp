import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacherapp/View/CWidgets/AppBarBackground.dart';
import '../../Controller/api_controllers/lessonLearningController.dart';
import '../../Models/api_models/learning_observation_api_model.dart';
import '../../Utils/Colors.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'LessonObs_apply.dart';

class LessonObservation extends StatefulWidget {
  const LessonObservation({
    super.key,
  });

  @override
  State<LessonObservation> createState() => _LessonObservationState();
}

class _LessonObservationState extends State<LessonObservation> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedValue;
  String? selectedValue1;
  String? selectedValue2;

  @override
  void initState() {
    super.initState();
    Get.find<LessonLearningController>().selectedDateController.value.clear();
    Get.find<LessonLearningController>().selectedDate.value = null;
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: ScreenUtil().screenHeight,
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
                      child: const UserDetails(
                        shoBackgroundColor: false,
                        isWelcome: false,
                        bellicon: true,
                        notificationcount: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20.w, top: 120.h, right: 20.w, bottom: 10.h),
                    // width: 550.w,
                    // height: 600.h,
                    // height: ScreenUtil().screenHeight * 0.8,
                    decoration: themeCardDecoration,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 25.w, top: 30.h),
                                child: Text(
                                  "Lesson Observation",
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              GetX<LessonLearningController>(
                                builder: (LessonLearningController controller) {
                                  List<TeacherData> teacherList =
                                      controller.teacherNameList.value;
                                  List<TeacherDetails?> teacherDetails =
                                      controller.teacherClassList.value;
                                  List<SubjectDetail> subList =
                                      controller.teacherSubjectList.value;
                                  if (teacherList.isEmpty) {
                                    return Image.asset(
                                      "assets/images/nodata.gif",
                                    );
                                  } else {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.w,
                                              right: 25.w,
                                              top: 20.h),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField2<String>(
                                              validator: (value) {
                                                if(value==null){
                                                  return '          Please Select Teacher';
                                                }
                                                return null;
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(right: 2,left: -15),
                                                
                                         enabledBorder:  const OutlineInputBorder(
                                           borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          230, 236, 254, 8),
                                                      width: 1.0),
                                                ),
                                             filled: true,
                                           
                                             fillColor: Color.fromRGBO(
                                                  230, 236, 254, 8),
                                                  border: OutlineInputBorder(
                                                 
                                                    borderRadius: const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ).r,
                                                  )
                                              ),
                                              isExpanded: true,
                                              hint: Text(
                                                'Teacher',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              
                                              items:
                                                  teacherList.map((teacher) {
                                                return DropdownMenuItem<
                                                    String>(
                                                  value: teacher.teacherName,
                                                  child: Text(
                                                    teacher.teacherName
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedValue,
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                // height: 40,
                                                // width: 200,
                                              ),
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                maxHeight: 600,
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                              ),
                                              
                                              dropdownSearchData:
                                                  DropdownSearchData(
                                                  
                                                searchController:
                                                    textEditingController,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                        textEditingController,
                                                    decoration:
                                                        InputDecoration(
                                                        
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                      hintText:
                                                          'Search Teacher',
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(
                                                       
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn:
                                                    (item, searchValue) {
                                                  return item.value
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(searchValue
                                                          .toLowerCase());
                                                },
                                              ),
                                              onMenuStateChange: (isOpen) {
                                                if (!isOpen) {
                                                  textEditingController
                                                      .clear();
                                                }
                                              },
                                              onChanged: (String? teacher) {
                                                setState(() {
                                                  selectedValue = teacher;
                                                  selectedValue1 = null;
                                                  selectedValue2 = null;
                                                });
                                                controller
                                                    .getTeacherClassData(
                                                        teacherName:
                                                            teacher!);
                                              },
                                            ),
                                          ),
                                        ),
                                        
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.w,
                                              right: 25.w,
                                              top: 20.h),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField2<String>(
                                              
                                              isExpanded: true,
                                               validator: (value) {
                                              if(value==null){
                                                return '           Please Select Class';
                                              }
                                              return null;
                                            },
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            decoration: InputDecoration(
                                             contentPadding: const EdgeInsets.only(right: 2,left: -15),
                                            
                                                                             enabledBorder:  const OutlineInputBorder(
                                                                                     borderRadius: BorderRadius.all(Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 236, 254, 8),
                                                    width: 1.0),
                                              ),
                                           filled: true,
                                                                       
                                           fillColor: Color.fromRGBO(
                                                230, 236, 254, 8),
                                                border: OutlineInputBorder(
                                               
                                                  borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ).r,
                                                )
                                            ),
                                          
                                              hint: Text(
                                                'Class',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 15,
                                                ),
                                              ),
                                              items: teacherDetails
                                                  .map((batchData) {
                                                String uniqueValue =
                                                    "${batchData?.className} ${batchData?.batchName}";
                                                return DropdownMenuItem<
                                                    String>(
                                                  value: uniqueValue,
                                                  child: Text(
                                                    "${batchData?.className} ${batchData?.batchName}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedValue1,
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                // height: 40,
                                                // width: 200,
                                              ),
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                maxHeight: 600,
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                              ),
                                              dropdownSearchData:
                                                  DropdownSearchData(
                                                searchController:
                                                    textEditingController1,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                        textEditingController1,
                                                    decoration:
                                                        InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                      hintText:
                                                          'Search Class',
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn:
                                                    (item, searchValue) {
                                                  return item.value
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(searchValue
                                                          .toLowerCase());
                                                },
                                              ),
                                              onMenuStateChange: (isOpen) {
                                                if (!isOpen) {
                                                  textEditingController1
                                                      .clear();
                                                }
                                              },
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedValue1 = newValue;
                                                  selectedValue2 = null;
                                                });
                                                controller
                                                    .getTeacherSubjectData(
                                                        classAndBatch:
                                                            selectedValue1
                                                                .toString());
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.w,
                                              right: 25.w,
                                              top: 20.h),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField2<String>(
                                               validator: (value) {
                                            if(value==null){
                                              return '          Please Select Subject';
                                            }
                                            return null;
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(right: 2,left: -15),
                                          
                                                                           enabledBorder:  const OutlineInputBorder(
                                                                                   borderRadius: BorderRadius.all(Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      230, 236, 254, 8),
                                                  width: 1.0),
                                            ),
                                                                                     filled: true,
                                                                                   
                                                                                     fillColor: Color.fromRGBO(
                                              230, 236, 254, 8),
                                              border: OutlineInputBorder(
                                             
                                                borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ).r,
                                              )
                                          ),
                                          
                                              isExpanded: true,
                                              hint: Text(
                                                'Subject',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 15,
                                                ),
                                              ),
                                              items: subList.map((subject) {
                                                return DropdownMenuItem<
                                                    String>(
                                                  value: subject.subjectName,
                                                  child: Text(
                                                    subject.subjectName
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedValue2,
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                // height: 40,
                                                // width: 200,
                                              ),
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                maxHeight: 600,
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                              ),
                                              dropdownSearchData:
                                                  DropdownSearchData(
                                                searchController:
                                                    textEditingController2,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                        textEditingController2,
                                                    decoration:
                                                        InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                      hintText:
                                                          'Search Subject',
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn:
                                                    (item, searchValue) {
                                                  return item.value
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(searchValue
                                                          .toLowerCase());
                                                },
                                              ),
                                              onMenuStateChange: (isOpen) {
                                                if (!isOpen) {
                                                  textEditingController2
                                                      .clear();
                                                }
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue2 = value;
                                                });
                                                controller
                                                    .setTeacherSubjectData(
                                                        subName:
                                                            selectedValue2
                                                                .toString());
                                              },
                                            ),
                                          ),
                                        ),

                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //       left: 15.w,
                                        //       right: 20.w,
                                        //       top: 20.h),
                                        //   child: DropdownButtonFormField(
                                        //     decoration: InputDecoration(
                                        //         hintStyle: TextStyle(
                                        //             color: Colors.black
                                        //                 .withOpacity(0.5)),
                                        //         contentPadding:
                                        //             EdgeInsets.symmetric(
                                        //                 vertical: 18.h,
                                        //                 horizontal: 20.w),
                                        //         hintText: "Subject",
                                        //         border: OutlineInputBorder(
                                        //           borderRadius:
                                        //               const BorderRadius.all(
                                        //             Radius.circular(10.0),
                                        //           ).r,
                                        //         ),
                                        //         enabledBorder:
                                        //             OutlineInputBorder(
                                        //           borderSide: const BorderSide(
                                        //             color: Color.fromRGBO(
                                        //                 230, 236, 254, 8),
                                        //             width: 1.0,
                                        //           ),
                                        //           borderRadius:
                                        //               const BorderRadius.all(
                                        //                       Radius.circular(
                                        //                           10.0))
                                        //                   .r,
                                        //         ),
                                        //         focusedBorder:
                                        //             OutlineInputBorder(
                                        //           borderSide: const BorderSide(
                                        //             color: Color.fromRGBO(
                                        //                 230, 236, 254, 8),
                                        //             width: 1.0,
                                        //           ),
                                        //           borderRadius:
                                        //               const BorderRadius.all(
                                        //                       Radius.circular(
                                        //                           10.0))
                                        //                   .r,
                                        //         ),
                                        //         fillColor: const Color.fromRGBO(
                                        //             230, 236, 254, 8),
                                        //         filled: true),
                                        //     padding: EdgeInsets.only(
                                        //         left: 10.w, right: 5.w),
                                        //     hint: const Text('Subject'),
                                        //     validator: (dynamic value) =>
                                        //         value == null
                                        //             ? 'Please Select Subject'
                                        //             : null,
                                        //     items: subList
                                        //         .map((sub) =>
                                        //             DropdownMenuItem<String>(
                                        //               value: sub.subjectName,
                                        //               child: SizedBox(
                                        //                 width: 190.w,
                                        //                 child: Text(
                                        //                   sub.subjectName
                                        //                       .toString(),
                                        //                   overflow: TextOverflow
                                        //                       .ellipsis,
                                        //                 ),
                                        //               ),
                                        //             ))
                                        //         .toList(),
                                        //     value: selectedValue2,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         selectedValue2 = value;
                                        //       });
                                        //       controller.setTeacherSubjectData(
                                        //           subName: selectedValue2
                                        //               .toString());
                                        //     },
                                        //   ),
                                        // ),
                                        // Obx(() => Padding(
                                        //   padding: EdgeInsets.only(
                                        //       left: 25.w,
                                        //       right: 25.w,
                                        //       top: 20.h),
                                        //   child: TextFormField(
                                        //     controller: Get.find<LessonLearningController>().selectedDateController.value,
                                        //     onTap: () async => await Get.find<LessonLearningController>().selectDate(context),
                                        //     autovalidateMode: AutovalidateMode.onUserInteraction,
                                        //     readOnly: true,
                                        //     validator: (dynamic value) =>
                                        //     value.toString().trim().isEmpty
                                        //         ? 'Please Select Date'
                                        //         : null,
                                        //     decoration: InputDecoration(
                                        //         hintStyle: TextStyle(
                                        //           color: Colors.black
                                        //               .withOpacity(0.5),
                                        //         ),
                                        //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        //         hintText: "Date",
                                        //         border: OutlineInputBorder(
                                        //           borderRadius:
                                        //           const BorderRadius.all(
                                        //             Radius.circular(10.0),
                                        //           ).r,
                                        //         ),
                                        //         enabledBorder:
                                        //         const OutlineInputBorder(
                                        //           borderSide: BorderSide(
                                        //               color: Color.fromRGBO(
                                        //                   230, 236, 254, 8),
                                        //               width: 1.0),
                                        //         ),
                                        //         focusedBorder:
                                        //         OutlineInputBorder(
                                        //           borderSide: const BorderSide(
                                        //               color: Color.fromRGBO(
                                        //                   230, 236, 254, 8),
                                        //               width: 1.0),
                                        //           borderRadius:
                                        //           const BorderRadius.all(
                                        //               Radius.circular(
                                        //                   10.0))
                                        //               .r,
                                        //         ),
                                        //         fillColor: const Color.fromRGBO(
                                        //             230, 236, 254, 8),
                                        //         filled: true),
                                        //     cursorColor: Colors.grey,
                                        //     keyboardType: TextInputType.text,
                                        //     maxLines: 1,
                                        //   ),
                                        // ),
                                        // ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.w,
                                              right: 25.w,
                                              top: 20.h),
                                          child: TextFormField(
                                            controller: _controller,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (dynamic value) =>
                                                value.toString().trim().isEmpty
                                                    ? 'Please Enter the Topic'
                                                    : null,
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 18.h,
                                                        horizontal: 20.w),
                                                hintText: "Topic",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ).r,
                                                ),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          230, 236, 254, 8),
                                                      width: 1.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          230, 236, 254, 8),
                                                      width: 1.0),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))
                                                          .r,
                                                ),
                                                fillColor: const Color.fromRGBO(
                                                    230, 236, 254, 8),
                                                filled: true),
                                            cursorColor: Colors.grey,
                                            keyboardType: TextInputType.text,
                                            maxLength: 100,
                                            maxLines: 5,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 280, top: 2),
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 25.h),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                          if(selectedValue!=null&&selectedValue1!=null&&selectedValue2!=null){
                          Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LessonObservationApply(
                                                                teacherName:
                                                                    selectedValue!,
                                                                classAndBatch:
                                                                    selectedValue1!,
                                                                subjectName:
                                                                    selectedValue2!,
                                                                selectedDate: Get.find<LessonLearningController>().selectedDateController.value.text,
                                                                topic:
                                                                    _controller
                                                                        .text,
                                                              )));}}
                                              },
                                              child: Container(
                                                  height: 50.h,
                                                  width: 220.w,
                                                  decoration: BoxDecoration(
                                                    color: Colorutils
                                                        .userdetailcolor,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                                Radius.circular(
                                                                    15))
                                                            .r,
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 100.h),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
