import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/text_and_file_widget.dart';
import 'package:teacherapp/View/Chat_View/feed_view_chat_screen.dart';
import '../../../Models/api_models/chat_feed_view_model.dart';

class ReplayMessageWidget extends StatelessWidget {
  ReplayMessageWidget({super.key, required this.replyData, this.senderId});
  final ReplyData replyData;
  final String? senderId;
  // FeedViewController feedViewController = Get.find<FeedViewController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  @override
  Widget build(BuildContext context) {
    final data = ChatRoomDataInheritedWidget.of(context);
    return GestureDetector(
      onTap: () async {
        if (!Get.find<FeedViewController>().isShowDialogShow) {
          // Get.find<FeedViewController>().chatMsgCount = 100;
          ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
            teacherId: userAuthController.userData.value.userId,
            schoolId: userAuthController.userData.value.schoolId,
            classs: data?.msgData?.classTeacherClass,
            batch: data?.msgData?.batch,
            subjectId: data?.msgData?.subjectId,
            offset: 0,
            limit: Get.find<FeedViewController>().chatMsgCount,
          );
          int? index = await Get.find<FeedViewController>().findMessageIndex(
              reqBody: chatFeedViewReqModel,
              msgId: replyData.messageId,
              context: context);

          if (index != null) {
            await Get.find<FeedViewController>()
                .chatFeedViewScrollController
                .value
                .scrollToIndex(
                  index,
                  preferPosition: AutoScrollPosition.middle,
                );
            await Get.find<FeedViewController>()
                .chatFeedViewScrollController
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
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
// import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
// import 'package:teacherapp/Services/snackBar.dart';
// import 'package:teacherapp/Utils/Colors.dart';
// import 'package:teacherapp/Utils/font_util.dart';
// import 'package:teacherapp/View/Chat_View/Chat_widgets/text_and_file_widget.dart';
// import 'package:teacherapp/View/Chat_View/feed_view_chat_screen.dart';
// import '../../../Models/api_models/chat_feed_view_model.dart';

// class ReplayMessageWidget extends StatelessWidget {
//   ReplayMessageWidget({super.key, required this.replyData, this.senderId});
//   final ReplyData replyData;
//   final String? senderId;
//   // FeedViewController feedViewController = Get.find<FeedViewController>();
//   UserAuthController userAuthController = Get.find<UserAuthController>();
//   @override
//   Widget build(BuildContext context) {
//     final data = ChatRoomDataInheritedWidget.of(context);
//     return GestureDetector(
//       onTap: () async {
//         if (!Get.find<FeedViewController>().isShowDialogShow) {
//           Get.find<FeedViewController>().chatMsgCount = 1000;
//           ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
//             teacherId: userAuthController.userData.value.userId,
//             schoolId: userAuthController.userData.value.schoolId,
//             classs: data?.msgData?.classTeacherClass,
//             batch: data?.msgData?.batch,
//             subjectId: data?.msgData?.subjectId,
//             offset: 0,
//             limit: Get.find<FeedViewController>().chatMsgCount,
//           );
//           int? index = await Get.find<FeedViewController>().findMessageIndex(
//               reqBody: chatFeedViewReqModel, msgId: replyData.messageId);

//           if (index != null) {
//             await Get.find<FeedViewController>()
//                 .chatFeedViewScrollController
//                 .value
//                 .scrollToIndex(
//                   index,
//                   preferPosition: AutoScrollPosition.middle,
//                 );
//             await Get.find<FeedViewController>()
//                 .chatFeedViewScrollController
//                 .value
//                 .highlight(index,
//                     highlightDuration: const Duration(seconds: 1),
//                     animated: true);
//           } else {
//             snackBar(
//                 context: context,
//                 message: "Message not found",
//                 color: Colorutils.Classcolour1);
//           }
//         }
//       },
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: IntrinsicHeight(
//           child: Row(
//             children: [
//               Container(
//                 width: 5.w,
//                 decoration: BoxDecoration(
//                     color: Colorutils.userdetailcolor,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(5.h),
//                         bottomLeft: Radius.circular(5.h))),
//               ),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       color: senderId ==
//                               Get.find<UserAuthController>()
//                                   .userData
//                                   .value
//                                   .userId
//                           ? Colorutils.userdetailcolor.withOpacity(0.3)
//                           : Colors.grey.withOpacity(0.2),
//                       borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                   child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             child: Text(
//                                 replyData.messageFromId ==
//                                         Get.find<UserAuthController>()
//                                             .userData
//                                             .value
//                                             .userId
//                                     ? "You"
//                                     : replyData.messageFromName ?? "--",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TeacherAppFonts.interW600_16sp_letters1
//                                 // style: FontsStyle()
//                                 //     .interW600_16sp
//                                 //     .copyWith(color: ColorUtil.gradientColorEnd),
//                                 ),
//                           ),
//                           TextAndFileWidget(replyData: replyData),
//                         ],
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

