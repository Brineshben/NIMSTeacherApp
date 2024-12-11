class GroupedViewApiModel {
  Status? status;
  Data? data;

  GroupedViewApiModel({this.status, this.data});

  GroupedViewApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
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
  List<RoomData>? data;

  Data({this.message, this.data, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <RoomData>[];
      json['data'].forEach((v) {
        data!.add(RoomData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomData {
  String? classs;
  String? batch;
  String? subjectId;
  String? subjectName;
  String? messageFrom;
  String? teacherName;
  String? unreadCount;
  LastMessageGroupedView? lastMessage;

  RoomData(
      {this.classs,
      this.batch,
      this.subjectId,
      this.subjectName,
      this.messageFrom,
      this.teacherName,
      this.unreadCount,
      this.lastMessage});

  RoomData.fromJson(Map<String, dynamic> json) {
    classs = json['class'];
    batch = json['batch'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    messageFrom = json['message_from'];
    teacherName = json['teacher_name'];
    unreadCount = json['unread_count'];
    lastMessage = json['last_message'] != null
        ? LastMessageGroupedView.fromJson(json['last_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class'] = classs;
    data['batch'] = batch;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['message_from'] = messageFrom;
    data['teacher_name'] = teacherName;
    data['unread_count'] = unreadCount;
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    return data;
  }
}

class LastMessageGroupedView {
  String? type;
  String? message;
  String? messageFromId;
  String? messageFile;
  String? fileName;
  String? messageAudio;
  String? sandAt;
  bool? read;

  LastMessageGroupedView(
      {this.type,
      this.message,
      this.messageFromId,
      this.messageFile,
      this.fileName,
      this.messageAudio,
      this.sandAt,
      this.read});

  LastMessageGroupedView.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
    messageFromId = json['message_from_id'];
    messageFile = json['message_file'];
    fileName = json['file_name'];
    messageAudio = json['message_audio'];
    sandAt = json['sand_at'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['message'] = message;
    data['message_from_id'] = messageFromId;
    data['message_file'] = messageFile;
    data['file_name'] = fileName;
    data['message_audio'] = messageAudio;
    data['sand_at'] = sandAt;
    data['read'] = read;
    return data;
  }
}
