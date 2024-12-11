class MessageInfoModel {
  Status? status;
  Data? data;

  MessageInfoModel({this.status, this.data});

  MessageInfoModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.status != null) {
  //     data['status'] = this.status!.toJson();
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

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['code'] = this.code;
  //   data['message'] = this.message;
  //   return data;
  // }
}

class Data {
  String? message;
  List<Viewdata>? viewdata;

  Data({this.message, this.viewdata});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      viewdata = <Viewdata>[];
      json['data'].forEach((v) {
        viewdata!.add(new Viewdata.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['message'] = this.message;
  //   if (this.viewdata != null) {
  //     data['data'] = this.viewdata!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Viewdata {
  String? parentName;
  String? relation;
  String? studentName;
  String? seenOn;
  bool? read;

  Viewdata(
      {this.parentName,
      this.relation,
      this.studentName,
      this.seenOn,
      this.read});

  Viewdata.fromJson(Map<String, dynamic> json) {
    parentName = json['parent_name'];
    relation = json['relation'];
    studentName = json['student_name'];
    seenOn = json['seen_on'];
    read = json['read'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['parent_name'] = this.parentName;
  //   data['relation'] = this.relation;
  //   data['student_name'] = this.studentName;
  //   data['seen_on'] = this.seenOn;
  //   data['read'] = this.read;
  //   return data;
  // }
}
