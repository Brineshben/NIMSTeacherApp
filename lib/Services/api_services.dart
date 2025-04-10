import 'dart:convert';
import 'dart:developer';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:teacherapp/Models/api_models/learning_walk_apply_model.dart';
import 'package:teacherapp/Models/api_models/leave_req_list_api_model.dart';

import '../Models/api_models/HosUpdateModel.dart';
import '../Models/api_models/LearningwalkSubmit.dart';
import '../Models/api_models/chat_feed_view_model.dart';
import '../Models/api_models/notificationModel.dart';
import '../Models/api_models/parent_chatting_model.dart';
import '../Models/api_models/recentlist_model.dart';
import '../Models/api_models/sent_msg_by_teacher_model.dart';
import '../Models/api_models/student_add_Model.dart';
import '../Models/api_models/student_updateModel.dart';
import '../Models/api_models/time_table_api_model.dart';
import '../Models/api_models/update_app_model.dart';
import '../Utils/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();

  ApiServices._internal();

  factory ApiServices() {
    return _instance;
  }

  static Future<Map<String, dynamic>> userLogin({
    required String userName,
    required String psw,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.login}";
    print(url);
    Map apiBody = {
      "username": userName,
      "password": psw,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> user login${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      return json.decode(respString);
      // if (response.statusCode == 200) {
      //   return json.decode(respString);
      // } else {
      //   throw Exception(response.statusCode);
      // }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String userName,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.forgotPassword}";
    print(url);
    Map apiBody = {
      "username": userName,
    };
    // try {
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    print('Api body---------------------->${request.body}');
    request.headers.addAll(ApiConstants.headers);
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    // if (response.statusCode == 200) {
    return json.decode(respString);
    // } else {
    //   throw Exception(response.statusCode);
    // }
    // } catch (e) {
    //   throw Exception("Service Error");
    // }
  }

  static Future<Map<String, dynamic>> getHosList({
    required String userId,
    required String acYr,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.hosList}";
    print(url);
    Map apiBody = {"user_id": userId, "academic_year": acYr, "hos": false};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->get hos${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getWorkLoadApi({
    required String userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.workLoad}";
    print(url);
    Map apiBody = {"user_id": userId};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get workd load api ${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //brineshleadership

  static Future<Map<String, dynamic>> getLeadership(
      {required String userId,
        required String academicYear,
        required bool hosStatus}) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.lessonObservation}";
    print(url);
    Map apiBody = {
      "user_id": userId,
      "academic_year": academicYear,
      "hos": hosStatus
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> of get leadership${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("----fgbfgb---------$url");
        print("----fgbfgb---------$apiBody");
        print("----fgbfgb---------$respString");
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //focus submit
  static Future<Map<String, dynamic>> getLearningwalksubmit({
    required LearningwalkSubmitModel data,
    // required String academicYear,
    // required String userID,
    // required String addedDate,
    // required String batchId,
    // required String classId,
    // required String cirriculamID,
    // required String evenBetterIF,
    // required String lwfocus,
    // required String notes,
    // required String observationDate,
    // required String questionToPupils,
    // required String questionToTeacher,
    // required String schoolID,
    // required String SenderID,
    // required String SessionID,
    // required String whatWentWell,
    // required List<String> observerRole,

  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.LearningWalksubmit}";
    print(url);
    Map apiBody = {
      "academic_year": data.academicYear,
      "added_by": data.addedBy,
      "added_date":data. addedDate,
      "batch_id": data.batchId,
      "class_id": data.classId,
      "curriculum_id":data.curriculumId,
      "even_better_if": data.evenBetterIf,
      "lw_focus": data.lwFocus,
      "notes": data.notes,
      "observation_date": data.observationDate,
      "observer_roles": data.observerRoles,
      "qs_to_puple": data.qsToPuple,
      "qs_to_teacher": data.qsToTeacher,
      "school_id": data.schoolId,
      "sender_id": data.senderId,
      "session_id": data.sessionId,
      "what_went_well": data.whatWentWell

    };
    print('Lesson observa $apiBody');
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> of learning walk submit${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //focus Learningwalk

  static Future<Map<String, dynamic>> getFocus({
    required String academicYear,
    required String schoolId,
    required String userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.Focus}";
    print(url);
    Map apiBody = {
      "academic_year": academicYear,
      "school_id": schoolId,
      "user_id": userId
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->get foucus${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //Learningwalk new class
  static Future<Map<String, dynamic>> getClass(
      {required String userId,
        required String academicYear,
        required String schoolId,
        required bool isAdmin}) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.classsLW}";
    print(url);
    Map apiBody = {
      "academic_year": academicYear,
      "admin": isAdmin,
      "school_id": schoolId,
      "user_id": userId
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get class ${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  // Learningwalk new batch
  static Future<Map<String, dynamic>> getBatch({
    required String academicYear,
    required String schoolId,
    required bool admin,
    required String userId,
    required String classId,
    required List<String> cirriculam,
    required List<String> session,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.batchLW}";
    print(url);
    Map apiBody = {
      "academic_year": academicYear,
      "admin": schoolId,
      "class_id": classId,
      "curriculum": cirriculam,
      "school_id": schoolId,
      "session": session,
      "user_id": userId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->get batch${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

//teacher List
  static Future<Map<String, dynamic>> getTeacherdata({
    required String academicYear,
    required String schoolId,
    required String sessionID,
    required String batchID,
    required String cirriculamID,
    required bool admin,
    required String userId,
    required String classId,
    required List<String> cirriculam,
    required List<String> session,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.teacherLW}";
    print(url);
    Map apiBody = {
      "academic_year": academicYear,
      "admin": admin,
      "batch_id": batchID,
      "class_id": classId,
      "curriculum": cirriculam,
      "curriculum_id": cirriculamID,
      "school_id": schoolId,
      "session": session,
      "session_id": sessionID,
      "user_id": userId
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body-----bennn-----------------> get teachers data${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

//Qr

  static Future<List<dynamic>> getQRdata(
      {required String searchKey,
        required String instId,
        required String type}) async {
    String url = ApiConstants.docMeUrl + ApiConstants.qrScan;
    print(url);
    Map apiBody = {"searchkey": searchKey, "inst_id": instId, "type": type};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get qrcodes${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<List<dynamic>> getSearchdata(
      {required String searchKey,
        required String instId,
        required String type}) async {
    String url = ApiConstants.docMeUrl + ApiConstants.qrScan;
    print(url);
    Map apiBody = {"searchkey": searchKey, "inst_id": instId, "type": type};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get search${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getTimeTableData(
      {required String schoolId,
        required String academicYear,
        required String teacherId}) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.timeTable}";
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "teacher_id": teacherId
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->get timetable data${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getNotification({
    required String userId,
  }) async {
    String url =
        '${ApiConstants.baseUrl}${ApiConstants.notification}$userId${ApiConstants.notificationEnd}';
    // print(' this is the get url $url');
    Map apiBody = {
      "user_id": userId,
    };
    try {
      var request = http.Request('GET', Uri.parse(url));
      request.body = (json.encode(apiBody));
      // print('Api body---------------------->getNotifications${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getMarkasReadNotification({
    required String userId,
    required String notificationId,
  }) async {
    String url = '${ApiConstants.baseUrl}${ApiConstants.updatenotification}';
    print(url);
    Map apiBody = {"user_id": userId, "notification_id": notificationId};
    try {
      var request = http.Request('PUT', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get mrkasRead${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getTimeTable({
    required String userId,
    required String academicYear,
    required String teacherId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.timeTable}";
    print(url);
    Map apiBody = {
      "school_id": userId,
      "academic_year": academicYear,
      "teacher_id": teacherId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get timetable${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error$e");
    }
  }

  static Future<Map<String, dynamic>> getClassGroupList({
    required String teacherId,
    required String emailId,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.classGroup}";
    print(url);
    Map apiBody = {
      "teacher_id": teacherId,
      "email": emailId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get chalass group list${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getParentChatList({
    required String teacherId,
    required String teacherEmail,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.parentChatList}";
    print(url);
    Map apiBody = {
      "teacher_id": teacherId,
      "email": teacherEmail,
      "offset": 0,
      "limit": 500
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->get parrantes chat${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> googleSignInApi({
    required String user,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.googleSignIn}";
    print(url);
    Map apiBody = {
      "username": user,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> google sing in api ${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      return json.decode(respString);
      // if (response.statusCode == 200) {
      //   return json.decode(respString);
      // } else {
      //   throw Exception(response.statusCode);
      // }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> sentMsgByTeacher({
    required SentMsgByTeacherModel teacherMsg,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.sentMsgByTeacher}";
    print(url);
    Map apiBody = teacherMsg.toJson();
    // Map apiBody = {
    //   "class": teacherMsg.classs,
    //   "batch": teacherMsg.batch,
    //   "subject_id": teacherMsg.subjectId,
    //   "subject": teacherMsg.subject,
    //   "message_from": teacherMsg.messageFrom,
    //   "message": teacherMsg.message,
    //   "reply_id" : teacherMsg.replyId,
    //   "parents": teacherMsg.parents,
    //   "file_data": {
    //     "name": teacherMsg.fileData?.name,
    //     "org_name": teacherMsg.fileData?.orgName,
    //     "extension": teacherMsg.fileData?.extension,
    //   }
    // };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->sent msgTecher${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getChatFeedView({
    required ChatFeedViewReqModel reqBodyData,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.teacherMsgList}";
    print(url);
    Map apiBody = {
      "class": reqBodyData.classs,
      "batch": reqBodyData.batch,
      "subject_id": reqBodyData.subjectId,
      "teacher_id": reqBodyData.teacherId,
      "school_id": reqBodyData.schoolId,
      "offset": reqBodyData.offset,
      "limit": reqBodyData.limit,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get Chatfeddview${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<dynamic> sendAttachment({
    required String filePath,
  }) async {
    String url = ApiConstants.chat + ApiConstants.fileUpload;
    print("--url--$url");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      var file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      String respString = await response.stream.bytesToString();
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> deleteSenderMsg({
    required int msgId,
    required String teacherId,
  }) async {
    String url = ApiConstants.chat + ApiConstants.deleteMsg;
    print("--url--$url");
    try {
      Map<String, dynamic> apiBody = {
        "message_id": msgId,
        "parent_id": teacherId
      };

      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode(apiBody);
      print('Api body----------------------> get delete sender msg${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      String respString = await response.stream.bytesToString();
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getParentList({
    required String classs,
    required String batch,
    required String subId,
    required String schoolId,
  }) async {
    String url = ApiConstants.chat + ApiConstants.parentList;
    print("Parentlist--url--$url");
    try {
      Map<String, dynamic> apiBody = {
        "class": classs,
        "batch": batch,
        "subject_id": subId,
        "school_id": schoolId,
      };

      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode(apiBody);
      print('Parentlist Api body---------------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      String respString = await response.stream.bytesToString();
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getGroupedViewList({
    required String classs,
    required String batch,
    required String subId,
    required String schoolId,
    required String teacherId,
  }) async {
    String url = ApiConstants.chat + ApiConstants.groupedView;
    print("--url--$url");
    try {
      Map<String, dynamic> apiBody = {
        "teacher_id": teacherId,
        "class": classs,
        "batch": batch,
        "school_id": schoolId,
        "offset": 0,
        "limit": 100
      };

      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode(apiBody);
      print('Api body----------------------> get group list${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      String respString = await response.stream.bytesToString();
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> getParentChatting({
    required ParentChattingReqModel reqBodyData,
  }) async {
    String url = "${ApiConstants.chat}${ApiConstants.parentChatMessages}";
    print(url);
    Map apiBody = {
      "class": reqBodyData.classs,
      "batch": reqBodyData.batch,
      "parent_id": reqBodyData.parentId,
      "teacher_id": reqBodyData.teacherId,
      "school_id": reqBodyData.schoolId,
      "offset": reqBodyData.offset,
      "limit": reqBodyData.limit,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body---------------------->Get parrent chating ${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getLeaveReqList({
    required String schoolId,
    required String accYr,
    required String userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.leaveReqList}";
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": accYr,
      "user_id": userId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get leave Reqlist${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getLeaveApproval({
    required String schoolId,
    required String accYr,
    required String userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.leaveApprovalList}";
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": accYr,
      "user_id": userId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> get leave approval${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<dynamic> leaveFileUpload({
    required String userId,
    required String filePath,
  }) async {
    String url = ApiConstants.downloadUrl + ApiConstants.leaveFileUpload;
    print("--url--$url");
    try {
      String fileName = filePath.split('/').last;
      String mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
      MediaType mediaType = MediaType.parse(mimeType);
      var request = http.MultipartRequest('POST', Uri.parse(url));
      var file = await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: fileName,
        contentType: mediaType,
      );
      request.files.add(file);
      request.fields['userPath'] = '$userId/leaveDocs/';
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      String respString = await response.stream.bytesToString();
      log("Raw Response: $respString");
      return respString;
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> leaveReqSubmit({
    required LeaveRequestModel reqData,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.requestLeave}";
    print(url);
    Map apiBody = reqData.toJson();

    if (apiBody['documentPath'] is String) {
      apiBody['documentPath'] = apiBody['documentPath']
          .replaceAll("\"", "")
          .replaceAll("\\", "");
    }

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Api body----------------------> leave Reqsubmit${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> lessonWalkSubmit({
    required LessonLearningApplyModel reqData,
  }) async {
    String url =
        "${ApiConstants.baseUrl}${reqData.isLesson ? ApiConstants.lessonSubmit : ApiConstants.learningWalkSubmit}";
    print(url);
    Map apiBody = reqData.lessonLearning.toJson();
    // apiBody.remove('submitted_date');
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body----------------------> lsswon walk sumbit + lseson${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //hierarchylist
  static Future<Map<String, dynamic>> loadHierarchyList({
    required String schoolId,
    required String academicYear,
    required String id,
    required String name,
  }) async {
    String url = ApiConstants.baseUrl + ApiConstants.hierarchyList;
    print(url);
    Map apiBody = {
      "args": {
        "school_id": schoolId,
        "academic_year": academicYear,
        "_id": id,
        "name": name
      }
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body----------------------> loadhireay list${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> loadObsResult({
    required String schoolId,
    required String academicYear,
    required String teacherId,
  }) async {
    String url = ApiConstants.baseUrl + ApiConstants.observationResult;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "teacher_id": teacherId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body----------------------> loadobsresult${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getRecentList({
    required String schoolId,
    required String academicYear,
    required String teacherID,
    required List<Map<String, dynamic>> endorsedClass,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.recentVisit;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "teacher_id": teacherID,
      "Endorsed_class": endorsedClass,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body---------------------->get recentlist${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }
  //hos full list clinic

  static Future<Map<String, dynamic>> getHosAllStudentList({
    required String schoolId,
    required String academicYear,
    required String date,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.hosAllStudentListClinic;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "Date": date
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body---------------------->get all studndents list${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //popup
  static Future<Map<String, dynamic>> popupcontoller({
    required String schoolId,
    required String academicYear,
    required String date,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.hosAllStudentListClinic;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "Date": date
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body---------------------->pop controler ${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

//get Hos Student listDate
  static Future<Map<String, dynamic>> getHosStudentListDate({
    required String schoolId,
    required String academicYear,
    required String userId,
    required String date,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.hosStudentsListClinic;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "user_id": userId,
      "Date": date,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body---------------------->get hos studentlist${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //get Hos Student list
  static Future<Map<String, dynamic>> getHosStudentList({
    required String schoolId,
    required String academicYear,
    required String userId,
    required String date,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.hosStudentsListClinic;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "user_id": userId,
      "Date": date,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body--------vebebebebeb-------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> getRecentDateList({
    required String schoolId,
    required String academicYear,
    required String teacherId,
    required List<Map<String, dynamic>> endorsedClass,
    required String date,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.recentVisit;
    print(url);
    Map apiBody = {
      "school_id": schoolId,
      "academic_year": academicYear,
      "teacher_id": teacherId,
      "Endorsed_class": endorsedClass,
      "Date": date,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body----------------------> get resend deatials${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

//summit data add students
  static Future<Map<String, dynamic>> getSubmit({
    required StudentAddModel data,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.addClinicStudents;
    print(url);
    Map apiBody = {
      "Admn_No": data.admnNo,
      "student_name": data.studentName,
      "profile_pic": data.profilePic,
      "batch_details": data.batchDetails,
      "academic_year": data.academicYear,
      "inst_ID": data.instID,
      "age": data.age,
      "dob": data.dob,
      "gender": data.gender,
      "father_name": data.fatherName,
      "father_phone": data.fatherPhone,
      "father_email": data.fatherEmail,
      "remarks": data.remarks,
      "role": data.role,
      "app_type": data.appType,
      "visit_status": data.visitStatus,
      "sent_by": data.sentBy,
      "sent_to": data.sentTo,
      "send_to_name": data.sentToName,
      "sent_by_id": data.sentById,
      "sent_by_token": data.sentByToken
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body studenthere-------------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //get Notifications Submit
  static Future<Map<String, dynamic>> getSubmitnotifications({
    required NotificationModel data,
  }) async {
    String url = ApiConstants.baseUrl + ApiConstants.notificationclinic;
    print(url);
    Map apiBody = {
      "id": data.id,
      "student_name": data.studentName,
      "class": data.classs,
      "batch": data.batch,
      "visit_date": data.visitDate,
      "visit_status": data.visitStatus,
      "remarks": data.remarks,
      "admission_no": data.admissionNo,
      "isprogress": data.isprogress,
      "sent_by_id": data.sentById,
      "send_by": data.sendByName,
      "role_of_sender": data.roleOfSender,
      "school_id": data.schoolId,
      "sound": data.sound
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body studenthere-------------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  //submitHOSdata

  static Future<Map<String, dynamic>> getSubmitHosdata({
    required HosUpdateModel data,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.hosDataUpdateClinic;
    print(url);
    Map apiBody = {
      "id": data.id,
      "visit_status": data.visitStatus,
      "sent_by": data.sentBy, //teacher name
      "sent_by_id": data.sentById //teacher id
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body-of Hosdataupdate--------------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

//summit data add students
  static Future<Map<String, dynamic>> getSubmitdata({
    required StudentUpdateModel data,
  }) async {
    String url = ApiConstants.bmClinic + ApiConstants.studentUpdateClinic;
    print(url);
    Map apiBody = {
      "visit_id": data.visitId,
      "user": data.user,
      "user_id": data.userId,
      "user_token": data.userToken
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body----------------------> submit data${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> fcmTokenSent({
    required String fcmToken,
    required String emailId,
  }) async {
    String url = ApiConstants.baseUrl + ApiConstants.fcmSentApi;
    print(url);
    Map apiBody = {
      "username": emailId,
      "device_id": fcmToken,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body----------------------> fcm tomeken send${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Error");
    }
  }

  static Future<Map<String, dynamic>> fcmtokenlogout({
    required String emailId,
  }) async {
    String url = ApiConstants.baseUrl + ApiConstants.logoutFcm;
    print(url);
    Map apiBody = {
      "email_id": emailId,
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      log('Api body--------eebgeg-------------->${request.body}');
      request.headers.addAll(ApiConstants.headers);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("logout successfully");
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("Service Errorsdfgergwrtjhuytuiryi78");
    }
  }

  Future<UpdateModel?> getUpdate() async {
    final url = ApiConstants.baseUrl + ApiConstants.update;

    print("---- URL --------- update ----------- : $url");

    final body = {"app_name": "teacher_app"};

    // Map<String, String> apiHeader = {
    //   'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
    //   'Content-Type': 'application/json',
    //   'API-Key': '525-777-777'
    // };

    print("---- body --------- update ----------- : ${jsonEncode(body)}");

    final resposne = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: ApiConstants.headers);

    print("-------resposne update--------${resposne.body}");

    try {
      if (resposne.statusCode == 200) {
        final jsonData = jsonDecode(resposne.body);
        final updateModelData = UpdateModel.fromJson(jsonData);
        return updateModelData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
