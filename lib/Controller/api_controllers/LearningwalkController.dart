import 'dart:core';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';

import '../../Models/api_models/ClassLW_Api_Model.dart';
import '../../Models/api_models/Teacher_Apimodel.dart';
import '../../Models/api_models/batch_Apimodel.dart';
import '../../Services/api_services.dart';

class LearningWalkController extends GetxController {
  RxList<Details> classDetails = <Details>[].obs;
  RxList<Detailsbatch> batchDetils = <Detailsbatch>[].obs;
  RxList<DetailsTeacher> teacherDetails = <DetailsTeacher>[].obs;
  Rx<Details?> details = Rx(null);
  Rx<Detailsbatch?> batchDetails = Rx(null);

  void resetData() {
    classDetails.value = [];
    batchDetils.value = [];
    teacherDetails.value = [];
  }

  Future<void> fetchteacherclassdata() async {
    resetData();
    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;
      String? acYr = Get.find<UserAuthController>().userData.value.academicYear;
      String? schoolID = Get.find<UserAuthController>().userData.value.schoolId;
      Map<String, dynamic> resp = await ApiServices.getClass(
          userId: userId.toString(),
          academicYear: acYr.toString(),
          schoolId: schoolID.toString(),
          admin: true);

      // lessonDataApi.value = LessonObservationData.fromJson(resp);

      if (resp['status']['code'] == 200) {
        LearningWalkClass classdetails = LearningWalkClass.fromJson(resp);
        classDetails.value = classdetails.data?.details ?? [];
      }
    } catch (e) {
      print("-----------lessongsgsg obs error--------------");
    } finally {}
  }

  Future<void> fetchteacherbatchdata(String classDetail) async {
    details.value = null;
    for (var batch in classDetails) {
      if (batch.name == classDetail) {
        details.value = batch;
      }
    }

    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;
      String? acYr = Get.find<UserAuthController>().userData.value.academicYear;
      String? schoolID = Get.find<UserAuthController>().userData.value.schoolId;

      Map<String, dynamic> resp = await ApiServices.getBatch(
          userId: userId.toString(),
          academicYear: acYr.toString(),
          schoolId: schoolID.toString(),
          admin: true,
          classId: details.value?.sId ?? " ",
          cirriculam: details.value?.curriculumIds ?? [],
          session: details.value?.sessionIds ?? []);
      // lessonDataApi.value = LessonObservationData.fromJson(resp);

      if (resp['status']['code'] == 200) {
        LearningWalkbatch batchdetails = LearningWalkbatch.fromJson(resp);
        batchDetils.value = batchdetails.data?.details ?? [];
        batchDetils.value.sort((a, b) => a.name.toString().compareTo(b.name.toString()));

      }
    } catch (e) {
      print(
          "-----------lessongsgsgbebebeb obs error-${e.toString()}-------------");
    } finally {}
  }

  void setSelectedBatch({required String division}) {
    for (var batch in batchDetils.value) {
      if(batch.name == division) {
        batchDetails.value = batch;
      }
    }
  }

  Future<void> fetchteacherdata(String batchDetail) async {
    for (var batch in batchDetils.value) {
      if (batch.name == batchDetail) {
        batchDetails.value = batch;
      }
    }

    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;
      String? acYr = Get.find<UserAuthController>().userData.value.academicYear;
      String? schoolID = Get.find<UserAuthController>().userData.value.schoolId;

      Map<String, dynamic> resp = await ApiServices.getTeacherdata(
          userId: userId.toString(),
          academicYear: acYr.toString(),
          schoolId: schoolID.toString(),
          admin: true,
          classId: details.value?.sId ?? " ",
          cirriculam: details.value?.curriculumIds ?? [],
          session: details.value?.sessionIds ?? [],
          sessionID: batchDetails.value?.session?? "",
          batchID:  batchDetails.value?.sId?? "",
          cirriculamID: batchDetails.value?.curriculum?? "");
      // lessonDataApi.value = LessonObservationData.fromJson(resp);

      if (resp['status']['code'] == 200) {
        LearningWalkTeacher teacherdetails = LearningWalkTeacher.fromJson(resp);
        teacherDetails.value = teacherdetails.data?.details ?? [];
        teacherDetails.value.sort((a, b) => a.name.toString().compareTo(b.name.toString()));

        print(
            "-----------lessongsgsgbebebeb obs error-${teacherDetails.value}-------------");
      }
    } catch (e) {
      print(
          "-----------lessongsgsgbebebeb obs error-${e.toString()}-------------");
    } finally {}
  }
}
