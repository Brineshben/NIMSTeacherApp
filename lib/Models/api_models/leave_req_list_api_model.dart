class LeaveRequestListApiModel {
  Status? status;
  Data? data;

  LeaveRequestListApiModel({this.status, this.data});

  LeaveRequestListApiModel.fromJson(Map<String, dynamic> json) {
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
  List<ClassData>? details;

  Data({this.message, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <ClassData>[];
      json['details'].forEach((v) {
        details!.add(ClassData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassData {
  String? sessionId;
  String? sessionName;
  String? curriculumId;
  String? curriculumName;
  String? classId;
  String? className;
  String? batchId;
  String? batchName;
  int? totalStudents;
  List<StudentsData>? students;

  ClassData(
      {this.sessionId,
      this.sessionName,
      this.curriculumId,
      this.curriculumName,
      this.classId,
      this.className,
      this.batchId,
      this.batchName,
      this.totalStudents,
      this.students});

  ClassData.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    sessionName = json['session_name'];
    curriculumId = json['curriculum_id'];
    curriculumName = json['curriculum_name'];
    classId = json['class_id'];
    className = json['class_name'];
    batchId = json['batch_id'];
    batchName = json['batch_name'];
    totalStudents = json['totalStudents'];
    if (json['students'] != null) {
      students = <StudentsData>[];
      json['students'].forEach((v) {
        students!.add(StudentsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_id'] = sessionId;
    data['session_name'] = sessionName;
    data['curriculum_id'] = curriculumId;
    data['curriculum_name'] = curriculumName;
    data['class_id'] = classId;
    data['class_name'] = className;
    data['batch_id'] = batchId;
    data['batch_name'] = batchName;
    data['totalStudents'] = totalStudents;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentsData {
  String? sId;
  String? studentId;
  String? admissionNumber;
  String? name;
  String? username;
  String? profileImage;

  StudentsData(
      {this.sId,
      this.studentId,
      this.admissionNumber,
      this.name,
      this.username,
      this.profileImage});

  StudentsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['studentId'];
    admissionNumber = json['admission_number'];
    name = json['name'];
    username = json['username'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['studentId'] = studentId;
    data['admission_number'] = admissionNumber;
    data['name'] = name;
    data['username'] = username;
    data['profileImage'] = profileImage;
    return data;
  }
}

class LeaveRequestModel {
  Classes classes;
  Student student;
  String reason;
  String academicYear;
  String startDate;
  String endDate;
  String schoolId;
  String submittedBy;
  String submittedRoleId;
  String studentId;
  String? documentPath;

  LeaveRequestModel({
    required this.classes,
    required this.student,
    required this.reason,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
    required this.schoolId,
    required this.submittedBy,
    required this.submittedRoleId,
    required this.studentId,
    this.documentPath,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      classes: Classes.fromJson(json['classes']),
      student: Student.fromJson(json['student']),
      reason: json['reason'],
      academicYear: json['academic_year'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      schoolId: json['school_id'],
      submittedBy: json['submittedBy'],
      submittedRoleId: json['submittedRoleId'],
      studentId: json['studentId'],
      documentPath: json['documentPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classes': classes.toJson(),
      'student': student.toJson(),
      'reason': reason,
      'academic_year': academicYear,
      'startDate': startDate,
      'endDate': endDate,
      'school_id': schoolId,
      'submittedBy': submittedBy,
      'submittedRoleId': submittedRoleId,
      'studentId': studentId,
      'documentPath': documentPath,
    };
  }
}

class Classes {
  String sessionId;
  String sessionName;
  String curriculumId;
  String curriculumName;
  String classId;
  String className;
  String batchId;
  String batchName;

  Classes({
    required this.sessionId,
    required this.sessionName,
    required this.curriculumId,
    required this.curriculumName,
    required this.classId,
    required this.className,
    required this.batchId,
    required this.batchName,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      sessionId: json['session_id'],
      sessionName: json['session_name'],
      curriculumId: json['curriculum_id'],
      curriculumName: json['curriculum_name'],
      classId: json['class_id'],
      className: json['class_name'],
      batchId: json['batch_id'],
      batchName: json['batch_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'session_name': sessionName,
      'curriculum_id': curriculumId,
      'curriculum_name': curriculumName,
      'class_id': classId,
      'class_name': className,
      'batch_id': batchId,
      'batch_name': batchName,
    };
  }
}

class Student {
  String id;
  String name;

  Student({
    required this.id,
    required this.name,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

