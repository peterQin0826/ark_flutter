import 'dart:convert';

import 'package:ark/bean/catalog_list_bean.dart';
import 'package:ark/bean/conceptRelationList.dart';
import 'package:ark/bean/bftable_bean.dart';
import 'package:ark/bean/bmtable_bean.dart';
import 'package:ark/bean/concept_detail_bean.dart';
import 'package:ark/bean/object_list_bean.dart';
import 'package:ark/bean/project_model.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/relation_all_bean.dart';
import 'package:ark/bean/summary_info.dart';
import 'package:ark/bean/user.dart';
import 'package:ark/bean/user_data.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/utils/string_utils.dart';
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

  static Future<bool> createBfPro(
      String obj_key, String property_name, String na, String data) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bftable_create,
        params: {
          'obj_key': obj_key,
          'property_name': property_name,
          'na': na,
          'data': data
        },
        isList: false, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  static Future<bool> createBmPro(
      String obj_key, String property_name, String na, String data) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_create,
        params: {
          'obj_key': obj_key,
          'property_name': property_name,
          'na': na,
          'data': data,
          'tp': 'txt'
        },
        isList: false, success: (json) {
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
      String objKey, String proName, String na, String tp, String dt) async {
    bool isSuccess = false;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.property_add,
        params: {
          'obj_key': objKey,
          'property_name': proName,
          'na': na,
          'ctp': 'list',
          'tp': tp,
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
  static Future<bool> deleteBmTablePro(String objKey, String proName) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.bmtable_delete,
        params: {'obj_key': objKey, 'property_name': proName}, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 删除bmtable 属性
  static Future<bool> deleteListPro(String objKey, String proName) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.propertyDelete,
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

  static Future<RelationAllBean> getAllRelation(String objKey) async {
    RelationAllBean allBean;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.relatedConcept,
        params: {'obj_key': objKey}, isList: false, success: (json) {
      allBean = RelationAllBean.fromJson(json);
    });
    return allBean;
  }

  static Future<ConceptRelationList> objectRelated(
      String objKey,
      String target_concepts,
      String type,
      String page_rules,
      bool hasLabel) async {
    ConceptRelationList conceptRelationList;
    await DioUtils.instance
        .request(HttpMethod.POST, HttpApi.objectRelated, params: {
      'obj_key': objKey,
      'target_concepts': target_concepts,
      'groupby_rule': type,
      'page_rules': page_rules,
      'has_label': hasLabel
    }, success: (json) {
      conceptRelationList = ConceptRelationList.fromJson(json);
    });
    return conceptRelationList;
  }

  static Future<bool> relationLabelAdd(
      String objKey, String target_obj, String data) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.relationLabelAdd,
        params: {'source_obj': objKey, 'target_obj': target_obj, 'data': data},
        success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  static Future<bool> removeRelationLabel(
      String source_obj, String target_obj, String keys) async {
    bool isSuccess;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.relLabelRemove,
        params: {
          'source_obj': source_obj,
          'target_obj': target_obj,
          'keys': keys
        }, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 创建关联
  static Future<bool> createRelation(
      String source_obj_name, String target_obj_name,
      {bool create_mode,
      String target_concept_name,
      int rel_number,
      int score,
      String data}) async {
    bool isSuccess;
    Map<String, dynamic> map = Map();
    map['source_obj_name'] = source_obj_name;
    map['target_obj_name'] = target_obj_name;
    if (StringUtils.isNotEmpty(target_concept_name)) {
      map['target_concept_name'] = target_concept_name;
    }
    if (rel_number > 0) {
      map['rel_number'] = rel_number;
    }
    if (score > 0) {
      map['score'] = score;
    }
    map['create_mode'] = create_mode;
    if (StringUtils.isNotEmpty(data)) {
      map['data'] = data;
    }

    await DioUtils.instance.request(HttpMethod.POST, HttpApi.relationCreate,
        params: map, success: (json) {
      isSuccess = true;
    });

    return isSuccess;
  }

  /// 添加关联
  static Future<bool> relationAdd(
      String source_obj, String target_obj, bool create_mode,
      {int rel_number, int score, String data}) async {
    bool isSuccess;
    Map<String, dynamic> map = Map();
    map['source_obj'] = source_obj;
    map['target_obj'] = target_obj;
    if (rel_number > 0) {
      map['rel_number'] = rel_number;
    }
    if (score > 0) {
      map['score'] = score;
    }
    map['create_mode'] = create_mode;
    if (StringUtils.isNotEmpty(data)) {
      map['data'] = data;
    }

    await DioUtils.instance.request(HttpMethod.POST, HttpApi.relationAdd,
        params: map, success: (json) {
      isSuccess = true;
    });
    return isSuccess;
  }

  /// 获取已创建用户列表
  static Future<UserData> getExistingUsers() async {
    UserData data;
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.existingUsers,
        success: (json) {
      return data = UserData.fromJson(json);
    });
    return data;
  }

  ///项目权限查看
  static Future<Map<String, dynamic>> getPermissionProjectList(
      String user_key, String concept_code) async {
    Map<String, dynamic> map;
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.permissionProject,
        queryParameters: {'user_key': user_key, 'concept_code': concept_code},
        success: (json) {
      map = json;
    });
    return map;
  }

  /// 目录层级接口
  static Future<List<ConceptLi>> getCatalog(String proName) async {
    List<ConceptLi> catalogs = List();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.project_catalog,
        params: {"project": proName, "target_concept": "", "layers": "all"},
        isList: true, successList: (data) {
      data.forEach((json) {
        catalogs.add(ConceptLi.fromJson(json));
      });
    });
    return catalogs;
  }

  /// 创建用户
  static Future<User> createUser(Map<String, dynamic> map) async {
    User user;
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.createUser,
        params: map, success: (json) {
      user = User.fromJson(json);
    });
    return user;
  }
}
