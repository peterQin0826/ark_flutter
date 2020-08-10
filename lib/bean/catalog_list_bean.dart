class CatalogListBean {
    String conceptName;
    String code;
    String type;
    String parent;
    String project;
    List<String> children;
    int objectsNumber;
    int childrenNumber;
    bool isFile;
    List<CatalogListBean> childrenData;

    CatalogListBean(
        {this.conceptName,
            this.code,
            this.type,
            this.parent,
            this.project,
            this.children,
            this.objectsNumber,
            this.childrenNumber,
        this.isFile,
        this.childrenData});

    CatalogListBean.fromJson(Map<String, dynamic> json) {
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