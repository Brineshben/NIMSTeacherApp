
import 'dart:developer';

import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Services/check_connectivity.dart';
import '../../Models/api_models/obs_result_api_model.dart';
import '../../Services/api_services.dart';

class ObsResultController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxBool connection = true.obs;
  RxList<ObsResultData> obsResultList = <ObsResultData>[].obs;
  RxList<ObsResultData> obsfileterList = <ObsResultData>[].obs;

  void resetStatus() {
    isLoading.value = false;
    // isError.value = false;
  }

  void resetData() {}

  Future<void> fetchObsResultList() async {
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    isError.value = false;
    connection.value = await CheckConnectivity().check();
    try {
      String usrId = Get.find<UserAuthController>().userData.value.userId ?? '';
      String acYr = Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId = Get.find<UserAuthController>().userData.value.schoolId ?? '';
      Map<String, dynamic> resp = await ApiServices.loadObsResult(schoolId: scId, teacherId: usrId, academicYear: acYr);
      if (resp['status']['code'] == 200) {
        ObservationResultApiModel observationResultApiModel = ObservationResultApiModel.fromJson(resp);
        obsResultList.value = observationResultApiModel.data?.details ?? [];
        obsResultList.value = obsResultList.value.where((element) => element.type == "lesson_observation").toList();
        obsfileterList.value =obsResultList.value.where((element) => element.type == "lesson_observation").toList();
        isLoaded.value = true;
      }else{
         isError.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      isError.value = true
      ;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
  void filterList({required String text}) {

    obsResultList.value = obsfileterList.value
        .where((student) => student.observerName!.toLowerCase().contains(text.toLowerCase())||
  student.dateOfObservation!.split('T').first.contains(text)|| student.dateOfObservation!.split('T').first.split('-').reversed.join('-').contains(text)).toList();
  
  }
}
