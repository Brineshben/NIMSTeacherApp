class WorkloadApiModel {
  WorkloadApiModel({
    required this.status,
    required this.data,
  });

  final Status? status;
  final Data? data;

  factory WorkloadApiModel.fromJson(Map<String, dynamic> json) {
    return WorkloadApiModel(
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
    required this.message,
    required this.data,
  });

  final String? message;
  final List<Datum> data;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class Datum {
  Datum({
    required this.employeeNo,
    required this.userId,
    required this.username,
    required this.schoolId,
    required this.name,
    required this.roleIds,
    required this.image,
    required this.quickLoginId,
    required this.facultyData,
    required this.roleArray,
  });

  final String? employeeNo;
  final String? userId;
  final String? username;
  final String? schoolId;
  final String? name;
  final List<String> roleIds;
  final String? image;
  final String? quickLoginId;
  final FacultyData? facultyData;
  final List<RoleArray> roleArray;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      employeeNo: json["employee_no"],
      userId: json["user_id"],
      username: json["username"],
      schoolId: json["school_id"],
      name: json["name"],
      roleIds: json["role_ids"] == null
          ? []
          : List<String>.from(json["role_ids"]!.map((x) => x)),
      image: json["image"],
      quickLoginId: json["quick_login_id"],
      facultyData: json["faculty_data"] == null
          ? null
          : FacultyData.fromJson(json["faculty_data"]),
      roleArray: json["role_array"] == null
          ? []
          : List<RoleArray>.from(
              json["role_array"]!.map((x) => RoleArray.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "employee_no": employeeNo,
        "user_id": userId,
        "username": username,
        "school_id": schoolId,
        "name": name,
        "role_ids": roleIds.map((x) => x).toList(),
        "image": image,
        "quick_login_id": quickLoginId,
        "faculty_data": facultyData?.toJson(),
        "role_array": roleArray.map((x) => x.toJson()).toList(),
      };
}

class FacultyData {
  FacultyData({
    required this.hodComponent,
    required this.teacherComponent,
  });

  final HodComponent? hodComponent;
  final TeacherComponent? teacherComponent;

  factory FacultyData.fromJson(Map<String, dynamic> json) {
    return FacultyData(
      hodComponent: json["hodComponent"] == null
          ? null
          : HodComponent.fromJson(json["hodComponent"]),
      teacherComponent: json["teacherComponent"] == null
          ? null
          : TeacherComponent.fromJson(json["teacherComponent"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "hodComponent": hodComponent?.toJson(),
        "teacherComponent": teacherComponent?.toJson(),
      };
}

class HodComponent {
  HodComponent({
    required this.component,
    required this.ownList,
    required this.isHod,
    required this.ownListGroups,
  });

  final String? component;
  final List<dynamic> ownList;
  final bool? isHod;
  final List<OwnListGroup> ownListGroups;

  factory HodComponent.fromJson(Map<String, dynamic> json) {
    return HodComponent(
      component: json["component"],
      ownList: json["own_list"] == null
          ? []
          : List<dynamic>.from(json["own_list"]!.map((x) => x)),
      isHod: json["is_hod"],
      ownListGroups: json["own_list_groups"] == null
          ? []
          : List<OwnListGroup>.from(
              json["own_list_groups"]!.map((x) => OwnListGroup.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "component": component,
        "own_list": ownList.map((x) => x).toList(),
        "is_hod": isHod,
        "own_list_groups": ownListGroups.map((x) => x.toJson()).toList(),
      };
}

class OwnListGroup {
  OwnListGroup({
    required this.session,
    required this.curriculum,
    required this.classGroup,
  });

  final RoleArray? session;
  final RoleArray? curriculum;
  final List<ClassGroup> classGroup;

  factory OwnListGroup.fromJson(Map<String, dynamic> json) {
    return OwnListGroup(
      session:
          json["session"] == null ? null : RoleArray.fromJson(json["session"]),
      curriculum: json["curriculum"] == null
          ? null
          : RoleArray.fromJson(json["curriculum"]),
      classGroup: json["class_group"] == null
          ? []
          : List<ClassGroup>.from(
              json["class_group"]!.map((x) => ClassGroup.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "session": session?.toJson(),
        "curriculum": curriculum?.toJson(),
        "class_group": classGroup.map((x) => x.toJson()).toList(),
      };
}

class ClassGroup {
  ClassGroup({
    required this.session,
    required this.curriculum,
    required this.classGroupClass,
    required this.batch,
    required this.academic,
    required this.subject,
    required this.classTeacher,
  });

  final RoleArray? session;
  final RoleArray? curriculum;
  final RoleArray? classGroupClass;
  final RoleArray? batch;
  final String? academic;
  final RoleArray? subject;
  final ClassTeacher? classTeacher;

  factory ClassGroup.fromJson(Map<String, dynamic> json) {
    return ClassGroup(
      session:
          json["session"] == null ? null : RoleArray.fromJson(json["session"]),
      curriculum: json["curriculum"] == null
          ? null
          : RoleArray.fromJson(json["curriculum"]),
      classGroupClass:
          json["class"] == null ? null : RoleArray.fromJson(json["class"]),
      batch: json["batch"] == null ? null : RoleArray.fromJson(json["batch"]),
      academic: json["academic"],
      subject:
          json["subject"] == null ? null : RoleArray.fromJson(json["subject"]),
      classTeacher: json["class_teacher"] == null
          ? null
          : ClassTeacher.fromJson(json["class_teacher"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "session": session?.toJson(),
        "curriculum": curriculum?.toJson(),
        "class": classGroupClass?.toJson(),
        "batch": batch?.toJson(),
        "academic": academic,
        "subject": subject?.toJson(),
        "class_teacher": classTeacher?.toJson(),
      };
}

class RoleArray {
  RoleArray({
    required this.id,
    required this.name,
  });

  final String? id;
  final String? name;

  factory RoleArray.fromJson(Map<String, dynamic> json) {
    return RoleArray(
      id: json["_id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class ClassTeacher {
  ClassTeacher({
    required this.userId,
    required this.name,
    required this.username,
    required this.employeeNo,
    required this.classTeacherExists,
  });

  final String? userId;
  final String? name;
  final String? username;
  final String? employeeNo;
  final bool? classTeacherExists;

  factory ClassTeacher.fromJson(Map<String, dynamic> json) {
    return ClassTeacher(
      userId: json["user_id"],
      name: json["name"],
      username: json["username"],
      employeeNo: json["employee_no"],
      classTeacherExists: json["class_teacher_exists"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "username": username,
        "employee_no": employeeNo,
        "class_teacher_exists": classTeacherExists,
      };
}

class TeacherComponent {
  TeacherComponent({
    required this.component,
    required this.ownList,
    required this.isClassTeacher,
  });

  final String? component;
  final List<OwnList> ownList;
  final bool? isClassTeacher;

  factory TeacherComponent.fromJson(Map<String, dynamic> json) {
    return TeacherComponent(
      component: json["component"],
      ownList: json["own_list"] == null
          ? []
          : List<OwnList>.from(
              json["own_list"]!.map((x) => OwnList.fromJson(x))),
      isClassTeacher: json["is_class_teacher"],
    );
  }

  Map<String, dynamic> toJson() => {
        "component": component,
        "own_list": ownList.map((x) => x.toJson()).toList(),
        "is_class_teacher": isClassTeacher,
      };
}

class OwnList {
  OwnList({
    required this.session,
    required this.curriculum,
    required this.ownListClass,
    required this.batch,
    required this.academic,
    required this.subjects,
    this.isClassTeacher,
      this.studentCount,
  });

  final RoleArray? session;
  final RoleArray? curriculum;
  final RoleArray? ownListClass;
  final RoleArray? batch;
  final String? academic;
  final List<RoleArray> subjects;
  final bool? isClassTeacher;
  final int? studentCount;

  factory OwnList.fromJson(Map<String, dynamic> json) {
    return OwnList(
      session:
          json["session"] == null ? null : RoleArray.fromJson(json["session"]),
      curriculum: json["curriculum"] == null
          ? null
          : RoleArray.fromJson(json["curriculum"]),
      isClassTeacher: json["is_class_teacher"],
      studentCount: json["student_count"],
      ownListClass:
          json["class"] == null ? null : RoleArray.fromJson(json["class"]),
      batch: json["batch"] == null ? null : RoleArray.fromJson(json["batch"]),
      academic: json["academic"],
      subjects: json["subjects"] == null
          ? []
          : List<RoleArray>.from(
              json["subjects"]!.map((x) => RoleArray.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "session": session?.toJson(),
        "curriculum": curriculum?.toJson(),
        "class": ownListClass?.toJson(),
        "batch": batch?.toJson(),
        "academic": academic,
        "subjects": subjects.map((x) => x.toJson()).toList(),
        "is_class_teacher": isClassTeacher,
        "student_count": studentCount,

      };
}

class Status {
  Status({
    required this.code,
    required this.message,
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
