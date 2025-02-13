import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacherapp/Utils/Colors.dart';

class TeacherAppFonts {
  static final TeacherAppFonts _instance = TeacherAppFonts._internal();

  TeacherAppFonts._internal();

  factory TeacherAppFonts() {
    return _instance;
  }

  static const _interFont = 'Inter';
  static const _poppinsFont = 'Poppins';
  static const _sfProItalic = 'SF-Pro';

  static final TextStyle interW600_20sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW300_23sp_reactionAddButton = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w300,
    fontSize: 23.sp,
    color: Colorutils.reactionAddButton,
  );

  static final TextStyle interW400_12sp_textWhite_italic = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    fontSize: 12.sp,
    color: Colorutils.Whitecolor,
  );
  //ben
  static final TextStyle interW600_24sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW600_18sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW600_14sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Colorutils.letters1,
  );
  static final TextStyle interW600_18sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
    color: Colorutils.letters1,
  );

  static final TextStyle interW600_14sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW600_14sp_black = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Colors.black,
  );

  static final TextStyle interW700_16sp_black = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    color: Colors.black,
  );

  static final TextStyle interW600_16sp_black = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    color: Colors.black,
  );

  static final TextStyle interW600_16sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    color: Colorutils.letters1,
  );

  static final TextStyle interW500_16sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    color: Colorutils.letters1,
  );

  static final TextStyle interW500_14sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: Colorutils.letters1,
  );

  static final TextStyle interW700_16sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    color: Colorutils.letters1,
  );

  static final TextStyle interW400_16sp_letters1 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: Colorutils.letters1,
  );
  static final TextStyle interW500_10sp_userdetailcolor = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    color: Colorutils.userdetailcolor,
  );

  static final TextStyle interW500_11sp_userdetailcolor = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 11.sp,
    color: Colorutils.userdetailcolor,
  );

  static final TextStyle interW500_20sp_textWhiteOp60 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
    color: Colorutils.Whitecolor.withOpacity(0.6),
  );
  static final TextStyle interW500_16sp_textWhiteOp60 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    color: Colorutils.Whitecolor.withOpacity(0.6),
  );

  static final TextStyle interW500_18sp_black = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w800,
    fontSize: 18.sp,
    color: Colors.black,
  );

  static final TextStyle interW400_14sp_textWhiteOp60 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: Colorutils.Whitecolor.withOpacity(0.6),
  );

  static final TextStyle interW400_8sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 8.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW400_14sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW400_14sp_chatSubTitleOp80 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: Colorutils.chatSubTitle.withOpacity(0.8),
  );

  static final TextStyle interW400_12sp_topicbackground = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: Colorutils.topicbackground,
  );

  static final TextStyle interW500_32sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 32.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW400_18sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW400_18sp_timecolortopics = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: Colorutils.timecolortopics,
  );

  static final TextStyle interW500_24sp_timecolortopics = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 24.sp,
    color: Colorutils.timecolortopics,
  );

  static final TextStyle interW600_14sp_timecolortopics = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Colorutils.timecolortopics,
  );

  static final TextStyle interW400_14sp_textWhiteOp75 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: Colorutils.Whitecolor.withOpacity(0.75),
  );

  static final TextStyle interW400_14sp_timecolortopicsOp80 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: Colorutils.timecolortopics.withOpacity(0.8),
  );

  static final TextStyle interW600_12sp_timecolortopicsOp80 = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    color: Colorutils.timecolortopics.withOpacity(0.8),
  );

  static final TextStyle interW500_12sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: Colorutils.Whitecolor,
  );
  static final TextStyle interW700_12sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle interW700_16sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    color: Colorutils.Whitecolor,
  );

  static final TextStyle poppinsW400_12sp_bottomiconcolor = TextStyle(
    fontFamily: _poppinsFont,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: Colorutils.bottomiconcolor,
  );

  static final TextStyle poppinsW500_13sp_letters1 = TextStyle(
    fontFamily: _poppinsFont,
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: Colorutils.letters1,
  );

  static final TextStyle poppinsW400_12sp_lightGreenForParent = TextStyle(
    fontFamily: _sfProItalic,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: Colorutils.lightGreenForParent,
  );

  static final TextStyle poppinsW500_12sp_lightGreenForParent = TextStyle(
    fontFamily: _sfProItalic,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: Colorutils.lightGreenForParent,
  );

  static final TextStyle p24color = TextStyle(
    fontFamily: _sfProItalic,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: Colorutils.lightGreenForParent,
  );

  static final TextStyle poppinsW400_13sp_bottomiconcolor = TextStyle(
    fontFamily: _poppinsFont,
    fontWeight: FontWeight.w400,
    fontSize: 13.sp,
    color: Colorutils.bottomiconcolor,
  );

  static final TextStyle poppinsW500_16sp_letters1 = TextStyle(
    fontFamily: _poppinsFont,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    color: Colorutils.letters1,
  );
static final TextStyle interW400_20sp = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w400,
    fontSize: 20.sp,
    color: Colorutils.Whitecolor,
  );
  static final TextStyle interW600_25sp_textWhite = TextStyle(
    fontFamily: _interFont,
    fontWeight: FontWeight.w600,
    fontSize: 25.sp,
    color: Colorutils.Whitecolor,
  );
}
