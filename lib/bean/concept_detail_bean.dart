class ConceptDetailBean {
  String conceptName;
  String code;
  String aka;
  int objectsNumber;
  String frontType;
  String project;
  String type;
  String image;
  String summary;
  int childrenNumber;
  List<String> children;
  String parent;

  ConceptDetailBean(
      {this.conceptName,
        this.code,
        this.aka,
        this.objectsNumber,
        this.frontType,
        this.project,
        this.type,
        this.image,
        this.summary,
        this.childrenNumber,
        this.children,
        this.parent});

  ConceptDetailBean.fromJson(Map<String, dynamic> json) {
    conceptName = json['concept_name'];
    code = json['code'];
    aka = json['aka'];
    objectsNumber = json['objects_number'];
    frontType = json['front_type'];
    project = json['project'];
    type = json['type'];
    image = json['image'];
    summary = json['summary'];
    childrenNumber = json['children_number'];
    children = json['children'].cast<String>();
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concept_name'] = this.conceptName;
    data['code'] = this.code;
    data['aka'] = this.aka;
    data['objects_number'] = this.objectsNumber;
    data['front_type'] = this.frontType;
    data['project'] = this.project;
    data['type'] = this.type;
    data['image'] = this.image;
    data['summary'] = this.summary;
    data['children_number'] = this.childrenNumber;
    data['children'] = this.children;
    data['parent'] = this.parent;
    return data;
  }
}