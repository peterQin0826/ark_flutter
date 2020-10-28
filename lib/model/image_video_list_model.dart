import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';
import 'package:ark/service/ark_repository.dart';

class CommonProListModel extends ViewStateRefreshListModel {
  String objKey;
  String proName;

  PropertyListBean _propertyListBean;

  PropertyListBean get propertyListBean => _propertyListBean;

  CommonProListModel(this.objKey, this.proName);

  @override
  Future<List> loadData({int pageNum}) async {
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.propertyPagination,
        queryParameters: {
          'obj_key': objKey,
          'property_name': proName,
          'pn': 1,
          'rn': 100
        },
        isList: false, success: (json) {
      _propertyListBean = PropertyListBean.fromJson(json);
//      print('文本列表：${_propertyListBean.data.dt.length}');
    });
    return _propertyListBean.data.dt;
  }

  /// 列表属性删除单元
  Future<bool> deleteItem(String id_li) async {
    List<Future> futures = List();
    setBusy();
    futures.add(ArkRepository.deleteItem(objKey, proName, id_li));
    await Future.wait(futures);
    setIdle();
    return futures[0];
  }

  /// 列表属性 修改单元

  Future<bool> propertyUnitEdit(String json) async {
    setBusy();
    List<Future> futures = List();
    futures.add(ArkRepository.propertyUnitEdit(objKey, proName, json));
    await Future.wait(futures);
    setIdle();
    return futures[0];
  }

  /// 列表属性 添加单元
  Future<num> propertyUnitAdd(
      String content, String title, String info, num time) async {
    List<Future> futures = List();
    futures.add(ArkRepository.propertyUnitAdd(
        objKey, proName, content, title, info, time));
    await Future.wait(futures);
    return futures[0];
  }

  /// 创建属性
  Future<bool> createListPro(
      String proName, String na, String ctp, String dt) async {
    return await ArkRepository.createListPro(objKey, proName, na, ctp, dt);
  }

  /// 修改属性
  Future<bool> propertyEdit(String na, int pos) async {
    List<Future> futures = List();
    futures.add(ArkRepository.propertyEdit(objKey, proName, na, pos));
    await Future.wait(futures);
    return futures[0];
  }

  /// 动态获取ip
  Future<String> getGroupId(String type, num size) async {
    List<Future> futures = List();
    futures.add(ArkRepository.groupId(type, size));
    await Future.wait(futures);
    return futures[0];
  }

  /// 删除属性
  Future<bool> deletePro() async {
    List<Future> futures = List();
    futures.add(ArkRepository.deleteListPro(objKey, proName));
    await Future.wait(futures);
    return futures[0];
  }
}
