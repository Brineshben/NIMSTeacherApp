import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/forward_controller.dart/forward_controller.dart';
import 'package:teacherapp/Models/api_models/chat_group_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_chat_list_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_list_api_model.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/last_seen_msg.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/new_parentChat_bottomSheet.dart';
import '../../Controller/api_controllers/chatClassGroupController.dart';
import '../../Utils/constants.dart';

class ForwardScreen extends StatefulWidget {
  const ForwardScreen({super.key});

  @override
  State<ForwardScreen> createState() => _ForwardScreenState();
}

class _ForwardScreenState extends State<ForwardScreen>
    with TickerProviderStateMixin {
  TabController? _tabcontroller;
  PageController pageController = PageController();

  @override
  void initState() {
    Get.find<ForwardController>().markGroupCount.value = 0; // set default //
    Get.find<ForwardController>().markSingleCount.value = 0; // set default //
    Get.find<ForwardController>().forwardSingleList.clear(); // set default //
    Get.find<ForwardController>()
        .forwardClassGroupList
        .clear(); // set default //
    Get.find<ForwardController>()
        .selectedForwardClassGroupList
        .clear(); // set default //
    Get.find<ForwardController>()
        .selectedForwardSingleList
        .clear(); // set default //
    _tabcontroller = TabController(length: 2, vsync: this);
    Get.find<ForwardController>().convertToForwardModelChatList(
        list: chatClassGroupController.classGroupList);

    Get.find<ForwardController>().convertToForwardModelChat(
        list: parentChatListController.parentChatList);
    print(
        "list lenght = ${Get.find<ForwardController>().forwardSingleList.length}, ${Get.find<ForwardController>().forwardClassGroupList.length}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ChatClassGroupController chatClassGroupController =
      Get.find<ChatClassGroupController>();
  ParentChatListController parentChatListController =
      Get.find<ParentChatListController>();

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
                    'Forward to...',
                    style: GoogleFonts.inter(
                      fontSize: 25.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // SvgPicture.asset(
                  //   'assets/images/MagnifyingGlass.svg',
                  //   width: 27.h,
                  //   fit: BoxFit.fitWidth,
                  // ),
                  // GetX<ChatClassGroupController>(
                  //   builder: (ChatClassGroupController controller) {
                  //     if (controller.currentChatTab.value == 1) {
                  //       return Padding(
                  //         padding: const EdgeInsets.only(left: 6).w,
                  //         child: InkWell(
                  //           onTap: () {
                  //             parentChatListController.setCurrentFilterClass(
                  //                 currentClass: 'All');
                  //             showModalBottomSheet(
                  //               context: context,
                  //               backgroundColor: Colors.transparent,
                  //               isScrollControlled: true,
                  //               builder: (context) {
                  //                 return const NewParentChat();
                  //               },
                  //             );
                  //           },
                  //           child: Container(
                  //             padding: const EdgeInsets.all(4.0).w,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(100).w),
                  //             child: const Icon(
                  //               Icons.add,
                  //               color: Colorutils.letters1,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       return Container(
                  //         width: 0,
                  //         height: 0,
                  //         color: Colorutils.userdetailcolor,
                  //       );
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
            Container(
              height: 55.h,
              color: Colorutils.userdetailcolor,
              alignment: Alignment.bottomCenter,
              child: TabBar(
                onTap: (index) {
                  _tabcontroller = TabController(
                      length: 2, vsync: this, initialIndex: index);
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceIn);
                  setState(() {});
                  Get.find<ChatClassGroupController>().setCurrentChatTab(index);
                },
                tabAlignment: TabAlignment.center,
                controller: _tabcontroller,
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
                                radius: 10.r,
                                child: FittedBox(
                                  child: Text(
                                    count.toString(),
                                    style: GoogleFonts.inter(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
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
                                radius: 10.r,
                                child: FittedBox(
                                  child: Text(
                                    count.toString(),
                                    style: GoogleFonts.inter(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
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
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  // if(_tabcontroller != null) {
                  _tabcontroller = TabController(
                      length: 2, vsync: this, initialIndex: index);
                  setState(() {});
                  Get.find<ChatClassGroupController>().setCurrentChatTab(index);
                  // }
                },
                children: [
                  // Class list //
                  GetBuilder<ForwardController>(
                    builder: (ForwardController controller) {
                      // List<ClassTeacherGroup> classTeacherGroups =
                      //     controller.classGroupList.value;
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.forwardClassGroupList.length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (BuildContext context, int index) {
                          LastMessageGroupChat? lastMsg = controller
                                  .forwardClassGroupList[index]
                                  .messageGroupdata
                                  .lastMessage!
                                  .isNotEmpty
                              ? controller.forwardClassGroupList[index]
                                  .messageGroupdata.lastMessage?.first
                              : LastMessageGroupChat();
                          DateTime? sentTime = lastMsg?.sandAt;
                          String? formattedDate;

                          try {
                            formattedDate =
                                DateFormat('EEE hh:mm a').format(sentTime!);
                          } catch (e) {}
                          String? userId = Get.find<UserAuthController>()
                              .userData
                              .value
                              .userId;
                          return InkWell(
                            onTap: () {
                              controller.markForwardGroupList(
                                  data: controller.forwardClassGroupList[index],
                                  context: context);
                            },
                            child: Container(
                              color:
                                  controller.forwardClassGroupList[index].select
                                      ? Colors.black.withOpacity(0.2)
                                      : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colorutils
                                              .chatLeadingColors[index % 5],
                                          radius: 28.r,
                                          child: FittedBox(
                                            child: Text(
                                              '${controller.forwardClassGroupList[index].messageGroupdata.classTeacherClass}${controller.forwardClassGroupList[index].messageGroupdata.batch}',
                                              style: TeacherAppFonts
                                                  .interW600_14sp_textWhite,
                                            ),
                                          ),
                                        ),
                                        controller.forwardClassGroupList[index]
                                                    .select ==
                                                true
                                            ? Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colorutils.greenDark,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(3.h),
                                                    child: SizedBox(
                                                      height: 20.h,
                                                      width: 20.h,
                                                      child: const Center(
                                                        child: FittedBox(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colorutils
                                                                .Whitecolor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    SizedBox(width: 15.h),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 120),
                                                      child: Text(
                                                        // "English",
                                                        controller
                                                                .forwardClassGroupList[
                                                                    index]
                                                                .messageGroupdata
                                                                .subjectName ??
                                                            '--',
                                                        style: TeacherAppFonts
                                                            .interW700_16sp_black,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2.h),
                                                Row(
                                                  children: [
                                                    if (userId != null &&
                                                        lastMsg != null)
                                                      if (userId ==
                                                          lastMsg.messageFromId)
                                                        SizedBox(
                                                          height: 21.h,
                                                          width: 21.h,
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/images/Checks.svg",
                                                            color: lastMsg.read!
                                                                ? Colors.green
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                    if (userId != null &&
                                                        lastMsg != null)
                                                      if (userId ==
                                                          lastMsg.messageFromId)
                                                        SizedBox(width: 5.h),
                                                    LastSeenMsgGroupChat(
                                                        lastMessage: lastMsg),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formattedDate ?? '',
                                          style: TeacherAppFonts
                                              .interW400_12sp_topicbackground,
                                        ),
                                        SizedBox(height: 10.h),
                                        if (controller
                                                .forwardClassGroupList[index]
                                                .messageGroupdata
                                                .unreadCount !=
                                            null)
                                          if (controller
                                                  .forwardClassGroupList[index]
                                                  .messageGroupdata
                                                  .unreadCount !=
                                              0)
                                            Container(
                                              height: 23.h,
                                              width: 23.h,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colorutils
                                                      .topicbackground),
                                              child: Center(
                                                child: Text(
                                                  controller
                                                      .forwardClassGroupList[
                                                          index]
                                                      .messageGroupdata
                                                      .unreadCount
                                                      .toString(),
                                                  style: TeacherAppFonts
                                                      .interW600_14sp_textWhite,
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
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 0,
                            thickness: 0.3,
                            indent: 15,
                            endIndent: 15,
                          );
                        },
                      );
                    },
                  ),

                  // chats //
                  Column(
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      GetBuilder<ForwardController>(
                        builder: (ForwardController controller) {
                          // List<Datum> chatParentList =
                          //     controller.parentChatList.value;
                          // print(
                          //     "---------sentTime----------${controller.parentChatList.value.first.lastMessage?.sandAt}");
                          return Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: controller.forwardSingleList.length,
                              itemBuilder: (BuildContext context, int index) {
                                LastMessage? lastMsg = controller
                                        .forwardSingleList[index]
                                        .messageGroupdata
                                        .lastMessage ??
                                    LastMessage();
                                DateTime? sentTime = lastMsg.sandAt;
                                String? formattedDate;
                                try {
                                  formattedDate = DateFormat('EEE hh:mm a')
                                      .format(sentTime!);
                                } catch (e) {}
                                String? userId = Get.find<UserAuthController>()
                                    .userData
                                    .value
                                    .userId;
                                return InkWell(
                                  onTap: () {
                                    controller.markForwardSingleChat(
                                        data:
                                            controller.forwardSingleList[index],
                                        context: context);
                                  },
                                  child: Container(
                                    color: controller
                                            .forwardSingleList[index].select
                                        ? Colors.black.withOpacity(0.2)
                                        : null,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.h),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colorutils
                                                        .chatLeadingColors[
                                                    index % 5],
                                                radius: 28.r,
                                                child: FittedBox(
                                                  child: Text(
                                                    "${controller.forwardSingleList[index].messageGroupdata.datumClass}${controller.forwardSingleList[index].messageGroupdata.batch}",
                                                    style: TeacherAppFonts
                                                        .interW600_14sp_textWhite,
                                                  ),
                                                ),
                                              ),
                                              controller
                                                          .forwardSingleList[
                                                              index]
                                                          .select ==
                                                      true
                                                  ? Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colorutils
                                                              .greenDark,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.h),
                                                          child: SizedBox(
                                                            height: 20.h,
                                                            width: 20.h,
                                                            child: const Center(
                                                              child: FittedBox(
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color: Colorutils
                                                                      .Whitecolor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        120),
                                                            child: Text(
                                                              // "English",
                                                              controller
                                                                      .forwardSingleList[
                                                                          index]
                                                                      .messageGroupdata
                                                                      .studentName ??
                                                                  '--',
                                                              style: TeacherAppFonts
                                                                  .interW700_16sp_black,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              controller
                                                                          .forwardSingleList[
                                                                              index]
                                                                          .messageGroupdata
                                                                          .relation !=
                                                                      null
                                                                  ? "${controller.forwardSingleList[index].messageGroupdata.relation} of ${controller.forwardSingleList[index].messageGroupdata.parentName}"
                                                                  : "${controller.forwardSingleList[index].messageGroupdata.parentName}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TeacherAppFonts
                                                                  .poppinsW400_12sp_lightGreenForParent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (userId != null &&
                                                          controller
                                                                  .forwardSingleList[
                                                                      index]
                                                                  .messageGroupdata
                                                                  .lastMessage !=
                                                              null)
                                                        if (userId ==
                                                            controller
                                                                .forwardSingleList[
                                                                    index]
                                                                .messageGroupdata
                                                                .lastMessage!
                                                                .messageFromId)
                                                          SizedBox(width: 5.h),
                                                      Row(
                                                        children: [
                                                          if (userId != null &&
                                                              controller
                                                                      .forwardSingleList[
                                                                          index]
                                                                      .messageGroupdata
                                                                      .lastMessage !=
                                                                  null)
                                                            if (userId ==
                                                                controller
                                                                    .forwardSingleList[
                                                                        index]
                                                                    .messageGroupdata
                                                                    .lastMessage!
                                                                    .messageFromId)
                                                              SizedBox(
                                                                height: 21.h,
                                                                width: 21.h,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  "assets/images/Checks.svg",
                                                                  color: controller
                                                                          .forwardSingleList[
                                                                              index]
                                                                          .messageGroupdata
                                                                          .lastMessage!
                                                                          .read!
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                          if (userId != null &&
                                                              controller
                                                                      .forwardSingleList[
                                                                          index]
                                                                      .messageGroupdata
                                                                      .lastMessage !=
                                                                  null)
                                                            if (userId ==
                                                                controller
                                                                    .forwardSingleList[
                                                                        index]
                                                                    .messageGroupdata
                                                                    .lastMessage!
                                                                    .messageFromId)
                                                              SizedBox(
                                                                  width: 5.h),
                                                          Expanded(
                                                            child: Builder(
                                                                builder:
                                                                    (context) {
                                                              if (controller
                                                                      .forwardSingleList[
                                                                          index]
                                                                      .messageGroupdata
                                                                      .lastMessage !=
                                                                  null) {
                                                                if (controller
                                                                        .forwardSingleList[
                                                                            index]
                                                                        .messageGroupdata
                                                                        .lastMessage!
                                                                        .type ==
                                                                    "file") {
                                                                  return Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            17,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image:
                                                                                AssetImage("assets/images/new-document.png"),
                                                                          ),
                                                                        ),
                                                                        // child:
                                                                        //     Center(
                                                                        //   child:
                                                                        //       SizedBox(
                                                                        //     height:
                                                                        //         8,
                                                                        //     width:
                                                                        //         12,
                                                                        //     child:
                                                                        //         FittedBox(
                                                                        //       child: Text(
                                                                        //         controller.forwardSingleList[index].messageGroupdata.lastMessage!.fileName!.split(".").last,
                                                                        //         style: const TextStyle(
                                                                        //           fontWeight: FontWeight.w400,
                                                                        //           color: Colors.black,
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              5.w),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          controller
                                                                              .forwardSingleList[index]
                                                                              .messageGroupdata
                                                                              .lastMessage!
                                                                              .fileName!,
                                                                          style: TeacherAppFonts
                                                                              .interW400_14sp_textWhite
                                                                              .copyWith(
                                                                            color:
                                                                                const Color(0xff535353).withOpacity(0.8),
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                } else if (controller
                                                                        .forwardSingleList[
                                                                            index]
                                                                        .messageGroupdata
                                                                        .lastMessage!
                                                                        .type ==
                                                                    "text") {
                                                                  return Text(
                                                                    // "Can you pls share the pdf adsdaddsf.",
                                                                    controller
                                                                            .forwardSingleList[
                                                                                index]
                                                                            .messageGroupdata
                                                                            .lastMessage
                                                                            ?.message
                                                                            ?.replaceAll('\n',
                                                                                ' ') ??
                                                                        "--",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: TeacherAppFonts
                                                                        .interW400_14sp_textWhite
                                                                        .copyWith(
                                                                      color: const Color(
                                                                              0xff535353)
                                                                          .withOpacity(
                                                                              0.8),
                                                                    ),
                                                                  );
                                                                } else if (controller
                                                                        .forwardSingleList[
                                                                            index]
                                                                        .messageGroupdata
                                                                        .lastMessage!
                                                                        .type ==
                                                                    "audio") {
                                                                  return Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            22,
                                                                        height:
                                                                            15.h,
                                                                        child: SvgPicture.asset(
                                                                            "assets/images/Record Audio.svg"),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              1.w),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          "Audio",
                                                                          style: TeacherAppFonts
                                                                              .interW400_14sp_textWhite
                                                                              .copyWith(
                                                                            color:
                                                                                const Color(0xff535353).withOpacity(0.8),
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                } else if (controller
                                                                            .forwardSingleList[
                                                                                index]
                                                                            .messageGroupdata
                                                                            .lastMessage!
                                                                            .type ==
                                                                        "text_file" ||
                                                                    controller
                                                                            .forwardSingleList[index]
                                                                            .messageGroupdata
                                                                            .lastMessage!
                                                                            .type ==
                                                                        "text_audio") {
                                                                  return Text(
                                                                    // "Can you pls share the pdf adsdaddsf.",
                                                                    controller
                                                                            .forwardSingleList[index]
                                                                            .messageGroupdata
                                                                            .lastMessage!
                                                                            .message ??
                                                                        "--",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,

                                                                    style: TeacherAppFonts
                                                                        .interW400_14sp_textWhite
                                                                        .copyWith(
                                                                      color: const Color(
                                                                              0xff535353)
                                                                          .withOpacity(
                                                                              0.8),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                            vertical: 1,
                                                            horizontal: 5)
                                                        .w,
                                                decoration: BoxDecoration(
                                                  color: Colorutils.Whitecolor,
                                                  borderRadius:
                                                      BorderRadius.circular(20)
                                                          .r,
                                                  border: Border.all(
                                                    color: Colorutils
                                                            .chatLeadingColors[
                                                        index % 5],
                                                  ),
                                                ),
                                                child: Text(
                                                  "Class ${controller.forwardSingleList[index].messageGroupdata.datumClass}",
                                                  style: TeacherAppFonts
                                                      .interW500_12sp_textWhite
                                                      .copyWith(
                                                    color: Colorutils
                                                            .chatLeadingColors[
                                                        index % 5],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                formattedDate ?? '',
                                                style: TeacherAppFonts
                                                    .interW400_12sp_topicbackground,
                                              ),
                                              SizedBox(height: 5.h),
                                              if (controller
                                                      .forwardSingleList[index]
                                                      .messageGroupdata
                                                      .unreadCount !=
                                                  null)
                                                if (controller
                                                        .forwardSingleList[
                                                            index]
                                                        .messageGroupdata
                                                        .unreadCount !=
                                                    "0")
                                                  Container(
                                                    height: 23.h,
                                                    width: 23.h,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colorutils
                                                                .topicbackground),
                                                    child: Center(
                                                      child: Text(
                                                        controller
                                                            .forwardSingleList[
                                                                index]
                                                            .messageGroupdata
                                                            .unreadCount
                                                            .toString(),
                                                        style: TeacherAppFonts
                                                            .interW600_14sp_textWhite,
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
                                // ChatItem(
                                //   time: formattedDate ?? '',
                                //   userId: userId,
                                //   leadColor:
                                //       Colorutils.chatLeadingColors[index % 5],
                                //   parentRoom: chatParentList[index],
                                // );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  height: 0,
                                  thickness: 0.3,
                                  indent: 15,
                                  endIndent: 15,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: GetX<ForwardController>(builder: (controller) {
          return controller.markGroupCount.value == 0 &&
                  controller.markSingleCount.value == 0
              ? const SizedBox()
              : controller.markGroupCount.value == 0
                  ? FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        controller.sentForwardMessageForSingle(
                            context: context);
                        // if (controller.markGroupCount.value == 1) {
                        //   print(
                        //       "selected workied --------------------------------- group");
                        // } else if (controller.markSingleCount.value != 0) {
                        //   print(
                        //       "selected workied --------------------------------- single");
                        // } else {
                        //   snackBar(
                        //       context: context,
                        //       message: "Something went wrong",
                        //       color: Colors.black);
                        // }
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  : FloatingActionButton.extended(
                      label: Text(
                        "Select Parent",
                        style: TeacherAppFonts.interW400_16sp_letters1
                            .copyWith(color: Colors.white),
                      ),
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        getParanetPopup(context: context);
                        //   if (controller.markGroupCount.value == 1) {
                        //     print(
                        //         "selected workied --------------------------------- group");
                        //   } else if (controller.markSingleCount.value != 0) {
                        //     print(
                        //         "selected workied --------------------------------- single");
                        //   } else {
                        //     snackBar(
                        //         context: context,
                        //         message: "Something went wrong",
                        //         color: Colors.black);
                        //   }
                      },
                    );
        }),
      ),
    );
  }
}

getParanetPopup({required BuildContext context}) async {
  final classdata = Get.find<ForwardController>()
      .selectedForwardClassGroupList
      .first
      .messageGroupdata;
  await Get.find<FeedViewController>().fetchParentList(
    classs: classdata.classTeacherClass!,
    batch: classdata.batch!,
    subId: classdata.subjectId!,
    schoolId: Get.find<UserAuthController>().userData.value.schoolId!,
  );

  Get.find<ForwardController>().convertPareNtListToForwardModel(
      Get.find<FeedViewController>().parentDataList);
  Get.find<ForwardController>().checkAllSelect();

  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Column(
        children: [
          // Text(
          //   "Select Parents",
          //   style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.h)),
        height: 500.h,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
          child: Column(
            children: [
              Text(
                "Select Parents",
                style: TeacherAppFonts.interW600_18sp_textWhite.copyWith(
                  color: Colors.black,
                ),
              ),
              hSpace(10.h),
              Row(
                children: [
                  GetX<ForwardController>(builder: (controller) {
                    return InkWell(
                      onTap: () {
                        print("working gvfdsg");
                        if (controller.isallSelect.value) {
                          controller.unSelectAllParents();
                        } else {
                          controller.selectAllParents();
                        }
                      },
                      child: Icon(
                        controller.isallSelect.value
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.teal,
                      ),
                    );
                  }),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text("Select All"),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: GetBuilder<ForwardController>(builder: (controller) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final parentData = controller.forwardParentList[index];
                        // return ParentListTileWidget(parentData: parentData);
                        String relation = "";
                        if (parentData.parentdata != null) {
                          relation =
                              parentData.parentdata?.gender?[0].toLowerCase() ==
                                      "m"
                                  ? "Son"
                                  : "Daughter";
                        }

                        return InkWell(
                          onTap: () {
                            if (parentData.selected!) {
                              parentData.selected = false;
                              Get.find<ForwardController>().checkAllSelect();
                            } else {
                              parentData.selected = true;
                              Get.find<ForwardController>().checkAllSelect();
                            }
                            controller.updateParentList(parentData);
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.h),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      parentData.selected ?? false
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: Colors.teal,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          parentData.parentdata?.studentName ??
                                              "--",
                                          style: TeacherAppFonts
                                              .interW700_16sp_black,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          parentData.parentdata!.gender != null
                                              ? "$relation of ${parentData.parentdata?.name}"
                                              : "${parentData.parentdata?.name}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TeacherAppFonts
                                              .poppinsW400_12sp_lightGreenForParent,
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: controller.forwardParentList.length);
                }),
              ),
              hSpace(10.h),
              GestureDetector(
                onTap: () {
                  if (Get.find<ForwardController>()
                      .getSeletectedParaentIdList()
                      .isEmpty) {
                    Get.snackbar("Alert", "Please select parents",
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    Get.find<ForwardController>().sentForwardMessageForGroup(
                        context: context,
                        parentList: Get.find<ForwardController>()
                            .getSeletectedParaentIdList());
                    Get.back();
                  }
                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colorutils.letters1,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: Center(
                    child: Text(
                      "Send",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
              // FilledButton(
              //   onPressed: () {
              //     if (Get.find<ForwardController>()
              //         .getSeletectedParaentIdList()
              //         .isEmpty) {
              //       Get.snackbar("Alert", "Please select parents",
              //           snackPosition: SnackPosition.BOTTOM);
              //     } else {
              //       Get.find<ForwardController>().sentForwardMessageForGroup(
              //           context: context,
              //           parentList: Get.find<ForwardController>()
              //               .getSeletectedParaentIdList());
              //       Get.back();
              //     }
              //   },
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.all(Colorutils.letters1),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         "Send",
              //         style: TextStyle(color: Colors.white, fontSize: 16.sp),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [],
    ),
  );
}

class ParentListTileWidget extends StatefulWidget {
  const ParentListTileWidget({
    super.key,
    required this.parentData,
  });

  final ForwardParentDataModel parentData;

  @override
  State<ParentListTileWidget> createState() => _ParentListTileWidgetState();
}

class _ParentListTileWidgetState extends State<ParentListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.parentData.selected!) {
            widget.parentData.selected = false;
            Get.find<ForwardController>().checkAllSelect();
          } else {
            widget.parentData.selected = true;
            Get.find<ForwardController>().checkAllSelect();
          }
        });
      },
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  widget.parentData.selected ?? false
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: Colors.teal,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: Text(widget.parentData.parentdata!.name ?? "--")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
