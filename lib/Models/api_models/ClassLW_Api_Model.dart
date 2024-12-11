class LearningWalkClass {
  Status? status;
  Data? data;

  LearningWalkClass({this.status, this.data});

  LearningWalkClass.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? message;
  List<Details>? details;

  Data({this.message, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? sId;
  String? name;
  int? sortOrder;
  List<String>? sessionIds;
  List<String>? curriculumIds;

  Details(
      {this.sId,
        this.name,
        this.sortOrder,
        this.sessionIds,
        this.curriculumIds});

  Details.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    sortOrder = json['sort_order'];
    sessionIds = json['session_ids'].cast<String>();
    curriculumIds = json['curriculum_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['sort_order'] = this.sortOrder;
    data['session_ids'] = this.sessionIds;
    data['curriculum_ids'] = this.curriculumIds;
    return data;
  }
}