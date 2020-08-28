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

  String _key;

  String get key => _key;

  Future<List> getProList(String objKey, String conceptName) async {
    _key = objKey;
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
        if (pro.propertyName != null &&
            Comparable.compare(pro.propertyName, proName) == 0) {
          _propertyList.remove(pro);
          notifyListeners();
          break;
        }
      }
    }
  }

  /// 删除列表属性的单元格
  deleteListItem(int id, String proName) {
    if (_propertyList.isNotEmpty) {
      for (var property in _propertyList) {
        if (Comparable.compare(property.propertyName, proName) == 0) {
          if (property.data != null &&
              property.data.dt != null &&
              property.data.dt.length > 0) {
            for (var dt in property.data.dt) {
              if (id == dt.id) {
                property.data.dt.remove(dt);
                property.total -= 1;
                notifyListeners();
                break;
              }
            }
          }
        }
      }
    }
  }

  /// 更新列表属性的条目  或者 添加新条目
  updateProListItem(Dt dt, String proName, bool isAdd) {
    print('==============开始更新详情页的数据 ============ ${propertyList.length}');

    for (var property in _propertyList) {
      print(' 更新详情页的数据  ===> ${property.propertyName}');
      if (null != property.propertyName &&
          Comparable.compare(property.propertyName, proName) == 0) {
        if (isAdd) {
          property.data.dt.add(dt);
          notifyListeners();
          break;
        } else {
          if (property.data != null &&
              property.data.dt != null &&
              property.data.dt.length > 0) {
            for (var data in property.data.dt) {
              if (dt.id == data.id) {
                data.content = dt.content;
                data.title = dt.title;
                data.time = dt.time;
                data.info = dt.info;
                data.infos = dt.infos;
                data.expandedDataBean = dt.expandedDataBean;
                notifyListeners();
                break;
              }
            }
          }
        }
      }
    }
  }

  /// 更新别称
  updateListProNa(String pro, String na, int pos,
      {bool isBf = false, bool isBm = false}) {
    for (var property in _propertyList) {
      print('开始更新别称：${property.propertyName}');
      if (property.propertyName != null && property.propertyName == pro) {
        if (property.data != null) {
          property.data.na = na;
          property.data.pos = pos;
          notifyListeners();
          break;
        }
      }
      if (isBf && property.bfTableBean != null) {
        if (property.bfTableBean.propertyName == pro) {
          property.bfTableBean.na = na;
          property.data.pos = pos;
        }
      }
      if (isBm && property.bmTableBean != null) {
        if (property.bmTableBean.propertyName == pro) {
          property.bmTableBean.na = na;
          property.data.pos = pos;
        }
      }
    }
  }
}
