import 'package:teacherapp/Models/api_models/chat_group_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_chat_list_api_model.dart';


class ForwardModelChatList {
  bool select;
  ClassTeacherGroup messageGroupdata;

  ForwardModelChatList({required this.select, required this.messageGroupdata});
}

class ForwardModelChats {
  bool select;
  Datum messageGroupdata;

  ForwardModelChats({required this.select, required this.messageGroupdata});
}
