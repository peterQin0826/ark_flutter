class PageBean {
  int pn;
  int rn;

  PageBean({this.pn, this.rn});

  PageBean.fromJson(Map<String, dynamic> json) {
    pn = json['pn'];
    rn = json['rn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pn'] = this.pn;
    data['rn'] = this.rn;
    return data;
  }
}
