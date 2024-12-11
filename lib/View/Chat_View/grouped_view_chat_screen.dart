import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/search_controller/search_controller.dart';
import 'package:teacherapp/Models/api_models/chat_feed_view_model.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/api_constants.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/chat_search.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/text_and_file_widget.dart';
import '../../Controller/api_controllers/groupedViewController.dart';
import '../../Models/api_models/grouped_view_list_api_model.dart';
import 'Chat_widgets/audio_widget.dart';
import 'Chat_widgets/chat_date_widget.dart';
import 'Chat_widgets/file_widget.dart';
import 'Chat_widgets/sent_bubble_widget.dart';

class GroupedViewChatScreen extends StatefulWidget {
  final RoomData? roomData;
  const GroupedViewChatScreen({super.key, this.roomData});

  @override
  State<GroupedViewChatScreen> createState() => _GroupedViewChatScreenState();
}

class _GroupedViewChatScreenState extends State<GroupedViewChatScreen> {
  GroupedViewController groupedViewController =
      Get.find<GroupedViewController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  Timer? chatUpdate;

  @override
  void initState() {
    Get.find<ChatSearchController>().setValueDefault(); // for set default//
    groupedViewController.chatGroupedViewScrollController =
        AutoScrollController().obs;
    groupedViewController.showScrollIcon = false;
    initialize();
    super.initState();

    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      teacherId: userAuthController.userData.value.userId,
      schoolId: userAuthController.userData.value.schoolId,
      classs: widget.roomData?.classs,
      batch: widget.roomData?.batch,
      subjectId: widget.roomData?.subjectId,
      offset: 0,
      limit: groupedViewController.chatMsgCount,
    );

