import 'package:get/get.dart';
import 'package:teacherapp/Models/api_models/notificationModel.dart';
import '../../Services/api_services.dart';

class Notificationcliniccontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {}

  Future<void> sentnotificationData({required NotificationModel data}) async {
    print("----------ststus correcbebebheerhd eht-------");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.getSubmitnotifications(data:data);
      print("------$resp-benenenen-----");
      if (resp['status']['code']== 200) {

        print("----------ststus correcbebebheerhd ehtdswfwerfgter4t-------");
      }




    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-swdfdghrtgerth----------");
    } finally {
      resetStatus();
    }

  }
}
