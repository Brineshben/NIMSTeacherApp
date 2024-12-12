import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/LearningwalkSubmit.dart';
import '../../Models/api_models/learning_observation_api_model.dart';
import '../../Models/api_models/learning_walk_apply_model.dart';
import '../../Services/api_services.dart';
import '../../Services/check_connectivity.dart';
import '../../Services/snackBar.dart';
import '../../View/CWidgets/TeacherAppPopUps.dart';
import '../../sqflite_db/LearningWalkDatabase/LwarningwalkDB.dart';
import '../../sqflite_db/lessonLearnDatabase/lessonLearnDbHelper.dart';

class LessonLearningController extends GetxController {
  RxList<TeacherData> teacherNameList = <TeacherData>[].obs;
  Rx<TeacherData?> selectedTeacher = Rx<TeacherData?>(null);
  RxList<TeacherDetails> teacherClassList = <TeacherDetails>[].obs;
  Rx<TeacherDetails?> selectedClass = Rx<TeacherDetails?>(null);
  RxList<SubjectDetail> teacherSubjectList = <SubjectDetail>[].obs;
  Rx<SubjectDetail?> selectedSubject = Rx<SubjectDetail?>(null);
  Rx<LessonObservationData> lessonDataApi = LessonObservationData().obs;

  RxList<ListElement> learningWalkList = <ListElement>[].obs;
  RxList<ListElement> lessonObservationList = <ListElement>[].obs;
  RxList<Indicator> markedIndicators = <Indicator>[].obs;
  RxList<Indicator> markedIndicators1 = <Indicator>[].obs;
  RxList<LearningwalkSubmitModel> learningData =
      <LearningwalkSubmitModel>[].obs;
  RxList<LessonLearningApplyModel> lessonData =
      <LessonLearningApplyModel>[].obs;

  void resetData() {
    teacherNameList.value = [];
    selectedTeacher.value = null;
    selectedClass.value = null;
    selectedSubject.value = null;
    teacherSubjectList.value = [];
    teacherClassList.value = [];
    lessonDataApi.value = LessonObservationData();
  }

  void resetLearningWalkDropdownData() {
    selectedTeacher.value = null;
    selectedClass.value = null;
    selectedSubject.value = null;
    teacherSubjectList.value = [];
    teacherClassList.value = [];
  }

