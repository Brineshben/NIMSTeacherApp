
class LoginApiModel {
  Status? status;
  LoginData? data;

  LoginApiModel({this.status, this.data});

  LoginApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
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

class LoginData {
  String? message;
  String? source;
  List<UserData>? data;
  String? sessionId;

  LoginData({this.message, this.source, this.data, this.sessionId});

  LoginData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    source = json['source'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['source'] = source;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['sessionId'] = sessionId;
    return data;
  }
}

class UserData {
  bool? passwordTracking;
  String? userId;
  String? username;
  String? schoolId;
  String? name;
  List<String>? roleIds;
  String? image;
  String? quickLoginId;
  // List<String>? newUsers;
  String? primaryRoleId;
  List<AllRolesArray>? allRolesArray;
  // List<ModulePrivileges>? modulePrivileges;
  // List<FeaturePrivileges>? featurePrivileges;
  String? academicYear;
  // List<AllAcademicYear>? allAcademicYear;
  String? schoolName;
  String? schoolLogo;
  bool? bannerstatus;
  String? classId;
  String? batchId;
  String? sessionId;
  String? curriculumId;
  String? className;
  String? batchName;
  String? sessionName;
  String? curriculumName;
  String? employeeNo;

  UserData(
      {this.passwordTracking,
      this.userId,
      this.username,
      this.schoolId,
      this.name,
      this.roleIds,
      this.image,
      this.quickLoginId,
      // this.newUsers,
      this.primaryRoleId,
      this.allRolesArray,
      // this.modulePrivileges,
      // this.featurePrivileges,
      this.academicYear,
      // this.allAcademicYear,
      this.schoolName,
      this.schoolLogo,
      this.bannerstatus,
      this.classId,
      this.batchId,
      this.sessionId,
      this.curriculumId,
      this.className,
      this.batchName,
      this.sessionName,
      this.curriculumName,
      this.employeeNo});

  UserData.fromJson(Map<String, dynamic> json) {
    passwordTracking = json['password_tracking'];
    userId = json['user_id'];
    username = json['username'];
    schoolId = json['school_id'];
    name = json['name'];
    roleIds = json['role_ids'].cast<String>();
    image = json['image'];
    quickLoginId = json['quick_login_id'];
    // newUsers = json['new_users'].cast<String>();
    primaryRoleId = json['primary_role_id'];
    if (json['all_roles_array'] != null) {
      allRolesArray = <AllRolesArray>[];
      json['all_roles_array'].forEach((v) {
        allRolesArray!.add(AllRolesArray.fromJson(v));
      });
    }
    // if (json['module_privileges'] != null) {
    //   modulePrivileges = <ModulePrivileges>[];
    //   json['module_privileges'].forEach((v) {
    //     modulePrivileges!.add(ModulePrivileges.fromJson(v));
    //   });
    // }
    // if (json['feature_privileges'] != null) {
    //   featurePrivileges = <FeaturePrivileges>[];
    //   json['feature_privileges'].forEach((v) {
    //     featurePrivileges!.add(FeaturePrivileges.fromJson(v));
    //   });
    // }
    academicYear = json['academic_year'];
    // if (json['allAcademic_year'] != null) {
    //   allAcademicYear = <AllAcademicYear>[];
    //   json['allAcademic_year'].forEach((v) {
    //     allAcademicYear!.add(AllAcademicYear.fromJson(v));
    //   });
    // }
    schoolName = json['school_name'];
    schoolLogo = json['school_logo'];
    bannerstatus = json['bannerstatus'];
    classId = json['class_id'];
    batchId = json['batch_id'];
    sessionId = json['session_id'];
    curriculumId = json['curriculum_id'];
    className = json['className'];
    batchName = json['batchName'];
    sessionName = json['sessionName'];
    curriculumName = json['curriculumName'];
    employeeNo = json['employeeNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password_tracking'] = passwordTracking;
    data['user_id'] = userId;
    data['username'] = username;
    data['school_id'] = schoolId;
    data['name'] = name;
    data['role_ids'] = roleIds;
    data['image'] = image;
    data['quick_login_id'] = quickLoginId;
    // data['new_users'] = newUsers;
    data['primary_role_id'] = primaryRoleId;
    if (allRolesArray != null) {
      data['all_roles_array'] = allRolesArray!.map((v) => v.toJson()).toList();
    }
    // if (modulePrivileges != null) {
    //   data['module_privileges'] =
    //       modulePrivileges!.map((v) => v.toJson()).toList();
    // }
    // if (featurePrivileges != null) {
    //   data['feature_privileges'] =
    //       featurePrivileges!.map((v) => v.toJson()).toList();
    // }
    data['academic_year'] = academicYear;
    // if (allAcademicYear != null) {
    //   data['allAcademic_year'] =
    //       allAcademicYear!.map((v) => v.toJson()).toList();
    // }
    data['school_name'] = schoolName;
    data['school_logo'] = schoolLogo;
    data['bannerstatus'] = bannerstatus;
    data['class_id'] = classId;
    data['batch_id'] = batchId;
    data['session_id'] = sessionId;
    data['curriculum_id'] = curriculumId;
    data['className'] = className;
    data['batchName'] = batchName;
    data['sessionName'] = sessionName;
    data['curriculumName'] = curriculumName;
    data['employeeNo'] = employeeNo;
    return data;
  }
}

class AllRolesArray {
  String? sId;
  String? name;
  bool? status;

  AllRolesArray({this.sId, this.name, this.status});

  AllRolesArray.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}

class ModulePrivileges {
  String? moduleId;
  String? name;
  String? state;
  String? iconUrl;

  ModulePrivileges({this.moduleId, this.name, this.state, this.iconUrl});

  ModulePrivileges.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    name = json['name'];
    state = json['state'];
    iconUrl = json['icon_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_id'] = moduleId;
    data['name'] = name;
    data['state'] = state;
    data['icon_url'] = iconUrl;
    return data;
  }
}

class FeaturePrivileges {
  String? roleId;
  String? moduleId;
  String? moduleState;
  String? featureId;
  String? name;
  List<Privilege>? privilege;

  FeaturePrivileges(
      {this.roleId,
      this.moduleId,
      this.moduleState,
      this.featureId,
      this.name,
      this.privilege});

  FeaturePrivileges.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    moduleId = json['module_id'];
    moduleState = json['module_state'];
    featureId = json['feature_id'];
    name = json['name'];
    if (json['privilege'] != null) {
      privilege = <Privilege>[];
      json['privilege'].forEach((v) {
        privilege!.add(Privilege.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = roleId;
    data['module_id'] = moduleId;
    data['module_state'] = moduleState;
    data['feature_id'] = featureId;
    data['name'] = name;
    if (privilege != null) {
      data['privilege'] = privilege!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Privilege {
  String? name;
  bool? status;
  int? type;

  Privilege({this.name, this.status, this.type});

  Privilege.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}

class AllAcademicYear {
  String? sId;
  String? year;
  String? status;
  String? startDate;

  AllAcademicYear({this.sId, this.year, this.status, this.startDate});

  AllAcademicYear.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    year = json['year'];
    status = json['status'];
    startDate = json['start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['year'] = year;
    data['status'] = status;
    data['start_date'] = startDate;
    return data;
  }
}
