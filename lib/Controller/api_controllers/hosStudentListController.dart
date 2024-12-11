import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/HosStudentListModel.dart';

import '../../Services/api_services.dart';

class Hosstudentlistcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<SendData> recentData = <SendData>[].obs;
  RxList<SendData> sentStudentData = <SendData>[].obs;
  RxList<SendData> recivedStudentData = <SendData>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    // recentData.value = [];
    sentStudentData.value = [];
    // recivedStudentData.value = [];
  }

  Future<void> fetchHosStudentList(DateTime? date) async {
    print("--------------here---");
    // resetData();
    sentStudentData.value.clear();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      String? selectedDate = DateFormat("yyyy-MM-dd").format(date ?? DateTime.now());
      String acYr =
          Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId =
          Get.find<UserAuthController>().userData.value.schoolId ?? '';
      String UserID =
          Get.find<UserAuthController>().userData.value.userId ?? '';


      // List<Map<String, dynamic>> classList = [];
      // for (var sub in teacherSubjects) {
      //   classList.add(
      //     {
      //       "class": sub.classs,
      //       "batch": sub.batch,
      //     },
      //   );
      // }

      Map<String, dynamic> resp = await ApiServices.getHosStudentList(
          schoolId: scId, academicYear: acYr, userId: UserID, date:selectedDate);

      if (resp['status']['code'] == 200) {
        HosStudentListMode hosStudentlist =
        HosStudentListMode.fromJson(resp);


        recentData.value = hosStudentlist.data!.data?.sendData ?? [];
        // sentStudentData.value= hosStudentlist.data?.data?.sendData?? [];
        // recivedStudentData.value=hosStudentlist.data?.data?.receiveData?? [];




        isLoaded.value = true;
        for (var student in recentData.value) {
          if (student.isprogress ?? false) {
            sentStudentData.add(student);
            print(
                "-----------sentStudentData..${sentStudentData.first.id}-----------");
            print(
                "-----------sentStudentData..${sentStudentData.first.studentName}-----------");
          } else {
            recivedStudentData.add(student);
            print(
                "-----------recivedStudentData..$recivedStudentData-----------");
          }
        }
        print(
            "-----------sentStvbenenenenudentData..${sentStudentData.length}-----------");
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
    sentStudentData.refresh();
  }
}
