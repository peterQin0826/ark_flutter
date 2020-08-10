import 'number_key_value_bean.dart';

class BfTableBean {
  String na;
  var pos;
  String ctp;
  String key;
  String tp;
  String rel;
  int number;
  String propertyName;
  int pn;
  int rn;
  int total;
  List<NumberKeyValueBean> bfDatas;

  BfTableBean(
      {this.na,
      this.pos,
      this.ctp,
      this.key,
      this.tp,
      this.rel,
      this.number,
      this.propertyName,
      this.pn,
      this.rn,
      this.total});

  BfTableBean.fromJson(Map<String, dynamic> json) {
    na = json['na'];
    pos = json['pos'];
    ctp = json['ctp'];
    key = json['key'];
    tp = json['tp'];
    rel = json['rel'];
    number = json['number'];
    propertyName = json['property_name'];
    pn = json['pn'];
    rn = json['rn'];
    total = json['total'];
    if (null != json['dt']) {
      bfDatas = List();
      packageBmDatas(json['dt']);
    }
  }

  packageBmDatas(Map<String, dynamic> map) {
    if (map.length > 0) {
      map.forEach((key, value) {
        NumberKeyValueBean shortProperty = new NumberKeyValueBean();
        shortProperty.key = key;
        shortProperty.value = value;
        bfDatas.add(shortProperty);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['na'] = this.na;
    data['pos'] = this.pos;
    data['ctp'] = this.ctp;
    data['key'] = this.key;
    data['tp'] = this.tp;
    data['rel'] = this.rel;
    data['number'] = this.number;
    data['property_name'] = this.propertyName;
    data['pn'] = this.pn;
    data['rn'] = this.rn;
    data['total'] = this.total;
    return data;
  }
}
