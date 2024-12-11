class StudentAddModel {
  String? admnNo;
  String? studentName;
  String? profilePic;
  String? batchDetails;
  String? academicYear;
  int? instID;
  int? age;
  String? dob;
  String? gender;
  String? fatherName;
  String? fatherPhone;
  String? fatherEmail;
  String? remarks;
  String? role;
  String? appType;
  String? visitStatus;
  String? sentBy;
  String? sentById;
  String? sentByToken;
  String? sentTo;
  String? sentToName;

  StudentAddModel(
      {this.admnNo,
        this.studentName,
        this.profilePic,
        this.batchDetails,
        this.academicYear,
        this.instID,
        this.age,
        this.dob,
        this.gender,
        this.fatherName,
        this.fatherPhone,
        this.fatherEmail,
        this.remarks,
        this.role,
        this.appType,
        this.visitStatus,
        this.sentBy,
        this.sentById,
        this.sentByToken,
        this.sentTo,this.sentToName});

  StudentAddModel.fromJson(Map<String, dynamic> json) {
    admnNo = json['Admn_No'];
    studentName = json['student_name'];
    profilePic = json['profile_pic'];
    batchDetails = json['batch_details'];
    academicYear = json['academic_year'];
    instID = json['inst_ID'];
    age = json['age'];
    dob = json['dob'];
    gender = json['gender'];
    fatherName = json['father_name'];
    fatherPhone = json['father_phone'];
    fatherEmail = json['father_email'];
    remarks = json['remarks'];
    role = json['role'];
    appType = json['app_type'];
    visitStatus = json['visit_status'];
    sentBy = json['sent_by'];
    sentById = json['sent_by_id'];
    sentByToken = json['sent_by_token'];
    sentTo = json['sent_to'];
    sentToName = json['send_to_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Admn_No'] = admnNo;
    data['student_name'] = studentName;
    data['profile_pic'] = profilePic;
    data['batch_details'] = batchDetails;
    data['academic_year'] = academicYear;
    data['inst_ID'] = instID;
    data['age'] = age;
    data['dob'] = dob;
    data['gender'] = gender;
    data['father_name'] = fatherName;
    data['father_phone'] = fatherPhone;
    data['father_email'] = fatherEmail;
    data['remarks'] = remarks;
    data['role'] = role;
    data['app_type'] = appType;
    data['visit_status'] = visitStatus;
    data['sent_by'] = sentBy;
    data['sent_by_id'] = sentById;
    data['sent_by_token'] = sentByToken;
    data['sent_to'] = sentTo;
    data['send_to_name'] = sentToName;
    return data;
  }
}


