import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/timeTableController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/recentlist_model.dart';
import '../../Models/api_models/time_table_api_model.dart';
import '../../Services/api_services.dart';

class RecentListApiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<RecentData> recentData = <RecentData>[].obs;
  RxList<RecentData> inProgressDataFromApi = <RecentData>[].obs;
  RxList<RecentData> inProgressData = <RecentData>[].obs;
  RxList<RecentData> progressCompletedData = <RecentData>[].obs;
  RxList<RecentData> progressCompletedDataApi = <RecentData>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    recentData.value = [];
    inProgressDataFromApi.value = [];
    progressCompletedDataApi.value = [];
  }

  Future<void> fetchRecentList() async {
    print("--------------here---");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      String acYr =
          Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId =
          Get.find<UserAuthController>().userData.value.schoolId ?? '';
      String teacherID =
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

      Map<String, dynamic> resp = await ApiServices.getRecentList(
          schoolId: scId, academicYear: acYr, endorsedClass: classList, teacherID: teacherID);

      if (resp['status']['code'] == 200) {
        RecentTrackingModel recentTrackingModel =
            RecentTrackingModel.fromJson(resp);

        recentData.value = recentTrackingModel.data?.data ?? [];
        print(
            "-----------inprogressdacccccta..${recentData.value.length}-----------");
        isLoaded.value = true;
        for (var sub in recentData.value) {
          if (sub.isprogress ?? false) {
            inProgressDataFromApi.add(sub);
            print(
                "-----------inprogressdata..${inProgressDataFromApi.first.id}-----------");
            print(
                "-----------inprogressdata..${inProgressDataFromApi.first.studentName}-----------");
          } else {
            progressCompletedDataApi.add(sub);
            print(
                "-----------inprogressdata..$progressCompletedData-----------");
          }
        }
        inProgressData.value = inProgressDataFromApi.value;
        progressCompletedData.value = progressCompletedDataApi.value;
      } else {
        inProgressData.value = [];
      }
    } catch (e) {
      isLoaded.value = false;
      inProgressData.value = [];
      progressCompletedData.value = [];
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
