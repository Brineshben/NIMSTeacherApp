
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Models/api_models/leave_req_list_api_model.dart';
import '../../Services/api_services.dart';

class LeaveRequestController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<ClassData> classList = <ClassData>[].obs;
  Rx<ClassData> classData = ClassData().obs;
  RxList<StudentsData> studentList = <StudentsData>[].obs;
  RxList<StudentsData> filteredStudentList = <StudentsData>[].obs;
  RxInt currentClassIndex = 0.obs;
  RxString claass = ''.obs;
  RxString batch = ''.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    classList.value = [];
    studentList.value = [];
    currentClassIndex.value = 0;
  }

  Future<void> fetchLeaveReqList() async {
    resetData();
    isLoading.value = true;
    isLoaded.value = false;
    try {
      String usrId = Get.find<UserAuthController>().userData.value.userId ?? '';
      String acYr = Get.find<UserAuthController>().userData.value.academicYear ?? '';
      String scId = Get.find<UserAuthController>().userData.value.schoolId ?? '';
      Map<String, dynamic> resp =
      await ApiServices.getLeaveReqList(schoolId: scId, accYr: acYr, userId: usrId);
      if (resp['status']['code'] == 200) {
        LeaveRequestListApiModel leaveRequestListApiModel = LeaveRequestListApiModel.fromJson(resp);
        classList.value = leaveRequestListApiModel.data?.details ?? [];

        if(classList.value.isNotEmpty) {
                     classList.sort((a, b) =>"${a.className!}${a.batchName!}".compareTo("${b.className!}${b.batchName!}"));
          studentList.value = classList.value.first.students ?? [];
          classData.value = classList.value.first;
          filteredStudentList.value = studentList.value;
          filteredStudentList.sort((a, b) => a.name!.compareTo(b.name!));
          claass.value = classList.value.first.className ?? '--';
          batch.value = classList.value.first.batchName ?? '--';

        }
        isLoaded = true.obs;
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------leave req error-----------");
    } finally {
      resetStatus();
    }
  }

  void setStudentList({required ClassData selectedClassData, required int index}) {
    currentClassIndex.value = index;
    studentList.value = selectedClassData.students ?? [];

    classData.value = selectedClassData;

    filteredStudentList.value = studentList.value;
    filteredStudentList.sort((a, b) => a.name!.compareTo(b.name!));
    claass.value = selectedClassData.className ?? '--';
    batch.value = selectedClassData.batchName ?? '--';
  }

  void filterList({required String text}) {
    filteredStudentList.value = studentList.value
        .where((student) => student.name!.toLowerCase().contains(text.toLowerCase()) || student.admissionNumber!.contains(text))
        .toList();
  }
}
