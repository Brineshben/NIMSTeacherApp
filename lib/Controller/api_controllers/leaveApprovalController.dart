
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/leave_approval_api_model.dart';
import '../../Services/api_services.dart';

class LeaveApprovalController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<LeaveData> leaveData = LeaveData().obs;
  RxList<Pendings> pendingLeaves = <Pendings>[].obs;
  RxList<ApprovedOrRejected> approvedOrRejectedLeaves = <ApprovedOrRejected>[].obs;
  RxList<AllLeaves> allLeaves = <AllLeaves>[].obs;
  RxList<Pendings> filteredPendingLeaves = <Pendings>[].obs;
  RxList<ApprovedOrRejected> filteredApprovedOrRejectedLeaves = <ApprovedOrRejected>[].obs;
  RxList<AllLeaves> filteredAllLeaves = <AllLeaves>[].obs;
  Rx<ApprovedOrRejected> selectedLeave = ApprovedOrRejected().obs;
  RxInt currentTab = 0.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    isLoading.value = false;
    isError.value = false;
    isLoaded.value = false;
    leaveData.value = LeaveData();
    pendingLeaves.value = [];
    approvedOrRejectedLeaves.value = [];
    allLeaves.value = [];
    filteredPendingLeaves.value = [];
    filteredApprovedOrRejectedLeaves.value = [];
    filteredAllLeaves.value = [];
    selectedLeave.value = ApprovedOrRejected();
    currentTab.value = 0;
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
      await ApiServices.getLeaveApproval(schoolId: scId, accYr: acYr, userId: usrId);
      if (resp['status']['code'] == 200) {
        LeaveApprovalApi leaveRequestListApiModel = LeaveApprovalApi.fromJson(resp);
        leaveData.value = leaveRequestListApiModel.data ?? LeaveData();
        pendingLeaves.value = leaveData.value.pendings ?? [];
        filteredPendingLeaves.value = pendingLeaves.value;
        approvedOrRejectedLeaves.value = leaveData.value.apprvedOrRejected ?? [];
        filteredApprovedOrRejectedLeaves.value = approvedOrRejectedLeaves.value;
        allLeaves.value = leaveData.value.allLeaves ?? [];
        filteredAllLeaves.value = allLeaves.value;
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------leave approval error-----------");
    } finally {
      resetStatus();
    }
  }

  void filterLeaveList({required String text}) {
    if(currentTab.value == 0) {
      filteredPendingLeaves.value = pendingLeaves.value.where((leave) {
        return leave.studentName.toString().toLowerCase().contains(text.toLowerCase());
      }).toList();
    }
    if(currentTab.value == 1) {
      filteredApprovedOrRejectedLeaves.value = approvedOrRejectedLeaves.value.where((leave) {
        return leave.studentName.toString().toLowerCase().contains(text.toLowerCase());
      }).toList();
    }
    if(currentTab.value == 2) {
      filteredAllLeaves.value = allLeaves.value.where((leave) {
        return leave.studentName.toString().toLowerCase().contains(text.toLowerCase());
      }).toList();
    }
  }

  void setSelectedLeave({required ApprovedOrRejected value}) {
    selectedLeave.value = value;
  }

  void setCurrentLeaveTab({required int index}) {
    currentTab.value = index;
  }
}
