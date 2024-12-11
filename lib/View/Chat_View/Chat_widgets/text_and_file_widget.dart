import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacherapp/Utils/Colors.dart';

import '../../../Models/api_models/chat_feed_view_model.dart';
import '../../../Utils/font_util.dart';

class TextAndFileWidget extends StatelessWidget {
  const TextAndFileWidget({
    super.key,
    required this.replyData,
  });
  final ReplyData replyData;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (replyData.type == "file") {
        return Row(
          children: [
            Container(
              width: 16,
              height: 18,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/new-document.png"),
                ),
              ),
              // child: Center(
              //   child: SizedBox(
              //     height: 8,
              //     width: 12,
              //     child: FittedBox(
              //       child: Text(
              //         replyData.fileName!.split(".").last,
              //         style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
              //           fontSize: 8.sp,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Text(
                replyData.fileName!,
                style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                  color: Colorutils.fontColor6.withOpacity(0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        );
      } else if (replyData.type == "text") {
        return Text(
          // "Can you pls share the pdf adsdaddsf.",
          replyData.message ?? "",
          overflow: TextOverflow.ellipsis,

          style: TeacherAppFonts.interW400_14sp_textWhite
              .copyWith(color: Colorutils.fontColor6.withOpacity(0.8)),
        );
      } else if (replyData.type == "audio") {
        return Row(
          children: [
            SizedBox(
              width: 22,
              height: 15.h,
              child: SvgPicture.asset("assets/images/Record Audio.svg"),
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                "Audio",
                style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                  color: Colorutils.fontColor6.withOpacity(0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        );
      } else if (replyData.type == "text_file" ||
          replyData.type == "text_audio") {
        return Text(
          // "Can you pls share the pdf adsdaddsf.",
          replyData.message ?? "",

          overflow: TextOverflow.ellipsis,

          style: TeacherAppFonts.interW400_14sp_textWhite
              .copyWith(color: Colorutils.fontColor6.withOpacity(0.8)),
        );
      }

      return const SizedBox();
    });
  }
}
