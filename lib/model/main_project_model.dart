import 'package:ark/bean/project_model.dart';
import 'package:ark/model/base_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';

class MainProjectModel extends BaseModel {
  Future<List<ProjectModel>> getProjectList() async {
    loading(true);
    List<ProjectModel> mData = List();
    DioUtils.instance.request(HttpMethod.POST, HttpApi.projectList,
        params: {"project_li": ""}, isList: true, successList: (data) {
      (data as List).forEach((json) {
        mData.add(ProjectModel.fromJson(json));
      });
    });
    loading(false);
    return mData;
  }
}
