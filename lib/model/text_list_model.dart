import 'dart:convert';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';
import 'package:ark/service/ark_repository.dart';

class TextListModel extends ViewStateRefreshListModel {
  String obj_key;
  String property_name;

  PropertyListBean _propertyListBean;

  PropertyListBean get propertyListBean => _propertyListBean;

  TextListModel(this.obj_key, this.property_name);

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> list = List();
    list.add(DioUtils.instance.request(
        HttpMethod.GET, HttpApi.propertyPagination,
        queryParameters: {
          'obj_key': obj_key,
          'property_name': property_name,
          'pn': 1,
          'rn': 100
        },
        isList: false, success: (json) {
      _propertyListBean = PropertyListBean.fromJson(json);

      print('文本列表：${_propertyListBean.data.dt.length}');
    }));
    await Future.wait(list);
    return _propertyListBean.data.dt;
  }

  /// 列表属性删除单元
  Future<bool> deleteItem(String id_li) async {
    List<Future> futures = List();
    setBusy();
    futures.add(ArkRepository.deleteItem(obj_key, property_name, id_li));
    await Future.wait(futures);
    setIdle();
    return futures[0];
  }

  /// 列表属性 修改单元

  Future<bool> propertyUnitEdit(String json) async {
    setBusy();
    List<Future> futures = List();
    futures.add(ArkRepository.propertyUnitEdit(obj_key, property_name, json));
    await Future.wait(futures);
    setIdle();
    return futures[0];
  }

  /// 列表属性 添加单元
  Future<num> propertyUnitAdd(
      String content, String title, String info, num time) async {
    List<Future> futures = List();
    futures.add(ArkRepository.propertyUnitAdd(
        obj_key, property_name, content, title, info, time));
    await Future.wait(futures);
    return futures[0];
  }

  /// 创建属性
  Future<bool> createListPro(
      String proName, String na, String ctp, String dt) async {
    List<Future> list = List();
    list.add(ArkRepository.createListPro(obj_key, proName, na, ctp, dt));
    await Future.wait(list);
    return list[0];
  }

  /// 修改属性
  Future<bool> propertyEdit(String na, int pos) async {
    List<Future> futures = List();
    futures.add(ArkRepository.propertyEdit(obj_key, property_name, na, pos));
    await Future.wait(futures);
    return futures[0];
  }

  Future<bool> deletePro() async {
    List<Future> futures = List();
    futures.add(ArkRepository.deletePro(obj_key, property_name));
    await Future.wait(futures);
    return futures[0];
  }
}
