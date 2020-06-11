import 'entity_factory.dart';

class BaseListEntity<T>{

  int code;
  String message;
  List<T> data;

  BaseListEntity({this.code, this.message, this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = List();
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }

    return BaseListEntity(
      code: json["code"],
      message: json["msg"],
      data: mData,
    );
  }
}