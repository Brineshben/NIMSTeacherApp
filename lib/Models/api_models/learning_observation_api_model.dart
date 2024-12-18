class LessonObservationData {
  LessonObservationData({
    this.status,
    this.data,
  });

  final Status? status;
  final Data? data;

  factory LessonObservationData.fromJson(Map<String, dynamic> json){
    return LessonObservationData(
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
    this.details,
  });

  final String? message;
  final Details? details;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      message: json["message"],
      details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "details": details?.toJson(),
  };

}

class Details {
  Details({
    this.response,
    this.lessonObservations,
    this.learningWalk,
    this.keyAreaStrength,
  });

  final List<TeacherData>? response;
  final LearningWalk? lessonObservations;
  final LearningWalk? learningWalk;
  final KeyAreaStrength? keyAreaStrength;

  factory Details.fromJson(Map<String, dynamic> json){
    return Details(
      response: json["response"] == null ? [] : List<TeacherData>.from(json["response"]!.map((x) => TeacherData.fromJson(x))),
      lessonObservations: json["lesson_observations"] == null ? null : LearningWalk.fromJson(json["lesson_observations"]),
      learningWalk: json["learning_walk"] == null ? null : LearningWalk.fromJson(json["learning_walk"]),
      keyAreaStrength: json["key_area_strength"] == null ? null : KeyAreaStrength.fromJson(json["key_area_strength"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "response": response?.map((x) => x.toJson()).toList(),
    "lesson_observations": lessonObservations?.toJson(),
    "learning_walk": learningWalk?.toJson(),
    "key_area_strength": keyAreaStrength?.toJson(),
  };

}

class KeyAreaStrength {
  KeyAreaStrength({
    this.strengths,
    this.areasForImprovement,
  });

  final List<AreasForImprovement>? strengths;
  final List<AreasForImprovement>? areasForImprovement;

  factory KeyAreaStrength.fromJson(Map<String, dynamic> json){
    return KeyAreaStrength(
      strengths: json["strengths"] == null ? [] : List<AreasForImprovement>.from(json["strengths"]!.map((x) => AreasForImprovement.fromJson(x))),
      areasForImprovement: json["areas_for_improvement"] == null ? [] : List<AreasForImprovement>.from(json["areas_for_improvement"]!.map((x) => AreasForImprovement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "strengths": strengths?.map((x) => x.toJson()).toList(),
    "areas_for_improvement": areasForImprovement?.map((x) => x.toJson()).toList(),
  };

}

class AreasForImprovement {
  AreasForImprovement({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory AreasForImprovement.fromJson(Map<String, dynamic> json){
    return AreasForImprovement(
      id: json["_id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };

}

class LearningWalk {
  LearningWalk({
    this.id,
    this.list,
    this.updatedOn,
    this.addedOn,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  final String? id;
  final List<ListElement>? list;
  final DateTime? updatedOn;
  final DateTime? addedOn;
  final String? schoolId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? updatedBy;

  factory LearningWalk.fromJson(Map<String, dynamic> json){
    return LearningWalk(
      id: json["_id"],
      list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
      updatedOn: DateTime.tryParse(json["updated_on"] ?? ""),
      addedOn: DateTime.tryParse(json["added_on"] ?? ""),
      schoolId: json["school_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      updatedBy: json["updated_by"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "list": list?.map((x) => x.toJson()).toList(),
    "updated_on": updatedOn?.toIso8601String(),
    "added_on": addedOn?.toIso8601String(),
    "school_id": schoolId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "updated_by": updatedBy,
  };

}

class ListElement {
  ListElement({
    this.indicator,
    this.rubrix,
    this.index,
    this.id,
  });

  final String? indicator;
  final List<Rubrix>? rubrix;
  final int? index;
  final String? id;

  factory ListElement.fromJson(Map<String, dynamic> json){
    return ListElement(
      indicator: json["indicator"],
      rubrix: json["rubrix"] == null ? [] : List<Rubrix>.from(json["rubrix"]!.map((x) => Rubrix.fromJson(x))),
      index: json["_index"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "indicator": indicator,
    "rubrix": rubrix?.map((x) => x.toJson()).toList(),
    "_index": index,
    "_id": id,
  };

}

class Rubrix {
  Rubrix({
    this.name,
    this.parameter,
    this.className,
    this.index,
    this.alias,
    this.dbKey,
    this.id,
  });

  final String? name;
  final String? parameter;
  final String? className;
  final int? index;
  final String? alias;
  final String? dbKey;
  final String? id;

  factory Rubrix.fromJson(Map<String, dynamic> json){
    return Rubrix(
      name: json["name"],
      parameter: json["parameter"],
      className: json["class_name"],
      index: json["_index"],
      alias: json["alias"],
      dbKey: json["db_key"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "parameter": parameter,
    "class_name": className,
    "_index": index,
    "alias": alias,
    "db_key": dbKey,
    "_id": id,
  };

}

class TeacherData {
  TeacherData({
    this.teacherId,
    this.teacherName,
    this.teacherImage,
    this.details,
  });

  final String? teacherId;
  final String? teacherName;
  final String? teacherImage;
  final List<TeacherDetails>? details;

  factory TeacherData.fromJson(Map<String, dynamic> json){
    return TeacherData(
      teacherId: json["teacher_id"],
      teacherName: json["teacher_name"],
      teacherImage: json["teacher_image"],
      details: json["details"] == null ? [] : List<TeacherDetails>.from(json["details"]!.map((x) => TeacherDetails.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "teacher_id": teacherId,
    "teacher_name": teacherName,
    "teacher_image": teacherImage,
    "details": details?.map((x) => x.toJson()).toList(),
  };

}

class TeacherDetails {
  TeacherDetails({
    this.sessionId,
    this.classId,
    this.batchId,
    this.curriculumId,
    this.subjects,
    this.subjectDetails,
    this.className,
    this.batchName,
    this.mainSubjects,
    this.isClassTeacher,
  });

  final String? sessionId;
  final String? classId;
  final String? batchId;
  final String? curriculumId;
  final List<String>? subjects;
  final List<SubjectDetail>? subjectDetails;
  final String? className;
  final String? batchName;
  final List<String>? mainSubjects;
  final bool? isClassTeacher;

  factory TeacherDetails.fromJson(Map<String, dynamic> json){
    return TeacherDetails(
      sessionId: json["session_id"],
      classId: json["class_id"],
      batchId: json["batch_id"],
      curriculumId: json["curriculum_id"],
      subjects: json["subjects"] == null ? [] : List<String>.from(json["subjects"]!.map((x) => x)),
      subjectDetails: json["subject_details"] == null ? [] : List<SubjectDetail>.from(json["subject_details"]!.map((x) => SubjectDetail.fromJson(x))),
      className: json["class_name"],
      batchName: json["batch_name"],
      mainSubjects: json["main_subjects"] == null ? [] : List<String>.from(json["main_subjects"]!.map((x) => x)),
      isClassTeacher: json["is_class_teacher"],
    );
  }

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "class_id": classId,
    "batch_id": batchId,
    "curriculum_id": curriculumId,
    "subjects": subjects?.map((x) => x).toList(),
    "subject_details": subjectDetails?.map((x) => x.toJson()).toList(),
    "class_name": className,
    "batch_name": batchName,
    "main_subjects": mainSubjects?.map((x) => x).toList(),
    "is_class_teacher": isClassTeacher,
  };

}

class SubjectDetail {
  SubjectDetail({
    this.subjectId,
    this.subjectName,
  });

  final String? subjectId;
  final String? subjectName;

  factory SubjectDetail.fromJson(Map<String, dynamic> json){
    return SubjectDetail(
      subjectId: json["subject_id"],
      subjectName: json["subject_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "subject_id": subjectId,
    "subject_name": subjectName,
  };

}

class Status {
  Status({
    this.code,
    this.message,
  });

  final int? code;
  final String? message;

  factory Status.fromJson(Map<String, dynamic> json){
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
