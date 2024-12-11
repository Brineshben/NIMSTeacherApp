import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/View/CWidgets/TeacherAppPopUps.dart';
import '../../Models/api_models/student_add_Model.dart';
import '../../Services/api_services.dart';

class Studentmodelcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxBool isFromScan = false.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
    isFromScan.value = false;
  }

  void resetData() {}

  Future<bool> sendStudentData({required StudentAddModel data }) async {

    print("--------------studenthere---${data.sentToName}");
    print("--------------studenthere---${data.role}");
    print("--------------studenthere---${data.sentTo}");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.getSubmit(data: data);
      if (resp['data']['status'] == 409) {

        TeacherAppPopUps.submitFailedTwoBack(
            title: "Warning",
            message: resp["data"]["message"],
            actionName: "Ok",
            iconData: Icons.error_outline_sharp,
            iconColor: Colors.red);
      }

      else if(resp['status']['code'] == 200) {
        TeacherAppPopUps.submitFailedThreeBack(
            title: resp["status"]["message"],
            message: resp["data"]["message"],
            actionName: "Ok",
            iconData: Icons.check_circle_outline,
            iconColor: Colors.green, fromScan: isFromScan.value);
        return true;
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
    return false;
  }
}
