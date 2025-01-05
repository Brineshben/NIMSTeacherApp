import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/db_controller/group_db_controller.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import '../../Models/api_models/grouped_view_list_api_model.dart';
import '../../Services/api_services.dart';

class GroupedViewListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool dbLoader = false.obs;
  RxBool isError = false.obs;
  RxList<RoomData> roomList = <RoomData>[].obs;
  RxList<RoomData> searchroomList = <RoomData>[].obs;
  RxInt unreadCount = 0.obs;
  RxString classs = ''.obs;
  RxString batch = ''.obs;
  RxString subjectId = ''.obs;
  RxString searchText = RxString('');
  Rx<ScrollController> groupedViewScrollController = ScrollController().obs;
  RxBool isSearch = false.obs;
  void resetStatus() {
    isLoading.value = false;
    // isError.value = false;
  }

  void resetData() {
    unreadCount.value = 0;
    roomList.value = [];
  }

  void setPayload(
      {required String stdClass,
      required String stdBatch,
      required String subId}) {
    classs.value = stdClass;
    batch.value = stdBatch;
    subjectId.value = subId;
  }

  Future<void> fetchGroupedViewList(BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;
    isError.value = false;
    resetData();

    roomList.value = await Get.find<GroupDbController>().getRoomList();
    if (roomList.isEmpty) {
      dbLoader.value = true;
    }

    isLoading.value = false;

    checkInternetWithReturnBool(
      context: context,
      function: () async {
        try {
          String? teacherId =
              Get.find<UserAuthController>().userData.value.userId;
          String? schoolId =
              Get.find<UserAuthController>().userData.value.schoolId;
          Map<String, dynamic> resp = await ApiServices.getGroupedViewList(
            batch: batch.value,
            classs: classs.value,
            schoolId: schoolId.toString(),
            subId: subjectId.value,
            teacherId: teacherId.toString(),
          );
          if (resp['status']['code'] == 200) {
            print(
                "Grouped loacal storage =================== ${await Get.find<GroupDbController>().getRoomList()}");
            GroupedViewApiModel groupedViewApiModel =
                GroupedViewApiModel.fromJson(resp);
            await Get.find<GroupDbController>()
                .storeChatRoomDatatoDB(groupedViewApiModel.data?.data ?? []);

            unreadCount.value = groupedViewApiModel.data?.count ?? 0;
            roomList.value = await Get.find<GroupDbController>().getRoomList();
            // roomList.value = groupedViewApiModel.data?.data ?? [];
          }
        } catch (e) {
          print("------class group error---------");
          isLoaded.value = false;
          isError.value = true;
        } finally {
          dbLoader.value = false;
          isLoading.value = false;
          resetStatus();
        }
      },
    ).then(
      (value) async {
        // if (!value) {
        //   print("group with out net -------------------- ");
        //   roomList.value = await Get.find<GroupDbController>().getRoomList();

        //   print(
        //       "group with out ------------------------ ${roomList[1].lastMessage?.read}");

        //   isLoading.value = false;
        // }
        dbLoader.value = false;
        isLoading.value = false;
      },
    );
  }

  // Future<void> fetchGroupedViewList() async {
  //   resetData();
  //   isLoading.value = true;
  //   isLoaded.value = false;
  //   isError.value = false;
  //   try {
  //     String? teacherId = Get.find<UserAuthController>().userData.value.userId;
  //     String? schoolId = Get.find<UserAuthController>().userData.value.schoolId;
  //     Map<String, dynamic> resp = await ApiServices.getGroupedViewList(
  //       batch: batch.value,
  //       classs: classs.value,
  //       schoolId: schoolId.toString(),
  //       subId: subjectId.value,
  //       teacherId: teacherId.toString(),
  //     );
  //     if (resp['status']['code'] == 200) {
  //       GroupedViewApiModel groupedViewApiModel =
  //           GroupedViewApiModel.fromJson(resp);
  //       unreadCount.value = groupedViewApiModel.data?.count ?? 0;
  //       roomList.value = groupedViewApiModel.data?.data ?? [];

  //     }
  //   } catch (e) {
  //     print("------class group error---------");
  //     isLoaded.value = false;
  //     isError.value = true;
  //   } finally {
  //     resetStatus();
  //   }
  // }

  Future<void> fetchGroupedViewListPeriodically() async {
    try {
      String? teacherId = Get.find<UserAuthController>().userData.value.userId;
      String? schoolId = Get.find<UserAuthController>().userData.value.schoolId;
      Map<String, dynamic> resp = await ApiServices.getGroupedViewList(
        batch: batch.value,
        classs: classs.value,
        schoolId: schoolId.toString(),
        subId: subjectId.value,
        teacherId: teacherId.toString(),
      );
      if (resp['status']['code'] == 200) {
        GroupedViewApiModel groupedViewApiModel =
            GroupedViewApiModel.fromJson(resp);
        unreadCount.value = groupedViewApiModel.data?.count ?? 0;
        roomList.value = groupedViewApiModel.data?.data ?? [];
      }
    } catch (e) {
      print("------class group error---------");
    } finally {}
  }

  searchChatRoom(String text) {
    searchText.value = text;
    searchroomList.value = roomList.value
        .where((chat) => "${chat.classs}${chat.batch!}${chat.subjectName}"
            .toUpperCase()
            .contains(text.toUpperCase()))
        .toList();
  }
}