  Future<void> fetchLessonObservation() async {
    resetData();
    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;
      String? acYr = Get.find<UserAuthController>().userData.value.academicYear;
      Map<String, dynamic> resp = await ApiServices.getLeadership(
          userId: userId.toString(),
          academicYear: acYr.toString(),
          hosStatus: true);

      lessonDataApi.value = LessonObservationData.fromJson(resp);

      if (resp['status']['code'] == 200) {
        teacherNameList.value =
            lessonDataApi.value.data?.details?.response ?? [];
        learningWalkList.value =
            lessonDataApi.value.data?.details?.learningWalk?.list ?? [];
        lessonObservationList.value =
            lessonDataApi.value.data?.details?.lessonObservations?.list ?? [];
      }
    } catch (e) {
      print("-----------lesson obs error--------------");
    } finally {}
  }

  Future<void> getTeacherClassData({required String teacherName}) async {
    teacherClassList.value = [];
    teacherSubjectList.value = [];
    selectedTeacher.value = null;
    selectedSubject.value = null;
    selectedClass.value = null;
    try {
      for (var teacher in teacherNameList) {
        if (teacher.teacherName == teacherName) {
          selectedTeacher.value = teacher;
          teacherClassList.value = teacher.details ?? [];
        }
      }
    } catch (e) {}
  }

  Future<void> getTeacherSubjectData({required String classAndBatch}) async {
    teacherSubjectList.value = [];
    selectedClass.value = null;
    selectedSubject.value = null;
    try {
      for (var classes in teacherClassList) {
        if ("${classes.className} ${classes.batchName}" == classAndBatch) {
          selectedClass.value = classes;
          teacherSubjectList.value = classes.subjectDetails ?? [];
        }
      }
    } catch (e) {}
  }

  Future<void> setTeacherSubjectData({required String subName}) async {
    try {
      for (var sub in teacherSubjectList) {
        if (sub.subjectName == subName) {
          selectedSubject.value = sub;
        }
      }
    } catch (e) {}
  }

  Future<void> refreshLessLearnData() async {
    List<LessonLearningApplyModel> lessLearn =
        await LessonLearningDatabase.instance.readAllLessonLearn();
    List<LearningwalkSubmitModel> lerningLearn =
        await LearningWalkDB.instance.fetchLearningWalks();

    learningData.value =
        lerningLearn.where((data) => data.addedDate == false).toList();
    lessonData.value =
        lessLearn.where((data) => data.isLesson == true).toList();
    print('lesson learn db length-------${lessonData.length}');
  }

  Future<void> lessonSubmit(BuildContext context) async {
    bool result = await CheckConnectivity().check();
    if (!result) {
      await snackBar(
          context: context,
          message: "No internet connection",
          color: Colors.red);
    } else {
      for (var data in lessonData) {
        try {
          Map<String, dynamic> resp =
              await ApiServices.lessonWalkSubmit(reqData: data);
          if (resp['status']['code'] == 200) {
            await LessonLearningDatabase.instance.delete(data.id!);
          } else {
            TeacherAppPopUps.submitFailed(
              title: "Error",
              message: "Failed to sync data.",
              actionName: "Close",
              iconData: Icons.error_outline,
              iconColor: Colors.red.shade900,
            );
            break;
          }
        } on SocketException {
          TeacherAppPopUps.submitFailed(
            title: "Error",
            message: "Internet connection is not stable",
            actionName: "Close",
            iconData: Icons.done,
            iconColor: Colors.green,
          );
          break;
        } catch (e) {
          TeacherAppPopUps.submitFailed(
            title: "Error",
            message: "Something went wrong",
            actionName: "Close",
            iconData: Icons.done,
            iconColor: Colors.green,
          );
          break;
        }
      }
    }
    await refreshLessLearnData().then((_) {
      if (lessonData.isEmpty) {
        TeacherAppPopUps.submitFailed(
          title: "Success",
          message: "Lesson Observation Result Added Successfully",
          actionName: "Close",
          iconData: Icons.done,
          iconColor: Colors.green,
        );
      }
    });
  }

  Future<void> learningSubmit(BuildContext context) async {
    bool result = await CheckConnectivity().check();
    if (!result) {
      await snackBar(
          context: context,
          message: "No internet connection",
          color: Colors.red);
    } else {
      for (var data in learningData) {
        try {
          Map<String, dynamic> resp =
              await ApiServices.getLearningwalksubmit(data: data);
          if (resp['status']['code'] == 200) {
          } else {
            TeacherAppPopUps.submitFailed(
              title: "Error",
              message: "Failed to sync data.",
              actionName: "Close",
              iconData: Icons.error_outline,
              iconColor: Colors.red.shade900,
            );
            break;
          }
        } on SocketException {
          TeacherAppPopUps.submitFailed(
            title: "Error",
            message: "Internet connection is not stable",
            actionName: "Close",
            iconData: Icons.done,
            iconColor: Colors.green,
          );
          break;
        } catch (e) {
          TeacherAppPopUps.submitFailed(
            title: "Error",
            message: "Something went wrong",
            actionName: "Close",
            iconData: Icons.done,
            iconColor: Colors.green,
          );
          break;
        }
      }
    }
    await refreshLessLearnData().then((_) {
      if (learningData.isEmpty) {
        TeacherAppPopUps.submitFailed(
          title: "Success",
          message: "Learning Walk Result Added Successfully",
          actionName: "Close",
          iconData: Icons.done,
          iconColor: Colors.green,
        );
      }
    });
  }
}
