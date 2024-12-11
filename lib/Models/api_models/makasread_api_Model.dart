class MarkasreadData {
  MarkasreadData({
     this.status,
     this.data,
  });

  final Status? status;
  final Data? data;

  factory MarkasreadData.fromJson(Map<String, dynamic> json){
    return MarkasreadData(
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
  });

  final String? message;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
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
