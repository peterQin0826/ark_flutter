import 'dart:convert';

import 'package:ark/bean/bftable_bean.dart';
import 'package:ark/bean/bmtable_bean.dart';
import 'package:ark/bean/concept_detail_bean.dart';
import 'package:ark/bean/object_list_bean.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/summary_info.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';

class ArkRepository {
  static Future<ConceptDetailBean> getConceptDetail(String code) async {
    ConceptDetailBean conceptDetailBean;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.concept_detail,
        params: {"concept_code": code}, isList: false, success: (json) {
      conceptDetailBean = ConceptDetailBean.fromJson(json);
    });
    return conceptDetailBean;
  }

  /// 对象列表
  static Future<ObjectListBean> getObjectList(
      String code, int pn, int rn) async {
    ObjectListBean objectListBean;
    await DioUtils.instance
        .request(HttpMethod.GET, HttpApi.object_list, queryParameters: {
      "concept_code": code,
      "rn": rn,
      "pn": pn,
    }, success: (data) {
      objectListBean = ObjectListBean.fromJson(data);
    });

    return objectListBean;
  }

  ///获取bmtable 的 数据
  static Future<PropertyListBean> getBmtable(
      String objKey, String proName, int rn) async {
    PropertyListBean propertyListBean = new PropertyListBean();
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.bmtable,
        queryParameters: {
          'obj_key': objKey,
          'property_name': proName,
          'pn': 1,
          'rn': rn
        }, success: (json) {
      BmTableBean bmTableBean = BmTableBean.fromJson(json);
      propertyListBean.bmTableBean = bmTableBean;
      PropertyListData data = new PropertyListData();
      data.pos = bmTableBean.pos;
      propertyListBean.data = data;
    });
    return propertyListBean;
  }

  /// 获取bftable 的数据
  static Future<PropertyListBean> getBftable(
      String objKey, String proName, int rn) async {
    PropertyListBean propertyListBean = new PropertyListBean();

    await DioUtils.instance.request(HttpMethod.GET, HttpApi.bftable,
        queryParameters: {
          'obj_key': objKey,
          'property_name': proName,
          'pn': 1,
          'rn': rn
        }, success: (json) {
      BfTableBean bfTableBean = BfTableBean.fromJson(json);
      propertyListBean.bfTableBean = bfTableBean;
      PropertyListData propertyListData = new PropertyListData();
      propertyListData.pos = bfTableBean.pos;
      propertyListBean.data = propertyListData;
    });
    return propertyListBean;
  }

  static Future<bool> editBfPro(
      String objkey, String proName, String na, int pos) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bftable_edit_pro,
        isList: false,
        params: {
          'obj_key': objkey,
          'property_name': proName,
          'na': na,
          'pos': pos
        }, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 获取详情页的摘要信息
  static Future<SummaryInfo> getSummary(
      String objKey, String conceptName) async {
    SummaryInfo summaryInfo;

    await DioUtils.instance.request(HttpMethod.GET, HttpApi.summary_info,
        queryParameters: {"obj_key": objKey, "concept_name": conceptName},
        isList: false, success: (json) {
      summaryInfo = SummaryInfo.fromJson(json);
    });

    return summaryInfo;
  }

  /// 获取对象的列表属性信息

  static Future<PropertyListBean> getProListData(
      String objKey, String proName, int rn) async {
    PropertyListBean propertyListBean;
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.list_pro,
        queryParameters: {
          'obj_key': objKey,
          'property_name': proName,
          'rn': rn,
          'pn': 1
        }, success: (json) {
      propertyListBean = PropertyListBean.fromJson(json);
    });

    return propertyListBean;
  }

  /// 创建列表属性
  static Future<bool> createListPro(
      String objKey, String proName, String na, String ctp, String dt) async {
    bool isSuccess = false;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.property_add,
        params: {
          'obj_key': objKey,
          'property_name': proName,
          'na': na,
          'ctp': ctp,
          'dt': dt,
        },
        isList: false, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 修改列表属性
  static Future<bool> propertyEdit(
      String objKey, String proName, String na, int pos) async {
    bool isSuccess = false;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.property_edit,
        params: {
          'obj_key': objKey,
          'property_name': proName,
          'na': na,
          'pos': pos
        },
        isList: false, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 删除列表属性的 单元
  static Future<bool> deleteItem(
      String objKey, String proName, String id_li) async {
    bool isSuccess = false;
    await DioUtils.instance.request(
        HttpMethod.POST, HttpApi.property_unit_delete,
        params: {'obj_key': objKey, 'property_name': proName, 'id_li': id_li},
        isList: false, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 列表属性 修改单元
  static Future<bool> propertyUnitEdit(
      String objKey, String proName, String json) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.property_unit_edit,
        params: {'obj_key': objKey, 'property_name': proName, 'dt': json},
        isList: false, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 列表属性 添加单元
  static Future<num> propertyUnitAdd(String objKey, String proName,
      String content, String title, String info, num time) async {
    int nid;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.property_unit_add,
        params: {
          'obj_key': objKey,
          'property_name': proName,
          'content': content,
          'title': title,
          'info': info,
          'time': time
        },
        isList: false, success: (json) {
      nid = json['nid'];
    });
    return nid;
  }

  /// 删除bmtable 属性
  static Future<bool> deletePro(String objKey, String proName) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_delete,
        params: {'obj_key': objKey, 'property_name': proName}, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  static Future<String> groupId(String type, num size) async {
    String domain;
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.group_id,
        queryParameters: {
          'group_id': SpUtil.getString(SpConstants.user_key, defValue: ''),
          'file_type': type,
          'file_number': 1,
          'file_size': size
        },
        isList: false, success: (json) {
      domain = json['domain'];
    });
    return domain;
  }

  static Future<bool> bmTableEditPro(
      String objKey, String proName, String na, int pos) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_pro_edit,
        isList: false,
        params: {
          'obj_key': objKey,
          'property_name': proName,
          'na': na,
          'pos': pos
        }, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }
}
