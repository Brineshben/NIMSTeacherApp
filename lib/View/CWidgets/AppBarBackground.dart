

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Utils/Colors.dart';

class AppBarBackground extends StatelessWidget {
  const AppBarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200.h,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.w),
                  bottomRight: Radius.circular(12.w)),
              color: Colorutils.userdetailcolor,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 40,
          child: SvgPicture.asset(
            'assets/images/pencil2.svg',
            width: 100.w,
            color: Colorutils.Whitecolor.withOpacity(0.1),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          left: 240,
          top: 25,
          child: Transform.rotate(
            angle: 0.5,
            child: SvgPicture.asset(
              'assets/images/stars1.svg',
              width: 20.w,
              color: Colorutils.Whitecolor.withOpacity(0.5),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          left: 220,
          top: 65,
          child: SvgPicture.asset(
            'assets/images/graduation-cap-icon.svg',
            width: 30.w,
            color: Colorutils.Whitecolor.withOpacity(0.07),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          left: 140,
          top: 10,
          child: SvgPicture.asset(
            'assets/images/read-book-icon.svg',
            width: 30.w,
            color: Colorutils.Whitecolor.withOpacity(0.07),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          left: 115,
          top: 65,
          child: SvgPicture.asset(
            'assets/images/stars1.svg',
            width: 20.w,
            color: Colorutils.Whitecolor.withOpacity(0.5),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          left: 5,
          top: 10,
          child: SvgPicture.asset(
            'assets/images/stars1.svg',
            width: 20.w,
            color: Colorutils.Whitecolor.withOpacity(0.5),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          right: 10,
          top: 140,
          child: SvgPicture.asset(
            'assets/images/stars1.svg',
            color: Colorutils.Whitecolor.withOpacity(0.9),
            width: 25.w,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          right: 0,
          top: -90,
          child: SvgPicture.asset(
            'assets/images/pencil3.svg',
            color: Colorutils.Whitecolor.withOpacity(0.2),
            height: 180.w,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}
