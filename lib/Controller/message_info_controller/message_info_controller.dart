import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Models/api_models/message_info_model.dart';
import 'package:teacherapp/Services/message_info_service/message_info_service.dart';
import 'package:teacherapp/Utils/constant_function.dart';

class MessageInfoController extends GetxController {
  // Rx<String?> deliveryTime = Rx(null);
  // Rx<String?> seenTime = Rx(null);
  // RxBool readstatus = false.obs;
  Rx<List<Viewdata>?> viewsList = Rx(null);
  Rx<List<Viewdata>> seenList = Rx([]);
  Rx<List<Viewdata>> deliverList = Rx([]);

  void getMessageInfo(
      {required BuildContext context, required int messageId}) async {
    viewsList.value = null;
    seenList.value = [];
    deliverList.value = [];
    checkInternetWithReturnBool(
      context: context,
      function: () async {
        MessageInfoModel? messageData =
            await MessageInfoService.getMessageInfo(messageId: messageId);
        print("message == data $messageData");

        if (messageData != null) {
          if (messageData.data != null) {
            if (messageData.data!.viewdata != null) {
              if (messageData.data!.viewdata!.isNotEmpty) {
                viewsList.value = messageData.data!.viewdata!;

                for (Viewdata data in viewsList.value!) {
                  if (data.read == true) {
                    seenList.value.add(data);
                  } else {
                    deliverList.value.add(data);
                  }
                }
              }
            }
          } else {
            viewsList.value = [];
          }
        }
      },
    ).then(
      (value) {
        if (value == false) {
          viewsList.value = [];
        }
      },
    );
  }
}
