import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/forward_controller.dart/forward_controller.dart';
import 'package:teacherapp/Controller/search_controller/search_controller.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/audio_file_widget.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/replay_in_message_widget.dart';

import '../../../Models/api_models/chat_feed_view_model.dart';
import '../../../Utils/font_util.dart';
import '../feed_view _chat_screen.dart';
import 'audio_widget.dart';
import 'file_widget.dart';

class SentMessageBubble extends StatelessWidget {
  SentMessageBubble(
      {super.key,
      this.message,
      this.time,
      this.replay,
      this.audio,
      this.fileName,
      this.fileLink,
      // this.senderId,
      this.messageData,
      required this.index,
      required this.widget});

  late Offset _tapPosition;

  bool? replay;
  String? time;
  String? message;
  MsgData? messageData;
  String? audio;
  String? fileName;
  String? fileLink;
  // String? senderId;+
  final int index;
  final FeedViewChatScreen widget;

  late List<IncomingReact> incomingReactList;

  @override
  Widget build(BuildContext context) {
    if (messageData!.incomingReact == null) {
      incomingReactList = [];
    } else {
      incomingReactList = messageData!.incomingReact!;
    }
    return AutoScrollTag(
      index: index,
      highlightColor: Colors.teal.shade200,
      controller:
          Get.find<FeedViewController>().chatFeedViewScrollController.value,
      key: ValueKey(index),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.h),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: -5.w,
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: SvgPicture.asset(
                            "assets/images/MessageBubbleShape.svg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                _tapPosition = details.globalPosition;
                                print(_tapPosition);
                                print(ScreenUtil().screenHeight);
                              },
                              onLongPress: () {
                                final data =
                                    ChatRoomDataInheritedWidget.of(context);
                                print(
                                    "dataajfdaisfjio ============== ${data?.msgData?.classTeacherClass}");
                                HapticFeedback.vibrate();

                                final renderObject =
                                    context.findRenderObject() as RenderBox;
                                final position =
                                    renderObject.localToGlobal(Offset.zero);

                                if (Get.find<FeedViewController>()
                                        .isShowDialogShow ==
                                    false) {
                                  Get.find<FeedViewController>()
                                      .seletedMsgData = messageData;

                                  Get.find<ForwardController>()
                                          .forwordMessageId =
                                      messageData?.messageId ?? "";

                                  messageMoreShowDialog(context, this, position,
                                      _tapPosition, data);
                                  Get.find<FeedViewController>()
                                      .isShowDialogShow = true;
                                }

                                // messageMoreShowDialog(
                                //     context, this, position, _tapPosition);

                                print(
                                    "msg ============= id ${Get.find<FeedViewController>().seletedMsgData!.messageId}");
                              },
                              child: IntrinsicWidth(
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 310.w),
                                  decoration: BoxDecoration(
                                      color: Colorutils.msgBubbleColor1,
                                      borderRadius:
                                          BorderRadius.circular(10.h)),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.h),
                                    child: Column(
                                      children: [
                                        messageData!.isForward ?? false
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    height: 14.h,
                                                    width: 14.h,
                                                    child: SvgPicture.asset(
                                                      "assets/images/ArrowBendUpRight.svg",
                                                      color: Colors.black
                                                          .withOpacity(.25),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text("Forwarded",
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25))),
                                                ],
                                              )
                                            : const SizedBox(),
                                        messageData!.replyData != null
                                            ? ReplayMessageWidget(
                                                senderId:
                                                    messageData!.messageFromId,
                                                replyData:
                                                    messageData!.replyData!,
                                              )
                                            : const SizedBox(),
                                        fileName != null &&
                                                messageData?.type == "file"
                                            ? FileWidget1(
                                                fileType:
                                                    fileName!.split(".").last,
                                                fileName: fileName ?? "",
                                                fileLink: fileLink ?? "",
                                                messageId:
                                                    messageData?.messageId ??
                                                        "",
                                              )
                                            : const SizedBox(),
                                        audio != null
                                            ? audio?.split('.').last == "wav"
                                                ? AudioWidget(
                                                    content: audio ?? "",
                                                    messageId: messageData!
                                                            .messageId ??
                                                        "")
                                                : AudioFileWidget(
                                                    content: audio ?? "",
                                                    messageId: messageData!
                                                            .messageId ??
                                                        "",
                                                    audioFileName:
                                                        fileName ?? "",
                                                  )
                                            : const SizedBox(),
                                        message != null && fileName != null ||
                                                audio != null
                                            ? SizedBox(height: 5.h)
                                            : const SizedBox(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              children: [
                                                // ConstrainedBox(
                                                //   constraints: BoxConstraints(
                                                //     maxWidth: 200.w,
                                                //   ),
                                                //   child: Text(
                                                //     message ?? "",
                                                //     // maxLines: 100,
                                                //     style: TeacherAppFonts
                                                //         .interW400_16sp_letters1
                                                //         .copyWith(color: Colors.black),
                                                //   ),
                                                // ),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 160.w,
                                                  ),
                                                  child: GetX<
                                                      ChatSearchController>(
                                                    builder:
                                                        (chatSerchController) {
                                                      if (chatSerchController
                                                          .searchValue
                                                          .value
                                                          .isEmpty) {
                                                        return RichText(
                                                          text: TextSpan(
                                                              children: Get.find<
                                                                      FeedViewController>()
                                                                  .getMessageText(
                                                                      text:
                                                                          message ??
                                                                              "",
                                                                      context:
                                                                          context),
                                                              style: TeacherAppFonts
                                                                  .interW400_16sp_letters1
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black)),
                                                        );
                                                      } else {
                                                        return RichText(
                                                          text: TextSpan(
                                                            children: Get
                                                                    .find<
                                                                        ChatSearchController>()
                                                                .getCombinedTextSpan(
                                                                    searchTerm:
                                                                        chatSerchController
                                                                            .searchValue
                                                                            .value,
                                                                    text:
                                                                        message ??
                                                                            "",
                                                                    context:
                                                                        context),
                                                            style: TeacherAppFonts
                                                                .interW400_16sp_letters1
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 5.h)
                                              ],
                                            ),
                                            SizedBox(width: 20.h),
                                            Row(
                                              children: [
                                                Text(
                                                  // "17:47",
                                                  messageBubbleTimeFormat(time),
                                                  style: TeacherAppFonts
                                                      .interW400_12sp_topicbackground
                                                      .copyWith(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  .25)),
                                                ),
                                                SizedBox(width: 5.h),
                                                // SizedBox(
                                                //   height: 21.h,
                                                //   width: 21.h,
                                                //   child: SizedBox(
                                                //     height: 21.h,
                                                //     width: 21.h,
                                                //     child: Center(
                                                //       child: Icon(
                                                //         Icons.check,
                                                //         color: Colors.grey,
                                                //         size: 16.h,
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                messageData!.messageId
                                                            .toString()
                                                            .split("/")
                                                            .first ==
                                                        "unsent"
                                                    ? SizedBox(
                                                        height: 21.h,
                                                        width: 21.h,
                                                        child: Center(
                                                          child: SizedBox(
                                                            height: 12.h,
                                                            width: 12.h,
                                                            child: SvgPicture.asset(
                                                                "assets/images/unsent_clock.svg",
                                                                color:
                                                                    Colorutils
                                                                        .grey),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 21.h,
                                                        width: 21.h,
                                                        child: SvgPicture.asset(
                                                            "assets/images/Checks.svg",
                                                            color: messageData
                                                                        ?.read ==
                                                                    null
                                                                ? Colors.grey
                                                                : messageData!
                                                                        .read!
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .grey),
                                                      ),
                                                // SizedBox(
                                                //   height: 21.h,
                                                //   width: 21.h,
                                                //   child: widget.msgData
                                                //               ?.isClassTeacher ==
                                                //           true
                                                //       ? SizedBox(
                                                //           height: 21.h,
                                                //           width: 21.h,
                                                //           child: Center(
                                                //             child: Icon(
                                                //               Icons.check,
                                                //               color: Colors.grey,
                                                //               size: 16.h,
                                                //             ),
                                                //           ),
                                                //         )
                                                //       : SvgPicture.asset(
                                                //           "assets/images/Checks.svg",
                                                //           color:
                                                //               messageData?.read == null
                                                //                   ? Colors.grey
                                                //                   : messageData!.read!
                                                //                       ? Colors.green
                                                //                           .shade900
                                                //                       : Colors.grey),
                                                // ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              incomingReactList.isEmpty && messageData!.myReact == null
                  ? const SizedBox()
                  : hSpace(20.h)
            ],
          ),
          incomingReactList.isEmpty && messageData!.myReact == null
              ? const SizedBox()
              : Positioned(
                  bottom: 0,
                  // right: isGroup ? 90.w : 50.w,
                  right: 50.w,
                  child: GestureDetector(
                    onTap: () {
                      reactionBottomSheet(
                          context, incomingReactList, messageData!.myReact);
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 30.h,
                        // width: 40.h,
                        decoration: BoxDecoration(
                          color: Colorutils.white,
                          borderRadius: BorderRadius.circular(20.h),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Center(
                            child: FittedBox(
                              child: Row(
                                children: [
                                  messageData!.myReact != null
                                      ? Text(messageData!.myReact ?? "")
                                      : incomingReactList.isNotEmpty
                                          ? Text(incomingReactList[0].react!)
                                          : const SizedBox(),
                                  messageData!.myReact != null
                                      ? incomingReactList.isNotEmpty
                                          ? Text(incomingReactList[0].react!)
                                          : const SizedBox()
                                      : incomingReactList.length >= 2
                                          ? Text(incomingReactList[1].react!)
                                          : const SizedBox(),
                                  messageData!.myReact == null
                                      ? incomingReactList.length >= 3
                                          ? Text(
                                              "${incomingReactList.length - 2}")
                                          : const SizedBox()
                                      : incomingReactList.length >= 2
                                          ? Text(
                                              "${incomingReactList.length - 1}")
                                          : const SizedBox(),
                                  // messageData!.myReact != null
                                  //     ? Text(messageData!.myReact ?? "")
                                  //     : messageData!.incomingReact!.isNotEmpty
                                  //         ? Text(messageData!
                                  //             .incomingReact![0].react!)
                                  //         : const SizedBox(),
                                  // messageData!.myReact != null
                                  //     ? messageData!.incomingReact!.isNotEmpty
                                  //         ? Text(messageData!
                                  //             .incomingReact![0].react!)
                                  //         : const SizedBox()
                                  //     : messageData!.incomingReact!.length >= 2
                                  //         ? Text(messageData!
                                  //             .incomingReact![1].react!)
                                  //         : const SizedBox(),
                                  // messageData!.myReact == null
                                  //     ? messageData!.incomingReact!.length >= 3
                                  //         ? Text(
                                  //             "${messageData!.incomingReact!.length - 2}")
                                  //         : const SizedBox()
                                  //     : messageData!.incomingReact!.length >= 2
                                  //         ? Text(
                                  //             "${messageData!.incomingReact!.length - 1}")
                                  //         : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

String messageBubbleTimeFormat(String? dateTime) {
  // Check if the input date-time string is null
  if (dateTime == null) {
    return "--";
  }

  // Parse the input date-time string
  DateTime parsedDateTime = DateTime.parse(dateTime);

  // Format the parsed DateTime to the desired time format
  String formattedTime = DateFormat('HH:mm').format(parsedDateTime);

  return formattedTime;
}

// String chatFormatDate(String? dateTime) {
//   // Check if the input date-time string is null
//   if (dateTime == null) {
//     return "--";
//   }
//   // Parse the input date-time string
//   DateTime parsedDateTime = DateTime.parse(dateTime);

//   // Format the parsed DateTime to the desired format
//   String formattedDate = DateFormat('EEE, MMM d').format(parsedDateTime);

//   return formattedDate;
// }

String chatFormatDate(String? dateTime) {
  if (dateTime == null) {
    return "--";
  }

  try {
    // Parse the input date-time string
    DateTime parsedDateTime = DateTime.parse(dateTime);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Get the start of today and yesterday
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime startOfYesterday = startOfToday.subtract(Duration(days: 1));

    // Check if the date is today
    // if (parsedDateTime.isAfter(startOfToday)) {
    //   return "Today";
    // }
    if (parsedDateTime == startOfToday) {
      return "Today";
    }

    // Check if the date is yesterday
    // if (parsedDateTime.isAfter(startOfYesterday) &&
    //     parsedDateTime.isBefore(startOfToday)) {
    //   return "Yesterday";
    // }
    if (parsedDateTime == startOfYesterday) {
      return "Yesterday";
    }

    // Otherwise, format as 'EEE, MMM d'
    return DateFormat('EEE, MMM d').format(parsedDateTime);
  } catch (e) {
    return "--";
  }
}

String chatRoomFormatTime(String? dateTime) {
  // Check if the input date-time string is null
  if (dateTime == null) {
    return "";
  }
  // Parse the input date-time string
  DateTime parsedDateTime = DateTime.parse(dateTime);

  // Format the parsed DateTime to the desired format
  String formattedDateTime = DateFormat('E h:mm a').format(parsedDateTime);

  return formattedDateTime;
}

String messageInfoformatDate(String? dateTimeString) {
  if (dateTimeString == null) {
    return "--";
  }
  // Parse the given date time string
  DateTime givenTime = DateTime.parse(dateTimeString);
  // Get the current time
  DateTime now = DateTime.now();

  // Calculate the difference in time
  Duration difference = now.difference(givenTime);

  // If the given time is today
  if (givenTime.year == now.year &&
      givenTime.month == now.month &&
      givenTime.day == now.day) {
    if (difference.inMinutes < 1) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Today';
    }
  }

  // If the given time was yesterday
  DateTime yesterday = now.subtract(const Duration(days: 1));
  if (givenTime.year == yesterday.year &&
      givenTime.month == yesterday.month &&
      givenTime.day == yesterday.day) {
    return 'Yesterday';
  }

  // Otherwise, return the date in "MMM dd" format
  return DateFormat('MMM dd').format(givenTime);
}

String messageInfoformatTime(String? dateTimeString) {
  if (dateTimeString == null) {
    return "--";
  }
  // Parse the given date time string
  DateTime givenTime = DateTime.parse(dateTimeString);

  // Format the given time to "h:mm a" format
  String formattedTime = DateFormat('h:mma').format(givenTime);

  return formattedTime;
}

reactionBottomSheet(
    BuildContext context, List<IncomingReact> reactionList, String? myReact) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity,
        height: ScreenUtil().screenHeight / 2,
        color: Colorutils.white,
        child: Column(
          children: [
            hSpace(15.h),
            Container(
              height: 5.h,
              width: 80.w,
              decoration: BoxDecoration(
                  color: Colorutils.grey,
                  borderRadius: BorderRadius.circular(100.h)),
            ),
            hSpace(15.h),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reacted by",
                  style: TeacherAppFonts.interW600_18sp_textWhite
                      .copyWith(color: Colors.teal),
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    myReact != null
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text(
                                  "You",
                                  style: TeacherAppFonts
                                      .interW500_16sp_textWhiteOp60
                                      .copyWith(color: Colorutils.black),
                                ),
                                const Spacer(),
                                Text(myReact, style: TextStyle(fontSize: 20.h))
                              ],
                            ),
                          )
                        : const SizedBox(),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    reactionList[index].reactBy ?? "--",
                                    style: TeacherAppFonts
                                        .interW500_16sp_textWhiteOp60
                                        .copyWith(color: Colorutils.black),
                                  ),
                                ),
                                const Spacer(),
                                Text(reactionList[index].react ?? "--",
                                    style: TextStyle(fontSize: 20.h))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox();
                        },
                        itemCount: reactionList.length)
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
