import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:teacherapp/Utils/api_constants.dart';

class PushNotificationController {
  sendNotification(
      {required String teacherId,
      required String? message,
      required String teacherName,
      required String teacherImage,
      required String messageFrom,
      required String studentClass,
      required String batch,
      required String subId,
      required String subjectName,
      required String? fileName,
      required List<Map<String, String>> parentData}) async {
    final url = ApiConstants.baseUrl + ApiConstants.messagePushNotifiaction;
    print(
        "Push Notification url --------------------------------------------$url");
    print(
        "Push Notification file --------------------------------------------${message}");

    String messagetype = "";
    if (message == null) {
      if (fileName != null) {
        if (fileName.split(".").last == "wav") {
          messagetype = "🎙 Voice message";
        } else if (fileName.split(".").last == "mp3") {
          messagetype = "🎙 Audio message";
        } else {
          messagetype =
              "${fileName.split(".").last.toUpperCase()} file Attached";
        }
      }
    } else {
      messagetype = message;
    }

    Map<String, String> header = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    Map<String, Object> body = {
      "app": "schooldairy",
      "title": "Message from $teacherName",
      "message": messagetype,
      "message_to": parentData,
      "payload": {
        "class": studentClass,
        "batch": batch,
        "subject_Id": subId,
        "subject": subjectName,
        "teacher_id": teacherId,
        "teacher_name": teacherName,
        "teacher_image": teacherImage
      }
    };

    [
      {
        "parent_id": "5d038f25729891326d027fa9",
        "student_id": "642e5a421c17d41497346833"
      }
    ];

    print(
        "Push Notification body --------------------------------------------${body}");

    final respose = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: header);

    if (respose.statusCode == 200) {
      print(
          "Push Notification sent success--------------------------------------------");
    }
  }
}
