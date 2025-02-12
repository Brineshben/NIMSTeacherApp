import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/ui_models/menu_item_model.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxList<MenuItemsModel> menuItemsPerRole = <MenuItemsModel>[].obs;
  RxInt navLength = 4.obs;
  Rx<RemoteMessage?> message = Rx(null);
  RxBool isChatScreen = false.obs;

  void changePage({required int currentPage}) {
    pageIndex.value = currentPage;
  }

  void setMenuItems(
      {required UserRole userRole, required bool isClassTeacher}) {
    if (!isClassTeacher) {
      navLength.value = 4;
      menuItemsPerRole.value = choiceTeacherMenuItems;
    } else {
      if (userRole == UserRole.leader) {
        navLength.value = 5;
        menuItemsPerRole.value = leaderMenuItems;
      } else {
        navLength.value = 5;
        menuItemsPerRole.value = teacherMenuItems;
      }
    }
  }
}
