import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';

import '../../Models/api_models/makasread_api_Model.dart';
import '../../Services/api_services.dart';

class MarkAsReadController extends GetxController {
  Rx<MarkasreadData> markAsReadValue = MarkasreadData().obs;

  void datamark() {


    markAsReadValue.value = MarkasreadData();
  }

  Future<void> fetchmarkasread({required String notificationId}) async {
    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;
      Map<String, dynamic> resp = await ApiServices.getMarkasReadNotification(
        userId: userId.toString(),
        notificationId: notificationId.toString(),
      );
      markAsReadValue.value = MarkasreadData.fromJson(resp);
      if (resp['status']['code'] == 200) {
      var statusvalue =  markAsReadValue.value;
      } else {}
    } catch (e) {}
  }
}
