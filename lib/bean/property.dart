class Property {
  int total;
  String propertyName;
  String ctp;
  Data data;

  Property({this.total, this.propertyName, this.ctp, this.data});

  Property.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    propertyName = json['property_name'];
    ctp = json['ctp'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['property_name'] = this.propertyName;
    data['ctp'] = this.ctp;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String na;
  var pos;
  String ctp;
  String tp;
  String rel;
  int number;
  int ml;
  String stVar;
  int id;

  Data({this.na, this.pos,  this.ctp, this.tp, this.rel, this.number, this.ml, this.stVar, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    na = json['na'];
    pos = json['pos'];

    ctp = json['ctp'];
    tp = json['tp'];
    rel = json['rel'];
    number = json['number'];
    ml = json['ml'];
    stVar = json['st_var'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['na'] = this.na;
    data['pos'] = this.pos;
    data['ctp'] = this.ctp;
    data['tp'] = this.tp;
    data['rel'] = this.rel;
    data['number'] = this.number;
    data['ml'] = this.ml;
    data['st_var'] = this.stVar;
    data['id'] = this.id;
    return data;
  }
}


