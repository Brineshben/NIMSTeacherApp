class NotificationModel {
  int? id;
  String? studentName;
  String? classs;
  String? batch;
  String? visitDate;
  String? visitStatus;
  String? remarks;
  String? admissionNo;
  bool? isprogress;
  String? sentById;
  String? sendByName;
  String? roleOfSender;
  String? schoolId;
  String? sound;

  NotificationModel(
      {this.id,
      this.studentName,
      this.classs,
      this.batch,
      this.visitDate,
      this.sendByName,
      this.visitStatus,
      this.remarks,
      this.admissionNo,
      this.isprogress,
      this.sentById,
      this.roleOfSender,
      this.schoolId,
      this.sound});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentName = json['student_name'];
    classs = json['class'];
    batch = json['batch'];
    visitDate = json['visit_date'];
    visitStatus = json['visit_status'];
    remarks = json['remarks'];
    admissionNo = json['admission_no'];
    isprogress = json['isprogress'];
    sentById = json['sent_by_id'];
    sendByName = json['send_by'];
    roleOfSender = json['role_of_sender'];
    schoolId = json['school_id'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_name'] = studentName;
    data['class'] = classs;
    data['batch'] = batch;
    data['visit_date'] = visitDate;
    data['visit_status'] = visitStatus;
    data['remarks'] = remarks;
    data['admission_no'] = admissionNo;
    data['isprogress'] = isprogress;
    data['send_by'] = sendByName;
    data['sent_by_id'] = sentById;
    data['role_of_sender'] = roleOfSender;
    data['school_id'] = schoolId;
    data['sound'] = sound;
    return data;
  }
}
