class SearchResultBean {
  int rn;
  int pn;
  int total;
  List<SearchResultData> data;

  SearchResultBean({this.rn, this.pn, this.total, this.data});

  SearchResultBean.fromJson(Map<String, dynamic> json) {
    rn = json['rn'];
    pn = json['pn'];
    total = json['total'];
    if (json['data'] != null) {
      data = new List<SearchResultData>();
      json['data'].forEach((v) {
        data.add(new SearchResultData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rn'] = this.rn;
    data['pn'] = this.pn;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchResultData {
  BasicData basicData;

  SearchResultData({this.basicData});

  SearchResultData.fromJson(Map<String, dynamic> json) {
    basicData = json['basic_data'] != null
        ? new BasicData.fromJson(json['basic_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.basicData != null) {
      data['basic_data'] = this.basicData.toJson();
    }
    return data;
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
  bool isSelected=false;

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