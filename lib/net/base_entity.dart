


// import '../entity_factory.dart';

import 'package:ark/bean/coin_market_model.dart';
import 'package:ark/common/common.dart';

class BaseEntity<T>{

  int status;
  String message;
  T resultObj;
  List<T> listData = [];

  BaseEntity(this.status, this.message, this.resultObj);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    status = json[Constant.code];
    message = json[Constant.message];
    if (json.containsKey(Constant.data)) {
      if (json[Constant.data] is List) {
        (json[Constant.data] as List).forEach((item) {
          listData.add(_generateOBJ<T>(item));
        });
      } else {
        resultObj = _generateOBJ(json[Constant.data]);
      }
    }
  }


  S _generateOBJ<S>(json) {
    if (S.toString() == 'String') {
      print(1);
      return json.toString() as S;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      print(2);
      return json as S;
    } else {
      print(3);
      return CoinMarketModel.fromJson(json) as S;
    }
  }
}