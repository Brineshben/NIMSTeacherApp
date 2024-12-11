import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/hosFullListModel.dart';
import '../../Services/api_services.dart';

class Hosallstudentslistcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxInt currentTabIndex = 0.obs;
  RxList<Datas> recentData = <Datas>[].obs;
  RxList<Datas> studentinprogressdata = <Datas>[].obs;
  RxList<Datas> studentCompletedData = <Datas>[].obs;


  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    recentData.value = [];
    studentinprogressdata.value = [];
    studentCompletedData.value = [];
  }

  Future<void> fetchAllStudentDateList({DateTime? date}) async {
    print("--------------here---");

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

      Map<String, dynamic> resp = await ApiServices.getHosAllStudentList(
          schoolId: scId, academicYear: acYr, date: selectedDate,);

      if (resp['status']['code'] == 200) {
        HosfullListModel hosfulldata =
        HosfullListModel.fromJson(resp);

        recentData.value = hosfulldata.data?.data ?? [];
        print("----------${recentData.length}-Studentadabendda-lerenh----------");
        isLoaded.value = true;

        for (var sub in recentData.value) {
          if (sub.isprogress ?? true) {
            studentinprogressdata.add(sub);
            print("----------${studentinprogressdata.length}-Studentadadda-----------");
          } else {
            studentCompletedData.add(sub);


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
