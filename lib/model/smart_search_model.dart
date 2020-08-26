import 'package:ark/bean/smart_search_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';

class SmartSearchModel extends ViewStateRefreshListModel {
  String _text;

  SmartSearchModel();

  SmartSearchBean _searchBean;

  SmartSearchBean get searchBean => _searchBean;

  void setText(String text) {
    this._text = text;
//    loadData(pageNum: 1);
  }

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = List();
    futures.add(DioUtils.instance.request(HttpMethod.POST, HttpApi.searchSmart,
        params: {'text': _text, 'rn': 100, 'pn': 1},
        isList: false, success: (json) {
      _searchBean = SmartSearchBean.fromJson(json);
    }));
    await Future.wait(futures);
    return _searchBean.data;
  }
}
