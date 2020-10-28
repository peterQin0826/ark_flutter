class CommonPermission {
  String name;
  String code;
  int isChecked;

  CommonPermission({this.name, this.code, this.isChecked});

  CommonPermission.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    isChecked = json['isChecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['isChecked'] = this.isChecked;
    return data;
  }
}