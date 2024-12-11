import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';

import '../../Models/api_models/Focus_Api_Model.dart';
import '../../Services/api_services.dart';

class Learningfocuscontroller extends GetxController {
  RxList<String> focusList = <String>[].obs;

  Future<void> fetchfocusdata() async {
    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;
      String? acYr = Get.find<UserAuthController>().userData.value.academicYear;
      String? schoolID = Get.find<UserAuthController>().userData.value.schoolId;

      Map<String, dynamic> resp = await ApiServices.getFocus(
          userId: userId.toString(),
          academicYear: acYr.toString(),
          schoolId: schoolID.toString());

      if (resp['status']['code'] == 200) {
        LearningWalkFocus focusDetails = LearningWalkFocus.fromJson(resp);
        focusList.value = focusDetails.data?.details ?? [];

        // focusList.value = batchdetails.data.details ?? [];
      }
    } catch (e) {
      print("-----------lesson obs error--------------");
    } finally {}
  }
}
