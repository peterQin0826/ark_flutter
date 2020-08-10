class BasicDetailBean {
  BasicDict basicDict;

  BasicDetailBean({this.basicDict});

  BasicDetailBean.fromJson(Map<String, dynamic> json) {
    basicDict = json['basic_dict'] != null
        ? new BasicDict.fromJson(json['basic_dict'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.basicDict != null) {
      data['basic_dict'] = this.basicDict.toJson();
    }
    return data;
  }
}

class BasicDict {
  String objKey;
  String conceptName;
  String conceptCode;
  String projectName;
  String objName;
  String aka;
  String image;
  String summary;
  String video;
  String audio;
  String ctime;
  String mtime;
  String updateTime;

  BasicDict(
      {this.objKey,
        this.conceptName,
        this.conceptCode,
        this.projectName,
        this.objName,
        this.aka,
        this.image,
        this.summary,
        this.video,
        this.audio,
        this.ctime,
        this.mtime,
        this.updateTime});

  BasicDict.fromJson(Map<String, dynamic> json) {
    objKey = json['obj_key'];
    conceptName = json['concept_name'];
    conceptCode = json['concept_code'];
    projectName = json['project_name'];
    objName = json['obj_name'];
    aka = json['aka'];
    image = json['image'];
    summary = json['summary'];
    video = json['video'];
    audio = json['audio'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obj_key'] = this.objKey;
    data['concept_name'] = this.conceptName;
    data['concept_code'] = this.conceptCode;
    data['project_name'] = this.projectName;
    data['obj_name'] = this.objName;
    data['aka'] = this.aka;
    data['image'] = this.image;
    data['summary'] = this.summary;
    data['video'] = this.video;
    data['audio'] = this.audio;
    data['ctime'] = this.ctime;
    data['mtime'] = this.mtime;
    data['update_time'] = this.updateTime;
    return data;
  }
}