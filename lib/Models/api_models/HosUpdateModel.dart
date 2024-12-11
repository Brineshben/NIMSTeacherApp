class HosUpdateModel {
  int? id;
  String? visitStatus;
  String? sentBy;
  String? sentById;

  HosUpdateModel({this.id, this.visitStatus, this.sentBy, this.sentById});

  HosUpdateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitStatus = json['visit_status'];
    sentBy = json['sent_by'];
    sentById = json['sent_by_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_status'] = visitStatus;
    data['sent_by'] = sentBy;
    data['sent_by_id'] = sentById;
    return data;
  }
}