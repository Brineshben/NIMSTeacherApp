class ParentChattingModel {
  Status? status;
  Data? data;

  ParentChattingModel({this.status, this.data});

  ParentChattingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (status != null) {
  //     data['status'] = status!.toJson();
  //   }
  //   if (this.data != null) {
  //     data['data'] = this.data!.toJson();
  //   }
  //   return data;
  // }
}

class Status {
  int? code;
  String? message;

  Status({this.code, this.message});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class Data {
  String? message;
  int? count;
  List<ParentMsgData>? data;

  Data({this.message, this.count, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <ParentMsgData>[];
      json['data'].forEach((v) {
        data!.add(ParentMsgData.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['message'] = message;
  //   data['count'] = count;
  //   if (this.data != null) {
  //     data['data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class ParentMsgData {
  String? messageId;
  String? type;
  String? message;
  String? subjectName;
  String? messageFile;
  String? fileName;
  String? messageAudio;
  String? messageFromId;
  String? messageFrom;
  String? messageFromPic;
  String? sendAt;
  String? appMsgId;
  bool? isForward;
  String? replyId;
  String? myReact;
  bool? read;
  ReplyData? replyData;
  List<IncomingReact>? incomingReact;

  ParentMsgData({
    this.messageId,
    this.type,
    this.message,
    this.subjectName,
    this.messageFile,
    this.fileName,
    this.messageAudio,
    this.messageFromId,
    this.messageFrom,
    this.messageFromPic,
    this.sendAt,
    this.appMsgId,
    this.isForward,
    this.replyId,
    this.myReact,
    this.replyData,
    this.read,
    this.incomingReact,
  });

  ParentMsgData.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    type = json['type'];
    message = json['message'];
    subjectName = json['subject_name'];
    messageFile = json['message_file'];
    fileName = json['file_name'];
    messageAudio = json['message_audio'];
    messageFromId = json['message_from_id'];
    messageFrom = json['message_from'];
    messageFromPic = json['message_from_pic'];
    sendAt = json['send_at'];
    appMsgId = json['app_msg_id'];
    isForward = json['is_forward'];
    replyId = json['reply_id'];
    myReact = json['my_react'];
    read = json['read'];
    replyData = json['reply_data'] != null
        ? ReplyData.fromJson(json['reply_data'])
        : null;
    if (json['incoming_react'] != null) {
      incomingReact = <IncomingReact>[];
      json['incoming_react'].forEach((v) {
        incomingReact!.add(IncomingReact.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['message_id'] = messageId;
  //   data['type'] = type;
  //   data['message'] = message;
  //   data['subject_name'] = subjectName;
  //   data['message_file'] = messageFile;
  //   data['file_name'] = fileName;
  //   data['message_audio'] = messageAudio;
  //   data['message_from_id'] = messageFromId;
  //   data['message_from'] = messageFrom;
  //   data['message_from_pic'] = messageFromPic;
  //   data['send_at'] = sendAt;
  //   data['app_msg_id'] = appMsgId;
  //   data['is_forward'] = isForward;
  //   data['reply_id'] = replyId;
  //   data['my_react'] = myReact;
  //   data['read'] = read;
  //   if (replyData != null) {
  //     data['reply_data'] = replyData!.toJson();
  //   }
  //   return data;
  // }
}

class ReplyData {
  int? messageId;
  String? type;
  String? message;
  String? messageFile;
  String? fileName;
  String? messageAudio;
  String? messageFromId;
  String? messageFromName;
  String? appMsgId;

  ReplyData(
      {this.messageId,
      this.type,
      this.message,
      this.messageFile,
      this.fileName,
      this.messageAudio,
      this.messageFromId,
      this.messageFromName,
      this.appMsgId});

  ReplyData.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    type = json['type'];
    message = json['message'];
    messageFile = json['message_file'];
    fileName = json['file_name'];
    messageAudio = json['message_audio'];
    messageFromId = json['message_from_id'];
    messageFromName = json['message_from_name'];
    appMsgId = json['app_msg_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = messageId;
    data['type'] = type;
    data['message'] = message;
    data['message_file'] = messageFile;
    data['file_name'] = fileName;
    data['message_audio'] = messageAudio;
    data['message_from_id'] = messageFromId;
    data['message_from_name'] = messageFromName;
    data['app_msg_id'] = appMsgId;
    return data;
  }
}

class ParentChattingReqModel {
  String? classs;
  String? batch;
  String? teacherId;
  String? parentId;
  String? schoolId;
  int? offset;
  int? limit;

  ParentChattingReqModel(
      {this.classs,
      this.batch,
      this.teacherId,
      this.parentId,
      this.schoolId,
      this.offset,
      this.limit});

  ParentChattingReqModel.fromJson(Map<String, dynamic> json) {
    classs = json['class'];
    batch = json['batch'];
    teacherId = json['teacher_id'];
    parentId = json['parent_id'];
    schoolId = json['school_id'];
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class'] = classs;
    data['batch'] = batch;
    data['teacher_id'] = teacherId;
    data['parent_id'] = parentId;
    data['school_id'] = schoolId;
    data['offset'] = offset;
    data['limit'] = limit;
    return data;
  }
}

class IncomingReact {
  String? react;
  String? reactBy;

  IncomingReact({this.react, this.reactBy});

  IncomingReact.fromJson(Map<String, dynamic> json) {
    react = json['react'];
    reactBy = json['react_by'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['react'] = this.react;
  //   data['react_by'] = this.reactBy;
  //   return data;
  // }
}
