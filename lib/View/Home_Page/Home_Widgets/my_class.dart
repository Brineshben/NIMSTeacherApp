import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyClass extends StatelessWidget {
  const MyClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 8).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Class',
            style: GoogleFonts.inter(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // CircleAvatar(
          //   backgroundColor: Colorutils.threedotcolor,
          //   radius: 23.r,
          //   child: SvgPicture.asset(
          //     'assets/images/DotsThreeOutline.svg',
          //     fit: BoxFit.contain,
          //   ),
          // ),
        ],
      ),
    );
  }
}
