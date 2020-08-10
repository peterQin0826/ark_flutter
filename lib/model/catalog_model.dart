
import 'package:ark/bean/catalog_list_bean.dart';
import 'package:ark/model/base_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';

class CatalogModel extends BaseModel {

  List<CatalogListBean> catalogs;


  Future<List<CatalogListBean>> getCatalog(String proName) async {
    loading(true);
    catalogs = List();
    await DioUtils.instance.request(HttpMethod.POST, HttpApi.project_catalog,
        params: {"project": proName, "target_concept": "", "layers": "all"},
        isList: true, successList: (data) {
      data.forEach((json) {
        catalogs.add(CatalogListBean.fromJson(json));
      });
    });
    loading(false);
  }
}
