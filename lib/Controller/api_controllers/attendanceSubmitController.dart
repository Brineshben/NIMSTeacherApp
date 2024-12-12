
import 'package:get/get.dart';

class AttendanceSubmitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<String?> errorMsg = Rx<String?>(null);


  Future<void> submitAttendance() async {
    try {} catch(e) {}
  }
}