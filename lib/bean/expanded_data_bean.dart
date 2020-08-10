
class ExpandedDataBean {
  String objKey;
  String objName;
  String conceptName;
  String conceptCode;
  String aka;
  String image;
  String video;
  String audio;
  String summary;
  String projectName;

  ExpandedDataBean(
      {this.objKey,
        this.objName,
        this.conceptName,
        this.conceptCode,
        this.aka,
        this.image,
        this.video,
        this.audio,
        this.summary,
        this.projectName});

  ExpandedDataBean.fromJson(Map<String, dynamic> json) {
    objKey = json['obj_key'];
    objName = json['obj_name'];
    conceptName = json['concept_name'];
    conceptCode = json['concept_code'];
    aka = json['aka'];
    image = json['image'];
    video = json['video'];
    audio = json['audio'];
    summary = json['summary'];
    projectName = json['project_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obj_key'] = this.objKey;
    data['obj_name'] = this.objName;
    data['concept_name'] = this.conceptName;
    data['concept_code'] = this.conceptCode;
    data['aka'] = this.aka;
    data['image'] = this.image;
    data['video'] = this.video;
    data['audio'] = this.audio;
    data['summary'] = this.summary;
    data['project_name'] = this.projectName;
    return data;
  }
}