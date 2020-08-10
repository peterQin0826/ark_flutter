
class NumberKeyValueBean{
  String key;
  num value;

  NumberKeyValueBean({this.key,this.value});

  NumberKeyValueBean.fromJson(Map<String, dynamic> json){
    key=json['key'];
    value=json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }

}