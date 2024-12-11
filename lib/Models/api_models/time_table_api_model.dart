
class TimeTableModel {
  TimeTableModel({
    required this.status,
    required this.data,
  });

  final Status? status;
  final Data? data;

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    return TimeTableModel(
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
    required this.resultArray,
    required this.periods,
    required this.timetable,
    required this.days,
  });

  final List<ResultArray> resultArray;
  final List<Period> periods;
  final List<Timetable> timetable;
  final List<Day> days;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      resultArray: json["resultArray"] == null
          ? []
          : List<ResultArray>.from(
              json["resultArray"]!.map((x) => ResultArray.fromJson(x))),
      periods: json["periods"] == null
          ? []
          : List<Period>.from(json["periods"]!.map((x) => Period.fromJson(x))),
      timetable: json["timetable"] == null
          ? []
          : List<Timetable>.from(
              json["timetable"]!.map((x) => Timetable.fromJson(x))),
      days: json["days"] == null
          ? []
          : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "resultArray": resultArray.map((x) => x.toJson()).toList(),
        "periods": periods.map((x) => x.toJson()).toList(),
        "timetable": timetable.map((x) => x.toJson()).toList(),
        "days": days.map((x) => x.toJson()).toList(),
      };
}

class Day {
  Day({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json["_id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Period {
  Period({
    required this.name,
    required this.nonteachingPeriod,
    required this.startTime,
    required this.endTime,
    required this.id,
    required this.periodNumber,
  });

  final List<String> name;
  final bool? nonteachingPeriod;
  final String? startTime;
  final String? endTime;
  final String? id;
  final int? periodNumber;

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      name: json["name"] == null
          ? []
          : List<String>.from(json["name"]!.map((x) => x)),
      nonteachingPeriod: json["nonteaching_period"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      id: json["_id"],
      periodNumber: json["period_number"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name.map((x) => x).toList(),
        "nonteaching_period": nonteachingPeriod,
        "start_time": startTime,
        "end_time": endTime,
        "_id": id,
        "period_number": periodNumber,
      };
}

class ResultArray {
  ResultArray({
    required this.id,
    required this.dayName,
    required this.timeTable,
  });

  final int? id;
  final String? dayName;
  final List<TimeTable> timeTable;

  factory ResultArray.fromJson(Map<String, dynamic> json) {
    return ResultArray(
      id: json["_id"],
      dayName: json["dayName"],
      timeTable: json["timeTable"] == null
          ? []
          : List<TimeTable>.from(
              json["timeTable"]!.map((x) => TimeTable.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dayName": dayName,
        "timeTable": timeTable.map((x) => x.toJson()).toList(),
      };
}

class TimeTable {
  TimeTable({
    required this.classDetails,
    required this.sessionId,
    required this.curriculumId,
    required this.classId,
    required this.batchId,
    required this.batchName,
    required this.subject,
    required this.timeString,
    required this.studentCount,
  });

  final List<dynamic> classDetails;
  final String? sessionId;
  final String? curriculumId;
  final String? classId;
  final String? batchId;
  final String? batchName;
  final String? subject;
  final String? timeString;
  final int? studentCount;

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      classDetails: json["class_details"] == null
          ? []
          : List<dynamic>.from(json["class_details"]!.map((x) => x)),
      sessionId: json["session_id"],
      curriculumId: json["curriculum_id"],
      classId: json["class_id"],
      batchId: json["batch_id"],
      batchName: json["batchName"],
      subject: json["subject"],
      timeString: json["timeString"],
      studentCount: json["student_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "class_details": classDetails.map((x) => x).toList(),
        "session_id": sessionId,
        "curriculum_id": curriculumId,
        "class_id": classId,
        "batch_id": batchId,
        "batchName": batchName,
        "subject": subject,
        "timeString": timeString,
        "student_count": studentCount,
      };
}

class Timetable {
  Timetable({
    required this.session,
    required this.curriculum,
    required this.timetableClass,
    required this.batch,
    required this.subject,
    required this.sessionId,
    required this.curriculumId,
    required this.classId,
    required this.batchId,
    required this.subjectId,
    required this.teacherId,
    required this.day,
    required this.period,
    required this.periodName,
    required this.dayName,
    required this.startTime,
    required this.endTime,
    required this.classDetails,
  });

  final String? session;
  final String? curriculum;
  final String? timetableClass;
  final String? batch;
  final String? subject;
  final String? sessionId;
  final String? curriculumId;
  final String? classId;
  final String? batchId;
  final String? subjectId;
  final String? teacherId;
  final int? day;
  final int? period;
  final List<String> periodName;
  final List<String> dayName;
  final String? startTime;
  final String? endTime;
  final List<dynamic> classDetails;

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      session: json["session"],
      curriculum: json["curriculum"],
      timetableClass: json["class"],
      batch: json["batch"],
      subject: json["subject"],
      sessionId: json["session_id"],
      curriculumId: json["curriculum_id"],
      classId: json["class_id"],
      batchId: json["batch_id"],
      subjectId: json["subject_id"],
      teacherId: json["teacher_id"],
      day: json["day"],
      period: json["period"],
      periodName: json["period_name"] == null
          ? []
          : List<String>.from(json["period_name"]!.map((x) => x)),
      dayName: json["day_name"] == null
          ? []
          : List<String>.from(json["day_name"]!.map((x) => x)),
      startTime: json["start_time"],
      endTime: json["end_time"],
      classDetails: json["classDetails"] == null
          ? []
          : List<dynamic>.from(json["classDetails"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "session": session,
        "curriculum": curriculum,
        "class": timetableClass,
        "batch": batch,
        "subject": subject,
        "session_id": sessionId,
        "curriculum_id": curriculumId,
        "class_id": classId,
        "batch_id": batchId,
        "subject_id": subjectId,
        "teacher_id": teacherId,
        "day": day,
        "period": period,
        "period_name": periodName.map((x) => x).toList(),
        "day_name": dayName.map((x) => x).toList(),
        "start_time": startTime,
        "end_time": endTime,
        "classDetails": classDetails.map((x) => x).toList(),
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

class TeacherSubject {
  final String? sub;
  final String? classs;
  final String? classId;
  final String? batch;
  final String? batchId;
  final String? sessionId;
  final String? curriculumId;
  final bool? isClassTeacher;
  final int? studentCount;

  const TeacherSubject({
    this.sub,
    this.classs,
    this.classId,
    this.batch,
    this.batchId,
    this.sessionId,
    this.curriculumId,
    this.isClassTeacher,
    this.studentCount,
  });
}
