import 'dart:convert';

import 'package:ark/bean/short_property.dart';
import 'package:ark/utils/utils.dart';

class ConceptRelationList {
  String type;
  List<Data> data;

  ConceptRelationList({this.type, this.data});

  ConceptRelationList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['data'] != null) {
      data = new List<Data>();
      if (json['data'] is List) {
        json['data'].forEach((v) {
          data.add(new Data.fromJson(v));
        });
      } else {
        print('==不是列表结构');
        data.add(Data.fromJson(json['data']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int total;
  String targetConceptName;
  String targetProjectName;
  List<Group> group;

  Data(
      {this.total, this.targetConceptName, this.targetProjectName, this.group});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json.containsKey('target_concept_name'))
      targetConceptName = json['target_concept_name'];
    if (json.containsKey('target_project_name'))
      targetProjectName = json['target_project_name'];
    if (json['group'] != null) {
      group = new List<Group>();
      json['group'].forEach((v) {
        group.add(new Group.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['target_concept_name'] = this.targetConceptName;
    data['target_project_name'] = this.targetProjectName;
    if (this.group != null) {
      data['group'] = this.group.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Group {
  int relNumber;
  List<Objects> objects;
  int total;
  int pn;
  int rn;

  Group({this.relNumber, this.objects, this.total, this.pn, this.rn});

  Group.fromJson(Map<String, dynamic> json) {
    relNumber = json['rel_number'];
    if (json['objects'] != null) {
      objects = new List<Objects>();
      json['objects'].forEach((v) {
        objects.add(new Objects.fromJson(v));
      });
    }
    total = json['total'];
    pn = json['pn'];
    rn = json['rn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel_number'] = this.relNumber;
    if (this.objects != null) {
      data['objects'] = this.objects.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['pn'] = this.pn;
    data['rn'] = this.rn;
    return data;
  }
}

class Objects {
  BasicData basicData;
  RelatedData relatedData;

//  ShortData shortData;
//  ShortProperty labelData;

  List<ShortProperty> labels;

  Objects({this.basicData, this.relatedData});

  Objects.fromJson(Map<String, dynamic> json) {
    basicData = json['basic_data'] != null
        ? new BasicData.fromJson(json['basic_data'])
        : null;
    relatedData = json['related_data'] != null
        ? new RelatedData.fromJson(json['related_data'])
        : null;
//    shortData = json['short_data'] != null ? new ShortData.fromJson(json['short_data']) : null;
//    labelData = json['label_data'] != null ? new ShortProperty.fromJson(json['label_data']) : null;

    if (null != json['label_data']) {
      labels = List();
      try {
        packageLabels(json['label_data']);
      } catch (e) {
        e.toString();
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.basicData != null) {
      data['basic_data'] = this.basicData.toJson();
    }
    if (this.relatedData != null) {
      data['related_data'] = this.relatedData.toJson();
    }
//    if (this.shortData != null) {
//      data['short_data'] = this.shortData.toJson();
//    }
//    if (this.labelData != null) {
//      data['label_data'] = this.labelData.toJson();
//    }
    return data;
  }

   packageLabels(Map<String, dynamic> map) {
     print('组装标签---》${json.encode(map)}');
    if (map != null && map.length > 0) {
      map.forEach((key, value) {
        ShortProperty shortProperty = new ShortProperty();
        shortProperty.key = key;
        shortProperty.value = value;
        labels.add(shortProperty);
      });
    }

  }
}

class BasicData {
  String objName;
  String objKey;
  String conceptName;
  String conceptCode;
  String projectName;
  String image;
  String aka;
  String summary;
  String ctime;
  String mtime;
  String updateTime;

  BasicData(
      {this.objName,
      this.objKey,
      this.conceptName,
      this.conceptCode,
      this.projectName,
      this.image,
      this.aka,
      this.summary,
      this.ctime,
      this.mtime,
      this.updateTime});

  BasicData.fromJson(Map<String, dynamic> json) {
    objName = json['obj_name'];
    objKey = json['obj_key'];
    conceptName = json['concept_name'];
    conceptCode = json['concept_code'];
    projectName = json['project_name'];
    image = json['image'];
    aka = json['aka'];
    summary = json['summary'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obj_name'] = this.objName;
    data['obj_key'] = this.objKey;
    data['concept_name'] = this.conceptName;
    data['concept_code'] = this.conceptCode;
    data['project_name'] = this.projectName;
    data['image'] = this.image;
    data['aka'] = this.aka;
    data['summary'] = this.summary;
    data['ctime'] = this.ctime;
    data['mtime'] = this.mtime;
    data['update_time'] = this.updateTime;
    return data;
  }
}

class RelatedData {
  int relNumber;
  int score;

  RelatedData({this.relNumber, this.score});

  RelatedData.fromJson(Map<String, dynamic> json) {
    relNumber = json['rel_number'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel_number'] = this.relNumber;
    data['score'] = this.score;
    return data;
  }
}
