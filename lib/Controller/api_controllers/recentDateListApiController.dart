import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Controller/api_controllers/timeTableController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/recent_date_model.dart';
import '../../Models/api_models/time_table_api_model.dart';
import '../../Services/api_services.dart';

class RecentDateListApiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxInt currentTabIndex = 0.obs;
  RxList<ListItem> recentData = <ListItem>[].obs;
  RxList<ListItem> inProgressData = <ListItem>[].obs;
  RxList<ListItem> progressCompletedData = <ListItem>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    recentData.value = [];
    inProgressData.value = [];
    progressCompletedData.value = [];
  }

  Future<void> fetchRecentDateList({DateTime? date}) async {
    print("--------------here---");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      String? selectedDate = DateFormat("yyyy-MM-dd").format(date ?? DateTime.now());
      String acYr =
          Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId =
          Get.find<UserAuthController>().userData.value.schoolId ?? '';
      String teacherId =
          Get.find<UserAuthController>().userData.value.userId ?? '';
      List<TeacherSubject> teacherSubjects =
          Get.find<TimeTableController>().teacherSubjects.value;

      List<Map<String, dynamic>> classList = [];
      for (var sub in teacherSubjects) {
        classList.add(
          {
            "class": sub.classs,
            "batch": sub.batch,
          },
        );
      }

      Map<String, dynamic> resp = await ApiServices.getRecentDateList(
          schoolId: scId, academicYear: acYr, endorsedClass: classList, date: selectedDate, teacherId: teacherId);

      if (resp['status']['code'] == 200) {
        TrackingDateModel recentdateTrackingModel =
        TrackingDateModel.fromJson(resp);

        recentData.value = recentdateTrackingModel.data?.data?? [];

        isLoaded.value = true;

        for (var sub in recentData.value) {
          if (sub.isprogress ?? false) {
            inProgressData.add(sub);
            print("----------$inProgressData-obs result list-----------");
          } else {
            progressCompletedData.add(sub);


          }
        }
        // print("-----------endorsedclasseslist${endorsedClassesList.value}-----------");
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
