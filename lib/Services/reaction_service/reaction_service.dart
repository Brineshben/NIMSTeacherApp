import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teacherapp/Utils/api_constants.dart';

class ReactionService {
  static Future<bool> postReaction(
      {required String reaction,
      required String messageId,
      required String parentId}) async {
    String url = ApiConstants.chat + ApiConstants.reactionSent;
    print("ReactionSent--url---------------------$url");

    Map<String, String> apiHeader = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> apiBody = {
      "react": reaction,
      "chat_id": messageId,
      "parent_id": parentId
    };
    print('ReactionSent--body---------------------->${jsonEncode(apiBody)}');
    try {
      final response = await http.post(Uri.parse(url),
          headers: apiHeader, body: jsonEncode(apiBody));

      print(
          "ReactionSent--response.statusCode ---------------------${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("ReactionSent--Json---------------------${jsonData}");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
