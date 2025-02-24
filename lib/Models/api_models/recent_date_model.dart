class TrackingDateModel {
  Status? status;
  int? count;
  Data? data;

  TrackingDateModel({this.status, this.count, this.data});

  TrackingDateModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? Status.fromJson(json['status']) : null;
    count = json['count'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['count'] = count;
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
  List<ListItem>? data;
  int? status;

  Data({this.message, this.data, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ListItem>[];
      json['data'].forEach((v) {
        data!.add(ListItem.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class ListItem {
  int? id;
  String? studentName;
  String? classs;
  String? batch;
  String? visitDate;
  String? visitStatus;
  String? remarks;
  String? profile;
  bool? isprogress;
  List<DataStatus>? status;

  ListItem(
      {this.id,
      this.studentName,
      this.classs,
      this.batch,
      this.visitDate,
      this.visitStatus,
      this.profile,
      this.remarks,
      this.isprogress,
      this.status});

  ListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentName = json['student_name'];
    classs = json['class'];
    batch = json['batch'];
    visitDate = json['visit_date'];
    visitStatus = json['visit_status'];
    remarks = json['remarks'];
    profile = json['profile_pic'];
    isprogress = json['isprogress'];
    if (json['status'] != null) {
      status = <DataStatus>[];
      json['status'].forEach((v) {
        status!.add(DataStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_name'] = studentName;
    data['class'] = classs;
    data['batch'] = batch;
    data['visit_date'] = visitDate;
    data['visit_status'] = visitStatus;
    data['remarks'] = remarks;
    data['profile_pic'] = profile;
    data['isprogress'] = isprogress;
    if (status != null) {
      data['status'] = status!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataStatus {
  String? sentBy;
  String? sentById;
  String? sentByToken;
  String? visitStatus;
  String? addedOn;
  String? remark;

  DataStatus(
      {this.sentBy,
      this.sentById,
      this.sentByToken,
      this.visitStatus,
      this.addedOn,
      this.remark});

  DataStatus.fromJson(Map<String, dynamic> json) {
    sentBy = json['sent_by'];
    sentById = json['sent_by_id'];
    sentByToken = json['sent_by_token'];
    visitStatus = json['visit_status'];
    addedOn = json['Added_on'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sent_by'] = sentBy;
    data['sent_by_id'] = sentById;
    data['sent_by_token'] = sentByToken;
    data['visit_status'] = visitStatus;
    data['Added_on'] = addedOn;
    data['remark'] = remark;
    return data;
  }
}
