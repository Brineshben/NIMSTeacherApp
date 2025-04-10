import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../Controller/api_controllers/LearningwalkController.dart';
import '../../Models/api_models/ClassLW_Api_Model.dart';
import '../../Models/api_models/Teacher_Apimodel.dart';
import '../../Models/api_models/batch_Apimodel.dart';
import '../../Utils/Colors.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';
import 'LearningwalkNew2.dart';

class LearningWalknew1 extends StatefulWidget {
  const LearningWalknew1({super.key});

  @override
  State<LearningWalknew1> createState() => _LearningWalknew1State();
}

class _LearningWalknew1State extends State<LearningWalknew1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  String? _selectedValue1;
  String? _selectedValue2;
  bool _isClassValid = true;
  bool _isDivisionValid = true;
  // String? _selectedValue3;

  @override
  void initState() {
    Get.find<LearningWalkController>().fetchteacherclassdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      left: 15.w, top: 120.h, right: 15.w, bottom: 10.h),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: themeCardDecoration,
                  child: SingleChildScrollView(
                    child: GetX<LearningWalkController>(
                      builder: (LearningWalkController controller) {
                        List<Details> ClassList = controller.classDetails.value;
                        List<Detailsbatch> batchList =
                            controller.batchDetils.value;
                        List<DetailsTeacher> teacherDetails =
                            controller.teacherDetails.value;

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 25.w, top: 30.h),
                                child: Text(
                                  "Learning Walk",
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.w,
                                            right: 25.w,
                                            top: 20.h),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ).r,
                                              color: Color.fromRGBO(230, 236, 254, 0.966),),
                                          height: 55.w,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                'CLASS',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              items: ClassList.map((Class) =>
                                                  DropdownMenuItem<String>(
                                                    value: Class.name,
                                                    child: Text(
                                                      "CLASS :${Class.name ?? " "}",
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  )).toList(),
                                              value: _selectedValue1,
                                              onChanged: (classes) {
                                                setState(() {
                                                  _selectedValue2 = null;
                                                  batchList.clear();
                                                  _selectedValue1 =
                                                      classes ?? "";
                                                  controller
                                                      .fetchteacherbatchdata(
                                                          _selectedValue1!);
                                                  print(
                                                      "bweghrebghrghk$_selectedValue1");
                                                      _isClassValid = _selectedValue1 != null && _selectedValue1!.isNotEmpty;
                                  
                                                });
                                                // _selectedValue1=Class;
                                                // controller.fetchteacherdata();
                                                // print("bweghrebghrghk$_selectedValue1");
                                              },
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
                                                searchController: controller1,
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
                                                    controller: controller1,
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
                                                  controller1.clear();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                    
                                      if (!_isClassValid)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 25),
                                          child: Text(
                                            "Please Select the Class",
                                            style: TextStyle(color: Colors.red, fontSize: 10),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.w, right: 25.w, top: 20.h),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ).r,
                                              color: Color.fromRGBO(230, 236, 254, 0.966),),
                                          height: 55.w,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                'DIVISION',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              items: batchList.map((batch) =>
                                                  DropdownMenuItem<String>(
                                                    value: batch.name,
                                                    child: Text(
                                                      "DIVISION :${batch.name ?? " "}",
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style:
                                                      TextStyle(fontSize: 14),
                                                    ),
                                                  )).toList(),
                                              value: _selectedValue2,
                                              onChanged: (batch) {
                                                setState(() {
                                                  _selectedValue2 = batch ?? "";
                                                
                                        _isDivisionValid = _selectedValue2 != null && _selectedValue2!.isNotEmpty;
                                                });
                                                controller.setSelectedBatch(division: _selectedValue2.toString());
                                                // controller.fetchteacherdata(
                                                //     _selectedValue2!);
                                              },
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
                                                searchController: controller2,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextField(
                                                    controller: controller2,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                      hintText: 'Search Division',
                                                      hintStyle:
                                                      TextStyle(fontSize: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                  controller2.clear();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      if (!_isDivisionValid)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 25),
                                          child: Text(
                                            "Please Select the Division",
                                            style: TextStyle(color: Colors.red, fontSize: 10),
                                          ),
                                        ),
                                    ],
                                  ),


                                ],
                              ),

                              SizedBox(
                                height: 70.h,
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 25.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isClassValid = _selectedValue1 != null && _selectedValue1!.isNotEmpty;
                                        _isDivisionValid = _selectedValue2 != null && _selectedValue2!.isNotEmpty;
                                      });
                                        // print("kaaajjhksadjhksdjhk$_selectedValue3");
                                      if (_isClassValid && _isDivisionValid) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LearningWalknew2(
                                              classsbatch: _selectedValue1 ?? "",
                                              Division: _selectedValue2 ?? "",
                                            ),
                                          ),
                                        );
                                      }


                                      // if(_formKey.currentState!.validate()) {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           LessonWalkApply(
                                      //
                                      //             teacherName: selectedValue!,
                                      //             classAndBatch: selectedValue1!,
                                      //             subjectName: selectedValue2!,
                                      //           ),
                                      //     ),
                                      //   );
                                      // }
                                    },
                                    child: Container(
                                        height: 50.h,
                                        width: 220.w,
                                        decoration: BoxDecoration(
                                          color: Colorutils.userdetailcolor,
                                          borderRadius: const BorderRadius.all(
                                                  Radius.circular(15))
                                              .r,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Continue',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
