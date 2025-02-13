class UpdateModel {
  Status? status;
  Data? data;
 
  UpdateModel({this.status, this.data});
 
  UpdateModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
 
class Data {
  String? message;
  Details? details;
 
  Data({this.message, this.details});
 
  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}
 
class Details {
  Response? response;
 
  Details({this.response});
 
  Details.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}
 
class Response {
  String? appName;
  bool? showPopup;
  String? date;
  String? url;
 
  Response({this.appName, this.showPopup, this.date, this.url});
 
  Response.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    showPopup = json['show_popup'];
    date = json['date'];
    url = json['url'];
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['show_popup'] = this.showPopup;
    data['date'] = this.date;
    data['url'] = this.url;
    return data;
  }
}