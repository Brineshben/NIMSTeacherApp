
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/qr_clinic_model.dart';
import '../../Services/api_services.dart';

class Qrcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  // RxBool isError = false.obs;
  Rx<QrclinicModel> studentqrdata = QrclinicModel().obs;
  RxList<QrclinicModel> SearchNameList = <QrclinicModel>[].obs;

  void resetStatus() {
    isLoading.value = false;
  }

  void resetData() {
    studentqrdata.value = QrclinicModel();
    SearchNameList.value = [];

  }

  Future<void> fetchQrData(  {required String qrCode}) async {
    print("-----------qrCode-----------$qrCode");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {

     String insID = Get.find<UserAuthController>().userData.value.schoolId ?? '';
    if (insID == "m2LMtqaESFZf6xDE8") {
      insID = "1";
    } else if (insID == "ps4vyLJhQvPZjfxaH") {
      insID = "2";
    } else if (insID == "2FwuqhgeoKt6SQiCG") {
      insID ="3";
    } else if (insID == "CPpbKPQTcuG97i3kv") {
      insID = "4";  // Reset to 1 or any other desired value
    }
      List<dynamic> resp = await ApiServices.getQRdata( type: "1", searchKey:qrCode, instId: insID);
      print("-----------qr resp-----------$resp");
      if (resp[0] != null) {
        studentqrdata.value = QrclinicModel.fromJson(resp[0]);

        isLoaded.value = true;
      } else {
        isLoaded.value = false;
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }

  Future<void> fetchSearchData(  {required String searchData}) async {
    print("-----------qrCode-----------$searchData");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {

      String insID = Get.find<UserAuthController>().userData.value.schoolId ?? '';
      if (insID == "m2LMtqaESFZf6xDE8") {
        insID = "1";
      } else if (insID == "ps4vyLJhQvPZjfxaH") {
        insID = "2";
      } else if (insID == "2FwuqhgeoKt6SQiCG") {
        insID ="3";
      } else if (insID == "CPpbKPQTcuG97i3kv") {
        insID = "4";  // Reset to 1 or any other desired value
      }
      List<dynamic> resp = await ApiServices.getSearchdata( type: "0", searchKey:searchData, instId: insID);
      print("-----------qr resp-----------$resp");


      SearchNameList.value = resp.map((x) => QrclinicModel.fromJson(x)).toList();

      isLoaded.value = true;
        } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
