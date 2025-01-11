import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Controller/api_controllers/groupedViewListController.dart';
import 'package:teacherapp/Controller/db_controller/group_db_controller.dart';
import 'package:teacherapp/Models/api_models/grouped_view_list_api_model.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/group_chat_list.dart';
import '../../Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/chat_group_api_model.dart';
import '../../Utils/Colors.dart';
import '../../Utils/font_util.dart';
import '../Chat_List/chat_list_widgets/last_seen_msg.dart';
import 'grouped_view_chat_screen.dart';

class GroupedViewChat extends StatelessWidget {
  final ClassTeacherGroup? msgData;
  const GroupedViewChat({super.key, required this.msgData});

  @override
  Widget build(BuildContext context) {
    print("message number === ${msgData?.batch}");
    return Container(
      color: Colorutils.Whitecolor,
      child: GetX<GroupedViewListController>(
        builder: (GroupedViewListController controller) {
          List<RoomData> room = controller.roomList.value;
          if (controller.searchText.isNotEmpty) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: controller.searchroomList.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (BuildContext context, int index) {
                final data = controller.searchroomList[index];
                DateTime? sentTime;
                try {
                  sentTime =
                      DateTime.parse(data.lastMessage!.sandAt.toString());
                } catch (e) {}
                // String? formattedDate;
                try {
                  // formattedDate = DateFormat('EEE hh:mm a').format(sentTime!);
                } catch (e) {}
                String? userId =
                    Get.find<UserAuthController>().userData.value.userId;
                return ChatItem(
                  time: sentTime.toString(),
                  lastMessage: data.lastMessage,
                  userId: userId,
                  classTeacherGroup: data,
                  avatarColor: Colorutils.chatLeadingColors[index % 5],
                  unreadMessages: 0,
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
          if (controller.isLoading.value) {
            return ListView.separated(
                padding: const EdgeInsets.only(bottom: 15),
                itemBuilder: (context, index) => const ChatListShimmer(),
                separatorBuilder: (context, index) => const Divider(
                      color: Colorutils.dividerColor1,
                      height: 0,
                    ),
                itemCount: 10);
          } else if (controller.dbLoader.value == true) {
            return const Center(
              child: Text("Loading..."),
            );
          }
          // else if (controller.isError.value) {
          //   return const Center(child: Text("Error Occurred"));
          // }
          else if (controller.roomList.isEmpty) {
            return const Center(child: Text("No chat"));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await Get.find<GroupedViewListController>()
                    .fetchGroupedViewList(context);
              },
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: room.length,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) {
                  DateTime? sentTime;
                  try {
                    sentTime = DateTime.parse(
                        room[index].lastMessage!.sandAt.toString());
                  } catch (e) {}
                  String? formattedDate;
                  try {
                    formattedDate = DateFormat('EEE hh:mm a').format(sentTime!);
                  } catch (e) {}
                  String? userId =
                      Get.find<UserAuthController>().userData.value.userId;
                  return ChatItem(
                    time: sentTime.toString(),
                    lastMessage: room[index].lastMessage,
                    userId: userId,
                    classTeacherGroup: room[index],
                    avatarColor: Colorutils.chatLeadingColors[index % 5],
                    unreadMessages: 0,
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
            );
          }
        },
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String time;
  final int? unreadMessages;
  final String? userId;
  final LastMessageGroupedView? lastMessage;
  final RoomData? classTeacherGroup;
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
    return InkWell(
      onTap: () async {
        await Get.find<GroupDbController>().createMessageTable(
            subId: classTeacherGroup?.subjectId ?? "",
            studentclass: classTeacherGroup?.classs ?? "",
            batch: classTeacherGroup?.batch ?? "");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupedViewChatScreen(
                roomData: classTeacherGroup,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10).w,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: avatarColor,
              radius: 28.r,
              child: FittedBox(
                child: Text(
                  '${classTeacherGroup?.classs}${classTeacherGroup?.batch}',
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
                              constraints:
                                  const BoxConstraints(maxWidth: 120).w,
                              child: Text(
                                // "English",
                                classTeacherGroup?.subjectName ?? '--',
                                style: TeacherAppFonts.interW700_16sp_black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 80).w,
                                child: Text(
                                  // "English",
                                  classTeacherGroup?.teacherName ?? '--',
                                  style: TeacherAppFonts
                                      .interW400_14sp_textWhite
                                      .copyWith(
                                    color: Colorutils.fontColor6,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                    color: Colors.blue,
                                  ),
                                ),
                            if (userId != null && lastMessage != null)
                              if (userId == lastMessage!.messageFromId)
                                SizedBox(width: 5.h),
                            LastSeenMsgGroupedViewChat(
                                lastMessage: classTeacherGroup!.lastMessage),
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
                  chatRoomDateAndTimeFormat(time),
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
      ),
    );
  }
}
