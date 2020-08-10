import 'package:ark/bean/basic_detail_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_model.dart';

class DetailModel extends ViewStateModel {
  final String objKey;

  BasicDetailBean _basicDetailBean;

  BasicDetailBean get basicDetailBean => _basicDetailBean;

  DetailModel({this.objKey});

  getBasicInfo() async {
    setBusy();
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.basic_info,
        queryParameters: {"obj_key": objKey, "only_basic": true},
        isList: false, success: (data) {
      _basicDetailBean = BasicDetailBean.fromJson(data);
    });
    setIdle();
  }

  update(String objName) {
    _basicDetailBean.basicDict.objName = objName;
    notifyListeners();
  }

}

