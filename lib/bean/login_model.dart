class LoginModel {
  int status;
  String message;
  ResultObj resultObj;

  LoginModel({this.status, this.message, this.resultObj});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    resultObj = json['resultObj'] != null
        ? new ResultObj.fromJson(json['resultObj'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.resultObj != null) {
      data['resultObj'] = this.resultObj.toJson();
    }
    return data;
  }
}

class ResultObj {
  String userName;
  String userKey;
  String image;
  String sessionId;

  ResultObj({this.userName, this.userKey, this.image, this.sessionId});

  ResultObj.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userKey = json['user_key'];
    image = json['image'];
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_key'] = this.userKey;
    data['image'] = this.image;
    data['session_id'] = this.sessionId;
    return data;
  }
}