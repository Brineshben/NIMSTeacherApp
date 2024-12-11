import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Models/api_models/student_updateModel.dart';
import '../../Services/api_services.dart';
import '../../View/CWidgets/TeacherAppPopUps.dart';

class Studentupdatecontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {}

  Future<void> sendStudentDatas({required StudentUpdateModel data}) async {
    print("--------------here---");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.getSubmitdata(data: data);
      if (resp['status']['code'] == 200) {
        TeacherAppPopUps.submitFailedTwoBack (
            title: resp["status"]["message"],
            message: resp["data"]["message"],
            actionName: "Ok",
            iconData: Icons.check_circle_outline,
            iconColor: Colors.green);

      }
      else {
        TeacherAppPopUps.submitFailed(
            title: "Failed",
            message:"Something went Wrong",
            actionName: "Ok",
            iconData: Icons.error_outline,
            iconColor: Colors.red);
      }


    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
