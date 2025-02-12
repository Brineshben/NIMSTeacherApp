import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/groupedViewListController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/db_controller/Feed_db_controller.dart';
import 'package:teacherapp/Controller/search_controller/search_controller.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Services/warning_dialog.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/chat_search.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/parent_select_bottomSheet.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/selected_parents_view.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../Controller/ui_controllers/page_controller.dart';
import '../../Models/api_models/chat_feed_view_model.dart';
import '../../Models/api_models/chat_group_api_model.dart';
import '../../Services/check_connectivity.dart';
import '../../Services/dialog_box.dart';
import '../../Services/fcm_service.dart';
import '../../Services/snackBar.dart';
import '../CWidgets/TeacherAppPopUps.dart';
import 'Grouped_view.dart';
import 'Chat_widgets/camera_screen.dart';
import 'Chat_widgets/chat_audioPlaying_widget.dart';
import 'Chat_widgets/chat_audioRecording_widget.dart';
import 'Chat_widgets/chat_date_widget.dart';
import 'Chat_widgets/more_option_widget.dart';
import 'Chat_widgets/reaction_widget.dart';
import 'Chat_widgets/receive_bubble_widget.dart';
import 'Chat_widgets/sent_bubble_widget.dart';
import 'Chat_widgets/swape_to.dart';

class FeedViewChatScreen extends StatefulWidget {
  final ClassTeacherGroup? msgData;
  const FeedViewChatScreen({super.key, this.msgData});

  @override
  State<FeedViewChatScreen> createState() => _FeedViewChatScreenState();
}

