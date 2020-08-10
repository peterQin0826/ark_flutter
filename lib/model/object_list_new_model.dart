import 'package:ark/bean/object_list_bean.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';
import 'package:ark/service/ark_repository.dart';
import 'package:flutter/cupertino.dart';

class ObjectListNewModel extends ViewStateRefreshListModel {

  String code;
  final int rn;
  ObjectListBean _objectListBean;

  ObjectListBean get objectListBean=>_objectListBean;

  ObjectListNewModel({@required this.code, this.rn});

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = List();
    if (pageNum == ViewStateRefreshListModel.pageNumFirst) {}
    futures.add(ArkRepository.getObjectList(code, pageNum, rn));
    var result = await Future.wait(futures);
    _objectListBean=result[0];
    return _objectListBean.data;
  }


}
