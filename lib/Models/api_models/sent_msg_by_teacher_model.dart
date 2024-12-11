class SentMsgByTeacherModel {
  String? classs;
  String? batch;
  String? subjectId;
  String? subject;
  String? messageFrom;
  String? message;
  String? replyId;
  List<String>? parents;
  FileData? fileData;

  SentMsgByTeacherModel(
      {this.classs,
      this.batch,
      this.subjectId,
      this.subject,
      this.messageFrom,
      this.message,
      this.replyId,
      this.parents,
      this.fileData});

  SentMsgByTeacherModel.fromJson(Map<String, dynamic> json) {
    classs = json['class'];
    batch = json['batch'];
    subjectId = json['subject_id'];
    subject = json['subject'];
    messageFrom = json['message_from'];
    message = json['message'];
    replyId = json['reply_id'];
    parents = json['parents'].cast<String>();
    fileData =
        json['file_data'] != null ? FileData.fromJson(json['file_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class'] = classs;
    data['batch'] = batch;
    data['subject_id'] = subjectId;
    data['subject'] = subject;
    data['message_from'] = messageFrom;
    data['message'] = message;
    data['reply_id'] = replyId;
    data['parents'] = parents;
    if (fileData != null) {
      data['file_data'] = fileData!.toJson();
    }
    return data;
  }
}

class FileData {
  String? name;
  String? orgName;
  String? extension;

  FileData({this.name, this.orgName, this.extension});

  FileData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    orgName = json['org_name'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['org_name'] = orgName;
    data['extension'] = extension;
    return data;
  }
}