class _FeedViewChatScreenState extends State<FeedViewChatScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController messageCtr = TextEditingController();
  FeedViewController feedViewController = Get.find<FeedViewController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  GroupedViewListController groupedViewListController =
      Get.find<GroupedViewListController>();
  Timer? chatUpdate;

  // late bool isKeboardOpen;
  // late double keybordHeight;
  //
  // late double screenHeight;
  TabController? tabController;

  @override
  void initState() {
    Get.find<PageIndexController>().message.value = null;
    Get.find<PageIndexController>().isChatScreen.value = true;
    super.initState();
    Get.find<ChatSearchController>().setValueDefault(); // for set default//
    Get.find<FeedViewController>().showSelectAllIcon.value =
        true; // for set default//
    Get.find<FeedViewController>().isShowDialogShow =
        false; // for set default//
    Get.find<FeedViewController>().chatMsgCount =
        Get.find<FeedViewController>().messageCount; // for set message count//
    Get.find<FeedViewController>().chatFeedViewScrollController =
        AutoScrollController().obs;
    Get.find<FeedViewController>().showScrollIcon = false;
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(() async {
      feedViewController.tabControllerIndex.value = tabController!.index;
      if (tabController?.index == 0) {
        // await Future.delayed(const Duration(milliseconds: 50), () {
        //   feedViewController.chatFeedViewScrollController.value.animateTo(
        //     feedViewController
        //         .chatFeedViewScrollController.value.position.maxScrollExtent,
        //     duration: const Duration(milliseconds: 200),
        //     curve: Curves.easeOut,
        //   );
        // });
      }
    });
    Get.find<FeedViewController>().isPeriodicFetching =
        false; // for set default//

    Get.find<FeedDBController>().isResentWorking == false;
    initialize();
    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      teacherId: userAuthController.userData.value.userId,
      schoolId: userAuthController.userData.value.schoolId,
      classs: widget.msgData?.classTeacherClass,
      batch: widget.msgData?.batch,
      subjectId: widget.msgData?.subjectId,
      offset: 0,
      limit: Get.find<FeedViewController>().chatMsgCount,
    );

    feedViewController.isReplay.value = null;

    Get.find<FeedViewController>()
        .chatFeedViewScrollController
        .value
        .addListener(() {
      // print(
      //     "List Controller Working times ${Get.find<FeedViewController>().chatFeedViewScrollController.value.offset}");
      if (Get.find<FeedViewController>()
              .chatFeedViewScrollController
              .value
              .position
              .maxScrollExtent ==
          Get.find<FeedViewController>()
              .chatFeedViewScrollController
              .value
              .offset) {
        print("List Controller Working");

        print("List Con ${Get.find<FeedViewController>().chatMsgCount}");

        Get.find<FeedViewController>().chatMsgCount =
            Get.find<FeedViewController>().chatMsgCount +
                Get.find<FeedViewController>().messageCount;
        Get.find<FeedViewController>()
            .fetchMoreMessage(reqBody: chatFeedViewReqModel);
      }

      if (Get.find<FeedViewController>()
              .chatFeedViewScrollController
              .value
              .offset ==
          Get.find<FeedViewController>()
              .chatFeedViewScrollController
              .value
              .position
              .minScrollExtent) {
        Get.find<FeedViewController>().showScrollIcon = false;
        Get.find<FeedViewController>().setScrollerIcon();
      } else {
        Get.find<FeedViewController>().showScrollIcon = true;
      }
    });
    Get.find<FeedViewController>().isSentLoading.value = false;
  }

  @override
  void dispose() {
    // Get.find<FeedViewController>().chatFeedViewScrollController.value.dispose();
    Get.find<PageIndexController>().isChatScreen.value = false;
    if (chatUpdate != null) {
      chatUpdate!.cancel();
    }
    super.dispose();
  }

  Future<void> initialize() async {
    // context.loaderOverlay.show();
    int notiId = "${widget.msgData?.classTeacherClass}${widget.msgData?.batch}${widget.msgData?.subjectId}".hashCode;
    await FcmService().removeNotificationWithPayload(notiId);

    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      teacherId: userAuthController.userData.value.userId,
      schoolId: userAuthController.userData.value.schoolId,
      classs: widget.msgData?.classTeacherClass,
      batch: widget.msgData?.batch,
      subjectId: widget.msgData?.subjectId,
      offset: 0,
      limit: Get.find<FeedViewController>().chatMsgCount,
    );
    //---- -- ------ //
    await feedViewController.fetchParentList(
      classs: chatFeedViewReqModel.classs ?? '--',
      batch: chatFeedViewReqModel.batch ?? '--',
      subId: chatFeedViewReqModel.subjectId ?? '--',
      schoolId: chatFeedViewReqModel.schoolId ?? '--',
    );
    //---- -- ------ //
    await feedViewController.fetchFeedViewMsgList(
        chatFeedViewReqModel, context);
    await groupedViewListController.fetchGroupedViewList(context);
    if (!mounted) return;
    context.loaderOverlay.hide();

    chatUpdate = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        if (Get.find<FeedDBController>().isResentWorking == false) {
          await Get.find<FeedDBController>().resentUnsentMessage(
              studentClass: widget.msgData?.classTeacherClass ?? "",
              batch: widget.msgData?.batch ?? "",
              teacherId: Get.find<UserAuthController>().userData.value.userId!,
              subId: widget.msgData?.subjectId ?? "",
              context: context);
        }
        await feedViewController
            .fetchFeedViewMsgListPeriodically(chatFeedViewReqModel);
        await groupedViewListController.fetchGroupedViewListPeriodically();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        Get.find<GroupedViewListController>().searchText.value = '';
        Get.find<GroupedViewListController>().isSearch.value = false;
      },
      child: ChatRoomDataInheritedWidget(
        msgData: widget.msgData,
        child: Scaffold(
          backgroundColor: Color(0xffEDF3F3),
          appBar: AppBar(
            backgroundColor: Colorutils.userdetailcolor,
            leadingWidth: 50.w,
            titleSpacing: 5,
            leading: InkWell(
              onTap: () {
                if (Get.find<ChatSearchController>().isSearch ||
                    Get.find<GroupedViewListController>().isSearch.value) {
                  Get.find<GroupedViewListController>().isSearch.value = false;
                  Get.find<GroupedViewListController>().searchroomList.value =
                      [];
                  Get.find<GroupedViewListController>().searchText.value = '';

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
                      searchListType: "feedMsgList",
                    )
                  : GetX<GroupedViewListController>(
                      builder: (controller3) {
                        return controller3.isSearch.value
                            ? Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                            Radius.circular(15))
                                        .r,
                                    color: Colors.white,
                                  ),
                                  child: CupertinoSearchTextField(
                                    backgroundColor: Colors.white,
                                    onChanged: (value) {
                                      controller3.searchChatRoom(value);
                                    },
                                  ),
                                ),
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
                                        "${widget.msgData?.classTeacherClass}${widget.msgData?.batch}",
                                        style: TeacherAppFonts
                                            .interW600_16sp_black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 170.w),
                                    child: TextScroll(
                                      widget.msgData?.subjectName ?? '--',
                                      style: GoogleFonts.inter(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                      mode: TextScrollMode.bouncing,
                                      velocity: const Velocity(
                                          pixelsPerSecond: Offset(40, 0)),
                                      delayBefore: const Duration(seconds: 1),
                                      numberOfReps: 3,
                                      pauseBetween: const Duration(seconds: 1),
                                      textAlign: TextAlign.right,
                                      selectable: true,
                                    ),
                                  ),
                                  const Spacer(),
                                  GetX<FeedViewController>(
                                      builder: (controller2) {
                                    return feedViewController
                                                .tabControllerIndex.value ==
                                            0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
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
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                // controller.showSearch();
                                                controller3.isSearch.value =
                                                    true;
                                                // ""
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
                                          );
                                    // : const SizedBox();
                                  })
                                ],
                              );
                      },
                    );
            }),
          ),
          body: SizedBox(
            // height: screenHeight,
            child: Column(
              children: [
                // Container(height: 10.h, color: Colorutils.userdetailcolor),
                widget.msgData?.isClassTeacher == true
                    ? Column(
                        children: [
                          Container(
                            color: Colorutils.userdetailcolor,
                            child: GetX<FeedViewController>(
                              builder: (controller) {
                                return TabBar(
                                  onTap: (_) {
                                    // for clearing the whole values in both search (feed and group) //
                                    Get.find<GroupedViewListController>()
                                        .isSearch
                                        .value = false;
                                    Get.find<GroupedViewListController>()
                                        .searchroomList
                                        .value = [];

                                    Get.find<ChatSearchController>()
                                        .hideSearch();
                                    Get.find<ChatSearchController>()
                                        .searchValue
                                        .value = "";
                                    Get.find<ChatSearchController>()
                                        .searchCtr
                                        .clear();
                                  },
                                  tabAlignment: TabAlignment.center,
                                  controller: tabController,
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  isScrollable: true,
                                  dividerHeight: 0,
                                  indicatorPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  tabs: <Widget>[
                                    Container(
                                      width: 180.w,
                                      height: 40.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Feed View',
                                            style: TeacherAppFonts
                                                .interW700_16sp_textWhite,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          if (controller
                                                  .feedUnreadCount.value !=
                                              0)
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 11.r,
                                              child: FittedBox(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0)
                                                          .w,
                                                  child: Text(
                                                    controller
                                                        .feedUnreadCount.value
                                                        .toString(),
                                                    style: GoogleFonts.inter(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colorutils
                                                            .letters1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 180.w,
                                      height: 40.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Grouped View',
                                            style: TeacherAppFonts
                                                .interW700_16sp_textWhite,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          GetX<GroupedViewListController>(
                                            builder: (GroupedViewListController
                                                groupedViewController) {
                                              int count = groupedViewController
                                                  .unreadCount.value;
                                              print(
                                                  "-------count--------$count");
                                              if (count != 0) {
                                                return CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 11.r,
                                                  child: FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                                  2.0)
                                                              .w,
                                                      child: Text(
                                                        groupedViewController
                                                            .unreadCount.value
                                                            .toString(),
                                                        style: GoogleFonts.inter(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colorutils
                                                                .letters1),
                                                      ),
                                                    ),
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
                                );
                              },
                            ),
                          ),
                          Container(
                            color: Colorutils.userdetailcolor,
                            height: 1.h,
                            width: double.infinity,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Expanded(
                  child: widget.msgData?.isClassTeacher == true
                      ? TabBarView(controller: tabController, children: [
                          Column(
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
                                      ChatList(widget: widget),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                    left: 10, bottom: 10)
                                                .w,
                                            child: GetX<FeedViewController>(
                                                builder: (controller) {
                                              return controller
                                                      .showSelectAllIcon.value
                                                  ? SizedBox()
                                                  : const SelectedParentsList();
                                            })),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              FeedViewTextField(
                                  feedViewController: feedViewController,
                                  messageCtr: messageCtr,
                                  widget: widget,
                                  userAuthController: userAuthController)
                            ],
                          ),
                          GroupedViewChat(msgData: widget.msgData)
                        ])
                      : Column(
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
                                    //   color: Colors.white.withOpacity(0.6),
                                    // ),
                                    ChatList(
                                      widget: widget,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                                left: 10, bottom: 10)
                                            .w,
                                        child: GetX<FeedViewController>(
                                            builder: (controller) {
                                          print(
                                              "dahsud --------- ${controller.showSelectAllIcon.value}");
                                          return controller
                                                  .showSelectAllIcon.value
                                              ? SizedBox()
                                              : const SelectedParentsList();
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FeedViewTextField(
                                feedViewController: feedViewController,
                                messageCtr: messageCtr,
                                widget: widget,
                                userAuthController: userAuthController)
                          ],
                        ),
                ),
                // FeedViewTextField(
                //     feedViewController: feedViewController,
                //     messageCtr: messageCtr,
                //     widget: widget,
                //     userAuthController: userAuthController)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedViewTextField extends StatelessWidget {
  const FeedViewTextField({
    super.key,
    required this.feedViewController,
    required this.messageCtr,
    required this.widget,
    required this.userAuthController,
  });

  final FeedViewController feedViewController;
  final TextEditingController messageCtr;
  final FeedViewChatScreen widget;
  final UserAuthController userAuthController;

  @override
  Widget build(BuildContext context) {
    Get.find<FeedViewController>().ontype.value = "";
    return GetX<FeedViewController>(
      builder: (FeedViewController controller) {
        return Container(
          width: double.infinity,
          color: Colorutils.bgcolor9,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              children: [
                controller.filePathList.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          hSpace(10.h),
                          Text(
                            "Attachments (${controller.filePathList.length})",
                            style: TeacherAppFonts.interW600_16sp_black
                                .copyWith(color: Colors.teal),
                          ),
                          hSpace(10.h),
                          Container(
                            constraints: BoxConstraints(maxHeight: 200.h),
                            child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colorutils.white,
                                      borderRadius: BorderRadius.circular(10.h),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25.w,
                                            height: 30.w,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    "assets/images/new-document.png"),
                                              ),
                                            ),
                                            // child: Center(
                                            //     child: Text(
                                            //   controller.filePathList[index]
                                            //       .split(".")
                                            //       .last,
                                            //   style: TeacherAppFonts
                                            //       .interW500_12sp_textWhite
                                            //       .copyWith(
                                            //     fontSize: 10.sp,
                                            //     color: Colors.black,
                                            //   ),
                                            // )),
                                          ),
                                          wSpace(5),
                                          Expanded(
                                            child: Text(
                                              controller.filePathList[index]
                                                  .split("/")
                                                  .last,
                                              style: TeacherAppFonts
                                                  .interW400_16sp_letters1
                                                  .copyWith(
                                                      color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller
                                                  .removeSelectedAttachment(
                                                      index);
                                            },
                                            child: SizedBox(
                                              width: 25.w,
                                              height: 40.w,
                                              child: const Icon(
                                                Icons.close,
                                                color: Colorutils.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return hSpace(5.h);
                                },
                                itemCount: controller.filePathList.length),
                          ),
                        ],
                      ),
                controller.filePath.value == null
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.h),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 25.w,
                                  height: 30.w,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/new-document.png"),
                                    ),
                                  ),
                                  // child: Center(
                                  //   child: Text(
                                  //     feedViewController.filePath.value!
                                  //         .split(".")
                                  //         .last,
                                  //     style: TeacherAppFonts
                                  //         .interW500_12sp_textWhite
                                  //         .copyWith(
                                  //       fontSize: 10.sp,
                                  //       color: Colors.black,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    feedViewController.filePath.value!
                                        .split("/")
                                        .last,
                                    style: TeacherAppFonts
                                        .interW400_16sp_letters1
                                        .copyWith(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    feedViewController.filePath.value = null;
                                  },
                                  child: SizedBox(
                                    width: 25.w,
                                    height: 40.w,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                controller.showAudioPlayingWidget.value == true
                    ? const ChatAudioPlayingWidget()
                    : const SizedBox(),
                SizedBox(height: 10.w),
                controller.isReplay.value != null
                    ? Column(
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(
                                      color: Colorutils.userdetailcolor,
                                      width: 3.w),
                                ),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              child: Row(
                                children: [
                                  // Container(
                                  //   width: 7.w,
                                  //   decoration: BoxDecoration(
                                  //     color: Colorutils.letters1,
                                  //     borderRadius: BorderRadius.only(
                                  //       topLeft: Radius.circular(10.h),
                                  //       bottomLeft: Radius.circular(10.h),
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              controller.replayName.value,
                                              style: TeacherAppFonts
                                                  .interW600_16sp_letters1,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Builder(
                                            builder: (context) {
                                              if (Get.find<FeedViewController>()
                                                      .replayMessage
                                                      .type ==
                                                  "file") {
                                                return Row(
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 18,
                                                      decoration:
                                                          const BoxDecoration(
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
                                                      //         Get.find<
                                                      //                 FeedViewController>()
                                                      //             .replayMessage
                                                      //             .fileName!
                                                      //             .split(".")
                                                      //             .last,
                                                      //         style: TeacherAppFonts
                                                      //             .interW400_14sp_textWhite
                                                      //             .copyWith(
                                                      //           fontSize: 8.sp,
                                                      //           color: Colors
                                                      //               .black,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ),
                                                    SizedBox(width: 5.h),
                                                    Expanded(
                                                      child: Text(
                                                        Get.find<
                                                                FeedViewController>()
                                                            .replayMessage
                                                            .fileName!,
                                                        style: TeacherAppFonts
                                                            .interW400_14sp_textWhite
                                                            .copyWith(
                                                          color: Colorutils
                                                              .fontColor6
                                                              .withOpacity(0.8),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              } else if (Get.find<
                                                          FeedViewController>()
                                                      .replayMessage
                                                      .type ==
                                                  "text") {
                                                return Text(
                                                  // "Can you pls share the pdf adsdaddsf.",
                                                  feedViewController
                                                          .replayMessage
                                                          .message ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TeacherAppFonts
                                                      .interW400_14sp_textWhite
                                                      .copyWith(
                                                          color: Colorutils
                                                              .fontColor6
                                                              .withOpacity(
                                                                  0.8)),
                                                );
                                              } else if (Get.find<
                                                          FeedViewController>()
                                                      .replayMessage
                                                      .type ==
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
                                                          color: Colorutils
                                                              .fontColor6
                                                              .withOpacity(0.8),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              } else if (Get.find<
                                                              FeedViewController>()
                                                          .replayMessage
                                                          .type ==
                                                      "text_file" ||
                                                  feedViewController
                                                          .replayMessage.type ==
                                                      "text_audio") {
                                                return Text(
                                                  // "Can you pls share the pdf adsdaddsf.",
                                                  feedViewController
                                                          .replayMessage
                                                          .message ??
                                                      "",

                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style: TeacherAppFonts
                                                      .interW400_14sp_textWhite
                                                      .copyWith(
                                                          color: Colorutils
                                                              .fontColor6
                                                              .withOpacity(
                                                                  0.8)),
                                                );
                                              }

                                              return const SizedBox();
                                            },
                                          ),
                                          // SizedBox(
                                          //   width: double.infinity,
                                          //   child: Text(
                                          //     controller
                                          //         .replayMessage.value,
                                          //     maxLines: 3,
                                          //     overflow:
                                          //         TextOverflow.ellipsis,
                                          //     style: FontsStyle()
                                          //         .interW400_16sp
                                          //         .copyWith(
                                          //             color: ColorUtil
                                          //                 .black),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      feedViewController.isReplay.value = null;
                                    },
                                    child: SizedBox(
                                      width: 25.w,
                                      height: 40.w,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w)
                                  // InkWell(
                                  //   onTap: () {},
                                  //   child: const Icon(
                                  //     Icons.close,
                                  //     color: ColorUtil.grey,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      )
                    : const SizedBox(),
                controller.showAudioRecordWidget.value
                    ? const ChatAudioRecordingWidget(isParentChat: false)
                    : Row(
                        children: [
                          controller.audioPath.value == null
                              ? InkWell(
                                  onTap: () async {
                                    await feedViewController.selectAttachment(
                                        context: context);

                                    // feedViewController
                                    //     .selectAttachment(context: context);
                                  },
                                  child: SizedBox(
                                    height: 25.w,
                                    width: 25.w,
                                    child: SvgPicture.asset(
                                        "assets/images/Attachment.svg"),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: Container(
                              // height: 40.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.h),
                                  border: Border.all(
                                    width: 0.5.w,
                                    color: Colorutils.bordercolor1,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        focusNode: controller.focusNode.value,
                                        controller: messageCtr,
                                        minLines: 1,
                                        maxLines: 2,
                                        // keyboardType: TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          prefix: SizedBox(
                                            width: 15.w,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "Message",
                                          hintStyle: TeacherAppFonts
                                              .interW400_16sp_letters1
                                              .copyWith(
                                                  color: Colors.black
                                                      .withOpacity(0.2)),
                                        ),
                                        onChanged: (value) {
                                          controller.ontype.value = value;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8).w,
                                      child: InkWell(
                                        child: SvgPicture.asset(
                                          'assets/images/profileplus.svg',
                                          height: 24.w,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        onTap: () {
                                          controller
                                              .showParentListFilteredToSelectedList();
                                          // controller.rebuildSelectedParentList();
                                          showModalBottomSheet(
                                            barrierColor: Colors.transparent,
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return ParentSelectionBottomSheet();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          controller.filePathList.isNotEmpty
                              ? const SizedBox()
                              : controller.audioPath.value == null
                                  ? InkWell(
                                      onTap: () async {
                                        bool permission =
                                            await Get.find<FeedViewController>()
                                                .permissionCheck(context);
                                        if (permission) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const CameraScreen(
                                                    isParentChat: false);
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: SizedBox(
                                        height: 25.w,
                                        width: 25.w,
                                        child: SvgPicture.asset(
                                            "assets/images/Camera.svg"),
                                      ),
                                    )
                                  : const SizedBox(),
                          SizedBox(
                            width: 20.w,
                          ),
                          controller.ontype.value.trim() == "" &&
                                  controller.audioPath.value == null &&
                                  controller.filePath.value == null &&
                                  controller.filePathList.isEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    snackBar(
                                        context: context,
                                        message: "Tap and hold to record",
                                        color: Colorutils.fontColor11);
                                  },
                                  onLongPress: () async {
                                    HapticFeedback.vibrate();
                                    await Permission.microphone.request();

                                    if (await Permission
                                        .microphone.status.isGranted) {
                                      feedViewController
                                          .showAudioRecordWidget.value = true;
                                    } else {
                                      ShowWarnDialog().showWarn(
                                          context: context,
                                          message:
                                              "Enable microphone permission.",
                                          iconData: Icons.mic_none);
                                    }
                                  },
                                  child: SizedBox(
                                    height: 25.w,
                                    width: 25.w,
                                    child: SvgPicture.asset(
                                        "assets/images/Record Audio.svg"),
                                  ),
                                )
                              : controller.isSentLoading.value == true
                                  ? SizedBox(
                                      height: 25.w,
                                      width: 25.w,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        // for getting bool value of warning msg from share preference //
                                        // SharedPreferences sharedPre =
                                        //     await SharedPreferences
                                        //         .getInstance();
                                        // final isShow =
                                        // sharedPre.getBool("MsgSentAlert");
                                        final isShow =
                                            true; // for hiding the feature of warning message //

                                        if (isShow == true ||
                                            controller
                                                    .showSelectedParentDataStack
                                                    .length !=
                                                controller
                                                    .selectedParentDataList
                                                    .length) {
                                          // for sent message without showdialog //
                                          controller.isSentLoading.value = true;
                                          await checkInternetWithReturnBool(
                                            context: context,
                                            function: () async {
                                              print(
                                                  "msg test ============= in ");
                                              /////////////////////////////////////
                                              if (controller
                                                  .filePathList.isNotEmpty) {
                                                // for sent multiple attachemnt //
                                                for (final file in controller
                                                    .filePathList) {
                                                  print(
                                                      "msg test ============= $file");
                                                  await Get.find<
                                                          FeedViewController>()
                                                      .sendAttach(
                                                    classs: widget.msgData
                                                            ?.classTeacherClass ??
                                                        '--',
                                                    batch:
                                                        widget.msgData?.batch ??
                                                            '--',
                                                    subId: widget.msgData
                                                            ?.subjectId ??
                                                        '--',
                                                    sub: widget.msgData
                                                            ?.subjectName ??
                                                        '--',
                                                    teacherId:
                                                        userAuthController
                                                                .userData
                                                                .value
                                                                .userId ??
                                                            '--',
                                                    context: context,
                                                    filePath: file,
                                                    message: messageCtr
                                                            .text.isNotEmpty
                                                        ? messageCtr.text
                                                        : null,
                                                  );
                                                  messageCtr.clear();
                                                }
                                                controller.filePathList.value =
                                                    [];

                                                controller.isSentLoading.value =
                                                    false;
                                              } else {
                                                // for sent single attachemnt //
                                                if (feedViewController
                                                            .audioPath.value !=
                                                        null ||
                                                    feedViewController
                                                            .filePath.value !=
                                                        null) {
                                                  await Get.find<
                                                          FeedViewController>()
                                                      .sendAttach(
                                                    classs: widget.msgData
                                                            ?.classTeacherClass ??
                                                        '--',
                                                    batch:
                                                        widget.msgData?.batch ??
                                                            '--',
                                                    subId: widget.msgData
                                                            ?.subjectId ??
                                                        '--',
                                                    sub: widget.msgData
                                                            ?.subjectName ??
                                                        '--',
                                                    teacherId:
                                                        userAuthController
                                                                .userData
                                                                .value
                                                                .userId ??
                                                            '--',
                                                    context: context,
                                                    filePath: Get.find<
                                                                FeedViewController>()
                                                            .audioPath
                                                            .value ??
                                                        Get.find<
                                                                FeedViewController>()
                                                            .filePath
                                                            .value,
                                                    message: messageCtr
                                                            .text.isNotEmpty
                                                        ? messageCtr.text
                                                        : null,
                                                  );
                                                } else {
                                                  // for sent text message //
                                                  if (messageCtr
                                                      .text.isNotEmpty) {
                                                    SentMsgByTeacherModel
                                                        sentMsgData =
                                                        SentMsgByTeacherModel(
                                                      subjectId: widget.msgData
                                                              ?.subjectId ??
                                                          '--',
                                                      batch: widget
                                                              .msgData?.batch ??
                                                          '--',
                                                      classs: widget.msgData
                                                              ?.classTeacherClass ??
                                                          '--',
                                                      message: messageCtr
                                                              .text.isNotEmpty
                                                          ? messageCtr.text
                                                          : null,
                                                      messageFrom:
                                                          userAuthController
                                                                  .userData
                                                                  .value
                                                                  .userId ??
                                                              '--',
                                                      parents: feedViewController
                                                          .setFinalParentList(),
                                                      subject: widget.msgData
                                                              ?.subjectName ??
                                                          '--',
                                                      replyId: controller
                                                          .isReplay.value,
                                                      fileData: FileData(
                                                        name: null,
                                                        orgName: null,
                                                        extension: null,
                                                      ),
                                                    );
                                                    await feedViewController
                                                        .sendAttachMsg(
                                                      sentMsgData: sentMsgData,
                                                      context: context,
                                                    );
                                                  }
                                                }
                                              }
                                              /////////////////////////////////
                                            },
                                          ).then(
                                            (value) async {
                                              if (!value) {
                                                if (controller
                                                    .filePathList.isNotEmpty) {
                                                  // for sent multiple attachemnt locally //
                                                  for (final file in controller
                                                      .filePathList) {
                                                    await Get.find<
                                                            FeedDBController>()
                                                        .sendMessageLocally(
                                                      teacherName: Get.find<
                                                              UserAuthController>()
                                                          .userData
                                                          .value
                                                          .name!,
                                                      teacherId: Get.find<
                                                              UserAuthController>()
                                                          .userData
                                                          .value
                                                          .userId!,
                                                      subId: widget.msgData
                                                              ?.subjectId ??
                                                          "",
                                                      className: widget.msgData
                                                              ?.classTeacherClass ??
                                                          '--',
                                                      batch: widget
                                                              .msgData?.batch ??
                                                          '--',
                                                      subject: widget.msgData
                                                              ?.subjectName ??
                                                          '',
                                                      filePath: file,
                                                      messageId: "unsent",
                                                      message: messageCtr.text,
                                                      replyId: Get.find<
                                                              FeedViewController>()
                                                          .isReplay
                                                          .value,
                                                      isForward: false,
                                                      replayMessageData: Get.find<
                                                              FeedViewController>()
                                                          .replayMessage,
                                                    );

                                                    messageCtr.clear();
                                                  }
                                                  controller
                                                      .filePathList.value = [];
                                                  controller.isSentLoading
                                                      .value = false;
                                                } else {
                                                  // for sent single message and attachemnt locally //
                                                  await Get.find<
                                                          FeedDBController>()
                                                      .sendMessageLocally(
                                                    teacherName: Get.find<
                                                            UserAuthController>()
                                                        .userData
                                                        .value
                                                        .name!,
                                                    teacherId: Get.find<
                                                            UserAuthController>()
                                                        .userData
                                                        .value
                                                        .userId!,
                                                    subId: widget.msgData
                                                            ?.subjectId ??
                                                        "",
                                                    className: widget.msgData
                                                            ?.classTeacherClass ??
                                                        '--',
                                                    batch:
                                                        widget.msgData?.batch ??
                                                            '--',
                                                    subject: widget.msgData
                                                            ?.subjectName ??
                                                        '',
                                                    filePath: Get.find<
                                                                FeedViewController>()
                                                            .audioPath
                                                            .value ??
                                                        Get.find<
                                                                FeedViewController>()
                                                            .filePath
                                                            .value,
                                                    messageId: "unsent",
                                                    message: messageCtr.text,
                                                    replyId: Get.find<
                                                            FeedViewController>()
                                                        .isReplay
                                                        .value,
                                                    isForward: false,
                                                    replayMessageData: Get.find<
                                                            FeedViewController>()
                                                        .replayMessage,
                                                  )
                                                      .then(
                                                    (value) {
                                                      Get.find<FeedViewController>()
                                                              .isReplay
                                                              .value =
                                                          null; // for hiding the replay container widget //

                                                      Get.find<FeedViewController>()
                                                              .audioPath
                                                              .value =
                                                          null; // for hiding the audio container widget //
                                                      Get.find<FeedViewController>()
                                                              .filePath
                                                              .value =
                                                          null; // for hiding the file container widget //
                                                      Get.find<FeedViewController>()
                                                              .showAudioRecordWidget
                                                              .value =
                                                          false; // for hiding the audio recording widget //
                                                      Get.find<FeedViewController>()
                                                              .showAudioPlayingWidget
                                                              .value =
                                                          false; // for hiding the audio playing widget //
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                          );
                                          controller.isSentLoading.value =
                                              false;

                                          messageCtr.clear();
                                          controller.ontype.value = "";
                                        } else {
                                          // for sent message with showdialog //
                                          await showChatWarningDialog(
                                            context: context,
                                            function: () async {
                                              controller.isSentLoading.value =
                                                  true;
                                              await checkInternet(
                                                context: context,
                                                function: () async {
                                                  if (controller.filePathList
                                                      .isNotEmpty) {
                                                    // for sent multiple attachemnt //
                                                    for (final file
                                                        in controller
                                                            .filePathList) {
                                                      print(
                                                          "msg test ============= $file");
                                                      await Get.find<
                                                              FeedViewController>()
                                                          .sendAttach(
                                                        classs: widget.msgData
                                                                ?.classTeacherClass ??
                                                            '--',
                                                        batch: widget.msgData
                                                                ?.batch ??
                                                            '--',
                                                        subId: widget.msgData
                                                                ?.subjectId ??
                                                            '--',
                                                        sub: widget.msgData
                                                                ?.subjectName ??
                                                            '--',
                                                        teacherId:
                                                            userAuthController
                                                                    .userData
                                                                    .value
                                                                    .userId ??
                                                                '--',
                                                        context: context,
                                                        filePath: file,
                                                        message: messageCtr
                                                                .text.isNotEmpty
                                                            ? messageCtr.text
                                                            : null,
                                                      );
                                                      messageCtr.clear();
                                                    }

                                                    controller.filePathList
                                                        .value = [];

                                                    controller.isSentLoading
                                                        .value = false;
                                                  } else {
                                                    // for sent single attachemnt //
                                                    if (feedViewController
                                                                .audioPath
                                                                .value !=
                                                            null ||
                                                        feedViewController
                                                                .filePath
                                                                .value !=
                                                            null) {
                                                      await Get.find<
                                                              FeedViewController>()
                                                          .sendAttach(
                                                        classs: widget.msgData
                                                                ?.classTeacherClass ??
                                                            '--',
                                                        batch: widget.msgData
                                                                ?.batch ??
                                                            '--',
                                                        subId: widget.msgData
                                                                ?.subjectId ??
                                                            '--',
                                                        sub: widget.msgData
                                                                ?.subjectName ??
                                                            '--',
                                                        teacherId:
                                                            userAuthController
                                                                    .userData
                                                                    .value
                                                                    .userId ??
                                                                '--',
                                                        context: context,
                                                        filePath: Get.find<
                                                                    FeedViewController>()
                                                                .audioPath
                                                                .value ??
                                                            Get.find<
                                                                    FeedViewController>()
                                                                .filePath
                                                                .value,
                                                        message: messageCtr
                                                                .text.isNotEmpty
                                                            ? messageCtr.text
                                                            : null,
                                                      );
                                                    } else {
                                                      // for sent text message //
                                                      if (messageCtr
                                                          .text.isNotEmpty) {
                                                        SentMsgByTeacherModel
                                                            sentMsgData =
                                                            SentMsgByTeacherModel(
                                                          subjectId: widget
                                                                  .msgData
                                                                  ?.subjectId ??
                                                              '--',
                                                          batch: widget.msgData
                                                                  ?.batch ??
                                                              '--',
                                                          classs: widget.msgData
                                                                  ?.classTeacherClass ??
                                                              '--',
                                                          message: messageCtr
                                                                  .text
                                                                  .isNotEmpty
                                                              ? messageCtr.text
                                                              : null,
                                                          messageFrom:
                                                              userAuthController
                                                                      .userData
                                                                      .value
                                                                      .userId ??
                                                                  '--',
                                                          parents:
                                                              feedViewController
                                                                  .setFinalParentList(),
                                                          subject: widget
                                                                  .msgData
                                                                  ?.subjectName ??
                                                              '--',
                                                          replyId: controller
                                                              .isReplay.value,
                                                          fileData: FileData(
                                                            name: null,
                                                            orgName: null,
                                                            extension: null,
                                                          ),
                                                        );
                                                        await feedViewController
                                                            .sendAttachMsg(
                                                          sentMsgData:
                                                              sentMsgData,
                                                          context: context,
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                              );
                                              controller.isSentLoading.value =
                                                  false;

                                              messageCtr.clear();
                                              controller.ontype.value = "";
                                            },
                                          );
                                        }

                                        // controller.isSentLoading.value = true;
                                        // await checkInternet(
                                        //   context: context,
                                        //   function: () async {
                                        //     if (feedViewController
                                        //                 .audioPath.value !=
                                        //             null ||
                                        //         feedViewController
                                        //                 .filePath.value !=
                                        //             null) {
                                        //       await Get.find<
                                        //               FeedViewController>()
                                        //           .sendAttach(
                                        //         classs: widget.msgData
                                        //                 ?.classTeacherClass ??
                                        //             '--',
                                        //         batch: widget.msgData?.batch ??
                                        //             '--',
                                        //         subId:
                                        //             widget.msgData?.subjectId ??
                                        //                 '--',
                                        //         sub: widget
                                        //                 .msgData?.subjectName ??
                                        //             '--',
                                        //         teacherId: userAuthController
                                        //                 .userData
                                        //                 .value
                                        //                 .userId ??
                                        //             '--',
                                        //         context: context,
                                        //         filePath: Get.find<
                                        //                     FeedViewController>()
                                        //                 .audioPath
                                        //                 .value ??
                                        //             Get.find<
                                        //                     FeedViewController>()
                                        //                 .filePath
                                        //                 .value,
                                        //         message:
                                        //             messageCtr.text.isNotEmpty
                                        //                 ? messageCtr.text
                                        //                 : null,
                                        //       );
                                        //     } else {
                                        //       if (messageCtr.text.isNotEmpty) {
                                        //         SentMsgByTeacherModel
                                        //             sentMsgData =
                                        //             SentMsgByTeacherModel(
                                        //           subjectId: widget
                                        //                   .msgData?.subjectId ??
                                        //               '--',
                                        //           batch:
                                        //               widget.msgData?.batch ??
                                        //                   '--',
                                        //           classs: widget.msgData
                                        //                   ?.classTeacherClass ??
                                        //               '--',
                                        //           message:
                                        //               messageCtr.text.isNotEmpty
                                        //                   ? messageCtr.text
                                        //                   : null,
                                        //           messageFrom:
                                        //               userAuthController
                                        //                       .userData
                                        //                       .value
                                        //                       .userId ??
                                        //                   '--',
                                        //           parents: feedViewController
                                        //               .setFinalParentList(),
                                        //           subject: widget.msgData
                                        //                   ?.subjectName ??
                                        //               '--',
                                        //           replyId:
                                        //               controller.isReplay.value,
                                        //           fileData: FileData(
                                        //             name: null,
                                        //             orgName: null,
                                        //             extension: null,
                                        //           ),
                                        //         );
                                        //         await feedViewController
                                        //             .sendAttachMsg(
                                        //           sentMsgData: sentMsgData,
                                        //           context: context,
                                        //         );
                                        //       }
                                        //     }
                                        //   },
                                        // );
                                        // controller.isSentLoading.value = false;

                                        // messageCtr.clear();
                                        // controller.ontype.value = "";
                                      },
                                      child: SizedBox(
                                        height: 25.w,
                                        width: 25.w,
                                        child: const Icon(
                                          Icons.send,
                                          color: Colorutils.bgcolor13,
                                        ),
                                      ),
                                    )
                        ],
                      ),
                SizedBox(
                  height: 35.w,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({super.key, required this.widget});
  final FeedViewChatScreen widget;
  @override
  Widget build(BuildContext context) {
    String userId =
        Get.find<UserAuthController>().userData.value.userId ?? '--';
    return GetX<FeedViewController>(builder: (controller) {
      // print("Arun");
      // print("List updated ========= ${controller.chatMsgList.length}");
      // // print("-------------dfvbdvb----------${msgList.last.message}");
      // if (controller.isLoaded.value == true) {
      //   return const Center(child: CircularProgressIndicator());
      // } else
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.dbLoader.value == true) {
        return const Center(child: Text("Loading..."));
      }
      // else if (controller.isError.value) {
      //   return const Center(child: Text("Error Occurred"));
      // }
      if (controller.chatMsgList.isEmpty) {
        return const Center(child: Text("No chat"));
      } else {
        return Stack(
          children: [
            GroupedListView<MsgData, String>(
              useStickyGroupSeparators: true,
              cacheExtent: 2000,
              floatingHeader: true,
              padding: const EdgeInsets.only(bottom: 50),
              controller: controller.chatFeedViewScrollController.value,
              groupBy: (element) {
                try {
                  return DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(element.sendAt!));
                } catch (e) {
                  return "--";
                }
              },
              // sort: true,
              reverse: true,
              shrinkWrap: true,
              elements: controller.chatMsgList,
              groupComparator: (value1, value2) => value2.compareTo(value1),
              order: GroupedListOrder.ASC,
              groupSeparatorBuilder: (String groupByValue) {
                return ChatDateWidget(date: groupByValue);
              },
              // footer: SizedBox(height: 80.w),
              itemComparator: (item1, item2) =>
                  item1.sendAt!.compareTo(item2.sendAt!),
              indexedItemBuilder: (context, element, index) {
                final messageData = controller.chatMsgList[index];
                // final messageData = msgList[index];

                if (index < controller.chatMsgList.length - 1) {
                  return "${messageData.messageFromId}" == userId
                      ? Column(
                          children: [
                            SwapeToWidget(
                              function: () {
                                controller.focusTextField();
                                // FocusScope.of(context).requestFocus(controller.focusNode);
                                controller.isReplay.value =
                                    messageData.messageId;
                                controller.replayName.value = "You";
                                controller.replayMessage = messageData;
                              },
                              iconWidget: SvgPicture.asset(
                                  "assets/images/ArrowBendUpLeft.svg"),
                              child: SentMessageBubble(
                                message: messageData.message ?? '',
                                time: messageData.sendAt,
                                replay: true,
                                audio: messageData.messageAudio,
                                fileName: messageData.fileName,
                                fileLink: messageData.messageFile,
                                messageData: messageData,
                                index: index,
                                widget: widget,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SwapeToWidget(
                              function: () {
                                controller.focusTextField();
                                // FocusScope.of(context)
                                //     .requestFocus(controller.focusNode);
                                controller.isReplay.value =
                                    messageData.messageId;
                                controller.replayName.value =
                                    messageData.messageFrom ?? "";
                                controller.replayMessage = messageData;
                              },
                              iconWidget: SvgPicture.asset(
                                  "assets/images/ArrowBendUpLeft.svg"),
                              child: ReceiveMessageBubble(
                                senderName: messageData.messageFrom,
                                message: messageData.message,
                                time: messageData.sendAt,
                                replay: true,
                                audio: messageData.messageAudio,
                                fileName: messageData.fileName,
                                fileLink: messageData.messageFile,
                                subject: messageData.subjectName,
                                messageData: messageData,
                                index: index,
                                widget: widget,
                              ),
                            ),
                          ],
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
                                          child: CircularProgressIndicator())),
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
              // separatorBuilder: (context, index) {
              //   return SizedBox(
              //     height: 5.h,
              //   );
              // },
              // itemCount: msgList.length,
            ),
            GetBuilder<FeedViewController>(builder: (controller2) {
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
                                Get.find<FeedViewController>()
                                    .chatFeedViewScrollController
                                    .value
                                    .animateTo(
                                      Get.find<FeedViewController>()
                                          .chatFeedViewScrollController
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
    });
  }
}

messageMoreShowDialog(BuildContext context, Widget widget, Offset position,
    Offset tapPosition, ChatRoomDataInheritedWidget? data) {
  print("reaction ------------ ${data}");
  double safeAreaVerticalPadding = MediaQuery.of(context).padding.top +
      MediaQuery.of(context).padding.bottom;

  showDialog(
    barrierColor: Colors.black.withOpacity(0.3),
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Stack(
          children: [
            Positioned(
              top: position.dy - 40,
              left: 0,
              right: 0,
              child: Container(child: widget),
            ),
            Positioned(
              top: tapPosition.dy -
                  safeAreaVerticalPadding -
                  ((ScreenUtil().screenHeight / 1.7) > tapPosition.dy
                      ? 160.h
                      : 420.h),
              left: Get.find<FeedViewController>()
                          .seletedMsgData!
                          .messageFromId ==
                      Get.find<UserAuthController>().userData.value.userId
                  ? null
                  : 20,
              right: Get.find<FeedViewController>()
                          .seletedMsgData!
                          .messageFromId !=
                      Get.find<UserAuthController>().userData.value.userId
                  ? null
                  : 20,
              child: Column(
                crossAxisAlignment: Get.find<FeedViewController>()
                            .seletedMsgData!
                            .messageFromId ==
                        Get.find<UserAuthController>().userData.value.userId
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  ScreenUtil().screenHeight / 1.7 < tapPosition.dy
                      ? MessageMoreContainer(
                          widget: widget,
                          data: data,
                        )
                      : const SizedBox(),
                  SizedBox(height: 20.h),
                  // Get.find<FeedViewController>()
                  //             .seletedMsgData!
                  //             .messageFromId ==
                  //         Get.find<UserAuthController>().userData.value.userId
                  //     ? const SizedBox()
                  //     :
                  ReactionContainerWidget(
                    data: data,
                  ),
                  SizedBox(height: 80.h),
                  ScreenUtil().screenHeight / 1.7 > tapPosition.dy
                      ? MessageMoreContainer(
                          widget: widget,
                          data: data,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      );
    },
  ).then(
    (value) {
      Get.find<FeedViewController>().isShowDialogShow = false;
      // print("Selected msg Show dialog dismissed");
    },
  );
}

class ChatRoomDataInheritedWidget extends InheritedWidget {
  final ClassTeacherGroup? msgData;

  const ChatRoomDataInheritedWidget({
    required this.msgData,
    required Widget child,
  }) : super(child: child);

  static ChatRoomDataInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ChatRoomDataInheritedWidget>();
  }

  @override
  bool updateShouldNotify(ChatRoomDataInheritedWidget oldWidget) {
    // return int1 != oldWidget.int1 || int2 != oldWidget.int2;
    return msgData != oldWidget.msgData;
  }
}
