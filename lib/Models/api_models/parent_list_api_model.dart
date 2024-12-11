class ParentListApiModel {
  Status? status;
  Data? data;

  ParentListApiModel({this.status, this.data});

  ParentListApiModel.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? Status.fromJson(json['status']) : null;
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
  List<ParentData>? parentData;

  Data({this.message, this.count, this.parentData});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      parentData = <ParentData>[];
      json['data'].forEach((v) {
        parentData!.add(ParentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['count'] = count;
    if (parentData != null) {
      data['data'] = parentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentDataSelected {
  String? name;
  String? username;
  String? image;
  String? sId;
  String? studentId;
  String? studentName;
  String? gender;
  bool isSelected;

  ParentDataSelected(
      {this.name,
        this.username,
        this.image,
        this.sId,
        this.studentId,
        this.studentName,
        required this.isSelected,
        this.gender});
}

class ParentData {
  String? name;
  String? username;
  String? image;
  String? sId;
  String? studentId;
  String? studentName;
  String? gender;

  ParentData(
      {this.name,
        this.username,
        this.image,
        this.sId,
        this.studentId,
        this.studentName,
        this.gender});

  ParentData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    image = json['image'];
    sId = json['_id'];
    studentId = json['student_id'];
    studentName = json['student_name'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['image'] = image;
    data['_id'] = sId;
    data['student_id'] = studentId;
    data['student_name'] = studentName;
    data['gender'] = gender;
    return data;
  }
}
