import 'dart:convert';

import 'package:ark/bean/conceptRelationList.dart';
import 'package:ark/bean/page_bean.dart';
import 'package:ark/bean/relation_all_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/service/ark_repository.dart';

class RelationModel extends ViewStateModel {
  String objKey;

  RelationModel(this.objKey);

  RelationAllBean _allBean;
  ConceptRelationList _conceptRelationList;

  ConceptRelationList get conceptRelationList => _conceptRelationList;

  RelationAllBean get allBean => _allBean;

  /// 获取所有的关联概念
  Future<ConceptRelationList> getAllRelation() async {
    setBusy();

    _allBean = await ArkRepository.getAllRelation(objKey);

    Map<String, Object> map = Map();

    List<RelationTabData> tabDatas = List();

    if (_allBean.data != null && _allBean.data.length > 0) {
      for (var bean in _allBean.data) {
        tabDatas.add(bean);
        PageBean pageBean = PageBean();
        pageBean.pn = 1;
        pageBean.rn = 15;
        map[bean.conceptName] = pageBean;
      }
    } else {
      map['pn'] = 1;
      map['rn'] = 15;
    }
    _conceptRelationList = await objectRelated(
        json.encode(tabDatas), 'concept_and_type', json.encode(map));
    setIdle();
    return _conceptRelationList;
  }

  /// 获取指定概念的关联
  Future<ConceptRelationList> objectRelated(
      String target_concepts, String type, String page_rules,
      {bool hasLabel = false}) async {
    setBusy();
    _conceptRelationList = await ArkRepository.objectRelated(
        objKey, target_concepts, type, page_rules, hasLabel);
    setIdle();
    return _conceptRelationList;
  }

  Future<bool> addRelLabel(String target_obj, String data) async {
    return await ArkRepository.relationLabelAdd(objKey, target_obj, data);
  }

  Future<bool> removeRelLabel(String target_obj, String keys) async {
    return await ArkRepository.removeRelationLabel(objKey, target_obj, keys);
  }

  /// 创建关联
  Future<bool> createRelation(String target_obj_name,
      {bool create_mode,
      String target_concept_name,
      int rel_number,
      int score,
      String data}) async {
    return await ArkRepository.createRelation(objKey, target_obj_name,
        create_mode: create_mode,
        target_concept_name: target_concept_name,
        rel_number: rel_number,
        score: score,
        data: data);
  }
}
