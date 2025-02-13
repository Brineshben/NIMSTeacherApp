import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import '../../Models/api_models/notification_api_model.dart';
import '../../Services/api_services.dart';

class NotificationController extends GetxController {
  RxList<RecentNotifications> Recentnotification = <RecentNotifications>[].obs;
  Rx<NotificationDataModel> Notificationdata = NotificationDataModel().obs;
  RxInt notificationStatusCount = 0.obs;
  RxList<RecentNotifications> unreadnotification = <RecentNotifications>[].obs;
  RxInt dropdownvalue = 1.obs;
  RxString validationmsg = 'No Notifications for you'.obs;
  RxList<RecentNotifications> last7dayslist = <RecentNotifications>[].obs;
  

  void data() {
    Recentnotification.value = [];
    notificationStatusCount.value = 0;
    Notificationdata.value = NotificationDataModel();
  }
 //this funtion calling every 3 sec
  Future<void> fetchNotification() async {
    try {
      String? userId = Get.find<UserAuthController>().userData.value.userId;

      Map<String, dynamic> resp = await ApiServices.getNotification(
        userId: userId.toString(),
      );
      Notificationdata.value = NotificationDataModel.fromJson(resp);
      if (resp['status']['code'] == 200) {
        // teacherNameList.value = lessonDataApi.value.data?.details?.response ?? [];
        Recentnotification.value =
            Notificationdata.value.data?.details?.recentNotifications ?? [];

        //this is filtereing 7 days notification
        DateTime now = DateTime.now();
        DateTime sevenDayAog = now.subtract(const Duration(days: 7));
        last7dayslist.clear();
        last7dayslist.value = Recentnotification.where((notification) {
          if (notification.genDate != null) {
            DateTime? notificationDate =
                DateTime.tryParse(notification.genDate!);
            if (notificationDate != null) {
              return notificationDate.isAfter(sevenDayAog) &&
                  notificationDate.isBefore(now);
            }
          }
          return false;
        }).toList();

        unreadnotification.value = Recentnotification.where((notification) {
          return notification.status == 'active';
        }).toList();
        
     
       

        int noiCount = 0;
        for (var notfication in Recentnotification.value) {
          if (notfication.status == 'active') {
            noiCount += 1;
          }
        }
        notificationStatusCount.value = noiCount;
      } else {}
    } catch (e) {}
  }

  Future<void> sort7daystvalue() async {
    validationmsg.value = 'No notifications in the last 7 days.';

    // DateTime now = DateTime.now();
    // DateTime sevenDayAog = now.subtract(const Duration(days: 7));
    // unreadnotification.clear();
    // unreadnotification.value = Recentnotification.where((notification) {
    //   if (notification.genDate != null) {
    //     DateTime? notificationDate = DateTime.tryParse(notification.genDate!);
    //     if (notificationDate != null) {
    //       return notificationDate.isAfter(sevenDayAog) &&
    //           notificationDate.isBefore(now);
    //     }
    //   }
    //   return false;
    // }).toList();
     dropdownvalue.value =1;
  }

  sortAllNotification() async {
    // fetchNotification();
    dropdownvalue.value = 2;

    validationmsg.value = 'No Notifications for you';
  }

  Future<void> sortUnreadNotifications() async {
    // unreadnotification.value = Recentnotification.where((notification) {
    //   return notification.status == 'active';
    // }).toList();
    validationmsg.value = 'No unread notifications.';
    dropdownvalue.value = 3;
    // Recentnotification.value = unreadnotification;
  }
}
