import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Models/api_models/chat_group_api_model.dart';
import '../../../Models/api_models/grouped_view_list_api_model.dart';
import '../../../Utils/font_util.dart';

class LastSeenMsgGroupChat extends StatelessWidget {
  final LastMessageGroupChat? lastMessage;
  const LastSeenMsgGroupChat({super.key, this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(builder: (context) {
        if (lastMessage != null) {
          if (lastMessage!.type == "file") {
            return Row(
              children: [
                Container(
                  width: 15,
                  height: 17,
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
                  //         lastMessage!.fileName!
                  //             .split(".")
                  //             .last,
                  //         style: const TextStyle(
                  //           fontWeight: FontWeight.w400,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    lastMessage!.fileName!,
                    style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                      color: Color(0xff535353).withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            );
          } else if (lastMessage!.type == "text") {
            return Text(
              // "Can you pls share the pdf adsdaddsf.",
              lastMessage?.message?.replaceAll('\n', ' ') ?? "--",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                color: Color(0xff535353).withOpacity(0.8),
              ),
            );
          } else if (lastMessage!.type == "audio") {
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
                      color: Color(0xff535353).withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            );
          } else if (lastMessage!.type == "text_file" ||
              lastMessage!.type == "text_audio") {
            return Text(
              // "Can you pls share the pdf adsdaddsf.",
              lastMessage!.message ?? "--",
              overflow: TextOverflow.ellipsis,

              style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                color: Color(0xff535353).withOpacity(0.8),
              ),
            );
          }
        }
        return const SizedBox();
      }),
    );
  }
}

class LastSeenMsgGroupedViewChat extends StatelessWidget {
  final LastMessageGroupedView? lastMessage;
  const LastSeenMsgGroupedViewChat({super.key, this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(builder: (context) {
        if (lastMessage != null) {
          if (lastMessage!.type == "file") {
            return Row(
              children: [
                Container(
                  width: 15,
                  height: 17,
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
                  //         lastMessage!.fileName!.split(".").last,
                  //         style: const TextStyle(
                  //           fontWeight: FontWeight.w400,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    lastMessage!.fileName!,
                    style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                      color: Color(0xff535353).withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            );
          } else if (lastMessage!.type == "text") {
            return Text(
              // "Can you pls share the pdf adsdaddsf.",
              lastMessage?.message?.replaceAll('\n', ' ') ?? "--",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                color: Color(0xff535353).withOpacity(0.8),
              ),
            );
          } else if (lastMessage!.type == "audio") {
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
                      color: Color(0xff535353).withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            );
          } else if (lastMessage!.type == "text_file" ||
              lastMessage!.type == "text_audio") {
            return Text(
              // "Can you pls share the pdf adsdaddsf.",
              lastMessage!.message ?? "--",
              overflow: TextOverflow.ellipsis,

              style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                color: Color(0xff535353).withOpacity(0.8),
              ),
            );
          }
        }
        return const SizedBox();
      }),
    );
  }
}
