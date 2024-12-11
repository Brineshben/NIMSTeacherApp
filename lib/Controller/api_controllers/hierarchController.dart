import 'package:get/get.dart';

import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/HierarchyModel.dart';
import '../../Models/api_models/HosStudentListModel.dart';

import '../../Services/api_services.dart';

class Hierarchcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<Users> hosdata = <Users>[].obs;
  RxList<Users> hoddata = <Users>[].obs;
  RxList<Users> supervisordata = <Users>[].obs;
  RxList<Users> principaldata = <Users>[].obs;
  RxList<Users> viceprincidata = <Users>[].obs;
  RxList<SendData> recivedStudentData = <SendData>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    hosdata.value = [];
    recivedStudentData.value = [];
  }

  Future<void> fetchHierarchyList() async {
    print("--------------here---");
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      String acYr =
          Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId =
          Get.find<UserAuthController>().userData.value.schoolId ?? '';

      // List<Map<String, dynamic>> classList = [];
      // for (var sub in teacherSubjects) {
      //   classList.add(
      //     {
      //       "class": sub.classs,
      //       "batch": sub.batch,
      //     },
      //   );
      // }

      Map<String, dynamic> hosResp = await ApiServices.loadHierarchyList(
          schoolId: scId, academicYear: acYr, id: 'role121234', name: 'HOS');

      Map<String, dynamic> hodResp = await ApiServices.loadHierarchyList(
          schoolId: scId, academicYear: acYr, id: 'role121235', name: 'HOD');

      Map<String, dynamic> supervisorResp = await ApiServices.loadHierarchyList(
          schoolId: scId,
          academicYear: acYr,
          id: 'v2QNTPPvPQK6T',
          name: 'Supervisor');
      Map<String, dynamic> principalResp = await ApiServices.loadHierarchyList(
          schoolId: scId,
          academicYear: acYr,
          id: 'rolepri12',
          name: 'Principal');
      Map<String, dynamic> viceprinciResp = await ApiServices.loadHierarchyList(
          schoolId: scId,
          academicYear: acYr,
          id: 'role12123',
          name: 'VicePrincipal');

      if (hosResp['status']['code'] == 200) {
        HierarchyListModel hoslist = HierarchyListModel.fromJson(hosResp);
        print("-----------hosrespppp..$hoslist-----------");

        hosdata.value = hoslist.data?.details?.response?.users ?? [];
        // isLoaded.value = true;
      }
      if (hodResp['status']['code'] == 200) {
        HierarchyListModel hodlist = HierarchyListModel.fromJson(hodResp);
        print("-----------hodrespppp..$hodlist-----------");

        hoddata.value = hodlist.data?.details?.response?.users ?? [];
      }
      if (supervisorResp['status']['code'] == 200) {
        HierarchyListModel supervisorlist =
            HierarchyListModel.fromJson(supervisorResp);
        print("-----------hodrespppp..$supervisorResp-----------");

        supervisordata.value =
            supervisorlist.data?.details?.response?.users ?? [];
      }
      if (principalResp['status']['code'] == 200) {
        HierarchyListModel principallist =
            HierarchyListModel.fromJson(principalResp);
        print("-----------principallist..$principallist-----------");

        principaldata.value =
            principallist.data?.details?.response?.users ?? [];
      }
      if (viceprinciResp['status']['code'] == 200) {
        HierarchyListModel viceprincilist =
            HierarchyListModel.fromJson(viceprinciResp);
        print("-----------principallist..$viceprincilist-----------");

        viceprincidata.value =
            viceprincilist.data?.details?.response?.users ?? [];
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------obs result list error-----------");
    } finally {
      resetStatus();
    }
  }
}
