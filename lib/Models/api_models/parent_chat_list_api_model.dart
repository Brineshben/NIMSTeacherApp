class ParentChatListApiModel {
  ParentChatListApiModel({
    this.status,
    this.data,
  });

  final Status? status;
  final Data? data;

  factory ParentChatListApiModel.fromJson(Map<String, dynamic> json) {
    return ParentChatListApiModel(
      status: json["status"] == null ? null : Status.fromJson(json["status"]),
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.message,
    this.unreadCount,
    this.data,
  });

  final String? message;
  final int? unreadCount;
  final List<Datum>? data;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json["message"],
      unreadCount: json["unread_count"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "unread_count": unreadCount,
        "data": data?.map((x) => x.toJson()).toList(),
      };
}

class Datum {
  Datum(
      {this.datumClass,
      this.batch,
      this.subjectId,
      this.subjectName,
      this.parentId,
      this.parentName,
      this.studentId,
      this.studentName,
      this.relation,
      this.unreadCount,
      this.lastMessage,
      this.image});

  final String? datumClass;
  final String? batch;
  final String? subjectId;
  final String? subjectName;
  final String? parentId;
  final String? parentName;
  final String? studentName;
  final String? studentId;
  final String? relation;
  final String? unreadCount;
  final String? image;
  LastMessage? lastMessage;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      datumClass: json["class"],
      batch: json["batch"],
      subjectId: json["subject_id"],
      subjectName: json["subject_name"],
      parentId: json["parent_id"],
      parentName: json["parent_name"],
      studentId: json["student_id"],
      studentName: json["student_name"],
      relation: json["relation"],
      unreadCount: json["unread_count"],
      image: json["image"],
      lastMessage: json["last_message"] == null
          ? null
          : LastMessage.fromJson(json["last_message"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "class": datumClass,
        "batch": batch,
        "subject_id": subjectId,
        "subject_name": subjectName,
        "parent_id": parentId,
        "parent_name": parentName,
        "student_id": studentId,
        "student_name": studentName,
        "relation": relation,
        "unread_count": unreadCount,
        "image": image,
        "last_message": lastMessage?.toJson(),
      };
}

class LastMessage {
  LastMessage({
    this.type,
    this.message,
    this.messageFile,
    this.fileName,
    this.messageAudio,
    this.messageFromId,
    this.read,
    this.sandAt,
  });

  final String? type;
  final String? message;
  final String? messageFile;
  final String? fileName;
  final String? messageAudio;
  final String? messageFromId;
  final bool? read;
  final DateTime? sandAt;

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      type: json["type"],
      message: json["message"],
      messageFile: json["message_file"],
      fileName: json["file_name"],
      messageAudio: json["message_audio"],
      messageFromId: json["message_from_id"],
      read: json["read"],
      sandAt: DateTime.tryParse(json["sand_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": message,
        "message_file": messageFile,
        "file_name": fileName,
        "message_audio": messageAudio,
        "message_from_id": messageFromId,
        "read": read,
        "sand_at": sandAt?.toIso8601String(),
      };
}

class Status {
  Status({
    this.code,
    this.message,
  });

  final int? code;
  final String? message;

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      code: json["code"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class ParentFilterClass {
  final String? stdClass;
  final String? stdBatch;
  const ParentFilterClass({this.stdClass, this.stdBatch});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ParentFilterClass) return false;
    return stdClass == other.stdClass && stdBatch == other.stdBatch;
  }

  @override
  int get hashCode => stdClass.hashCode ^ stdBatch.hashCode;
}
