import 'dart:convert';

import 'login_api_model.dart';

const String tableLessLearn = 'LessonLearning';

class LessonLearningFields {
  static final List<String> values = [
    /// Add all fields
    id, isLesson, lessonLearning, schoolId, teacherId, teacherName, observerId,
    observerName,
    classId,
    classBatchName, batchId, topic, academicYear, batchName, className,
    subjectName,
    subjectId, submittedDate, rollIds, areasForImprovement, strengths, remedialMeasures,
    upperHierarchy,
    sessionId, curriculumId, isJoin, remarksData, indicators, name, remark,
    point, dbKey, alias
  ];

  static const String id = '_id';
  static const String isLesson = 'isLesson';
  static const String lessonLearning = 'lessonLearning';
  static const String schoolId = 'school_id';
  static const String teacherId = 'teacher_id';
  static const String teacherName = 'teacher_name';
  static const String observerId = 'observer_id';
  static const String observerName = 'observer_name';
  static const String classId = 'class_id';
  static const String classBatchName = 'class_batch_name';
  static const String batchId = 'batch_id';
  static const String topic = 'topic';
  static const String academicYear = 'academic_year';
  static const String batchName = 'batch_name';
  static const String className = 'class_name';
  static const String subjectName = 'subject_name';
  static const String subjectId = 'subject_id';
  static const String submittedDate = 'submitted_date';
  static const String rollIds = 'roll_ids';
  static const String areasForImprovement = 'areas_for_improvement';
  static const String strengths = 'strengths';
  static const String remedialMeasures = 'remedial_measures';
  static const String upperHierarchy = 'upper_hierarchy';
  static const String sessionId = 'session_id';
  static const String curriculumId = 'curriculum_id';
  static const String isJoin = 'isJoin';
  static const String remarksData = 'remarks_data';
  static const String indicators = 'Indicators';
  static const String name = 'name';
  static const String remark = 'remark';
  static const String point = 'point';
  static const String dbKey = 'db_key';
  static const String alias = 'alias';
}

class LessonLearningApplyModel {
  final int? id;
  final bool isLesson;
  final LessonLearning lessonLearning;
  LessonLearningApplyModel(
      {this.id, required this.isLesson, required this.lessonLearning});

  LessonLearningApplyModel copy({
    int? id,
    bool? isLesson,
    LessonLearning? lessonLearning,
  }) =>
      LessonLearningApplyModel(
        id: id ?? this.id,
        isLesson: isLesson ?? this.isLesson,
        lessonLearning: lessonLearning ?? this.lessonLearning,
      );

  factory LessonLearningApplyModel.fromJson(Map<String, dynamic> json) =>
      LessonLearningApplyModel(
        id: json[LessonLearningFields.id],
        isLesson: json[LessonLearningFields.isLesson] == 1,
        lessonLearning: LessonLearning.fromJson(
            jsonDecode(json[LessonLearningFields.lessonLearning])),
      );

  Map<String, dynamic> toJsonForDb() => {
        LessonLearningFields.id: id,
        LessonLearningFields.isLesson: isLesson ? 1 : 0,
        LessonLearningFields.lessonLearning:
            jsonEncode(lessonLearning.toJsonForDb()),
      };

  Map<String, dynamic> toJson() => {
        LessonLearningFields.id: id,
        LessonLearningFields.isLesson: isLesson,
        LessonLearningFields.lessonLearning: lessonLearning,
      };
}

class LessonLearning {
  final String schoolId;
  final String teacherId;
  final String teacherName;
  final String observerId;
  final String observerName;
  final String classId;
  final String classBatchName;
  final String batchId;
  final String topic;
  final String academicYear;
  final String batchName;
  final String className;
  final String subjectName;
  final String subjectId;
  final String submittedDate;
  final List<AllRolesArray> rollIds;
  final List<String> areasForImprovement;
  final List<String> strengths;
  final String remedialMeasures;
  final String? upperHierarchy;
  final String sessionId;
  final String curriculumId;
  final bool isJoin;
  final List<RemarksData> remarksData;

