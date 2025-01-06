import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Controller/db_controller/parent_db_controller.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/api_constants.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/new_parentChat_bottomSheet.dart';
import 'package:teacherapp/View/Chat_View/parent_chat_screen.dart';
import '../../../Controller/api_controllers/userAuthController.dart';
import '../../../Models/api_models/parent_chat_list_api_model.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/font_util.dart';

class ParentChatList extends StatelessWidget {
  const ParentChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetX<ParentChatListController>(
          builder: (ParentChatListController controller) {
            int currentIndex = controller.currentTab.value;
            return Container(
              height: 50.w,
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(width: 15.w),
                  InkWell(
                    onTap: () {
                      controller.setTab(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 14)
                          .w,
                      decoration: BoxDecoration(
                        color: currentIndex == 0
                            ? Colorutils.buttoncolor
                            : Colorutils.unselectedTab,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Text(
                        'All',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),

                  InkWell(
                    onTap: () {
                      controller.setTab(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12)
                          .w,
                      decoration: BoxDecoration(
                        color: currentIndex == 1
                            ? Colorutils.buttoncolor
                            : Colorutils.unselectedTab,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Text(
                        'Unread',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 5.w),

                  // InkWell(
                  //   onTap: () {
                  //     final tempIndex = currentIndex;
                  //     controller.setTab(3);

                  //     showModalBottomSheet(
                  //       context: context,
                  //       backgroundColor: Colors.transparent,
                  //       isScrollControlled: true,
                  //       builder: (context) {
                  //         return const NewParentChat();
                  //       },
                  //     ).then(
                  //       (value) {
                  //         Get.find<ParentChatListController>()
                  //             .isTextField
                  //             .value = "";
                  //         controller.setTab(tempIndex);
                  //       },
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 12)
                  //         .w,
                  //     decoration: BoxDecoration(
                  //       // color: Colorutils.unselectedTab,
                  //       color: currentIndex == 3
                  //           ? Colorutils.buttoncolor
                  //           : Colorutils.unselectedTab,
                  //       borderRadius: BorderRadius.circular(15),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.1),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Text(
                  //       'By Class',
                  //       style: GoogleFonts.inter(
                  //         color: Colors.black,
                  //         fontSize: 15.sp,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //     width: 5.w
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12).w,
                  //   decoration: BoxDecoration(
                  //     color: Colorutils.buttoncolor,
                  //     borderRadius: BorderRadius.circular(15),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(
                  //             0.1),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Text(
                  //     'By Class',
                  //     style: GoogleFonts.inter(
                  //       color: Colors.black,
                  //       fontSize: 13.sp,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
        GetX<ParentChatListController>(
          builder: (ParentChatListController controller) {
            List<Datum> chatParentList = controller.parentChatList.value;
            if (controller.isLoading.value) {
              return Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 15),
                    itemBuilder: (context, index) => const MessageListShimmer(),
                    separatorBuilder: (context, index) => const Divider(
                          color: Colorutils.dividerColor1,
                          height: 0,
                        ),
                    itemCount: 10),
              );
            } else if (controller.dbLoader.value) {
              return Expanded(
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      "Loading",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            } else if (controller.parentChatList.isEmpty) {
              return Expanded(
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      "Empty chat list.",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // context.loaderOverlay.show();

                    // checkInternet(
                    //   context: context,
                    //   function: () async {

                    //   },
                    // );
                    await Get.find<ParentChatListController>()
                        .fetchParentChatList(context: context);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: chatParentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      LastMessage? lastMsg =
                          chatParentList[index].lastMessage ?? LastMessage();
                      DateTime? sentTime = lastMsg.sandAt;
                      String? formattedDate;
                      try {
                        formattedDate =
                            DateFormat('EEE hh:mm a').format(sentTime!);
                      } catch (e) {}
                      String? userId =
                          Get.find<UserAuthController>().userData.value.userId;
                      return ChatItem(
                        time: sentTime.toString(),
                        userId: userId,
                        leadColor: Colorutils.chatLeadingColors[index % 5],
                        parentRoom: chatParentList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 0.2,
                        indent: 10,
                        endIndent: 10,
                        height: 0,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class ChatItem extends StatelessWidget {
  final String time;
  final String? userId;
  final Color leadColor;
  final Datum parentRoom;
  // final String Parentdetail;
  // final String classsdetail;

  const ChatItem({
    super.key,
    required this.time,
    required this.userId,
    required this.leadColor,
    required this.parentRoom,
    // required this.Parentdetail,
    // required this.classsdetail,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.find<ParentDbController>().createMessageTable(
            parentId: parentRoom.parentId ?? "",
            studentclass: parentRoom.datumClass ?? "",
            batch: parentRoom.batch ?? "");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ParentChatScreen(msgData: parentRoom);
            },
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Row(
            children: [
              parentRoom.image == null
                  ? CircleAvatar(
                      backgroundColor: leadColor,
                      radius: 28.r,
                      child: FittedBox(
                        child: Text(
                          "${parentRoom.datumClass}${parentRoom.batch}",
                          style: TeacherAppFonts.interW600_14sp_textWhite,
                        ),
                      ),
                    )
                  : Container(
                      height: 54.r,
                      width: 54.r,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 207, 207, 207),
                          // border: Border.all(color: Colors.white, width: 2.w),
                          shape: BoxShape.circle),
                      // backgroundImage:
                      //     AssetImage('assets/images/profile2.png'),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100).r,
                        child: CachedNetworkImage(
                          imageUrl:
                              "${ApiConstants.downloadUrl}${parentRoom.image}",
                          placeholder: (context, url) => const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 40,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      )),
              // Container(
              //   padding: const EdgeInsets.all(1).w,
              //   decoration: BoxDecoration(
              //     color: Colors.grey,
              //     borderRadius: BorderRadius.circular(100).r,
              //   ),
              //   child: Container(
              //     padding: const EdgeInsets.all(10).w,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(100).r,
              //     ),
              //     child: CachedNetworkImage(
              //       imageUrl: '--',
              //       errorWidget: (context, txt, obj) => const Icon(Icons.person, color: Colors.grey),
              //     ),
              //   ),
              // ),
              SizedBox(width: 15.h),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 120),
                                child: Text(
                                  // "English",
                                  parentRoom.studentName ?? '--',
                                  style: TeacherAppFonts.interW700_16sp_black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  parentRoom.relation != null
                                      ? "${parentRoom.relation} of ${parentRoom.parentName}"
                                      : "${parentRoom.parentName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TeacherAppFonts
                                      .poppinsW400_12sp_lightGreenForParent,
                                ),
                              ),
                            ],
                          ),
                          if (userId != null && parentRoom.lastMessage != null)
                            if (userId == parentRoom.lastMessage!.messageFromId)
                              SizedBox(width: 5.h),
                          Row(
                            children: [
                              if (userId != null &&
                                  parentRoom.lastMessage != null)
                                if (userId ==
                                    parentRoom.lastMessage!.messageFromId)
                                  SizedBox(
                                    height: 21.h,
                                    width: 21.h,
                                    child: SvgPicture.asset(
                                      "assets/images/Checks.svg",
                                      color: parentRoom.lastMessage!.read!
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                              if (userId != null &&
                                  parentRoom.lastMessage != null)
                                if (userId ==
                                    parentRoom.lastMessage!.messageFromId)
                                  SizedBox(width: 5.h),
                              Expanded(
                                child: Builder(builder: (context) {
                                  if (parentRoom.lastMessage != null) {
                                    if (parentRoom.lastMessage!.type ==
                                        "file") {
                                      return Row(
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 17,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    "assets/images/new-document.png"),
                                              ),
                                            ),
                                            // child: Center(
                                            //   child: SizedBox(
                                            //     height: 8,
                                            //     width: 12,
                                            //     child: FittedBox(
                                            //       child: Text(
                                            //         parentRoom
                                            //             .lastMessage!.fileName!
                                            //             .split(".")
                                            //             .last,
                                            //         style: const TextStyle(
                                            //           fontWeight:
                                            //               FontWeight.w400,
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
                                              parentRoom.lastMessage!.fileName!,
                                              style: TeacherAppFonts
                                                  .interW400_14sp_textWhite
                                                  .copyWith(
                                                color: const Color(0xff535353)
                                                    .withOpacity(0.8),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      );
                                    } else if (parentRoom.lastMessage!.type ==
                                        "text") {
                                      return Text(
                                        // "Can you pls share the pdf adsdaddsf.",
                                        parentRoom.lastMessage?.message
                                                ?.replaceAll('\n', ' ') ??
                                            "--",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TeacherAppFonts
                                            .interW400_14sp_textWhite
                                            .copyWith(
                                          color: const Color(0xff535353)
                                              .withOpacity(0.8),
                                        ),
                                      );
                                    } else if (parentRoom.lastMessage!.type ==
                                        "audio") {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 22,
                                            height: 15.h,
                                            child: SvgPicture.asset(
                                                "assets/images/Record Audio.svg"),
                                          ),
                                          SizedBox(width: 1.w),
                                          Expanded(
                                            child: Text(
                                              "Audio",
                                              style: TeacherAppFonts
                                                  .interW400_14sp_textWhite
                                                  .copyWith(
                                                color: const Color(0xff535353)
                                                    .withOpacity(0.8),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      );
                                    } else if (parentRoom.lastMessage!.type ==
                                            "text_file" ||
                                        parentRoom.lastMessage!.type ==
                                            "text_audio") {
                                      return Text(
                                        // "Can you pls share the pdf adsdaddsf.",
                                        parentRoom.lastMessage!.message ?? "--",
                                        overflow: TextOverflow.ellipsis,

                                        style: TeacherAppFonts
                                            .interW400_14sp_textWhite
                                            .copyWith(
                                          color: const Color(0xff535353)
                                              .withOpacity(0.8),
                                        ),
                                      );
                                    }
                                  }
                                  return const SizedBox();
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 5)
                            .w,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      borderRadius: BorderRadius.circular(20).r,
                      border: Border.all(
                        color: leadColor,
                      ),
                    ),
                    child: Text(
                      "Class ${parentRoom.datumClass}${parentRoom.batch}",
                      style: TeacherAppFonts.interW500_12sp_textWhite.copyWith(
                        color: leadColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    chatRoomDateAndTimeFormat(time),
                    style: TeacherAppFonts.interW400_12sp_topicbackground,
                  ),
                  SizedBox(height: 5.h),
                  if (parentRoom.unreadCount != null)
                    if (parentRoom.unreadCount != "0")
                      Container(
                        height: 23.h,
                        width: 23.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colorutils.topicbackground),
                        child: Center(
                          child: Text(
                            parentRoom.unreadCount.toString(),
                            style: TeacherAppFonts.interW600_14sp_textWhite,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 23.h,
                        width: 23.h,
                      )
                  else
                    SizedBox(
                      height: 23.h,
                      width: 23.h,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   height: 60,
    //   child: ListTile(
    //     leading: CircleAvatar(
    //       radius: 25,
    //       child: Text(
    //         classs,
    //         style: GoogleFonts.inter(
    //             fontSize: 16.0,
    //             fontWeight: FontWeight.w500,
    //             color: Colors.black),
    //       ),
    //     ),
    //     title: Text(
    //       className,
    //       style: GoogleFonts.inter(
    //           fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
    //     ),
    //     subtitle: Text(
    //       message,
    //       style: GoogleFonts.inter(
    //           fontSize: 13.0, fontWeight: FontWeight.w400, color: Colors.black),
    //     ),
    //     trailing: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(time),
    //         SizedBox(height: 5),
    //         if (unreadMessages > 0)
    //           CircleAvatar(
    //             radius: 10,
    //             backgroundColor: Colorutils.userdetailcolor,
    //             child: Text(
    //               unreadMessages.toString(),
    //               style: TextStyle(color: Colors.white, fontSize: 12),
    //             ),
    //           ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class MessageListShimmer extends StatelessWidget {
  const MessageListShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colorutils.white,
          borderRadius: BorderRadius.circular(20.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                period: const Duration(milliseconds: 2500),
                child: Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colorutils.bgcolor11.withOpacity(.2),
                  ),
                ),
              ),
              wSpace(15.h),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      period: const Duration(milliseconds: 2500),
                      child: Container(
                        // width: ScreenUtil().screenWidth / 2,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colorutils.bgcolor11.withOpacity(.2),
                          borderRadius: BorderRadius.circular(20.h),
                        ),
                      ),
                    ),
                    hSpace(10.h),
                    Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      period: const Duration(milliseconds: 2500),
                      child: Container(
                        // width: ScreenUtil().screenWidth / 2,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colorutils.bgcolor11.withOpacity(.2),
                          borderRadius: BorderRadius.circular(20.h),
                        ),
                      ),
                    ),
                    hSpace(10.h),
                    Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      period: const Duration(milliseconds: 2500),
                      child: Container(
                        // width: ScreenUtil().screenWidth / 2,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colorutils.bgcolor11.withOpacity(.2),
                          borderRadius: BorderRadius.circular(20.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              wSpace(15.h),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 60.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 2500),
                        child: Container(
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colorutils.bgcolor11.withOpacity(.2),
                            borderRadius: BorderRadius.circular(20.h),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 2500),
                        child: Container(
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colorutils.bgcolor11.withOpacity(.2),
                            borderRadius: BorderRadius.circular(20.h),
                          ),
                        ),
                      ),
                      // hSpace(15.h),
                      Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 2500),
                        child: Container(
                          width: 20.h,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: Colorutils.bgcolor11.withOpacity(.2),
                            borderRadius: BorderRadius.circular(20.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
