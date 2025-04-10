import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Models/api_models/chat_feed_view_model.dart';
import 'package:teacherapp/Models/api_models/parent_chatting_model.dart';
import 'package:teacherapp/Services/reaction_service/reaction_service.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:teacherapp/View/Chat_View/feed_view_chat_screen.dart';
import 'package:teacherapp/View/Chat_View/parent_chat_screen.dart';

class ReactionController extends GetxController {
  postReaction(
      {required BuildContext context,
      required String reaction,
      required String messageId,
      required String parentId,
      required ChatRoomDataInheritedWidget? data,
      required ChatRoomParentDataInheritedWidget? data2}) {
    checkInternet(
      context: context,
      function: () async {
        final status = await ReactionService.postReaction(
            reaction: reaction, messageId: messageId, parentId: parentId);

        if (status) {
          print("Reaction success");
          if (data != null) {
            // print(
            //     "reaction update working ------------${data.msgData?.classTeacherClass}");
            // print("reaction update working ------------${data.msgData?.batch}");
            // print(
            //     "reaction update working ------------${data.msgData?.subjectId}");
            // print(
            //     "reaction update working ------------${Get.find<UserAuthController>().userData.value.userId}");
            // print(
            //     "reaction update working ------------${Get.find<UserAuthController>().userData.value.schoolId}");
            // print(
            //     "reaction update working ------------${Get.find<FeedViewController>().messageCount}");

            Get.find<FeedViewController>()
                .fetchFeedViewMsgListPeriodically(ChatFeedViewReqModel(
              classs: data.msgData?.classTeacherClass ?? "",
              batch: data.msgData?.batch ?? "",
              subjectId: data.msgData?.subjectId ?? "",
              teacherId: Get.find<UserAuthController>().userData.value.userId,
              schoolId: Get.find<UserAuthController>().userData.value.schoolId,
              limit: Get.find<FeedViewController>().messageCount,
              offset: 0,
            ));
          } else if (data2 != null) {
            print("reaction update working ------------2");
            Get.find<ParentChattingController>().fetchParentMsgListPeriodically(
                ParentChattingReqModel(
                    classs: data2.msgData?.datumClass ?? "",
                    batch: data2.msgData?.batch ?? "",
                    parentId: data2.msgData?.parentId ?? "",
                    schoolId:
                        Get.find<UserAuthController>().userData.value.schoolId,
                    teacherId:
                        Get.find<UserAuthController>().userData.value.userId,
                    limit: Get.find<ParentChattingController>().messageCount,
                    offset: 0));
          }
        } else {
          snackBar(
              context: context,
              message: "Something went wrong.",
              color: Colors.black);
        }
      },
    );
    Navigator.pop(context);
  }
}
