import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Services/warning_dialog.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/font_util.dart';
import '../../../Models/api_models/parent_list_api_model.dart';

class ParentSelectionBottomSheet extends StatefulWidget {
  ParentSelectionBottomSheet({super.key});

  @override
  State<ParentSelectionBottomSheet> createState() =>
      _ParentSelectionBottomSheetState();
}

class _ParentSelectionBottomSheetState
    extends State<ParentSelectionBottomSheet> {
  late TextEditingController textCtr;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textCtr = TextEditingController(); // for search parentlist //
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Get.find<FeedViewController>().sortSelectedParent();
      },
    );
    // Get.find<FeedViewController>().sortSelectedParent();
    return Theme(
      data: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff77B7AF),
                  borderRadius: BorderRadius.circular(15).r,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10).r,
              ),
              padding: const EdgeInsets.only(left: 16, bottom: 16).w,
              height: MediaQuery.of(context).size.height * 0.87,
              child: GetBuilder<FeedViewController>(
                builder: (FeedViewController controller) {
                  int count =
                      controller.parentListApiData.value.data?.count ?? 0;
                  // List<ParentData> parentList = controller.parentDataList.value;
                  List<ParentDataSelected> selectedParentList =
                      controller.selectedParentDataList;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) {
                      controller.getSelectedParentCount();
                      controller.getSelectAllIconData();
                    },
                  );

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 16).w,
                        child: Container(
                          width: 50.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100).r,
                              color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                                right: 16, top: 10, bottom: 10)
                            .w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Select Parents',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  // '${controller.selectedParentCount} / $count',
                                  '${controller.selectedParentCount} / ${controller.selectedParentDataList.length}',

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colorutils.letters1),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                if (controller.selectedParentCount.value == 0) {
                                  Navigator.of(context).pop();
                                  showParentRemoveWarningDialog(
                                    context: context,
                                    function: () {
                                      controller.selectedDoneFunction();
                                    },
                                  );
                                } else {
                                  controller.selectedDoneFunction();
                                  Navigator.of(context).pop();
                                  // controller.takeSelectedListForSubmit();
                                }
                              },
                              child: Text(
                                'Done',
                                style: TextStyle(
                                    color: Colorutils.letters1,
                                    fontSize: 16.sp,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colorutils.letters1,
                                    decorationThickness: 2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16).w,
                        child: TextField(
                          onChanged: (value) {
                            controller.search(value);
                          },
                          controller: textCtr,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Search name..',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  'assets/images/MagnifyingGlass.svg',
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0), // Border radius
                              borderSide:
                                  BorderSide.none, // Removes the outline border
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                              color: Colors.black), // Text color
                          cursorColor: Colors.black, // Cursor color
                        ),
                      ),
                      SizedBox(height: 16.w),
                      SizedBox(
                        width: ScreenUtil().screenWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(selectedParentList.length,
                                (index) {
                              // List<Color> colors = [
                              //   Colorutils.letters1,
                              //   Colorutils.svguicolour2,
                              //   Colorutils.Subjectcolor4
                              // ];

                              // Color color = colors[index % colors.length];

                              if (selectedParentList[index].isSelected) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, left: 5)
                                          .w,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 55.w,
                                              height: 55.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colorutils.grey
                                                    .withOpacity(0.2),
                                                border: Border.all(
                                                  color: Colorutils.grey
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100)
                                                        .r,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10)
                                                          .w,
                                                  child: FittedBox(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          selectedParentList[
                                                                      index]
                                                                  .image ??
                                                              '',
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return const Icon(
                                                            Icons.person,
                                                            color: Colors.grey);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Image.asset("assets/images/profile image.png"),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () =>
                                                    controller.removeParentList(
                                                        selectedParentList[
                                                            index]),
                                                child: Container(
                                                    width: 18.w,
                                                    height: 18.w,
                                                    padding:
                                                        const EdgeInsets.all(3)
                                                            .w,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Colorutils.Whitecolor,
                                                      border: Border.all(
                                                        color: Colorutils.grey
                                                            .withOpacity(0.2),
                                                      ),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/images/cancel.svg',
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        hSpace(5),
                                        SizedBox(
                                          width: 55.w,
                                          child: Text(
                                            selectedParentList[index]
                                                    .studentName ??
                                                '',
                                            style: TextStyle(
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.showSelectAllIcon.value) {
                                controller.unselectAllParents();
                              } else {
                                controller.selectAllParents();
                              }
                            },
                            child: Icon(
                              controller.showSelectAllIcon.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank_rounded,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Select All"),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: textCtr.text.isEmpty
                            ? ListView.separated(
                                itemCount: selectedParentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // List<Color> colors = [
                                  //   Colorutils.letters1,
                                  //   Colorutils.svguicolour2,
                                  //   Colorutils.Subjectcolor4
                                  // ];

                                  // Color color = colors[index % colors.length];
                                  return ListTile(
                                    contentPadding:
                                        EdgeInsets.only(right: 50.w),
                                    minVerticalPadding: 0,
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (selectedParentList[index]
                                            .isSelected)
                                          const Icon(Icons.check_circle,
                                              color: Colorutils.iconColor)
                                        else
                                          Icon(Icons.circle_outlined,
                                              weight: 0.2,
                                              color: Colorutils.iconColor
                                                  .withOpacity(0.5)),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          width: 50.w,
                                          height: 50.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colorutils.grey
                                                  .withOpacity(0.2),
                                            ),
                                            shape: BoxShape.circle,
                                            color: Colorutils.grey
                                                .withOpacity(0.2),
                                            // border: Border.all(
                                            //   color: color,
                                            // ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100).r,
                                            child: FittedBox(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    selectedParentList[index]
                                                            .image ??
                                                        '',
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(10)
                                                            .w,
                                                    child: const Icon(
                                                        Icons.person,
                                                        color: Colors.grey),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      capitalizeEachWord(
                                              selectedParentList[index]
                                                  .studentName) ??
                                          '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      selectRelation(selectedParentList[index]),
                                      overflow: TextOverflow.ellipsis,
                                      style: TeacherAppFonts
                                          .poppinsW500_12sp_lightGreenForParent,
                                    ),
                                    onTap: () {
                                      controller.addParentList(
                                          selectedParentList[index]);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 0,
                                    endIndent: 50.w,
                                    color: const Color(0xffE3E3E3),
                                  );
                                },
                              )
                            : ListView.separated(
                                itemCount: controller.tempList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // List<Color> colors = [
                                  //   Colorutils.letters1,
                                  //   Colorutils.svguicolour2,
                                  //   Colorutils.Subjectcolor4
                                  // ];

                                  // Color color = colors[index % colors.length];
                                  return ListTile(
                                    contentPadding:
                                        EdgeInsets.only(right: 50.w),
                                    minVerticalPadding: 0,
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (controller
                                            .tempList[index].isSelected)
                                          const Icon(Icons.check_circle,
                                              color: Colorutils.iconColor)
                                        else
                                          Icon(Icons.circle_outlined,
                                              color: Colorutils.iconColor
                                                  .withOpacity(0.5)),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          width: 55.w,
                                          height: 55.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colorutils.grey
                                                .withOpacity(0.2),
                                            // border: Border.all(
                                            //   color: color,
                                            // ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100).r,
                                            child: FittedBox(
                                              child: CachedNetworkImage(
                                                imageUrl: controller
                                                        .tempList[index]
                                                        .image ??
                                                    '',
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(10)
                                                            .w,
                                                    child: const Icon(
                                                        Icons.person,
                                                        color: Colors.grey),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      capitalizeEachWord(controller
                                              .tempList[index].studentName) ??
                                          '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      selectRelation(
                                          controller.tempList[index]),
                                      overflow: TextOverflow.ellipsis,
                                      style: TeacherAppFonts
                                          .poppinsW500_12sp_lightGreenForParent,
                                    ),
                                    onTap: () {
                                      controller.addParentList(
                                          controller.tempList[index]);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 0,
                                    endIndent: 50.w,
                                    color: const Color(0xffE3E3E3),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String selectRelation(ParentDataSelected parentData) {
    String? gender = parentData.gender?.substring(0, 1).toUpperCase();
    if (gender != null) {
      if (gender == "F") {
        return "Daughter of ${capitalizeEachWord(parentData.name) ?? '--'}";
      } else if (gender == "M") {
        return "Son of ${capitalizeEachWord(parentData.name) ?? '--'}";
      }
    }
    return "--";
  }
}
