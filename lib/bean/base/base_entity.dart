import 'package:ark/bean/base/entity_factory.dart';

class BaseEntity<T> {
  int code;
  String message;
  T data;

  BaseEntity({this.code, this.message, this.data});

  factory BaseEntity.fromJson(json) {
    print('数据基类：${json["data"]}');
    return BaseEntity(
      code: json["code"],
      message: json["message"],
      // data值需要经过工厂转换为我们传进来的类型
      data: EntityFactory.generateOBJ<T>(json["data"]),
    );
  }
}
