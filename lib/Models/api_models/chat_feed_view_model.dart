class ChatFeedViewModel {
  Status? status;
  Data? data;

  ChatFeedViewModel({this.status, this.data});

  ChatFeedViewModel.fromJson(Map<String, dynamic> json) {
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
  List<MsgData>? data;

  Data({this.message, this.count, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <MsgData>[];
      json['data'].forEach((v) {
        data!.add(MsgData.fromJson(v));
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

class MsgData {
  String? messageId;
  String? type;
  String? message;
  String? subjectName;
  String? messageFile;
  String? fileName;
  String? messageAudio;
  String? messageFromId;
  String? messageFrom;
  String? sendAt;
  String? appMsgId;
  List<StudentData>? studentData;
  String? replyId;
  bool? read;
  String? myReact;
  bool? isForward;
  ReplyData? replyData;
  String? userImage;
  List<IncomingReact>? incomingReact;
  String? roleName;

  MsgData({
    this.messageId,
    this.type,
    this.message,
    this.subjectName,
    this.messageFile,
    this.fileName,
    this.messageAudio,
    this.messageFromId,
    this.messageFrom,
    this.sendAt,
    this.appMsgId,
    this.studentData,
    this.replyId,
    this.read,
    this.myReact,
    this.isForward,
    this.replyData,
    this.userImage,
    this.incomingReact,
    this.roleName,
  });

  MsgData.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    type = json['type'];
    message = json['message'];
    subjectName = json['subject_name'];
    messageFile = json['message_file'];
    fileName = json['file_name'];
    messageAudio = json['message_audio'];
    messageFromId = json['message_from_id'];
    messageFrom = json['message_from'];
    sendAt = json['send_at'];
    appMsgId = json['app_msg_id'];
    read = json['read'];
    myReact = json['my_react'];
    userImage = json['message_from_pic'];
    isForward = json['is_forward'];
    roleName = json['role_name'];
    if (json['student_data'] != null) {
      studentData = <StudentData>[];
      json['student_data'].forEach((v) {
        studentData!.add(StudentData.fromJson(v));
      });
    }
    replyId = json['reply_id'];
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
  //   data['send_at'] = sendAt;
  //   data['app_msg_id'] = appMsgId;
  //   data['read'] = read;
  //   data['my_react'] = myReact;
  //   data['is_forward'] = isForward;
  //   data['message_from_pic'] = userImage;
  //   if (studentData != null) {
  //     data['student_data'] = studentData!.map((v) => v.toJson()).toList();
  //   }
  //   data['reply_id'] = replyId;
  //   if (replyData != null) {
  //     data['reply_data'] = replyData!.toJson();
  //   }
  //   return data;
  // }
}

class StudentData {
  String? studentName;
  String? relation;

  StudentData({this.studentName, this.relation});

  StudentData.fromJson(Map<String, dynamic> json) {
    studentName = json['student_name'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_name'] = studentName;
    data['relation'] = relation;
    return data;
  }
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
  String? sandAt;

  ReplyData(
      {this.messageId,
      this.type,
      this.message,
      this.messageFile,
      this.fileName,
      this.messageAudio,
      this.messageFromId,
      this.messageFromName,
      this.sandAt});

  ReplyData.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    type = json['type'];
    message = json['message'];
    messageFile = json['message_file'];
    fileName = json['file_name'];
    messageAudio = json['message_audio'];
    messageFromId = json['message_from_id'];
    messageFromName = json['message_from_name'];
    sandAt = json['sand_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = this.messageId;
    data['type'] = this.type;
    data['message'] = this.message;
    data['message_file'] = this.messageFile;
    data['file_name'] = this.fileName;
    data['message_audio'] = this.messageAudio;
    data['message_from_id'] = this.messageFromId;
    data['message_from_name'] = this.messageFromName;
    data['sand_at'] = this.sandAt;
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

// class ReplyData {
//   int? messageId;
//   String? type;
//   String? message;
//   String? messageFile;
//   String? fileName;
//   String? messageAudio;
//   String? sandAt;

//   ReplyData(
//       {this.messageId,
//       this.type,
//       this.message,
//       this.messageFile,
//       this.fileName,
//       this.messageAudio,
//       this.sandAt});

//   ReplyData.fromJson(Map<String, dynamic> json) {
//     messageId = json['message_id'];
//     type = json['type'];
//     message = json['message'];
//     messageFile = json['message_file'];
//     fileName = json['file_name'];
//     messageAudio = json['message_audio'];
//     sandAt = json['sand_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['message_id'] = messageId;
//     data['type'] = type;
//     data['message'] = message;
//     data['message_file'] = messageFile;
//     data['file_name'] = fileName;
//     data['message_audio'] = messageAudio;
//     data['sand_at'] = sandAt;
//     return data;
//   }
// }

class ChatFeedViewReqModel {
  String? classs;
  String? batch;
  String? subjectId;
  String? teacherId;
  String? schoolId;
  int? offset;
  int? limit;

  ChatFeedViewReqModel(
      {this.classs,
      this.batch,
      this.subjectId,
      this.teacherId,
      this.schoolId,
      this.offset,
      this.limit});

  ChatFeedViewReqModel.fromJson(Map<String, dynamic> json) {
    classs = json['class'];
    batch = json['batch'];
    subjectId = json['subject_id'];
    teacherId = json['teacher_id'];
    schoolId = json['school_id'];
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class'] = classs;
    data['batch'] = batch;
    data['subject_id'] = subjectId;
    data['teacher_id'] = teacherId;
    data['school_id'] = schoolId;
    data['offset'] = offset;
    data['limit'] = limit;
    return data;
  }
}