  LessonLearning({
    required this.schoolId,
    required this.teacherId,
    required this.teacherName,
    required this.observerId,
    required this.observerName,
    required this.classId,
    required this.classBatchName,
    required this.batchId,
    required this.topic,
    required this.academicYear,
    required this.batchName,
    required this.className,
    required this.subjectName,
    required this.subjectId,
    required this.submittedDate,
    required this.rollIds,
    required this.areasForImprovement,
    required this.strengths,
    required this.remedialMeasures,
    this.upperHierarchy,
    required this.sessionId,
    required this.curriculumId,
    required this.isJoin,
    required this.remarksData,
  });

  LessonLearning copy({
    String? schoolId,
    String? teacherId,
    String? teacherName,
    String? observerId,
    String? observerName,
    String? classId,
    String? classBatchName,
    String? batchId,
    String? topic,
    String? academicYear,
    String? batchName,
    String? className,
    String? subjectName,
    String? subjectId,
    String? submittedDate,
    List<AllRolesArray>? rollIds,
    List<String>? areasForImprovement,
    List<String>? strengths,
    String? remedialMeasures,
    String? upperHierarchy,
    String? sessionId,
    String? curriculumId,
    bool? isJoin,
    List<RemarksData>? remarksData,
  }) =>
      LessonLearning(
        schoolId: schoolId ?? this.schoolId,
        teacherId: teacherId ?? this.teacherId,
        teacherName: teacherName ?? this.teacherName,
        observerId: observerId ?? this.observerId,
        observerName: observerName ?? this.observerName,
        classId: classId ?? this.classId,
        classBatchName: classBatchName ?? this.classBatchName,
        batchId: batchId ?? this.batchId,
        topic: topic ?? this.topic,
        academicYear: academicYear ?? this.academicYear,
        batchName: batchName ?? this.batchName,
        className: className ?? this.className,
        subjectName: subjectName ?? this.subjectName,
        subjectId: subjectId ?? this.subjectId,
        submittedDate: submittedDate ?? this.submittedDate,
        rollIds: rollIds ?? this.rollIds,
        areasForImprovement: areasForImprovement ?? this.areasForImprovement,
        strengths: strengths ?? this.strengths,
        remedialMeasures: remedialMeasures ?? this.remedialMeasures,
        upperHierarchy: upperHierarchy ?? this.upperHierarchy,
        sessionId: sessionId ?? this.sessionId,
        curriculumId: curriculumId ?? this.curriculumId,
        isJoin: isJoin ?? this.isJoin,
        remarksData: remarksData ?? this.remarksData,
      );

