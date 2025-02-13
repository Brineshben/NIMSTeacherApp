import 'dart:convert';
 
import 'package:http/http.dart' as http;

import 'package:teacherapp/Utils/api_constants.dart';

import '../Models/api_models/update_model.dart';
 
class UpdateService {
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