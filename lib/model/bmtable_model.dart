import 'package:ark/bean/bmtable_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_list_model.dart';
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';
import 'package:ark/service/ark_repository.dart';

class BmTableModel extends ViewStateRefreshListModel {
  BmTableBean _bmTableBean;

  BmTableBean get bmTableBean => _bmTableBean;

  int rn = 100;
  String objKey;
  String proName;

  BmTableModel({this.objKey, this.proName});

  /// 编辑条目
  Future<bool> editItem(String data) async {
    bool isSuccess;
    setBusy();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_edit,
        params: {'obj_key': objKey, 'property_name': proName, 'data': data},
        isList: false, success: (json) {
      isSuccess = true;
    });
    setIdle();

    return isSuccess;
  }

  /// 删除条目
  Future<bool> deleteItem(String keys) async {
    bool isSuccess;
    setBusy();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_remove,
        params: {'obj_key': objKey, 'property_name': proName, 'key_li': keys},
        isList: false, success: (json) {
      isSuccess = true;
    });
    setIdle();
    return isSuccess;
  }

  /// 删除bmtable 属性
  Future<bool> deletePro() async {
    bool isSuccess;
    setBusy();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_delete,
        params: {'obj_key': objKey, 'property_name': proName}, success: (json) {
      isSuccess = true;
    });
    setIdle();
    return isSuccess;
  }

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = List();

    List<ShortProperty> _bmDatas = List();
    futures.add(DioUtils.instance.request(HttpMethod.GET, HttpApi.bmtable,
        queryParameters: {
          'obj_key': objKey,
          'property_name': proName,
          'pn': 1,
          'rn': rn
        },
        isList: false, success: (json) {
      Map<String, dynamic> map = json['dt'];
      if (null != map) {
        if (map.length > 0) {
          map.forEach((key, value) {
            ShortProperty shortProperty = new ShortProperty();
            shortProperty.key = key;
            shortProperty.value = value.toString();
            _bmDatas.add(shortProperty);
          });
        }
      }
      _bmTableBean = BmTableBean.fromJson(json);
      _bmTableBean.bmDatas = _bmDatas;
      print('验证数据 ${_bmTableBean.bmDatas.length}');
    }));
    var result = await Future.wait(futures);
    _bmTableBean = result[0];
    return _bmDatas;
  }

  /// 编辑属性
  Future<bool> bmTableEditPro(String na, int pos) async {
    return await ArkRepository.bmTableEditPro(objKey, proName, na, pos);
  }
}
