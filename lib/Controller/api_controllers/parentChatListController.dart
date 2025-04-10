import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/db_controller/parent_db_controller.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import '../../Models/api_models/chat_group_api_model.dart';
import '../../Models/api_models/parent_chat_list_api_model.dart';
import '../../Models/api_models/parent_list_api_model.dart';
import '../../Services/api_services.dart';
import 'chatClassGroupController.dart';

class ParentChatListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isNewChatLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool dbLoader = false.obs;
  RxBool isNewChatLoaded = false.obs;
  RxBool isError = false.obs;
  RxBool isNewChatError = false.obs;
  RxString isNewChatErrorMsg = "".obs;
  RxInt currentTab = 0.obs;
  RxList<Datum> parentChatList = <Datum>[].obs;
  RxList<Datum> parentChatListCopy = <Datum>[].obs;
  RxList<Datum> filteredChatList = <Datum>[].obs;
  RxList<Datum> allParentChatList = <Datum>[].obs;
  RxList<ParentFilterClass> allClasses = <ParentFilterClass>[].obs;
  RxList<ParentData> parentList = <ParentData>[].obs;
  RxList<ParentData> filteredParentList = <ParentData>[].obs;
  RxInt unreadCount = 0.obs;
  Rx<ParentFilterClass> currentFilterClass = const ParentFilterClass().obs;
  RxBool searchEnabled = false.obs;
  RxString isTextField = "".obs;
  RxInt selectedClassListIndex = 0.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    unreadCount.value = 0;
    currentTab.value = 0;
    allParentChatList.value = [];
    parentChatList.value = [];
    filteredChatList.value = [];
    allClasses.value = [];
    parentList.value = [];
    filteredParentList.value = [];
  }

  Future<void> fetchParentChatList({required BuildContext context}) async {
    print("parent room list --------------------");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    allParentChatList.value =
        await Get.find<ParentDbController>().getRoomList();
    print("all parent list =---------------------- ${allParentChatList}");
    parentChatListCopy.value = allParentChatList;
    isLoading.value = false;
    if (allParentChatList.isEmpty) {
      dbLoader.value = true;
    }
    setChatList();
    await checkInternet(
      context: context,
      function: () async {
        try {
          String? teacherId =
              Get.find<UserAuthController>().userData.value.userId;
          String? email =
              Get.find<UserAuthController>().userData.value.username;
          Map<String, dynamic> resp = await ApiServices.getParentChatList(
            teacherId: teacherId.toString(),
            teacherEmail: email.toString(),
          );
          if (resp['status']['code'] == 200) {
            ParentChatListApiModel parentChatListApiModel =
                ParentChatListApiModel.fromJson(resp);
            //for store data in local storage //
            await Get.find<ParentDbController>()
                .storeChatRoomDatatoDB(parentChatListApiModel.data!.data!);
            // Getting data from local storage //
            allParentChatList.value =
                await Get.find<ParentDbController>().getRoomList();
            unreadCount.value = parentChatListApiModel.data?.unreadCount ?? 0;
            parentChatListCopy.value = allParentChatList;

            // unreadCount.value = parentChatListApiModel.data?.unreadCount ?? 0;
            // allParentChatList.value = parentChatListApiModel.data?.data ?? [];
            // parentChatListCopy.value = parentChatListApiModel.data?.data ?? [];
            // filterByClass('All');
            // setClassList();
            // setChatList();
            // isLoaded.value = true;
          }
        } catch (e) {
          print("------parent chat list error 1---------");
          isLoaded.value = false;
        } finally {
          dbLoader.value = false;
          await setClassList();
          if (allClasses.isNotEmpty) {
            await filterByClass(allClasses.value.first);
          }
          setChatList();
          resetStatus();
        }
      },
    ).then(
      (value) {
        dbLoader.value = false;
      },
    );
  }

  // Future<void> fetchParentChatListPeriodically() async {
  //   try {
  //     String? teacherId = Get.find<UserAuthController>().userData.value.userId;
  //     String? email = Get.find<UserAuthController>().userData.value.username;
  //     Map<String, dynamic> resp = await ApiServices.getParentChatList(
  //       teacherId: teacherId.toString(),
  //       teacherEmail: email.toString(),
  //     );
  //     if (resp['status']['code'] == 200) {
  //       ParentChatListApiModel parentChatListApiModel =
  //           ParentChatListApiModel.fromJson(resp);
  //       unreadCount.value = parentChatListApiModel.data?.unreadCount ?? 0;
  //       allParentChatList.value = parentChatListApiModel.data?.data ?? [];
  //       parentChatListCopy.value = parentChatListApiModel.data?.data ?? [];
  //       filterByClass(currentFilterClass.value);
  //       setClassList();
  //       setChatList();
  //     }
  //   } catch (e) {
  //     print("------parent chat list error---------");
  //   } finally {
  //     resetStatus();
  //   }
  // }

  Future<void> fetchParentChatListPeriodically() async {
    checkInternetWithOutSnacksbar(
      function: () async {
        try {
          String? teacherId =
              Get.find<UserAuthController>().userData.value.userId;
          String? email =
              Get.find<UserAuthController>().userData.value.username;
          Map<String, dynamic> resp = await ApiServices.getParentChatList(
            teacherId: teacherId.toString(),
            teacherEmail: email.toString(),
          );
          if (resp['status']['code'] == 200) {
            ParentChatListApiModel parentChatListApiModel =
                ParentChatListApiModel.fromJson(resp);
            //for store data in local storage //
            await Get.find<ParentDbController>()
                .storeChatRoomDatatoDB(parentChatListApiModel.data!.data!);
            // Getting data from local storage //
            allParentChatList.value =
                await Get.find<ParentDbController>().getRoomList();
            unreadCount.value = parentChatListApiModel.data?.unreadCount ?? 0;
            // parentChatListCopy.value = allParentChatList;
            // unreadCount.value = parentChatListApiModel.data?.unreadCount ?? 0;
            // allParentChatList.value = parentChatListApiModel.data?.data ?? [];
            // parentChatListCopy.value = parentChatListApiModel.data?.data ?? [];
            if (allClasses.value.isEmpty) {
              await setClassList();
              if (allClasses.value.isNotEmpty) {
                await filterByClass(allClasses.value.first);
              }
            }
            setChatList();
          }
        } catch (e) {
          print("------parent chat list error 2---------");
        } finally {
          resetStatus();
        }
      },
    );
  }

  void setCurrentFilterClass({required ParentFilterClass currentClass}) {
    currentFilterClass.value = currentClass;
  }

  void setTab(int index) {
    currentTab.value = index;
    setChatList();
  }

  void setChatList() {
    if (currentTab.value == 0) {
      parentChatList.value = allParentChatList;
    }
    if (currentTab.value == 1) {
      parentChatList.value = [];
      for (var chat in allParentChatList) {
        if (chat.unreadCount != null && chat.unreadCount != "0") {
          parentChatList.add(chat);
        }
      }
    }
  }

  Future<void> setClassList() async {
    allClasses.value = [];
    List<ClassTeacherGroup> classGrpLst =
        Get.find<ChatClassGroupController>().classGroupList.value;
    if (classGrpLst.isNotEmpty) {
      for (var chatRoom in classGrpLst) {
        allClasses.value.add(ParentFilterClass(
            stdClass: chatRoom.classTeacherClass, stdBatch: chatRoom.batch));
      }
      allClasses.value = allClasses.value.toSet().toList();
    } else {
      // chat list empty
    }
  }

  Future<void> filterByClass(ParentFilterClass classBatch) async {
    isNewChatLoading.value = true;
    isNewChatLoaded.value = false;
    isNewChatError.value = false;
    parentList.value = [];
    String schoolId =
        Get.find<UserAuthController>().userData.value.schoolId ?? '';
    try {
      Map<String, dynamic> respJson = await ApiServices.getParentList(
          classs: classBatch.stdClass ?? '',
          batch: classBatch.stdBatch ?? '',
          subId: 'class_group',
          schoolId: schoolId);
      print("-----parent resp--------$respJson");
      if (respJson['status']['code'].toString() == "200") {
        ParentListApiModel jsonToDart = ParentListApiModel.fromJson(respJson);
        parentList.value = jsonToDart.data?.parentData ?? [];
        filteredParentList.value = parentList.value;
        if (filteredParentList.isNotEmpty) {
          filteredParentList
              .sort((a, b) => a.studentName!.toLowerCase().compareTo(b.studentName!.toLowerCase()));
        }
        isNewChatLoaded.value = true;
      } else {
        isNewChatError.value = true;
        isNewChatErrorMsg.value =
            respJson['message'] ?? "Something went wrong.";
      }
    } catch (e) {
      print("--------new chat list error-------------${e.toString()}");
      isNewChatError.value = true;
      isNewChatErrorMsg.value = "Something went wrong.";
    } finally {
      isNewChatLoading.value = false;
    }
  }

  void filterGroupList({required String text}) {
    parentChatList.value = parentChatListCopy
        .where((chat) => "${chat.datumClass}${chat.batch}${chat.studentName!}"
            .trim()
            .toUpperCase()
            .contains(text.replaceAll(' ', '').toUpperCase()))
        .toList();
  }

  void filterParentList({required String text}) {
    filteredParentList.value = parentList.value
        .where((parent) => parent.studentName
            .toString()
            .toUpperCase()
            .contains(text.toUpperCase()))
        .toList();
  }
}
