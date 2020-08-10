import 'package:ark/bean/bftable_bean.dart';
import 'package:ark/bean/bmtable_bean.dart';
import 'package:ark/bean/number_key_value_bean.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/bean/summary_info.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/service/ark_repository.dart';
import 'package:common_utils/common_utils.dart';

class DetailProModel extends ViewStateModel {
  List<PropertyListBean> _propertyList = List();

  List<PropertyListBean> get propertyList => _propertyList;

  Future<List> getProList(String objKey, String conceptName) async {
    List<Future> list = List();
    List<Future> proFutureList = List();
    SummaryInfo summaryInfo;
    setBusy();
    list.add(ArkRepository.getSummary(objKey, conceptName));
    var result = await Future.wait(list);
    summaryInfo = result[0];
    _propertyList = List();

    if (summaryInfo.shortProperties.isNotEmpty) {
      PropertyListBean propertyListBean = new PropertyListBean();
      propertyListBean.shortProperties = summaryInfo.shortProperties;
      propertyListBean.itemType = 0;
      _propertyList.add(propertyListBean);
    }
    if (summaryInfo.property.isNotEmpty) {
      for (var property in summaryInfo.property) {
        String conceptName = property.propertyName;
        switch (property.ctp) {
          case 'list':
            if (property.data != null && property.data.tp.isNotEmpty) {
              switch (property.data.tp) {
                case 'txt':
                  proFutureList.add(getProListData(
                      objKey, conceptName, 100, _propertyList, 3));
                  break;
                case 'img':
                  proFutureList.add(getProListData(
                      objKey, conceptName, 30, _propertyList, 4));
                  break;
                case 'video':
                  proFutureList.add(getProListData(
                      objKey, conceptName, 10, _propertyList, 5));
                  break;
                case 'object':
                  proFutureList.add(getProListData(
                      objKey, conceptName, 10, _propertyList, 6));
                  break;
                case 'time':
                  proFutureList.add(getProListData(
                      objKey, conceptName, 500, _propertyList, 7));
                  break;
                case 'file':
                  proFutureList.add(getProListData(
                      objKey, conceptName, 100, _propertyList, 8));
                  break;
              }
            }
            break;
          case 'BMTable':
            proFutureList
                .add(getBmtable(objKey, conceptName, 100, _propertyList));
            break;
          case 'BFTable':
            proFutureList
                .add(getBftable(objKey, conceptName, 100, _propertyList));
            break;
        }
      }
    }
    await Future.wait(proFutureList);
    print('=======================>${_propertyList.length}');
    setIdle();
    return _propertyList;
  }

