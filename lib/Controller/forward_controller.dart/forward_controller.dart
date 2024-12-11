// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Models/api_models/chat_group_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_chat_list_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_list_api_model.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Models/ui_models/forward_model/forward_model.dart';
import 'package:teacherapp/Services/forward_service/forward_service.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:teacherapp/View/CWidgets/TeacherAppPopUps.dart';
import 'package:teacherapp/View/Chat_View/feed_view%20_chat_screen.dart';

class ForwardController extends GetxController {
  List<ForwardModelChatList> forwardClassGroupList = [];
  List<ForwardModelChatList> selectedForwardClassGroupList = [];
  List<ForwardModelChats> forwardSingleList = [];
  List<ForwardModelChats> selectedForwardSingleList = [];

  RxList<ForwardParentDataModel> forwardParentList = RxList([]);

  RxBool isallSelect = false.obs;

  RxInt markGroupCount = 0.obs;
  RxInt markSingleCount = 0.obs;

  void convertToForwardModelChatList({required List<ClassTeacherGroup> list}) {
    forwardClassGroupList.clear();
    for (ClassTeacherGroup element in list) {
      ForwardModelChatList data =
          ForwardModelChatList(select: false, messageGroupdata: element);
      forwardClassGroupList.add(data);
    }

    getMarkCountGroupList();

    update();
  }

  void convertToForwardModelChat({required List<Datum> list}) {
    forwardSingleList.clear();
    for (Datum element in list) {
      ForwardModelChats data =
          ForwardModelChats(select: false, messageGroupdata: element);
      forwardSingleList.add(data);
    }

    getMarkCountGroupList();

    update();
  }

  getMarkCountGroupList() {
    markGroupCount.value = 0;
    selectedForwardClassGroupList.clear();
    forwardClassGroupList.forEach((element) {
      if (element.select) {
        markGroupCount.value++;
        selectedForwardClassGroupList.add(element);
      }
    });
  }

  getMarkCountSingleChat() {
    markSingleCount.value = 0;
    selectedForwardSingleList.clear();
    forwardSingleList.forEach((element) {
      if (element.select) {
        markSingleCount.value++;
        selectedForwardSingleList.add(element);
      }
    });
  }

  markForward(
      {required ForwardModelChatList data, required BuildContext context}) {}

  markForwardGroupList(
      {required ForwardModelChatList data, required BuildContext context}) {
    if (markSingleCount == 0) {
      if (data.select == true) {
        data.select = false;
      } else {
        if (markGroupCount >= 1) {
          TeacherAppPopUps.submitFailed(
              title: "Alert",
              message: "You can only share with one group",
              actionName: "Ok",
              iconData: Icons.info,
              iconColor: Colors.black);
        } else {
          data.select = true;
        }
      }
    } else {
      TeacherAppPopUps.submitFailed(
          title: "Alert",
          message:
              "You can't forward Message to class list and chats at same time",
          actionName: "Ok",
          iconData: Icons.info,
          iconColor: Colors.black);
    }
    getMarkCountGroupList();
    update();
  }

  markForwardSingleChat(
      {required ForwardModelChats data, required BuildContext context}) {
    if (markGroupCount == 0) {
      if (data.select == true) {
        data.select = false;
      } else {
        if (markSingleCount >= 5) {
          TeacherAppPopUps.submitFailed(
              title: "Alert",
              message: "You can only share with up to 5 chats",
              actionName: "Ok",
              iconData: Icons.info,
              iconColor: Colors.black);
          // ShowWarnDialog().showWarnText(
          //     context: context,
          //     message: "You can only share with up to 5 chats");
        } else {
          data.select = true;
        }
      }
    } else {
      TeacherAppPopUps.submitFailed(
          title: "Alert",
          message:
              "You can't forward Message to class list and chats at same time",
          actionName: "Ok",
          iconData: Icons.info,
          iconColor: Colors.black);
    }
    getMarkCountSingleChat();
    update();
  }

  sentForwardMessageForGroup(
      {required BuildContext context, required List<String> parentList}) {
    checkInternet(
        context: context,
        function: () async {
          print("forward status ============ working ${parentList.length}");

          final singleChatData =
              selectedForwardClassGroupList.first.messageGroupdata;

          SentMsgByTeacherModel data = SentMsgByTeacherModel(
              batch: singleChatData.batch,
              classs: singleChatData.classTeacherClass,
              messageFrom: Get.find<UserAuthController>().userData.value.userId,
              parents: parentList,
              subject: singleChatData.subjectName,
              subjectId: singleChatData.subjectId,
              fileData: null,
              message: null,
              replyId: null);
          final status = await ForwardService.sentMsgGroup(teacherMsg: data);
          print("forward status ===================================== $status");
        });

    snackBar(
        context: context,
        message: "Message forwarded",
        color: Colorutils.timecolortopics);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  sentForwardMessageForSingle({
    required BuildContext context,
  }) {
    checkInternet(
        context: context,
        function: () {
          selectedForwardSingleList.forEach(
            (element) async {
              final singleChatData = element.messageGroupdata;
              SentMsgByTeacherModel data = SentMsgByTeacherModel(
                  batch: singleChatData.batch,
                  classs: singleChatData.datumClass,
                  messageFrom:
                      Get.find<UserAuthController>().userData.value.userId,
                  parents: [singleChatData.parentId!],
                  subject: singleChatData.studentName,
                  subjectId: singleChatData.subjectId,
                  fileData: null,
                  message: null,
                  replyId: null);
              final status =
                  await ForwardService.sentMsgSingle(teacherMsg: data);
              print(
                  "forward status ===================================== $status");
            },
          );
        });

    snackBar(
        context: context,
        message: "Message forwarded",
        color: Colorutils.timecolortopics);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  convertPareNtListToForwardModel(List<ParentData> list) {
    forwardParentList.clear();
    list.forEach(
      (element) {
        final data =
            ForwardParentDataModel(selected: false, parentdata: element);
        forwardParentList.add(data);
      },
    );

    print("Working =====");
  }

  updateParentList(ForwardParentDataModel parentData) {
    update();
  }

  selectAllParents() {
    forwardParentList.forEach(
      (element) {
        element.selected = true;
      },
    );
    checkAllSelect();
    update();
  }

  unSelectAllParents() {
    forwardParentList.forEach(
      (element) {
        element.selected = false;
      },
    );
    checkAllSelect();
    update();
  }

  checkAllSelect() {
    for (ForwardParentDataModel element in forwardParentList) {
      if (element.selected == false) {
        isallSelect.value = false;
        print("all selection = ${isallSelect.value}");
        return;
      }
    }
    isallSelect.value = true;
    print("all selection = ${isallSelect.value}");
  }

  List<String> getSeletectedParaentIdList() {
    List<String> parentList = [];
    forwardParentList.forEach(
      (element) {
        if (element.selected!) {
          parentList.add(element.parentdata!.sId!);
        }
      },
    );

    return parentList;
  }
}

class ForwardParentDataModel {
  bool? selected;
  ParentData? parentdata;
  ForwardParentDataModel({
    this.selected,
    this.parentdata,
  });
}
