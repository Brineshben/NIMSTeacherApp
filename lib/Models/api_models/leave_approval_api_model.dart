class LeaveApprovalApi {
  Status? status;
  LeaveData? data;

  LeaveApprovalApi({this.status, this.data});

  LeaveApprovalApi.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    data = json['data'] != null ? LeaveData.fromJson(json['data']) : null;
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

class LeaveData {
  String? message;
  List<Pendings>? pendings;
  List<ApprovedOrRejected>? apprvedOrRejected;
  List<AllLeaves>? allLeaves;

  LeaveData({this.message, this.pendings, this.apprvedOrRejected, this.allLeaves});

  LeaveData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['pendings'] != null) {
      pendings = <Pendings>[];
      json['pendings'].forEach((v) {
        pendings!.add(Pendings.fromJson(v));
      });
    }
    if (json['apprved_or_rejected'] != null) {
      apprvedOrRejected = <ApprovedOrRejected>[];
      json['apprved_or_rejected'].forEach((v) {
        apprvedOrRejected!.add(ApprovedOrRejected.fromJson(v));
      });
    }
    if (json['allLeaves'] != null) {
      allLeaves = <AllLeaves>[];
      json['allLeaves'].forEach((v) {
        allLeaves!.add(AllLeaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (pendings != null) {
      data['pendings'] = pendings!.map((v) => v.toJson()).toList();
    }
    if (apprvedOrRejected != null) {
      data['apprved_or_rejected'] =
          apprvedOrRejected!.map((v) => v.toJson()).toList();
    }
    if (allLeaves != null) {
      data['allLeaves'] = allLeaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pendings {
  String? sId;
  String? updatedOn;
  String? startDate;
  String? endDate;
  String? applyDate;
  int? days;
  String? schoolId;
  String? sessionId;
  String? curriculumId;
  String? classId;
  String? batchId;
  String? academicYear;
  String? reason;
  String? submittedBy;
  String? submittedRoleId;
  String? studentId;
  String? classs;
  String? batch;
  String? studentName;
  String? documentPath;
  String? status;
  String? admissionNumber;
  String? profileImage;
  bool? myPending;

  Pendings({this.sId, this.updatedOn, this.startDate, this.endDate, this.applyDate, this.days, this.schoolId, this.sessionId, this.curriculumId, this.classId, this.batchId, this.academicYear, this.reason, this.submittedBy, this.submittedRoleId, this.studentId, this.classs, this.batch, this.studentName, this.documentPath, this.status, this.admissionNumber, this.profileImage, this.myPending});

  Pendings.fromJson(Map<String, dynamic> json) {
  sId = json['_id'];
  updatedOn = json['updated_on'];
  startDate = json['startDate'];
  endDate = json['endDate'];
  applyDate = json['applyDate'];
  days = json['days'] != null ? int.parse(json['days'].toString()) : null;
  schoolId = json['school_id'];
  sessionId = json['session_id'];
  curriculumId = json['curriculum_id'];
  classId = json['class_id'];
  batchId = json['batch_id'];
  academicYear = json['academic_year'];
  reason = json['reason'];
  submittedBy = json['submittedBy'];
  submittedRoleId = json['submittedRoleId'];
  studentId = json['studentId'];
  classs = json['class'];
  batch = json['batch'];
  studentName = json['studentName'];
  documentPath = json['documentPath'];
  status = json['status'];
  admissionNumber = json['admission_number'];
  profileImage = json['profileImage'];
  myPending = json['myPending'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['_id'] = sId;
  data['updated_on'] = updatedOn;
  data['startDate'] = startDate;
  data['endDate'] = endDate;
  data['applyDate'] = applyDate;
  data['days'] = days;
  data['school_id'] = schoolId;
  data['session_id'] = sessionId;
  data['curriculum_id'] = curriculumId;
  data['class_id'] = classId;
  data['batch_id'] = batchId;
  data['academic_year'] = academicYear;
  data['reason'] = reason;
  data['submittedBy'] = submittedBy;
  data['submittedRoleId'] = submittedRoleId;
  data['studentId'] = studentId;
  data['class'] = classs;
  data['batch'] = batch;
  data['studentName'] = studentName;
  data['documentPath'] = documentPath;
  data['status'] = status;
  data['admission_number'] = admissionNumber;
  data['profileImage'] = profileImage;
  data['myPending'] = myPending;
  return data;
  }
}

class ApprovedOrRejected {
  String? sId;
  String? updatedOn;
  String? startDate;
  String? endDate;
  String? applyDate;
  int? days;
  String? schoolId;
  String? sessionId;
  String? curriculumId;
  String? classId;
  String? batchId;
  String? academicYear;
  String? reason;
  String? submittedBy;
  String? submittedRoleId;
  String? studentId;
  String? classs;
  String? batch;
  String? studentName;
  String? documentPath;
  String? status;
  String? approvedBy;
  String? admissionNumber;
  String? profileImage;

  ApprovedOrRejected(
      {this.sId,
      this.updatedOn,
      this.startDate,
      this.endDate,
      this.applyDate,
      this.days,
      this.schoolId,
      this.sessionId,
      this.curriculumId,
      this.classId,
      this.batchId,
      this.academicYear,
      this.reason,
      this.submittedBy,
      this.submittedRoleId,
      this.studentId,
      this.classs,
      this.batch,
      this.studentName,
      this.documentPath,
      this.status,
      this.approvedBy,
      this.admissionNumber,
      this.profileImage});

  ApprovedOrRejected.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    updatedOn = json['updated_on'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    applyDate = json['applyDate'];
    days = json['days'] != null ? int.parse(json['days'].toString()) : null;
    schoolId = json['school_id'];
    sessionId = json['session_id'];
    curriculumId = json['curriculum_id'];
    classId = json['class_id'];
    batchId = json['batch_id'];
    academicYear = json['academic_year'];
    reason = json['reason'];
    submittedBy = json['submittedBy'];
    submittedRoleId = json['submittedRoleId'];
    studentId = json['studentId'];
    classs = json['class'];
    batch = json['batch'];
    studentName = json['studentName'];
    documentPath = json['documentPath'];
    status = json['status'];
    approvedBy = json['approvedBy'];
    admissionNumber = json['admission_number'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['updated_on'] = updatedOn;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['applyDate'] = applyDate;
    data['days'] = days;
    data['school_id'] = schoolId;
    data['session_id'] = sessionId;
    data['curriculum_id'] = curriculumId;
    data['class_id'] = classId;
    data['batch_id'] = batchId;
    data['academic_year'] = academicYear;
    data['reason'] = reason;
    data['submittedBy'] = submittedBy;
    data['submittedRoleId'] = submittedRoleId;
    data['studentId'] = studentId;
    data['class'] = classs;
    data['batch'] = batch;
    data['studentName'] = studentName;
    data['documentPath'] = documentPath;
    data['status'] = status;
    data['approvedBy'] = approvedBy;
    data['admission_number'] = admissionNumber;
    data['profileImage'] = profileImage;
    return data;
  }
}

class AllLeaves {
  String? sId;
  String? updatedOn;
  String? startDate;
  String? endDate;
  String? applyDate;
  int? days;
  String? schoolId;
  String? sessionId;
  String? curriculumId;
  String? classId;
  String? batchId;
  String? academicYear;
  String? reason;
  String? submittedBy;
  String? submittedRoleId;
  String? studentId;
  String? classs;
  String? batch;
  String? studentName;
  String? documentPath;
  String? status;
  String? admissionNumber;
  String? profileImage;
  String? approvedBy;
  String? comment;
  String? updatedBy;
  bool? myPending;

  AllLeaves({this.sId, this.updatedOn, this.startDate, this.endDate, this.applyDate, this.days, this.schoolId, this.sessionId, this.curriculumId, this.classId, this.batchId, this.academicYear, this.reason, this.submittedBy, this.submittedRoleId, this.studentId, this.classs, this.batch, this.studentName, this.documentPath, this.status, this.admissionNumber, this.profileImage, this.approvedBy, this.comment, this.updatedBy, this.myPending});

  AllLeaves.fromJson(Map<String, dynamic> json) {
  sId = json['_id'];
  updatedOn = json['updated_on'];
  startDate = json['startDate'];
  endDate = json['endDate'];
  applyDate = json['applyDate'];
  days = json['days'] != null ? int.parse(json['days'].toString()) : null;
  schoolId = json['school_id'];
  sessionId = json['session_id'];
  curriculumId = json['curriculum_id'];
  classId = json['class_id'];
  batchId = json['batch_id'];
  academicYear = json['academic_year'];
  reason = json['reason'];
  submittedBy = json['submittedBy'];
  submittedRoleId = json['submittedRoleId'];
  studentId = json['studentId'];
  classs = json['class'];
  batch = json['batch'];
  studentName = json['studentName'];
  documentPath = json['documentPath'];
  status = json['status'];
  admissionNumber = json['admission_number'];
  profileImage = json['profileImage'];
  approvedBy = json['approvedBy'];
  comment = json['comment'];
  updatedBy = json['updated_by'];
  myPending = json['myPending'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['_id'] = sId;
  data['updated_on'] = updatedOn;
  data['startDate'] = startDate;
  data['endDate'] = endDate;
  data['applyDate'] = applyDate;
  data['days'] = days;
  data['school_id'] = schoolId;
  data['session_id'] = sessionId;
  data['curriculum_id'] = curriculumId;
  data['class_id'] = classId;
  data['batch_id'] = batchId;
  data['academic_year'] = academicYear;
  data['reason'] = reason;
  data['submittedBy'] = submittedBy;
  data['submittedRoleId'] = submittedRoleId;
  data['studentId'] = studentId;
  data['class'] = classs;
  data['batch'] = batch;
  data['studentName'] = studentName;
  data['documentPath'] = documentPath;
  data['status'] = status;
  data['admission_number'] = admissionNumber;
  data['profileImage'] = profileImage;
  data['approvedBy'] = approvedBy;
  data['comment'] = comment;
  data['updated_by'] = updatedBy;
  data['myPending'] = myPending;
  return data;
  }
}