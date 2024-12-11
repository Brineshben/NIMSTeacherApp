import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teacherapp/Models/api_models/message_info_model.dart';
import 'package:teacherapp/Utils/api_constants.dart';

class MessageInfoService {
  static Future<MessageInfoModel?> getMessageInfo(
      {required int messageId}) async {
    String url = ApiConstants.chat + ApiConstants.messageInfo;
    print("messageInfo--url---------------------$url");

    Map<String, String> apiHeader = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> apiBody = {"message_id": messageId};
    print('messageInfo--body---------------------->${apiBody}');
    try {
      final response = await http.post(Uri.parse(url),
          headers: apiHeader, body: jsonEncode(apiBody));
      print("messageInfo start");
      print(
          "messageInfo--response.statusCode ---------------------${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("messageInfo--Json---------------------${jsonData}");

        MessageInfoModel data = MessageInfoModel.fromJson(jsonData);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("messageInfo--Error---------------------$e");
      return null;
    }
  }
}
