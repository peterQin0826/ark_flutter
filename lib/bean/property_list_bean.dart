import 'package:ark/bean/bftable_bean.dart';
import 'package:ark/bean/bmtable_bean.dart';
import 'package:ark/bean/expanded_data_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/utils/utils.dart';

class PropertyListBean {
  String propertyName;
  PropertyListData data;
  int pn;
  int rn;
  int total;
  BmTableBean bmTableBean;
  BfTableBean bfTableBean;
  int itemType;
  List<ShortProperty> shortProperties;

  PropertyListBean(
      {this.propertyName, this.data, this.pn, this.rn, this.total});

  PropertyListBean.fromJson(Map<String, dynamic> json) {
    propertyName = json['property_name'];
    data = json['data'] != null
        ? new PropertyListData.fromJson(json['data'])
        : null;
    pn = json['pn'];
    rn = json['rn'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_name'] = this.propertyName;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['pn'] = this.pn;
    data['rn'] = this.rn;
    data['total'] = this.total;
    return data;
  }
}

class PropertyListData {
  String na;
  List<Dt> dt;
  var pos;
  String rel;
  String ctp;
  String tp;
  int ml;
  String stVar;
  int id;

  PropertyListData(
      {this.na,
      this.dt,
      this.pos,
      this.rel,
      this.ctp,
      this.tp,
      this.ml,
      this.stVar,
      this.id});

  PropertyListData.fromJson(Map<String, dynamic> json) {
    na = json['na'];
    if (json['dt'] != null) {
      dt = new List<Dt>();
      json['dt'].forEach((v) {
        dt.add(new Dt.fromJson(v));
      });
    }
    pos = json['pos'];
    rel = json['rel'];
    ctp = json['ctp'];
    tp = json['tp'];
    ml = json['ml'];
    stVar = json['st_var'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['na'] = this.na;
    if (this.dt != null) {
      data['dt'] = this.dt.map((v) => v.toJson()).toList();
    }
    data['pos'] = this.pos;
    data['rel'] = this.rel;
    data['ctp'] = this.ctp;
    data['tp'] = this.tp;
    data['ml'] = this.ml;
    data['st_var'] = this.stVar;
    data['id'] = this.id;
    return data;
  }
}

class Dt {
  String content;
  String title;
  String info;
  int time;
  int id ;
  ExpandedDataBean expandedDataBean;

  List<ShortProperty> infos;

  Dt({this.content, this.title='', this.info, this.time, this.id=0});

  Dt.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    title = json['title'];
    info = json['info'];
    time = json['time'];
    id = json['id'];
    expandedDataBean=json['expanded_data']!=null?ExpandedDataBean.fromJson(json['expanded_data']):null;
    if (null != json['info']) {
      infos = List();
      try{
        packageInfos(Utils.parseData(json['info']));
      }catch(e){
        e.toString();
      }

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['title'] = this.title;
    data['info'] = this.info;
    data['time'] = this.time;
    data['id'] = this.id;
    return data;
  }

  packageInfos(Map<String, dynamic> map) {
    if (map.length > 0) {
      map.forEach((key, value) {
        ShortProperty shortProperty = new ShortProperty();
        shortProperty.key = key;
        shortProperty.value = value;
        infos.add(shortProperty);
      });
    }
  }
}
