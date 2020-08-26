import 'package:ark/bean/search_result_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/net/net.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';

class SearchResultModel extends ViewStateRefreshListModel {
  String _text;

  SearchResultModel(this._text);

  SearchResultBean _resultBean;

  SearchResultBean get resultBean => _resultBean;

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = List();
    futures.add(DioUtils.instance.request(
        HttpMethod.POST, HttpApi.search_result,
        params: {'text': _text, 'rn': 20, 'pn': 1},
        isList: false, success: (json) {
      _resultBean = SearchResultBean.fromJson(json);
    }));
    await Future.wait(futures);

    return _resultBean.data;
  }

  updateCheckState(String objKey, bool value) {
    for (var data in _resultBean.data) {
      if (Comparable.compare(data.basicData.objKey, objKey) == 0) {
        data.basicData.isSelected = value;
      } else {
        data.basicData.isSelected = false;
      }
    }
    notifyListeners();
  }
}
