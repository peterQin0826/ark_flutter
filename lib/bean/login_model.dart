class LoginModel {
  String userName;
  String userKey;
  String image;
  String sessionId;

  LoginModel({this.userName, this.userKey, this.image, this.sessionId});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
