import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/group_chat_list.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/parent_chat_list.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/chat_appBar.dart';
import '../../Controller/api_controllers/chatClassGroupController.dart';
import '../../Models/api_models/chat_group_api_model.dart';
import '../../Models/api_models/parent_chat_list_api_model.dart';
import '../../Utils/constants.dart';
import '../../Utils/font_util.dart';
import '../Chat_List/chat_list_widgets/last_seen_msg.dart';

class ChatWithParentsDummyLayer extends StatefulWidget {
  const ChatWithParentsDummyLayer({super.key});

  @override
  State<ChatWithParentsDummyLayer> createState() =>
      _ChatWithParentsDummyLayerState();
}

class _ChatWithParentsDummyLayerState extends State<ChatWithParentsDummyLayer>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: const ChatAppBar(),
        body: Column(
          children: [
            Container(
              height: 100.h,
              color: Colorutils.userdetailcolor,
              padding: const EdgeInsets.symmetric(horizontal: 16).w,
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Text(
                    'Chat with Parents',
                    style: GoogleFonts.inter(
                      fontSize: 25.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/images/MagnifyingGlass.svg',
                    width: 27.h,
                    fit: BoxFit.fitWidth,
                  ),
                  GetX<ChatClassGroupController>(
                    builder: (ChatClassGroupController controller) {
                      if (controller.currentChatTab.value == 1) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6).w,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4.0).w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100).w),
                              child: Icon(
                                Icons.add,
                                color: Colorutils.letters1,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 0,
                          height: 0,
                          color: Colorutils.userdetailcolor,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 55.h,
              color: Colorutils.userdetailcolor,
              alignment: Alignment.bottomCenter,
              child: TabBar(
                onTap: (index) {},
                controller: _tabController,
                tabAlignment: TabAlignment.center,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                tabs: <Widget>[
                  Container(
                    width: 180.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/images/chatting_icon.svg",
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Class List",
                          style: GoogleFonts.inter(
                            color: Colorutils.Whitecolor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.h,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GetX<ChatClassGroupController>(
                          builder: (ChatClassGroupController controller) {
                            int count = controller.unreadCount.value;
                            if (count != 0) {
                              return CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 10,
                                child: Text(
                                  count.toString(),
                                  style: GoogleFonts.inter(
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Chats",
                          style: GoogleFonts.inter(
                            color: Colorutils.Whitecolor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.h,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GetX<ParentChatListController>(
                          builder: (ParentChatListController controller) {
                            int count = controller.unreadCount.value;
                            if (count != 0) {
                              return CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 10,
                                child: Text(
                                  count.toString(),
                                  style: GoogleFonts.inter(
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  GroupChatList(),
                  ParentChatList(),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   zoomDrawerController: widget.zoomDrawerController,
        // ),
      ),
    );
  }
}

class GroupChatList extends StatelessWidget {
  const GroupChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // int colorInt = 0;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        LastMessageGroupChat? lastMsg = LastMessageGroupChat();
        DateTime? sentTime = lastMsg.sandAt;
        String? formattedDate;
        // if(colorInt > 4) {
        //   colorInt = 0;
        // }
        // colorInt++;
        // print("-------colorInt---------$colorInt");
        try {
          formattedDate = DateFormat('EEE hh:mm a').format(sentTime!);
        } catch (e) {}
        return ChatItem(
          // className: classTeacherGroups[index].subjectName ?? '--',
          time: formattedDate ?? '',
          unreadMessages: 0,
          // classs: '${classTeacherGroups[imkvkosdmvksfmnvbndex].classTeacherClass}${classTeacherGroups[index].batch}',
          lastMessage: lastMsg,
          userId: "userId",
          classTeacherGroup: ClassTeacherGroup(
            subjectName: '--',
            classTeacherClass: '--',
            batch: '--',
          ),
          avatarColor: Colorutils.chatLeadingColors[index % 5],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 0.3,
          indent: 15,
          endIndent: 15,
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  final String time;
  final int? unreadMessages;
  final String? userId;
  final LastMessageGroupChat? lastMessage;
  final ClassTeacherGroup? classTeacherGroup;
  final Color? avatarColor;

  const ChatItem({
    super.key,
    required this.time,
    required this.unreadMessages,
    required this.userId,
    required this.lastMessage,
    required this.classTeacherGroup,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10).w,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 28.r,
            child: FittedBox(
              child: Text(
                '${classTeacherGroup?.classTeacherClass}${classTeacherGroup?.batch}',
                style: TeacherAppFonts.interW600_14sp_textWhite,
              ),
            ),
          ),
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
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              // "English",
                              classTeacherGroup?.subjectName ?? '--',
                              style: TeacherAppFonts.interW700_16sp_black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          if (userId != null && lastMessage != null)
                            if (userId == lastMessage!.messageFromId)
                              SizedBox(
                                height: 21.h,
                                width: 21.h,
                                child: SvgPicture.asset(
                                  "assets/images/Checks.svg",
                                  color: lastMessage!.read!
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                          if (userId != null && lastMessage != null)
                            if (userId == lastMessage!.messageFromId)
                              SizedBox(width: 5.h),
                          LastSeenMsgGroupChat(lastMessage: lastMessage),
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
              Text(
                time,
                style: TeacherAppFonts.interW400_12sp_topicbackground,
              ),
              SizedBox(height: 10.h),
              if (unreadMessages != null)
                if (unreadMessages != 0)
                  Container(
                    height: 23.h,
                    width: 23.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colorutils.topicbackground),
                    child: Center(
                      child: Text(
                        unreadMessages.toString(),
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
    );
  }
}

class ParentChatList extends StatelessWidget {
  const ParentChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GetX<ParentChatListController>(
            builder: (ParentChatListController controller) {
              int currentIndex = controller.currentTab.value;
              return Container(
                height: 50.w,
                child: Row(
                  children: [
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
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              LastMessage? lastMsg = LastMessage();
              DateTime? sentTime = lastMsg.sandAt;
              String? formattedDate;
              try {
                formattedDate = DateFormat('EEE hh:mm a').format(sentTime!);
              } catch (e) {}
              return ChatItemParent(
                time: formattedDate ?? '',
                userId: "userId",
                leadColor: Colorutils.chatLeadingColors[index % 5],
                parentRoom: Datum(),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 0.3,
                indent: 15,
                endIndent: 15,
              );
            },
          ),
        )
      ],
    );
  }
}

class ChatItemParent extends StatelessWidget {
  final String time;
  final String? userId;
  final Color leadColor;
  final Datum parentRoom;
  // final String Parentdetail;
  // final String classsdetail;

  const ChatItemParent({
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
    return Padding(
      padding: EdgeInsets.all(15.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: leadColor,
            radius: 28.r,
            child: FittedBox(
              child: Text(
                "${parentRoom.datumClass}${parentRoom.batch}",
                style: TeacherAppFonts.interW600_14sp_textWhite,
              ),
            ),
          ),
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
                            constraints: const BoxConstraints(maxWidth: 120),
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
                          Expanded(
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
                          if (userId != null && parentRoom.lastMessage != null)
                            if (userId == parentRoom.lastMessage!.messageFromId)
                              SizedBox(
                                height: 21.h,
                                width: 21.h,
                                child: SvgPicture.asset(
                                  "assets/images/Checks.svg",
                                  color: parentRoom.lastMessage!.read!
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                          if (userId != null && parentRoom.lastMessage != null)
                            if (userId == parentRoom.lastMessage!.messageFromId)
                              SizedBox(width: 5.h),
                          Expanded(
                            child: Builder(builder: (context) {
                              if (parentRoom.lastMessage != null) {
                                if (parentRoom.lastMessage!.type == "file") {
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
                                        //         parentRoom.lastMessage!.fileName!
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
                                          parentRoom.lastMessage!.fileName!,
                                          style: TeacherAppFonts
                                              .interW400_14sp_textWhite
                                              .copyWith(
                                            color: Color(0xff535353)
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
                                    parentRoom.lastMessage?.message ?? "--",
                                    overflow: TextOverflow.ellipsis,

                                    style: TeacherAppFonts
                                        .interW400_14sp_textWhite
                                        .copyWith(
                                      color: Color(0xff535353).withOpacity(0.8),
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
                                            color: Color(0xff535353)
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
                                      color: Color(0xff535353).withOpacity(0.8),
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
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 5).w,
                decoration: BoxDecoration(
                  color: Colorutils.Whitecolor,
                  borderRadius: BorderRadius.circular(20).r,
                  border: Border.all(
                    color: leadColor,
                  ),
                ),
                child: Text(
                  "Class ${parentRoom.datumClass}",
                  style: TeacherAppFonts.interW500_12sp_textWhite.copyWith(
                    color: leadColor,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                time,
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
