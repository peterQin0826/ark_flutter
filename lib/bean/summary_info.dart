import 'dart:collection';

import 'package:ark/bean/property.dart';
import 'package:ark/bean/short_property.dart';

class SummaryInfo {
  ShortProperty shortProperty;
  List<Property> property;
  List<ShortProperty> shortProperties;

  SummaryInfo({this.shortProperty, this.property});

  SummaryInfo.fromJson(Map<String, dynamic> json) {
//    shortProperty = json['short_property'] != null ?ShortProperty.fromJson( shortToJson(json['short_property'])) : null;
    if (json['property'] != null) {
      property = new List<Property>();
      json['property'].forEach((v) {
        property.add(new Property.fromJson(v));
      });
    }
    if (json['short_property'] != null) {
      shortProperties = new List();
      shortToJson(json['short_property']);
    }
  }

  /// 将动态key-value 解析成 固定key-value 的集合
   shortToJson(Map<String, dynamic> json) {
    if (json.length > 0) {
      json.forEach((key, value) {
        ShortProperty shortProperty = new ShortProperty(key: key, value: value);
        shortProperties.add(shortProperty);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shortProperty != null) {
      data['short_property'] = this.shortProperty.toJson();
    }
    if (this.property != null) {
      data['property'] = this.property.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
