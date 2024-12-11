import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/Colors.dart';

BoxDecoration themeCardDecoration = BoxDecoration(
  color: Colorutils.Whitecolor,
  borderRadius: BorderRadius.circular(20).r,
  boxShadow: [
    BoxShadow(
      color: Colors.teal.shade50,
      spreadRadius: 1,
      blurRadius: 0,
      offset: const Offset(0, 1),
    ),
  ],
);
BoxDecoration themeCardDecoration2 = BoxDecoration(
  color: Colorutils.Whitecolor,
  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
  boxShadow: [
    BoxShadow(
      color: Colors.teal.shade50,
      spreadRadius: 1,
      blurRadius: 0,
      offset: const Offset(0, 1),
    ),
  ],
);
