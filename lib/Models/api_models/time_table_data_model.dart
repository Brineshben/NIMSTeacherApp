class TimeTableDataModel {
  TimeTableDataModel({
     this.status,
     this.data,
  });

  final Status? status;
  final Data? data;

  factory TimeTableDataModel.fromJson(Map<String, dynamic> json){
    return TimeTableDataModel(
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
  final List<dynamic> periods;
  final List<dynamic> timetable;
  final List<Day> days;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      resultArray: json["resultArray"] == null ? [] : List<ResultArray>.from(json["resultArray"]!.map((x) => ResultArray.fromJson(x))),
      periods: json["periods"] == null ? [] : List<dynamic>.from(json["periods"]!.map((x) => x)),
      timetable: json["timetable"] == null ? [] : List<dynamic>.from(json["timetable"]!.map((x) => x)),
      days: json["days"] == null ? [] : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "resultArray": resultArray.map((x) => x.toJson()).toList(),
    "periods": periods.map((x) => x).toList(),
    "timetable": timetable.map((x) => x).toList(),
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

  factory Day.fromJson(Map<String, dynamic> json){
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

class ResultArray {
  ResultArray({
    required this.id,
    required this.dayName,
    required this.timeTable,
  });

  final int? id;
  final String? dayName;
  final List<dynamic> timeTable;

  factory ResultArray.fromJson(Map<String, dynamic> json){
    return ResultArray(
      id: json["_id"],
      dayName: json["dayName"],
      timeTable: json["timeTable"] == null ? [] : List<dynamic>.from(json["timeTable"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "dayName": dayName,
    "timeTable": timeTable.map((x) => x).toList(),
  };

}

class Status {
  Status({
    required this.code,
    required this.message,
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