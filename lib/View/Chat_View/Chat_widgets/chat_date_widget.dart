import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/sent_bubble_widget.dart';

import '../../../Utils/font_util.dart';

class ChatDateWidget extends StatelessWidget {
  const ChatDateWidget({super.key, this.date});

  final String? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colorutils.fontColor15,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Text(chatFormatDate(date),
                  style: TeacherAppFonts.interW500_12sp_textWhite
                      .copyWith(color: Colorutils.fontColor16)),
            ),
          ),
        ],
      ),
    );
  }
}
