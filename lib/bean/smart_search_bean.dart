
class SmartSearchBean {
  int pn;
  int rn;
  List<String> data;

  SmartSearchBean({this.pn, this.rn, this.data});

  SmartSearchBean.fromJson(Map<String, dynamic> json) {
    pn = json['pn'];
    rn = json['rn'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pn'] = this.pn;
    data['rn'] = this.rn;
    data['data'] = this.data;
    return data;
  }
}