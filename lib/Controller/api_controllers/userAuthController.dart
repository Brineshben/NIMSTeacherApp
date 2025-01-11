
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/notificationController.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import 'package:teacherapp/Services/shared_preferences.dart';
import '../../Models/api_models/hos_listing_api_model.dart';
import '../../Models/api_models/login_api_model.dart';
import '../../Services/api_services.dart';
import '../../Utils/Colors.dart';
import '../../View/CWidgets/TeacherAppPopUps.dart';

enum UserRole { leader, bothTeacherAndLeader, teacher }

class UserAuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<UserData> userData = UserData().obs;
  Rx<UserRole?> userRole = Rx<UserRole?>(null);
  Rx<String?> schoolToken = Rx<String?>(null);
  RxList<HosList> hosList = <HosList>[].obs;
  // Rx<HosList?> selectedHos = Rx<HosList?>(null);

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchUserData(
      {required String username, required String password}) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp =
          await ApiServices.userLogin(userName: username, psw: password);
      if (resp['status']['code'] == 200) {
        LoginApiModel loginApi = LoginApiModel.fromJson(resp);
        List<UserData> list = loginApi.data?.data ?? [];
        if (list.isNotEmpty) {
          userData.value = loginApi.data?.data?.first ?? UserData();
          String? schoolId = userData.value.schoolId;
          if (schoolId != null) {
            await setFirebaseToken();
            setSchoolTokenAndRoll(schoolId);
            getNotificationPeriodically();
          }
          if((list.first.roleIds?.isNotEmpty ?? false) && list.first.roleIds != null && !list.first.roleIds!.contains("") && !list.first.roleIds!.contains("student")) {
            await SharedPrefs().setLoginData(loginApi);
            await SharedPrefs().setLoginCreds(
                {
                  "username": username,
                  "password": password
                }
            );
          }
          isLoaded.value = true;
        }
      } else {
        print(".......${resp['error']['message']}");
        TeacherAppPopUps.submitFailed(
          title: "Failed",
          message: "${resp['error']['message'] ?? 'Something went wrong.'}",
          actionName: "Close",
          iconData: Icons.error_outline,
          iconColor: Colorutils.svguicolour2,
        );
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------login error-----------");
      TeacherAppPopUps.submitFailed(
        title: "Failed",
        message: "Something went wrong.",
        actionName: "Close",
        iconData: Icons.error_outline,
        iconColor: Colorutils.svguicolour2,
      );
    } finally {
      resetStatus();
    }
  }

  Future<void> googleSignInUser({required String username}) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.googleSignInApi(user: username);
      if (resp['status']['code'] == 200) {
        LoginApiModel loginApi = LoginApiModel.fromJson(resp);
        List<UserData> list = loginApi.data?.data ?? [];
        if (list.isNotEmpty) {
          userData.value = loginApi.data?.data?.first ?? UserData();
          String? schoolId = userData.value.schoolId;
          if (schoolId != null) {
            await setFirebaseToken();
            setSchoolTokenAndRoll(schoolId);
            getNotificationPeriodically();
          }
          if((list.first.roleIds?.isNotEmpty ?? false) && list.first.roleIds != null && !list.first.roleIds!.contains("") && !list.first.roleIds!.contains("student")) {
            await SharedPrefs().setLoginData(loginApi);
            await SharedPrefs().setLoginCreds(
                {
                  "username": username
                }
            );
          }
          isLoaded.value = true;
        }
      } else {
        TeacherAppPopUps.submitFailed(
          title: "Failed",
          message: "${resp['error']['message'] ?? 'Something went wrong.'}",
          actionName: "Close",
          iconData: Icons.error_outline,
          iconColor: Colorutils.svguicolour2,
        );
      }
    } catch (e) {
      isLoaded.value = false;
      print("-----------google login error-----------");
      TeacherAppPopUps.submitFailed(
        title: "Failed",
        message: "Something went wrong.",
        actionName: "Close",
        iconData: Icons.error_outline,
        iconColor: Colorutils.svguicolour2,
      );
    } finally {
      resetStatus();
    }
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    Map<String, dynamic>? loginCreds = await SharedPrefs().getLoginCreds();
    if(loginCreds != null) {
      if(loginCreds['username'] != null && loginCreds['password'] == null) {
        try {
          Map<String, dynamic> resp = await ApiServices.googleSignInApi(user: loginCreds['username']);
          if (resp['status']['code'] == 200) {
            LoginApiModel loginApi = LoginApiModel.fromJson(resp);
            List<UserData> list = loginApi.data?.data ?? [];
            if (list.isNotEmpty) {
              userData.value = loginApi.data?.data?.first ?? UserData();
              String? schoolId = userData.value.schoolId;
              if (schoolId != null) {
                await setFirebaseToken();
                setSchoolTokenAndRoll(schoolId);
                getNotificationPeriodically();
              }
              if((list.first.roleIds?.isNotEmpty ?? false) && list.first.roleIds != null && !list.first.roleIds!.contains("") && !list.first.roleIds!.contains("student")) {
                await SharedPrefs().setLoginData(loginApi);
                await SharedPrefs().setLoginCreds(
                    {
                      "username": loginCreds['username']
                    }
                );
              }
            }
          }
        } catch (e) {} finally {}
      } else {
        try {
          Map<String, dynamic> resp =
          await ApiServices.userLogin(userName: loginCreds['username'], psw: loginCreds['password']);
          if (resp['status']['code'] == 200) {
            LoginApiModel loginApi = LoginApiModel.fromJson(resp);
            List<UserData> list = loginApi.data?.data ?? [];
            if (list.isNotEmpty) {
              userData.value = loginApi.data?.data?.first ?? UserData();
              String? schoolId = userData.value.schoolId;
              if (schoolId != null) {
                await setFirebaseToken();
                setSchoolTokenAndRoll(schoolId);
                getNotificationPeriodically();
              }
              if((list.first.roleIds?.isNotEmpty ?? false) && list.first.roleIds != null && !list.first.roleIds!.contains("") && !list.first.roleIds!.contains("student")) {
                await SharedPrefs().setLoginData(loginApi);
                await SharedPrefs().setLoginCreds(
                    {
                      "username": loginCreds['username'],
                      "password": loginCreds['password']
                    }
                );
              }
            }
          }
        } catch (e) {} finally {}
      }
    }

    if((userData.value.roleIds?.isNotEmpty ?? false) && userData.value.roleIds != null && !userData.value.roleIds!.contains("") && !userData.value.roleIds!.contains("student")) {

    } else {
      LoginApiModel? loginApi = await SharedPrefs().getLoginData();
        userData.value = loginApi?.data?.data?.first ?? UserData();
      String? userId = userData.value.userId;
      if (userId != null) {
        // await Get.find<ChatClassGroupController>().fetchClassGroupList();
        isLoaded.value = true;
        await setFirebaseToken();
        getNotificationPeriodically();
      } else {
        isLoaded.value = false;
      }
      String? schoolId = userData.value.schoolId;
      if (schoolId != null) {
        await setSchoolTokenAndRoll(schoolId);
      }
    }
    isLoading.value = false;
  }

  Future<void> getNotificationPeriodically() async {
    await Get.find<NotificationController>().fetchNotification();
    await Future.delayed(const Duration(seconds: 3));
    await getNotificationPeriodically();
  }

  Future<void> setSchoolTokenAndRoll(schoolId) async {
    List<String> roleIds = userData.value.roleIds ?? [];
    if (schoolId == "CPpbKPQTcuG97i3kv") {
      schoolToken.value = "7a9d733269d23bc35b04b56dc855d330";
    }

    if(schoolId == "ps4vyLJhQvPZjfxaH") {
      schoolToken.value = "99d351fe9165be1c0cf35fa0a0885c17";
    }

    if(schoolId == "m2LMtqaESFZf6xDE8") {
      schoolToken.value = "47e2b919b8551d762e1dd1f5769b66ba";
    }

    if(schoolId == "2FwuqhgeoKt6SQiCG") {
      schoolToken.value = "0ae409a7d98dde57b35a4643d2354906";
    }

    if ((roleIds.contains("rolepri12") ||
        roleIds.contains("role12123") ||
        roleIds.contains("role121234") ||
        roleIds.contains("role121235") ||
        roleIds.contains("5e37f0f7f50ca66f1d22d74b") ||
        roleIds.contains("v2QNTPPvPQK6T") ||
        roleIds.contains("62690f2b15f336042ba786786") ||
        roleIds.contains("5d8b3b701dad2f60218cbe46")) &&
            roleIds.contains("role12123rqwer")) {
      userRole.value = UserRole.bothTeacherAndLeader;
    } else if ((roleIds.contains("rolepri12") ||
        roleIds.contains("role12123") ||
        roleIds.contains("role121234") ||
        roleIds.contains("role121235") ||
        roleIds.contains("5e37f0f7f50ca66f1d22d74b") ||
        roleIds.contains("v2QNTPPvPQK6T") ||
        roleIds.contains("62690f2b15f336042ba786786") ||
        roleIds.contains("5d8b3b701dad2f60218cbe46")) &&
            !roleIds.contains("role12123rqwer")) {
      userRole.value = UserRole.leader;
    } else if (roleIds.contains("role12123rqwer")) {
      userRole.value = UserRole.teacher;
    }

    // if (schoolId == "CPpbKPQTcuG97i3kv") {
    //   schoolToken.value = "7a9d733269d23bc35b04b56dc855d330";
    //   if (roleIds.contains("rolepri12") ||
    //       roleIds.contains("role12123") ||
    //       roleIds.contains("62690f2b15f336042ba786786")) {
    //     userRole.value = UserRole.principal;
    //   } else if (roleIds.contains("role121235") ||
    //       roleIds.contains("role121234") ||
    //       roleIds.contains("v2QNTPPvPQK6T") &&
    //           roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.hos;
    //   } else if (roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.teacher;
    //   }
    // }
    // if (schoolId == "ps4vyLJhQvPZjfxaH") {
    //   schoolToken.value = "99d351fe9165be1c0cf35fa0a0885c17";
    //   if (roleIds.contains("rolepri12") ||
    //       roleIds.contains("role12123") ||
    //       roleIds.contains("62690f2b15f336042ba786786")) {
    //     userRole.value = UserRole.principal;
    //   } else if (roleIds.contains("role121235") ||
    //       roleIds.contains("role121234") ||
    //       roleIds.contains("5d8b3b701dad2f60218cbe46") &&
    //       roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.hos;
    //   } else if (roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.teacher;
    //   }
    // }
    // if (schoolId == "m2LMtqaESFZf6xDE8") {
    //   schoolToken.value = "47e2b919b8551d762e1dd1f5769b66ba";
    //   if (roleIds.contains("rolepri12") ||
    //       roleIds.contains("role12123") ||
    //       roleIds.contains("62690f2b15f336042ba786786")) {
    //     userRole.value = UserRole.principal;
    //   } else if (roleIds.contains("role121235") ||
    //       roleIds.contains("role121234") ||
    //       roleIds.contains("Eqt48DDGmQx8P") &&
    //       roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.hos;
    //   } else if (roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.teacher;
    //   }
    // }
    // if (schoolId == "2FwuqhgeoKt6SQiCG") {
    //   schoolToken.value = "0ae409a7d98dde57b35a4643d2354906";
    //   if (roleIds.contains("rolepri12") ||
    //       roleIds.contains("role12123") ||
    //       roleIds.contains("62690f2b15f336042ba786786")) {
    //     userRole.value = UserRole.principal;
    //   } else if (roleIds.contains("role121235") ||
    //       roleIds.contains("role121234") ||
    //       roleIds.contains("v2QNTPPvPQK6T") &&
    //       roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.hos;
    //   } else if (roleIds.contains("role121235") ||
    //       roleIds.contains("role121234") ||
    //       roleIds.contains("v2QNTPPvPQK6T")) {
    //     userRole.value = UserRole.hos;
    //   } else if (roleIds.contains("role12123rqwer")) {
    //     userRole.value = UserRole.teacher;
    //   }
    // }

    // if(userRole.value == UserRole.bothTeacherAndLeader) {
    //   Get.find<PageIndexController>().setMenuItems(userRole: UserRole.bothTeacherAndLeader, fromChoice: false);
    // }
    if(userRole.value == UserRole.teacher) {
      Get.find<PageIndexController>().setMenuItems(userRole: UserRole.teacher, isClassTeacher: true);
    } else {
      Get.find<PageIndexController>().setMenuItems(userRole: UserRole.leader, isClassTeacher: true);
    }
  }

  Future<void> fetchHosList() async {
    if(userRole.value == UserRole.bothTeacherAndLeader || userRole.value == UserRole.leader) {
      String? userId = userData.value.userId;
      String? academicYear = userData.value.academicYear;
      try {
        Map<String, dynamic> resp =
        await ApiServices.getHosList(userId: userId.toString(), acYr: academicYear.toString());
        if (resp['status']['code'] == 200) {
          HosListApiModel hosListApi = HosListApiModel.fromJson(resp);
          hosList.value = hosListApi.data?.details?.response?.list ?? [];
        }
      } catch (e) {
        print("---------hos list error---sdgdfhgdfjh------");
      } finally {}
    }
  }

  // void setSelectedHosData({required String hosName, String? hosId, required bool isHos}) {
  //   if(isHos) {
  //     selectedHos.value = HosList(
  //       hosName: hosName,
  //       userId: hosId,
  //     );
  //   } else {
  //     if(hosList.value.isNotEmpty) {
  //       for (var hos in hosList.value) {
  //         if(hos.hosName != null) {
  //           if(hos.hosName!.contains(hosName.substring(0, hos.hosName!.length))) {
  //             selectedHos.value = hos;
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  Future<void> setFirebaseToken() async {
    String? fcmToken;
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      fcmToken = await messaging.getToken();
      messaging.requestPermission(
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        alert: true,
        badge: true,
        sound: true,
      );
      messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      if(fcmToken != null) {
        print("--------fcm token-----------$fcmToken");
        Map<String, dynamic> resp = await ApiServices.fcmTokenSent(fcmToken: fcmToken, emailId: userData.value.username ?? '');
        print("--------fcm api resp-----------$resp");
      }
    } catch(e) {
      print("-------fcm token error----------${e.toString()}");
    }
  }
}
