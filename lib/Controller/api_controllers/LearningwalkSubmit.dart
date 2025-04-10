import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teacherapp/View/Home_Page/leader_home.dart';

import '../../Models/api_models/LearningwalkSubmit.dart';
import '../../Services/api_services.dart';
import '../../View/CWidgets/TeacherAppPopUps.dart';
import '../../sqflite_db/LearningWalkDatabase/LwarningwalkDB.dart';

class LearningwalksubmitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {}

  Future<void> Sendlearningwalksubmit({required LearningwalkSubmitModel data}) async {
    print("--------------hereben---");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.getLearningwalksubmit(data: data);
      print("-----learning resp-------$resp");
      if (resp['status']['code'] == 200) {
   
        TeacherAppPopUps.submitFailedTwoBackforupdate (
            title: resp["status"]["message"],
            message: resp["data"]["message"],
            actionName: "Ok",
            iconData: Icons.check_circle_outline,
            iconColor: Colors.green);
         
      }
      else {
        final dbHelper =
        LearningWalkDB();
        final result = await dbHelper
            .insertLearningWalk(
            data.toMap());
        print("brineshDB${result}");
        TeacherAppPopUps
            .submitFailedThreeLearningBack(
          title: "Success",
          message:
          "Learning Walk Added Successfully",
          actionName: "Close",
          iconData: Icons.done,
          iconColor: Colors.green,
        );
        // TeacherAppPopUps.submitFailed(
        //     title: "Failed",
        //     message:"Something went Wrong",
        //     actionName: "Ok",
        //     iconData: Icons.error_outline,
        //     iconColor: Colors.red);
      }


    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