  ///获取bmtable 的 数据
  Future<PropertyListBean> getBmtable(String objKey, String proName, int rn,
      List<PropertyListBean> propertyList) async {
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
      propertyListBean.itemType = 1;
      propertyList.add(propertyListBean);
    });
  }

  /// 获取bftable 的数据
  Future<PropertyListBean> getBftable(String objKey, String proName, int rn,
      List<PropertyListBean> propertyList) async {
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
      propertyListBean.itemType = 2;
      propertyList.add(propertyListBean);
    });
  }

  /// 获取对象的列表属性信息

  Future<PropertyListBean> getProListData(String objKey, String proName, int rn,
      List<PropertyListBean> propertyList, int itemType) async {
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.list_pro,
        queryParameters: {
          'obj_key': objKey,
          'property_name': proName,
          'rn': rn,
          'pn': 1
        }, success: (json) {
      PropertyListBean propertyListBean = PropertyListBean.fromJson(json);
      propertyListBean.itemType = itemType;
      propertyList.add(propertyListBean);
    });
  }

  updateShortPro(String key, String value, bool isAdd) {
    if (_propertyList.isNotEmpty && _propertyList[0].itemType == 0) {
      if (isAdd) {
        _propertyList[0]
            .shortProperties
            .add(ShortProperty(key: key, value: value));
        notifyListeners();
      } else {
        for (var short in _propertyList[0].shortProperties) {
          if (Comparable.compare(short.key, key) == 0) {
            short.value = value;
            notifyListeners();
            break;
          }
        }
      }
    }
  }

  /// 同步删除短属性的Item
  deleteShortProItem(int position) {
    if (_propertyList.isNotEmpty && _propertyList[0].itemType == 0) {
      _propertyList[0].shortProperties.removeAt(position);
      notifyListeners();
    }
  }

  /// 删除bmtable 的单元格
  deleteBmTableProItem(String proName, String key) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (pro.bmTableBean != null &&
            Comparable.compare(pro.bmTableBean.propertyName, proName) == 0) {
          if (pro.bmTableBean.bmDatas != null &&
              pro.bmTableBean.bmDatas.length > 0) {
            for (var bmdt in pro.bmTableBean.bmDatas) {
              if (Comparable.compare(bmdt.key, key) == 0) {
                pro.bmTableBean.bmDatas.remove(bmdt);
                notifyListeners();
                break;
              }
            }
          }
        }
      }
    }
  }

  /// 删除bftable 的单元格
  deleteBfTableProItem(String proName, String key) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (pro.bfTableBean != null &&
            Comparable.compare(pro.bfTableBean.propertyName, proName) == 0) {
          if (pro.bfTableBean.bfDatas != null &&
              pro.bfTableBean.bfDatas.length > 0) {
            for (var bfdt in pro.bfTableBean.bfDatas) {
              if (Comparable.compare(bfdt.key, key) == 0) {
                print('删除的单元格 $key');
                pro.bfTableBean.bfDatas.remove(bfdt);
                notifyListeners();
                break;
              }
            }
          }
        }
      }
    }
  }

  /// 更新bmtable 单元格
  updateBmtableItem(String proName, String key, String value, isAdd) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (pro.bmTableBean != null &&
            Comparable.compare(pro.bmTableBean.propertyName, proName) == 0) {
          if (isAdd) {
            pro.bmTableBean.bmDatas.add(ShortProperty(key: key, value: value));
            notifyListeners();
            break;
          } else {
            if (pro.bmTableBean.bmDatas != null &&
                pro.bmTableBean.bmDatas.length > 0) {
              for (var bmtable in pro.bmTableBean.bmDatas) {
                if (Comparable.compare(key, bmtable.key) == 0) {
                  bmtable.value = value;
                  notifyListeners();
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  /// 更新bftable 单元格
  updateBfTableItem(String proName, String key, num value, isAdd) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (pro.bfTableBean != null &&
            Comparable.compare(pro.bfTableBean.propertyName, proName) == 0) {
          if (isAdd) {
            pro.bfTableBean.bfDatas
                .add(NumberKeyValueBean(key: key, value: value));
            notifyListeners();
          } else {
            if (pro.bfTableBean.bfDatas.isNotEmpty) {
              for (var bfdt in pro.bfTableBean.bfDatas) {
                if (Comparable.compare(bfdt.key, key) == 0) {
                  bfdt.value = value;
                  notifyListeners();
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  /// 删除bmtable
  deleteBmTablePro(String proName) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (pro.bmTableBean != null &&
            Comparable.compare(pro.bmTableBean.propertyName, proName) == 0) {
          _propertyList.remove(pro);
          notifyListeners();
          break;
        }
      }
    }
  }

  /// 删除bfTable
  deleteBfTablePro(String proName) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (pro.bfTableBean != null &&
            Comparable.compare(pro.bfTableBean.propertyName, proName) == 0) {
          _propertyList.remove(pro);
          notifyListeners();
          break;
        }
      }
    }
  }

  /// 删除列表属性
  deleteListPro(String proName) {
    if (_propertyList.isNotEmpty) {
      for (var pro in _propertyList) {
        if (Comparable.compare(pro.propertyName, proName) == 0) {
          _propertyList.remove(pro);
          notifyListeners();
          break;
        }
      }
    }
  }
}
