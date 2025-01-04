import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatController.dart';
import 'package:teacherapp/Controller/forward_controller.dart/forward_controller.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Utils/api_constants.dart';

class ForwardService {
  static Future<bool> sentMsgSingle({
    required SentMsgByTeacherModel teacherMsg,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.sentMsgByTeacher}";
    print(url);
    // Map apiBody = teacherMsg.toJson();
    Map apiBody = {
      "class": teacherMsg.classs,
      "batch": teacherMsg.batch,
      "subject_id": teacherMsg.subjectId,
      "subject": teacherMsg.subject,
      "message_from": teacherMsg.messageFrom,
      "message": teacherMsg.message,
      "reply_id": teacherMsg.replyId,
      "parents": teacherMsg.parents,
      "file_data": {"name": null, "org_name": null, "extension": null},
      "is_forward": true,
      "is_forward_id": Get.find<ForwardController>().forwordMessageId
      // Get.find<ParentChattingController>().seletedMsgData!.messageId
    };

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return true;
      } else {
        // throw Exception(response.statusCode);
        print("forward status ================= else");
        return false;
      }
    } catch (e) {
      // throw Exception("Service Error");
      print("forward status ================= $e");

      return false;
    }
  }

  static Future<bool> sentMsgGroup({
    required SentMsgByTeacherModel teacherMsg,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.sentMsgByTeacher}";
    print(url);
    // Map apiBody = teacherMsg.toJson();
    Map apiBody = {
      "class": teacherMsg.classs,
      "batch": teacherMsg.batch,
      "subject_id": teacherMsg.subjectId,
      "subject": teacherMsg.subject,
      "message_from": teacherMsg.messageFrom,
      "message": teacherMsg.message,
      "reply_id": teacherMsg.replyId,
      "parents": teacherMsg.parents,
      "file_data": {"name": null, "org_name": null, "extension": null},
      "is_forward": true,
      "is_forward_id": Get.find<ForwardController>().forwordMessageId
      // Get.find<FeedViewController>().seletedMsgData!.messageId
    };

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return true;
      } else {
        // throw Exception(response.statusCode);
        print("forward status ================= else");
        return false;
      }
    } catch (e) {
      // throw Exception("Service Error");
      print("forward status ================= $e");

      return false;
    }
  }
}
