import 'package:ark/bean/property.dart';
import 'package:ark/bean/short_property.dart';

class BmTableBean {
  String na;
  String tp;
  var pos;
  String ctp;
  String key;
  String rel;
  int number;
  String propertyName;
  int pn;
  int rn;
  int total;

  List<ShortProperty> bmDatas;

//  List<ShortProperty> get bmDatas => _bmDatas;

  BmTableBean(
      {this.na,
      this.tp,
      this.pos,
      this.ctp,
      this.key,
      this.rel,
      this.number,
      this.propertyName,
      this.pn,
      this.rn,
      this.total});

  BmTableBean.fromJson(Map<String, dynamic> json) {
    na = json['na'];
    tp = json['tp'];
    pos = json['pos'];
    ctp = json['ctp'];
    key = json['key'];
    rel = json['rel'];
    number = json['number'];
    propertyName = json['property_name'];
    pn = json['pn'];
    rn = json['rn'];
    total = json['total'];
    if (null != json['dt']) {
      bmDatas = List();
      packageBmDatas(json['dt']);
    }
  }

  packageBmDatas(Map<String, dynamic> map) {
    if (map.length > 0) {
      map.forEach((key, value) {
        ShortProperty shortProperty = new ShortProperty();
        shortProperty.key = key;
        shortProperty.value = value.toString();
        bmDatas.add(shortProperty);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['na'] = this.na;
    data['tp'] = this.tp;
    data['pos'] = this.pos;
    data['ctp'] = this.ctp;
    data['key'] = this.key;
    data['rel'] = this.rel;
    data['number'] = this.number;
    data['property_name'] = this.propertyName;
    data['pn'] = this.pn;
    data['rn'] = this.rn;
    data['total'] = this.total;
    return data;
  }
}
