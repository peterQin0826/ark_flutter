import 'dart:convert';

import 'package:ark/bean/bftable_bean.dart';
import 'package:ark/bean/bmtable_bean.dart';
import 'package:ark/bean/object_list_bean.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/summary_info.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:flutter/foundation.dart';

class ArkRepository {
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
}
