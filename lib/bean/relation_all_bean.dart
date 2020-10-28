import 'package:ark/bean/base_select_entity.dart';

class RelationAllBean {
  List<RelationTabData> data;

  RelationAllBean({this.data});

  RelationAllBean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<RelationTabData>();
      json['data'].forEach((v) {
        data.add(new RelationTabData.fromJson(v));
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

class RelationTabData implements BaseSelectEntity {
//  String conceptCode;
  String conceptName;
  String projectName;
  int number;

  RelationTabData(
      { this.conceptName, this.projectName, this.number});

  RelationTabData.fromJson(Map<String, dynamic> json) {
//    conceptCode = json['concept_code'];
    conceptName = json['concept_name'];
    projectName = json['project_name'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['concept_code'] = this.conceptCode;
    data['concept_name'] = this.conceptName;
    data['project_name'] = this.projectName;
    data['number'] = this.number;
    return data;
  }

  @override
  String getTag() {
    return conceptName + '(' + projectName + ")";
  }
}
