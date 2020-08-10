class ObjectListBean {
  int count;
  int rn;
  int pn;
  int numPages;
  List<Data> data;
  String conceptName;
  String code;
  String cpath;

  ObjectListBean(
      {this.count,
        this.rn,
        this.pn,
        this.numPages,
        this.data,
        this.conceptName,
        this.code,
        this.cpath});

  ObjectListBean.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rn = json['rn'];
    pn = json['pn'];
    numPages = json['num_pages'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    conceptName = json['concept_name'];
    code = json['code'];
    cpath = json['cpath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['rn'] = this.rn;
    data['pn'] = this.pn;
    data['num_pages'] = this.numPages;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['concept_name'] = this.conceptName;
    data['code'] = this.code;
    data['cpath'] = this.cpath;
    return data;
  }
}

class Data {
  String conceptCode;
  String conceptName;
  String projectName;
  String objName;
  String objKey;
  String aka;
  String summary;
  String image;
  String video;
  String audio;
  String ctime;
  String mtime;
  String updateTime;

  Data(
      {this.conceptCode,
        this.conceptName,
        this.projectName,
        this.objName,
        this.objKey,
        this.aka,
        this.summary,
        this.image,
        this.video,
        this.audio,
        this.ctime,
        this.mtime,
        this.updateTime});

  Data.fromJson(Map<String, dynamic> json) {
    conceptCode = json['concept_code'];
    conceptName = json['concept_name'];
    projectName = json['project_name'];
    objName = json['obj_name'];
    objKey = json['obj_key'];
    aka = json['aka'];
    summary = json['summary'];
    image = json['image'];
    video = json['video'];
    audio = json['audio'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concept_code'] = this.conceptCode;
    data['concept_name'] = this.conceptName;
    data['project_name'] = this.projectName;
    data['obj_name'] = this.objName;
    data['obj_key'] = this.objKey;
    data['aka'] = this.aka;
    data['summary'] = this.summary;
    data['image'] = this.image;
    data['video'] = this.video;
    data['audio'] = this.audio;
    data['ctime'] = this.ctime;
    data['mtime'] = this.mtime;
    data['update_time'] = this.updateTime;
    return data;
  }
}