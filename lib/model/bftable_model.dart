import 'package:ark/bean/bftable_bean.dart';
import 'package:ark/bean/number_key_value_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';
import 'package:ark/service/ark_repository.dart';

class BfTableModel extends ViewStateRefreshListModel {
  int rn = 100;
  String objKey;
  String proName;
  BfTableBean _bfTableBean;

  BfTableBean get bfTableBean => _bfTableBean;

  BfTableModel(this.objKey, this.proName);

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = List();
    List<NumberKeyValueBean> bfDatas = List();
    futures.add(DioUtils.instance.request(HttpMethod.GET, HttpApi.bftable,
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
            NumberKeyValueBean bftableData = new NumberKeyValueBean();
            bftableData.key = key;
            bftableData.value = value;
            bfDatas.add(bftableData);
          });
        }
      }

      _bfTableBean = BfTableBean.fromJson(json);
      _bfTableBean.bfDatas = bfDatas;
    }));
    var result = await Future.wait(futures);
    return _bfTableBean.bfDatas;
  }

  Future<bool> editItem(String data) async {
    bool isSuccess;
    setBusy();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bftable_Add,
        params: {'obj_key': objKey, 'property_name': proName, 'data': data},
        isList: false, success: (json) {
      isSuccess = true;
    });
    setIdle();
    return isSuccess;
  }

  Future<bool> deleteItem(String key_li) async {
    bool isSuccess;
    setBusy();

    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bftable_remove,
        isList: false,
        params: {'obj_key': objKey, 'property_name': proName, 'key_li': key_li},
        success: (json) {
      isSuccess = true;
    });
    setIdle();
    return isSuccess;
  }

  Future<bool> deletePro() async {
    bool isSuccess;
    setBusy();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bftable_delete,
        isList: false,
        params: {'obj_key': objKey, 'property_name': proName}, success: (json) {
      isSuccess = true;
    });
    setIdle();
    return isSuccess;
  }


}
