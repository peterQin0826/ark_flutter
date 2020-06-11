class ProjectModel {
  String project;
  int total;
  List<ConceptLi> conceptLi;

  ProjectModel({this.project, this.total, this.conceptLi});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    project = json['project'];
    total = json['total'];
    if (json['concept_li'] != null) {
      conceptLi = new List<ConceptLi>();
      json['concept_li'].forEach((v) {
        conceptLi.add(new ConceptLi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project'] = this.project;
    data['total'] = this.total;
    if (this.conceptLi != null) {
      data['concept_li'] = this.conceptLi.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConceptLi {
  String conceptName;
  String code;
  String type;
  String parent;
  String project;
  List<String> children;
  int objectsNumber;
  int childrenNumber;

  ConceptLi(
      {this.conceptName,
        this.code,
        this.type,
        this.parent,
        this.project,
        this.children,
        this.objectsNumber,
        this.childrenNumber});

  ConceptLi.fromJson(Map<String, dynamic> json) {
    conceptName = json['concept_name'];
    code = json['code'];
    type = json['type'];
    parent = json['parent'];
    project = json['project'];
    children = json['children'].cast<String>();
    objectsNumber = json['objects_number'];
    childrenNumber = json['children_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concept_name'] = this.conceptName;
    data['code'] = this.code;
    data['type'] = this.type;
    data['parent'] = this.parent;
    data['project'] = this.project;
    data['children'] = this.children;
    data['objects_number'] = this.objectsNumber;
    data['children_number'] = this.childrenNumber;
    return data;
  }
}