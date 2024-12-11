class ObservationResultApiModel {
  Status? status;
  Data? data;

  ObservationResultApiModel({this.status, this.data});

  ObservationResultApiModel.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? Status.fromJson(json['status']) : null;
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
  List<ObsResultData>? details;

  Data({this.message, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <ObsResultData>[];
      json['details'].forEach((v) {
        details!.add(ObsResultData.fromJson(v));
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

class ObsResultData {
  String? sId;
  String? dateOfObservation;
  String? observerName;
  String? subjectName;
  String? type;
  bool? lwNew;
  String? classId;
  String? batchId;
  String? addedBy;
  String? lwFocus;
  String? whatWentWell;
  String? evenBetterIf;
  String? notes;

  ObsResultData(
      {this.sId,
        this.dateOfObservation,
        this.observerName,
        this.subjectName,
        this.type,
        this.lwNew,
        this.classId,
        this.batchId,
        this.addedBy,
        this.lwFocus,
        this.whatWentWell,
        this.evenBetterIf,
        this.notes});

  ObsResultData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    dateOfObservation = json['date_of_observation'];
    observerName = json['observer_name'];
    subjectName = json['subject_name'];
    type = json['type'];
    lwNew= json['LW_NEW'];
    classId = json['class_id'];
    batchId = json['batch_id'];
    addedBy = json['added_by'];
    lwFocus = json['lw_focus'];
    whatWentWell = json['what_went_well'];
    evenBetterIf = json['even_better_if'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['date_of_observation'] = dateOfObservation;
    data['observer_name'] = observerName;
    data['subject_name'] = subjectName;
    data['type'] = type;
    data['LW_NEW'] = lwNew;
    data['class_id'] = classId;
    data['batch_id'] = batchId;
    data['added_by'] = addedBy;
    data['lw_focus'] = lwFocus;
    data['what_went_well'] = whatWentWell;
    data['even_better_if'] = evenBetterIf;
    data['notes'] = notes;
    return data;
  }
}
