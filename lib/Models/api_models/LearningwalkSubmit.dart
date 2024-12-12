import 'dart:convert';

class LearningwalkSubmitModel {
  String? academicYear;
  String? addedBy;
  String? addedDate;
  String? batchId;
  String? classId;
  String? curriculumId;
  String? evenBetterIf;
  String? lwFocus;
  String? notes;
  String? observationDate;
  List<String>? observerRoles;
  String? qsToPuple;
  String? qsToTeacher;
  String? schoolId;
  String? senderId;
  String? sessionId;
  String? whatWentWell;

  LearningwalkSubmitModel(
      {this.academicYear,
        this.addedBy,
        this.addedDate,
        this.batchId,
        this.classId,
        this.curriculumId,
        this.evenBetterIf,
        this.lwFocus,
        this.notes,
        this.observationDate,
        this.observerRoles,
        this.qsToPuple,
        this.qsToTeacher,
        this.schoolId,
        this.senderId,
        this.sessionId,
        this.whatWentWell});

  LearningwalkSubmitModel.fromJson(Map<String, dynamic> json) {
    academicYear = json['academic_year'];
    addedBy = json['added_by'];
    addedDate = json['added_date'];
    batchId = json['batch_id'];
    classId = json['class_id'];
    curriculumId = json['curriculum_id'];
    evenBetterIf = json['even_better_if'];
    lwFocus = json['lw_focus'];
    notes = json['notes'];
    observationDate = json['observation_date'];
    observerRoles = (json['observer_roles']?.isNotEmpty ?? false) ? jsonDecode(json['observer_roles']) : [];
    qsToPuple = json['qs_to_puple'];
    qsToTeacher = json['qs_to_teacher'];
    schoolId = json['school_id'];
    senderId = json['sender_id'];
    sessionId = json['session_id'];
    whatWentWell = json['what_went_well'];
  }

  // Map<String, dynamic> toMap() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['academic_year'] = this.academicYear;
  //   data['added_by'] = this.addedBy;
  //   data['added_date'] = this.addedDate;
  //   data['batch_id'] = this.batchId;
  //   data['class_id'] = this.classId;
  //   data['curriculum_id'] = this.curriculumId;
  //   data['even_better_if'] = this.evenBetterIf;
  //   data['lw_focus'] = this.lwFocus;
  //   data['notes'] = this.notes;
  //   data['observation_date'] = this.observationDate;
  //   data['observer_roles'] = this.observerRoles;
  //   data['qs_to_puple'] = this.qsToPuple;
  //   data['qs_to_teacher'] = this.qsToTeacher;
  //   data['school_id'] = this.schoolId;
  //   data['sender_id'] = this.senderId;
  //   data['session_id'] = this.sessionId;
  //   data['what_went_well'] = this.whatWentWell;
  //   return data;
  // }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['academic_year'] = this.academicYear;
    data['added_by'] = this.addedBy;
    data['added_date'] = this.addedDate;
    data['batch_id'] = this.batchId;
    data['class_id'] = this.classId;
    data['curriculum_id'] = this.curriculumId;
    data['even_better_if'] = this.evenBetterIf;
    data['lw_focus'] = this.lwFocus;
    data['notes'] = this.notes;
    data['observation_date'] = this.observationDate;
    data['observer_roles'] = this.observerRoles?.join(',');  // Convert list to string
    data['qs_to_puple'] = this.qsToPuple;
    data['qs_to_teacher'] = this.qsToTeacher;
    data['school_id'] = this.schoolId;
    data['sender_id'] = this.senderId;
    data['session_id'] = this.sessionId;
    data['what_went_well'] = this.whatWentWell;
    return data;
  }

}