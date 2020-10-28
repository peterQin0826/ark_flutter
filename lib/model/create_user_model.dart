import 'package:ark/bean/catalog_list_bean.dart';
import 'package:ark/bean/project_model.dart';
import 'package:ark/bean/user.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/service/ark_repository.dart';
import 'package:ark/utils/string_utils.dart';

class CreateUserModel extends ViewStateModel {
  User _user;
  List<ProjectModel> _proList = List();

  List<ProjectModel> get proList => _proList;

  User get user => _user;

  Future<User> createUser(String username, String password, String password2,
      {String phone, String email, String image}) async {
    setBusy();

    Map<String, dynamic> map = Map();
    map['username'] = username;
    map['password'] = password;
    map['password2'] = password2;
    if (StringUtils.isNotEmpty(phone)) {
      map['phone'] = phone;
    }
    if (StringUtils.isNotEmpty(email)) {
      map['email'] = email;
    }

    if (StringUtils.isNotEmpty(image)) {
      map['image'] = image;
    }

    await DioUtils.instance.request(HttpMethod.POST, HttpApi.createUser,
        params: map, success: (json) {
      _user = User.fromJson(json);
    });

    setIdle();
    return _user;
  }

  ///项目权限查看
  Future<List<ProjectModel>> getPermissionProjectList(
      String user_key, String concept_code) async {
    setBusy();
    _proList = List();
    List<Future> futures = List();

    Map<String, dynamic> map =
        await ArkRepository.getPermissionProjectList(user_key, concept_code);
    if (null != map && map.length > 0) {
      map.forEach((key, value) {
        ProjectModel project = ProjectModel();
        project.project = key;
        project.permission = value;

        futures.add(getCatalog(key, project));
      });
      await Future.wait(futures);
    }

    setIdle();
    return _proList;
  }

  /// 目录层级接口
  Future<List<ConceptLi>> getCatalog(
      String proName, ProjectModel project) async {
    List<ConceptLi> list = await ArkRepository.getCatalog(proName);
    project.conceptLi = list;
    _proList.add(project);
    return list;
  }
}
