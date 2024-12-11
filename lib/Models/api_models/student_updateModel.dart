class StudentUpdateModel {
  int? visitId;
  String? user;
  String? userId;
  String? userToken;

  StudentUpdateModel({this.visitId, this.user, this.userId, this.userToken});

  StudentUpdateModel.fromJson(Map<String, dynamic> json) {
    visitId = json['visit_id'];
    user = json['user'];
    userId = json['user_id'];
    userToken = json['user_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visit_id'] = visitId;
    data['user'] = user;
    data['user_id'] = userId;
    data['user_token'] = userToken;
    return data;
  }

}