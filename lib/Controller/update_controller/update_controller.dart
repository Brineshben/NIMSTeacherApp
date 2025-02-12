import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherapp/Models/update_model/update_model.dart';
import 'package:teacherapp/Services/update_service/update_service.dart';

class AppUpdateController extends GetxController {
  String finalDate = "";
  String link = "";
  bool isLoading = false;
  bool isError = false;
  bool isAfterUpdate = false;

  DateTime convertToDateTime(String? dateString) {
    if (dateString == null) {
      return DateTime.now();
    }
    return DateFormat("dd-MM-yyyy").parse(dateString);
  }

  String formatDate(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  Future<bool> getUpdate() async {
    isLoading = true;
    isError = false;
    update();

    final sharedPre = await SharedPreferences.getInstance();
    try {
      UpdateModel? updateData = await UpdateService().getUpdate();

      if (updateData != null) {
        if (updateData.data?.details?.response?.showPopup == true) {
          print(
              "Date 1 -------------------- ${updateData.data?.details?.response?.date}");
          DateTime dateData =
              convertToDateTime(updateData.data?.details?.response?.date);
          // DateTime dateData = convertToDateTime("05-01-2025");
          final date = dateData.add(const Duration(days: 30));
          finalDate = formatDate(date);

          sharedPre.setString("updateDate", finalDate);

          link = updateData.data?.details?.response?.url ?? "";

          sharedPre.setString("updateLink", link);

          if (DateTime.now().isAfter(date)) {
            isAfterUpdate = true;
          }

          isLoading = false;
          update();
          return true;
        } else {
          isLoading = false;
          // isError = true;
          update();
          return false;
        }
      } else {
        isLoading = false;
        // isError = true;
        update();
        return false;
      }
    } catch (e) {
      final date = sharedPre.getString("updateDate");
      final udpatelink = sharedPre.getString("updateLink");
      if (date == null || udpatelink == null) {
        isLoading = false;
        // isError = true;
        update();
        return false;
      } else {
        finalDate = date;
        link = udpatelink;
        DateTime dateData = convertToDateTime(date);

        if (DateTime.now().isAfter(dateData)) {
          isAfterUpdate = true;
        }
        isLoading = false;
        // isError = true;
        update();
        return true;
      }
    }
  }
}
