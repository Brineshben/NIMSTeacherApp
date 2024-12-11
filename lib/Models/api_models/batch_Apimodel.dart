class LearningWalkbatch {
  Status? status;
  Data? data;

  LearningWalkbatch({this.status, this.data});

  LearningWalkbatch.fromJson(Map<String, dynamic> json) {
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
  List<Detailsbatch>? details;

  Data({this.message, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <Detailsbatch>[];
      json['details'].forEach((v) {
        details!.add(new Detailsbatch.fromJson(v));
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

class Detailsbatch {
  String? sId;
  String? name;
  String? session;
  String? curriculum;

  Detailsbatch({this.sId, this.name, this.session, this.curriculum});

  Detailsbatch.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    session = json['session'];
    curriculum = json['curriculum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['session'] = this.session;
    data['curriculum'] = this.curriculum;
    return data;
  }
}