  factory LessonLearning.fromJson(Map<String, dynamic> json) {
    return LessonLearning(
      schoolId: json[LessonLearningFields.schoolId],
      teacherId: json[LessonLearningFields.teacherId],
      teacherName: json[LessonLearningFields.teacherName],
      observerId: json[LessonLearningFields.observerId],
      observerName: json[LessonLearningFields.observerName],
      classId: json[LessonLearningFields.classId],
      classBatchName: json[LessonLearningFields.classBatchName],
      batchId: json[LessonLearningFields.batchId],
      topic: json[LessonLearningFields.topic],
      academicYear: json[LessonLearningFields.academicYear],
      batchName: json[LessonLearningFields.batchName],
      className: json[LessonLearningFields.className],
      subjectName: json[LessonLearningFields.subjectName],
      subjectId: json[LessonLearningFields.subjectId],
      submittedDate: json[LessonLearningFields.submittedDate],
      rollIds: (json[LessonLearningFields.rollIds] as List)
          .map((i) => AllRolesArray.fromJson(i))
          .toList(),
      areasForImprovement:
          List<String>.from(json[LessonLearningFields.areasForImprovement]),
      strengths: List<String>.from(json[LessonLearningFields.strengths]),
      remedialMeasures: json[LessonLearningFields.remedialMeasures],
      upperHierarchy: json[LessonLearningFields.upperHierarchy],
      sessionId: json[LessonLearningFields.sessionId],
      curriculumId: json[LessonLearningFields.curriculumId],
      isJoin: json[LessonLearningFields.isJoin] == 1,
      remarksData: (json[LessonLearningFields.remarksData] as List)
          .map((i) => RemarksData.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJsonForDb() {
    return {
      LessonLearningFields.schoolId: schoolId,
      LessonLearningFields.teacherId: teacherId,
      LessonLearningFields.teacherName: teacherName,
      LessonLearningFields.observerId: observerId,
      LessonLearningFields.observerName: observerName,
      LessonLearningFields.classId: classId,
      LessonLearningFields.classBatchName: classBatchName,
      LessonLearningFields.batchId: batchId,
      LessonLearningFields.topic: topic,
      LessonLearningFields.academicYear: academicYear,
      LessonLearningFields.batchName: batchName,
      LessonLearningFields.className: className,
      LessonLearningFields.subjectName: subjectName,
      LessonLearningFields.subjectId: subjectId,
      LessonLearningFields.submittedDate: submittedDate,
      LessonLearningFields.rollIds: rollIds.map((i) => i.toJson()).toList(),
      LessonLearningFields.areasForImprovement: areasForImprovement,
      LessonLearningFields.strengths: strengths,
      LessonLearningFields.remedialMeasures: remedialMeasures,
      LessonLearningFields.upperHierarchy: upperHierarchy,
      LessonLearningFields.sessionId: sessionId,
      LessonLearningFields.curriculumId: curriculumId,
      LessonLearningFields.isJoin: isJoin ? 1 : 0,
      LessonLearningFields.remarksData:
          remarksData.map((i) => i.toJson()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      LessonLearningFields.schoolId: schoolId,
      LessonLearningFields.teacherId: teacherId,
      LessonLearningFields.teacherName: teacherName,
      LessonLearningFields.observerId: observerId,
      LessonLearningFields.observerName: observerName,
      LessonLearningFields.classId: classId,
      LessonLearningFields.classBatchName: classBatchName,
      LessonLearningFields.batchId: batchId,
      LessonLearningFields.topic: topic,
      LessonLearningFields.academicYear: academicYear,
      LessonLearningFields.batchName: batchName,
      LessonLearningFields.className: className,
      LessonLearningFields.subjectName: subjectName,
      LessonLearningFields.subjectId: subjectId,
      LessonLearningFields.submittedDate: submittedDate,
      LessonLearningFields.rollIds: rollIds.map((i) => i.toJson()).toList(),
      LessonLearningFields.areasForImprovement: areasForImprovement,
      LessonLearningFields.strengths: strengths,
      LessonLearningFields.remedialMeasures: remedialMeasures,
      LessonLearningFields.upperHierarchy: upperHierarchy,
      LessonLearningFields.sessionId: sessionId,
      LessonLearningFields.curriculumId: curriculumId,
      LessonLearningFields.isJoin: isJoin,
      LessonLearningFields.remarksData:
          remarksData.map((i) => i.toJson()).toList(),
    };
  }
}

class RemarksData {
  final List<Indicator?> indicators;

  RemarksData({
    required this.indicators,
  });

  RemarksData copy({
    List<Indicator?>? indicators,
  }) =>
      RemarksData(
        indicators: indicators ?? this.indicators,
      );

  factory RemarksData.fromJson(Map<String, dynamic> json) {
    return RemarksData(
      indicators: (json[LessonLearningFields.indicators] as List)
          .map((i) => Indicator.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      LessonLearningFields.indicators:
          indicators.map((i) => i?.toJson()).toList(),
    };
  }
}

class Indicator {
  final String? name;
  final String? remark;
  final int? point;
  final String? dbKey;
  final String? alias;

  Indicator({
    this.name,
    this.remark,
    this.point,
    this.dbKey,
    this.alias,
  });

  Indicator copy({
    String? name,
    String? remark,
    int? point,
    String? dbKey,
    String? alias,
  }) =>
      Indicator(
        name: name ?? this.name,
        remark: remark ?? this.remark,
        point: point ?? this.point,
        dbKey: dbKey ?? this.dbKey,
        alias: alias ?? this.alias,
      );

  factory Indicator.fromJson(Map<String, dynamic> json) {
    return Indicator(
      name: json[LessonLearningFields.name],
      remark: json[LessonLearningFields.remark],
      point: json[LessonLearningFields.point],
      dbKey: json[LessonLearningFields.dbKey],
      alias: json[LessonLearningFields.alias],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      LessonLearningFields.name: name,
      LessonLearningFields.remark: remark,
      LessonLearningFields.point: point,
      LessonLearningFields.dbKey: dbKey,
      LessonLearningFields.alias: alias,
    };
  }
}