    groupedViewController.chatGroupedViewScrollController.value.addListener(() {
      print(
          "List Controller Working times ${groupedViewController.chatGroupedViewScrollController.value.offset}");
      if (groupedViewController
              .chatGroupedViewScrollController.value.position.maxScrollExtent ==
          groupedViewController.chatGroupedViewScrollController.value.offset) {
        print("List Controller Working");

        print("List Con ${groupedViewController.chatMsgCount}");

        groupedViewController.chatMsgCount =
            groupedViewController.chatMsgCount +
                groupedViewController.messageCount;
        groupedViewController.fetchMoreMessage(
            reqBody:
                // timer: _timer,
                chatFeedViewReqModel);
      }

      if (groupedViewController.chatGroupedViewScrollController.value.offset ==
          groupedViewController
              .chatGroupedViewScrollController.value.position.minScrollExtent) {
        groupedViewController.showScrollIcon = false;
        groupedViewController.setScrollerIcon();
      } else {
        groupedViewController.showScrollIcon = true;
      }
    });
  }

  void initialize() async {
    // context.loaderOverlay.show();
    Get.find<GroupedViewController>().chatMsgCount =
        Get.find<GroupedViewController>()
            .messageCount; // for set message count//
    String? userId = Get.find<UserAuthController>().userData.value.userId;
    String? schoolId = Get.find<UserAuthController>().userData.value.schoolId;
    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      classs: widget.roomData?.classs ?? '--',
      batch: widget.roomData?.batch ?? '--',
      subjectId: widget.roomData?.subjectId ?? '--',
      teacherId: userId ?? '--',
      schoolId: schoolId ?? '--',
      limit: Get.find<GroupedViewController>().chatMsgCount,
      offset: 0,
    );
    await groupedViewController.fetchFeedViewMsgList(
        chatFeedViewReqModel, context);

    if (!mounted) return;
    context.loaderOverlay.hide();
    chatUpdate = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        await groupedViewController
            .fetchFeedViewMsgListPeriodically(chatFeedViewReqModel);
      },
    );
  }

  @override
  void dispose() {
    groupedViewController.chatGroupedViewScrollController.value.dispose();
    chatUpdate!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("fhsahifh");
    print("${widget.roomData?.subjectName}  fhsahifh " ?? "fhsahifh");
    return AllChatRoomDataInheritedWidget(
      batch: widget.roomData?.batch,
      classs: widget.roomData?.classs,
      subjectId: widget.roomData?.subjectId,
      child: PopScope(
        onPopInvoked: (didPop) {
          Get.find<ChatSearchController>().hideSearch();
          Get.find<ChatSearchController>().searchValue.value = "";
          Get.find<ChatSearchController>().searchCtr.clear();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colorutils.userdetailcolor,
            leadingWidth: 40.w,
            titleSpacing: 5,
            leading: InkWell(
              onTap: () {
                if (Get.find<ChatSearchController>().isSearch) {
                  Get.find<ChatSearchController>().hideSearch();
                  Get.find<ChatSearchController>().searchValue.value = "";
                  Get.find<ChatSearchController>().searchCtr.clear();
                  print("searchList ============== onsearch");
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            title: GetBuilder<ChatSearchController>(builder: (controller) {
              return controller.isSearch
                  ? ChatSearchTextFieldWidget(
                      controller: controller,
                      searchListType: "groupMsgList",
                    )
                  : Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          padding: const EdgeInsets.all(10).w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: FittedBox(
                            child: Text(
                              "${widget.roomData?.classs}${widget.roomData?.batch}",
                              style: TeacherAppFonts.interW600_16sp_black,
                            ),
                          ),
                        ),
                        // CircleAvatar(
                        //     radius: 20.r, backgroundColor: Colors.white),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.roomData?.subjectName ?? '--',
                                  style:
                                      TeacherAppFonts.interW600_18sp_textWhite,
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10)
                                      .w,
                                  decoration: BoxDecoration(
                                    color: Colorutils.Whitecolor,
                                    borderRadius: BorderRadius.circular(28).r,
                                  ),
                                  child: Text(
                                    "${widget.roomData?.classs ?? ''}${widget.roomData?.batch ?? ''}",
                                    style: TeacherAppFonts
                                        .interW500_12sp_textWhite
                                        .copyWith(
                                      color: const Color(0xFF003D36),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.roomData?.teacherName ?? '--',
                              style: TeacherAppFonts.interW400_14sp_textWhite,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              controller.showSearch();
                            },
                            child: SizedBox(
                              height: 27.w,
                              width: 27.w,
                              child: SvgPicture.asset(
                                'assets/images/MagnifyingGlass.svg',
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
            }),
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 20),
            //     child: Container(
            //       height: 27.w,
            //       width: 27.w,
            //       child: SvgPicture.asset(
            //         'assets/images/MagnifyingGlass.svg',
            //         width: 200,
            //         height: 200,
            //       ),
            //     ),
            //   )
            // ],
          ),
          body: SizedBox(
            // height: screenHeight,

            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/chatBg.png",
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Container(
                        //   color: Colors.white.withOpacity(0.4),
                        // ),
                        const ChatList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    String userId =
        Get.find<UserAuthController>().userData.value.userId ?? '--';
    return GetX<GroupedViewController>(
      builder: (GroupedViewController controller) {
        List<MsgData> msgData = controller.chatMsgList;
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.isError.value) {
          return const Center(child: Text("Error Occurred"));
        }
        if (controller.chatMsgList.isEmpty) {
          return const Center(child: Text("No chat"));
        } else {
          return Stack(
            children: [
              GroupedListView<MsgData, String>(
                useStickyGroupSeparators: true,
                cacheExtent: 10000,
                floatingHeader: true,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                controller: controller.chatGroupedViewScrollController.value,
                groupBy: (element) {
                  try {
                    return DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(element.sendAt!));
                  } catch (e) {
                    return "--";
                  }
                },
                sort: true,
                reverse: true,
                groupComparator: (value1, value2) => value2.compareTo(value1),
                elements: msgData,
                groupSeparatorBuilder: (String groupByValue) {
                  return ChatDateWidget(date: groupByValue);
                },
                indexedItemBuilder: (context, messageDatas, index) {
                  final messageData = controller.chatMsgList[index];
                  List<StudentData> student = messageData.studentData ?? [];
                  StudentData? relation =
                      student.isNotEmpty ? student.first : StudentData();
                  String relationData =
                      "${relation.relation ?? ''} ${relation.relation != null ? 'of' : ''} ${messageData.messageFrom ?? '--'}";
                  if (index < controller.chatMsgList.length - 1) {
                    return "${messageData.messageFromId}" == userId
                        ? SentMessageBubble(
                            message: messageData.message ?? '',
                            time: messageData.sendAt,
                            replay: true,
                            audio: messageData.messageAudio,
                            fileName: messageData.fileName,
                            fileLink: messageData.messageFile,
                            messageData: messageData,
                            index: index,
                          )
                        : ReceiveMessageBubble(
                            senderName: student.isNotEmpty
                                ? messageData.studentData?.first.studentName ??
                                    '--'
                                : '--',
                            message: messageData.message,
                            time: messageData.sendAt,
                            replay: true,
                            audio: messageData.messageAudio,
                            fileName: messageData.fileName,
                            fileLink: messageData.messageFile,
                            messageData: messageData,
                            relation: relationData,
                            index: index,
                          );
                  } else {
                    return controller.showLoaderMoreMessage.value &&
                            controller.chatMsgList.length >
                                controller.messageCount
                        ? Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 25.h,
                                        width: 25.h,
                                        child: const Center(
                                            child:
                                                CircularProgressIndicator())),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      "Load More...",
                                      style: TeacherAppFonts
                                          .interW400_16sp_letters1
                                          .copyWith(color: Colors.black),
                                    )
                                  ]),
                            ),
                          )
                        : const SizedBox();
                  }
                },
                separator: SizedBox(
                  height: 5.h,
                ),
              ),
              GetBuilder<GroupedViewController>(builder: (controller2) {
                return controller2.showScrollIcon
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(15.h),
                          child: InkWell(
                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 50),
                                () {
                                  Get.find<GroupedViewController>()
                                      .chatGroupedViewScrollController
                                      .value
                                      .animateTo(
                                        Get.find<GroupedViewController>()
                                            .chatGroupedViewScrollController
                                            .value
                                            .position
                                            .minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut,
                                      );
                                },
                              );
                            },
                            child: Container(
                              width: 45.h,
                              height: 45.h,
                              decoration: const BoxDecoration(
                                color: Colorutils.Whitecolor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.h),
                                child: const FittedBox(
                                  child: Icon(
                                    Icons.keyboard_double_arrow_down_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox();
              })
            ],
          );
        }
      },
    );
  }
}

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
      required this.index});

  late Offset _tapPosition;

  bool? replay;
  String? time;
  String? message;
  MsgData? messageData;
  String? audio;
  String? fileName;
  String? fileLink;
  // String? senderId;
  final int index;

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
      controller: Get.find<GroupedViewController>()
          .chatGroupedViewScrollController
          .value,
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
                            child: IntrinsicWidth(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 310.w),
                                decoration: BoxDecoration(
                                    color: Colorutils.msgBubbleColor1,
                                    borderRadius: BorderRadius.circular(10.h)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.h),
                                  child: Column(
                                    children: [
                                      messageData!.replyData != null
                                          ? ReplayMessageWidget3(
                                              senderId:
                                                  messageData!.messageFromId,
                                              replyData:
                                                  messageData!.replyData!,
                                            )
                                          : const SizedBox(),
                                      fileName != null
                                          ? FileWidget1(
                                              fileType:
                                                  fileName!.split(".").last,
                                              fileName: fileName!,
                                              fileLink: fileLink!,
                                              messageId:
                                                  messageData?.messageId ?? "")
                                          : const SizedBox(),
                                      audio != null
                                          ? AudioWidget(
                                              content: audio!,
                                              messageId:
                                                  messageData!.messageId ?? "")
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
                                                child:
                                                    GetX<ChatSearchController>(
                                                  builder:
                                                      (chatSerchController) {
                                                    if (chatSerchController
                                                        .searchValue
                                                        .value
                                                        .isEmpty) {
                                                      return RichText(
                                                        text: TextSpan(
                                                            children: Get.find<
                                                                    GroupedViewController>()
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
                                                                        .black)),
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
                                                            .withOpacity(.25)),
                                              ),
                                              SizedBox(width: 5.h),
                                              SizedBox(
                                                height: 21.h,
                                                width: 21.h,
                                                child: SvgPicture.asset(
                                                    "assets/images/Checks.svg",
                                                    color: messageData?.read ==
                                                            null
                                                        ? Colors.grey
                                                        : messageData!.read!
                                                            ? Colors.blue
                                                            : Colors.grey),
                                              ),
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

class ReceiveMessageBubble extends StatelessWidget {
  ReceiveMessageBubble(
      {super.key,
      this.message,
      this.time,
      this.replay,
      this.audio,
      this.fileLink,
      this.fileName,
      this.senderName,
      this.messageData,
      this.relation,
      required this.index});

  bool? replay;
  String? time;
  String? message;
  String? audio;
  String? fileName;
  String? fileLink;
  String? senderName;
  MsgData? messageData;
  String? relation;
  final int index;

  late List<IncomingReact> incomingReactList;

  @override
  Widget build(BuildContext context) {
    if (messageData!.incomingReact == null) {
      incomingReactList = [];
    } else {
      incomingReactList = messageData!.incomingReact!;
    }
    List<StudentData> student = messageData?.studentData ?? [];
    StudentData? relation = student.isNotEmpty ? student.first : StudentData();
    String msgLeftSideTitle = student.isNotEmpty
        ? student.first.studentName ?? "--"
        : messageData?.messageFrom ?? "--";
    String msgRightSideTitle = getRightSideTitle(messageData!);
    return AutoScrollTag(
      index: index,
      highlightColor: Colors.teal.shade200,
      controller: Get.find<GroupedViewController>()
          .chatGroupedViewScrollController
          .value,
      key: ValueKey(index),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // widget.msgData?.isClassTeacher ==
                      // true
                      // ?
                      Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colorutils.white),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.h),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${ApiConstants.downloadUrl}${messageData!.userImage}',
                            placeholder: (context, url) => SizedBox(
                              height: 27.h,
                              width: 27.h,
                              child: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              height: 27.h,
                              width: 27.h,
                              child: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //     : const SizedBox(),
                      Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: -2.w,
                            child: SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: SvgPicture.asset(
                                  "assets/images/MessageBubbleShape2.svg",
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 310.w),
                              decoration: BoxDecoration(
                                  color: Colorutils.fontColor8,
                                  borderRadius: BorderRadius.circular(10.h)),
                              child: Padding(
                                padding: EdgeInsets.all(10.h),
                                child: Stack(
                                  children: [
                                    IntrinsicWidth(
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 90.w),
                                                child: Text(
                                                  "~${msgLeftSideTitle}",
                                                  // senderName == null
                                                  //     ? "--"
                                                  //     : "~ ${senderName?.split(" ").first ?? ""}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TeacherAppFonts
                                                      .interW700_12sp_textWhite
                                                      .copyWith(
                                                          color: Colorutils
                                                              .fontColor5),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 130.w),
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.right,
                                                  // "Arabic",
                                                  msgRightSideTitle ?? "--",

                                                  style: TeacherAppFonts
                                                      .interW400_12sp_textWhite_italic
                                                      .copyWith(
                                                          color: Colorutils
                                                              .fontColor10),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          messageData!.replyData != null
                                              ? ReplayMessageWidget3(
                                                  senderId: messageData!
                                                      .messageFromId,
                                                  replyData:
                                                      messageData!.replyData!,
                                                )
                                              : const SizedBox(),
                                          fileName != null
                                              ? FileWidget2(
                                                  fileType:
                                                      fileName!.split(".").last,
                                                  fileName: fileName!,
                                                  fileLink: fileLink!,
                                                  messageId:
                                                      messageData?.messageId ??
                                                          "")
                                              : const SizedBox(),
                                          audio != null
                                              ? AudioWidget2(
                                                  content: audio!,
                                                  messageId:
                                                      messageData!.messageId ??
                                                          "")
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
                                                  //     maxWidth: 210.w,
                                                  //   ),
                                                  //   child: Text(
                                                  //     message ?? "",
                                                  //     maxLines: 100,
                                                  //     style: TeacherAppFonts
                                                  //         .interW400_16sp_letters1
                                                  //         .copyWith(color: Colors.black),
                                                  //   ),
                                                  // ),
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: 180.w,
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
                                                                        GroupedViewController>()
                                                                    .getMessageText(
                                                                        text: message ??
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
                                                                children: Get.find<ChatSearchController>().getCombinedTextSpan(
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
                                                                            .black)),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                ],
                                              ),
                                              SizedBox(width: 20.h),
                                              Text(
                                                // "17:47",
                                                messageBubbleTimeFormat(time),
                                                style: TeacherAppFonts
                                                    .interW400_12sp_topicbackground
                                                    .copyWith(
                                                        color: Colors.black
                                                            .withOpacity(.25)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                  : SizedBox(height: 20.h),
            ],
          ),
          incomingReactList.isEmpty && messageData!.myReact == null
              ? const SizedBox()
              : Positioned(
                  bottom: 0,
                  // left: widget.msgData?.isClassTeacher == true ? 90.w : 50.w,
                  left: 90.w,
                  child: GestureDetector(
                    onTap: () {
                      reactionBottomSheet(
                          context, incomingReactList, messageData!.myReact);
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 30.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.h),
                        ),
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
                                      ? Text("${incomingReactList.length - 2}")
                                      : const SizedBox()
                                  : incomingReactList.length >= 2
                                      ? Text("${incomingReactList.length - 1}")
                                      : const SizedBox(),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  String getRightSideTitle(MsgData messageData) {
    print("Start working ------------ ");
    if (messageData.roleName == "parents") {
      List<StudentData> student = messageData.studentData ?? [];
      StudentData? relation =
          student.isNotEmpty ? student.first : StudentData();
      // String msgRightSideTitle = student.isNotEmpty
      //     ? "${relation.relation ?? ''} ${relation.relation != null ? 'of' : ''} ${messageData?.messageFrom ?? '--'}"
      //     : messageData?.subjectName ?? "--";

      return "${relation.relation ?? ''} ${relation.relation != null ? 'of' : ''} ${messageData.messageFrom ?? '--'}";
    } else if (messageData.roleName == "teacher") {
      return messageData.subjectName ?? "";
    } else {
      String role = messageData.roleName ?? "";
      return role.capitalizeFirst!;
    }
  }
}

class ReplayMessageWidget3 extends StatelessWidget {
  ReplayMessageWidget3({super.key, required this.replyData, this.senderId});
  final ReplyData replyData;
  final String? senderId;
  // FeedViewController feedViewController = Get.find<FeedViewController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  @override
  Widget build(BuildContext context) {
    final data = AllChatRoomDataInheritedWidget.of(context);
    return GestureDetector(
      onTap: () async {
        Get.find<GroupedViewController>().chatMsgCount = 1000;
        ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
          teacherId: userAuthController.userData.value.userId,
          schoolId: userAuthController.userData.value.schoolId,
          classs: data?.classs,
          batch: data?.batch,
          subjectId: data?.subjectId,
          offset: 0,
          limit: Get.find<GroupedViewController>().chatMsgCount,
        );
        print("message number = id = ${replyData.messageId}");
        // print(
        //     "message number = userAuthController.userData.value.userId = ${userAuthController.userData.value.userId}");
        // print(
        //     "message number = userAuthController.userData.value.schoolId = ${userAuthController.userData.value.schoolId}");
        // print(
        //     "message number =  data?.msgData?.classTeacherClass = ${data?.msgData?.classTeacherClass}");
        // print(
        //     "message number = data?.msgData?.batch = ${data?.msgData?.batch}");
        // print(
        //     "message number = data?.msgData?.subjectId = ${data?.msgData?.subjectId}");

        int? index = await Get.find<GroupedViewController>().findMessageIndex(
            reqBody: chatFeedViewReqModel,
            msgId: replyData.messageId,
            context: context);

        print("message number = index = $index");

        if (index != null) {
          await Get.find<GroupedViewController>()
              .chatGroupedViewScrollController
              .value
              .scrollToIndex(
                index,
                preferPosition: AutoScrollPosition.middle,
              );
          await Get.find<GroupedViewController>()
              .chatGroupedViewScrollController
              .value
              .highlight(index,
                  highlightDuration: const Duration(seconds: 1),
                  animated: true);
        } else {
          snackBar(
              context: context,
              message: "Message not found",
              color: Colorutils.Classcolour1);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: IntrinsicHeight(
          child: Container(
            constraints: BoxConstraints(maxWidth: 230.w),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: Colorutils.userdetailcolor, width: 3.w)),
                color: senderId ==
                        Get.find<UserAuthController>().userData.value.userId
                    ? Colorutils.fontColor17
                    : Colorutils.replayBg,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.w),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                            replyData.messageFromId ==
                                    Get.find<UserAuthController>()
                                        .userData
                                        .value
                                        .userId
                                ? "You"
                                : "~ ${replyData.messageFromName ?? "--"}",
                            overflow: TextOverflow.ellipsis,
                            style: TeacherAppFonts.interW600_14sp_letters1
                            // style: FontsStyle()
                            //     .interW600_16sp
                            //     .copyWith(color: ColorUtil.gradientColorEnd),
                            ),
                      ),
                      TextAndFileWidget(replyData: replyData),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class AllChatRoomDataInheritedWidget extends InheritedWidget {
  final String? classs;
  final String? batch;
  final String? subjectId;
  const AllChatRoomDataInheritedWidget({
    this.classs,
    this.batch,
    this.subjectId,
    required Widget child,
  }) : super(child: child);

  static AllChatRoomDataInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AllChatRoomDataInheritedWidget>();
  }

  @override
  bool updateShouldNotify(AllChatRoomDataInheritedWidget oldWidget) {
    // return int1 != oldWidget.int1 || int2 != oldWidget.int2;
    return classs != oldWidget.classs ||
        batch != oldWidget.batch ||
        subjectId != oldWidget.subjectId;
  }
}
