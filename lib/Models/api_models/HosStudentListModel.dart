class HosStudentListMode {
  Status? status;
  int? count;
  Data? data;

  HosStudentListMode({this.status, this.count, this.data});

  HosStudentListMode.fromJson(Map<String, dynamic> json) {
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
  StudentData? data;
  int? status;

  Data({this.message, this.data, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? StudentData.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class StudentData {
  List<SendData>? sendData;
  List<SendData>? receiveData;

  StudentData({this.sendData, this.receiveData});

  StudentData.fromJson(Map<String, dynamic> json) {
    if (json['sendData'] != null) {
      sendData = <SendData>[];
      json['sendData'].forEach((v) {
        sendData!.add(SendData.fromJson(v));
      });
    }
    if (json['receiveData'] != null) {
      receiveData = <SendData>[];
      json['receiveData'].forEach((v) {
        receiveData!.add(SendData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sendData != null) {
      data['sendData'] = sendData!.map((v) => v.toJson()).toList();
    }
    if (receiveData != null) {
      data['receiveData'] = receiveData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SendData {
  int? id;
  int? institutionId;
  String? academicYear;
  String? studentName;
  String? profilePic;
  String? admissionNo;
  String? age;
  String? dob;
  String? gender;
  String? classs;
  String? batch;
  String? section;
  String? batchDetails;
  String? appType;
  String? visitDate;
  String? visitType;
  String? reason;
  String? situation;
  String? visitStatus;
  String? informedParent;
  String? contactStatus;
  String? remarks;
  String? parentName;
  String? parentEmail;
  String? parentMobile;
  String? teacherId;
  String? sendTo;
  String? createdAt;
  String? updatedAt;
  bool? isprogress;
  List<Statuss>? status;

  SendData(
      {this.id,
      this.institutionId,
      this.academicYear,
      this.studentName,
      this.profilePic,
      this.admissionNo,
      this.age,
      this.dob,
      this.gender,
      this.classs,
      this.batch,
      this.section,
      this.batchDetails,
      this.appType,
      this.visitDate,
      this.visitType,
      this.reason,
      this.situation,
      this.visitStatus,
      this.informedParent,
      this.contactStatus,
      this.remarks,
      this.parentName,
      this.parentEmail,
      this.parentMobile,
      this.teacherId,
      this.sendTo,
      this.createdAt,
      this.updatedAt,
      this.isprogress,
      this.status});

  SendData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionId = json['institution_id'];
    academicYear = json['academic_year'];
    studentName = json['student_name'];
    profilePic = json['profile_pic'];
    admissionNo = json['admission_no'];
    age = json['age'];
    dob = json['dob'];
    gender = json['gender'];
    classs = json['class'];
    batch = json['batch'];
    section = json['section'];
    batchDetails = json['batch_details'];
    appType = json['app_type'];
    visitDate = json['visit_date'];
    visitType = json['visit_type'];
    reason = json['reason'];
    situation = json['situation'];
    visitStatus = json['visit_status'];
    informedParent = json['informed_parent'];
    contactStatus = json['contact_status'];
    remarks = json['remarks'];
    parentName = json['parent_name'];
    parentEmail = json['parent_email'];
    parentMobile = json['parent_mobile'];
    teacherId = json['teacher_id'];
    sendTo = json['send_to'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isprogress = json['isprogress'];
    if (json['status'] != null) {
      status = <Statuss>[];
      json['status'].forEach((v) {
        status!.add(Statuss.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['institution_id'] = institutionId;
    data['academic_year'] = academicYear;
    data['student_name'] = studentName;
    data['profile_pic'] = profilePic;
    data['admission_no'] = admissionNo;
    data['age'] = age;
    data['dob'] = dob;
    data['gender'] = gender;
    data['class'] = classs;
    data['batch'] = batch;
    data['section'] = section;
    data['batch_details'] = batchDetails;
    data['app_type'] = appType;
    data['visit_date'] = visitDate;
    data['visit_type'] = visitType;
    data['reason'] = reason;
    data['situation'] = situation;
    data['visit_status'] = visitStatus;
    data['informed_parent'] = informedParent;
    data['contact_status'] = contactStatus;
    data['remarks'] = remarks;
    data['parent_name'] = parentName;
    data['parent_email'] = parentEmail;
    data['parent_mobile'] = parentMobile;
    data['teacher_id'] = teacherId;
    data['send_to'] = sendTo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isprogress'] = isprogress;
    if (status != null) {
      data['status'] = status!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Statuss {
  String? sentBy;
  String? sentById;
  String? sentByToken;
  String? visitStatus;
  String? addedOn;
  String? remark;

  Statuss(
      {this.sentBy,
      this.sentById,
      this.sentByToken,
      this.visitStatus,
      this.addedOn,
      this.remark});

  Statuss.fromJson(Map<String, dynamic> json) {
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
