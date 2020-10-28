
class User {
  String objKey;
  String username;

  User({this.objKey, this.username});

  User.fromJson(Map<String, dynamic> json) {
    objKey = json['obj_key'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obj_key'] = this.objKey;
    data['username'] = this.username;
    return data;
  }
}