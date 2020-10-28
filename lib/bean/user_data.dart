class UserData {
  List<UserBean> data;

  UserData({this.data});

  UserData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<UserBean>();
      json['data'].forEach((v) {
        data.add(new UserBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserBean {
  String username;
  String conceptName;
  String conceptCode;
  String projectName;
  String objKey;
  String phone;
  String email;
  String image;

  UserBean(
      {this.username,
      this.conceptName,
      this.conceptCode,
      this.projectName,
      this.objKey,
      this.phone,
      this.email,
      this.image});

  UserBean.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    conceptName = json['concept_name'];
    conceptCode = json['concept_code'];
    projectName = json['project_name'];
    objKey = json['obj_key'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['concept_name'] = this.conceptName;
    data['concept_code'] = this.conceptCode;
    data['project_name'] = this.projectName;
    data['obj_key'] = this.objKey;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}
