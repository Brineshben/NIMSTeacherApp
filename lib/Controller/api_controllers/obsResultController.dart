
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/obs_result_api_model.dart';
import '../../Services/api_services.dart';

class ObsResultController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<ObsResultData> obsResultList = <ObsResultData>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {}

  Future<void> fetchObsResultList() async {
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      String usrId = Get.find<UserAuthController>().userData.value.userId ?? '';
      String acYr = Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId = Get.find<UserAuthController>().userData.value.schoolId ?? '';
      Map<String, dynamic> resp = await ApiServices.loadObsResult(schoolId: scId, teacherId: usrId, academicYear: acYr);
      if (resp['status']['code'] == 200) {
        ObservationResultApiModel observationResultApiModel = ObservationResultApiModel.fromJson(resp);
        obsResultList.value = observationResultApiModel.data?.details ?? [];
        obsResultList.value = obsResultList.value.where((element) => element.type == "lesson_observation").toList();
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
