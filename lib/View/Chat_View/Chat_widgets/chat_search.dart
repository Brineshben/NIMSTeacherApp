import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacherapp/Controller/search_controller/search_controller.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';

class ChatSearchTextFieldWidget extends StatelessWidget {
  ChatSearchTextFieldWidget({
    super.key,
    required this.controller,
    required this.searchListType,
  });

  final ChatSearchController controller;
  final String searchListType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // InkWell(
        //   onTap: () {
        //     controller.hideSearch();
        //     controller.searchValue.value = "";
        //     controller.searchCtr.clear();
        //     print("searchList ============== onsearch");
        //   },
        //   child: SizedBox(
        //     height: 24.h,
        //     width: 24.h,
        //     child: SvgPicture.asset("assets/images/back.svg"),
        //   ),
        // ),
        // wSpace(20.h),
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: Center(
              child: TextField(
                onChanged: (value) {
                  controller.searchChat(
                      text: value,
                      context: context,
                      searchListType: searchListType);
                },
                style: TeacherAppFonts.interW600_18sp_textWhite,
                controller: controller.searchCtr,
                cursorColor: Colorutils.white,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colorutils.white,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colorutils.white,
                    ),
                  ),
                  hintText: "Search...",
                  hintStyle: TeacherAppFonts.interW600_20sp_textWhite,
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ),
        ),
        wSpace(20.h),
        InkWell(
          onTap: () {
            controller.nextIndex(context, searchListType);
          },
          child: SizedBox(
            height: 24.h,
            width: 24.h,
            child: RotatedBox(
              quarterTurns: 45,
              child: SvgPicture.asset("assets/images/back.svg"),
            ),
          ),
        ),
        wSpace(30.h),
        InkWell(
          onTap: () {
            controller.previousIndex(context, searchListType);
          },
          child: RotatedBox(
            quarterTurns: -45,
            child: SizedBox(
              height: 24.h,
              width: 24.h,
              child: SvgPicture.asset("assets/images/back.svg"),
            ),
          ),
        ),
        wSpace(20.h),
      ],
    );
  }
}
