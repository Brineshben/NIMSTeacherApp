class QrclinicModel {
  String? studentId;
  String? admnNo;
  String? studentName;
  String? profileImage;
  String? profileImageAlternate;
  String? classCode;
  String? batch;
  String? description;
  String? studStatus;
  int? instID;
  int? age;
  String? dob;
  String? gender;
  String? fatherName;
  String? fatherAddress;
  String? fatherPhone;
  String? fatherEmail;
  String? fatherPostalCode;
  String? motherName;
  String? motherAddress;
  String? motherPhone;
  String? motherEmail;
  String? motherPostalCode;
  List<Siblings>? siblings;

  QrclinicModel(
      {this.studentId,
        this.admnNo,
        this.studentName,
        this.profileImage,
        this.profileImageAlternate,
        this.classCode,
        this.batch,
        this.description,
        this.studStatus,
        this.instID,
        this.age,
        this.dob,
        this.gender,
        this.fatherName,
        this.fatherAddress,
        this.fatherPhone,
        this.fatherEmail,
        this.fatherPostalCode,
        this.motherName,
        this.motherAddress,
        this.motherPhone,
        this.motherEmail,
        this.motherPostalCode,
        this.siblings});

  QrclinicModel.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    admnNo = json['Admn_No'];
    studentName = json['student_name'];
    profileImage = json['profile_image'];
    profileImageAlternate = json['profile_image_alternate'];
    classCode = json['Class_code'];
    batch = json['batch'];
    description = json['Description'];
    studStatus = json['stud_status'];
    instID = json['inst_ID'];
    age = json['age'];
    dob = json['dob'];
    gender = json['gender'];
    fatherName = json['father_name'];
    fatherAddress = json['father_address'];
    fatherPhone = json['father_phone'];
    fatherEmail = json['father_email'];
    fatherPostalCode = json['father_postal_code'];
    motherName = json['mother_name'];
    motherAddress = json['mother_address'];
    motherPhone = json['mother_phone'];
    motherEmail = json['mother_email'];
    motherPostalCode = json['mother_postal_code'];
    if (json['siblings'] != null) {
      siblings = <Siblings>[];
      json['siblings'].forEach((v) {
        siblings!.add(Siblings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['Admn_No'] = admnNo;
    data['student_name'] = studentName;
    data['profile_image'] = profileImage;
    data['profile_image_alternate'] = profileImageAlternate;
    data['Class_code'] = classCode;
    data['batch'] = batch;
    data['Description'] = description;
    data['stud_status'] = studStatus;
    data['inst_ID'] = instID;
    data['age'] = age;
    data['dob'] = dob;
    data['gender'] = gender;
    data['father_name'] = fatherName;
    data['father_address'] = fatherAddress;
    data['father_phone'] = fatherPhone;
    data['father_email'] = fatherEmail;
    data['father_postal_code'] = fatherPostalCode;
    data['mother_name'] = motherName;
    data['mother_address'] = motherAddress;
    data['mother_phone'] = motherPhone;
    data['mother_email'] = motherEmail;
    data['mother_postal_code'] = motherPostalCode;
    if (siblings != null) {
      data['siblings'] = siblings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Siblings {
  String? siblingId;
  String? siblingName;
  String? siblingGender;
  String? siblingAdmnNo;
  String? siblingProfileImage;
  String? siblingProfileImageAlternate;
  String? siblingClassCode;
  String? siblingBatch;
  String? siblingAcademicYear;
  String? siblingStudStatus;
  int? siblingInstId;
  int? siblingAge;
  String? siblingDob;

  Siblings(
      {this.siblingId,
        this.siblingName,
        this.siblingGender,
        this.siblingAdmnNo,
        this.siblingProfileImage,
        this.siblingProfileImageAlternate,
        this.siblingClassCode,
        this.siblingBatch,
        this.siblingAcademicYear,
        this.siblingStudStatus,
        this.siblingInstId,
        this.siblingAge,
        this.siblingDob});

  Siblings.fromJson(Map<String, dynamic> json) {
    siblingId = json['sibling_id'];
    siblingName = json['sibling_name'];
    siblingGender = json['sibling_gender'];
    siblingAdmnNo = json['sibling_admn_no'];
    siblingProfileImage = json['sibling_profile_image'];
    siblingProfileImageAlternate = json['sibling_profile_image_alternate'];
    siblingClassCode = json['sibling_class_code'];
    siblingBatch = json['sibling_batch'];
    siblingAcademicYear = json['sibling_academic_year'];
    siblingStudStatus = json['sibling_stud_status'];
    siblingInstId = json['sibling_inst_id'];
    siblingAge = json['sibling_age'];
    siblingDob = json['sibling_dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sibling_id'] = siblingId;
    data['sibling_name'] = siblingName;
    data['sibling_gender'] = siblingGender;
    data['sibling_admn_no'] = siblingAdmnNo;
    data['sibling_profile_image'] = siblingProfileImage;
    data['sibling_profile_image_alternate'] = siblingProfileImageAlternate;
    data['sibling_class_code'] = siblingClassCode;
    data['sibling_batch'] = siblingBatch;
    data['sibling_academic_year'] = siblingAcademicYear;
    data['sibling_stud_status'] = siblingStudStatus;
    data['sibling_inst_id'] = siblingInstId;
    data['sibling_age'] = siblingAge;
    data['sibling_dob'] = siblingDob;
    return data;
  }
}