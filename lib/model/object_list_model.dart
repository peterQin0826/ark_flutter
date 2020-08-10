import 'package:ark/bean/object_list_bean.dart';
import 'package:ark/model/base_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';

class ObjectListModel extends BaseModel{

  ObjectListBean objectListBean;

  List<Data> datas =new List();
  
  Future<ObjectListBean> getObjectList(String code,int pn,int rn) async{
    loading(true);
    await DioUtils.instance.request(HttpMethod.GET, HttpApi.object_list,queryParameters: {
      "concept_code":code,
      "rn":rn,
      "pn":pn,
    },success: (data){
      objectListBean =ObjectListBean.fromJson(data);
      if(pn==1){
        datas.clear();
      }
      datas.addAll(objectListBean.data);
      print('对象列表页面：${objectListBean.count}');
    });
    loading(false);
  }
}