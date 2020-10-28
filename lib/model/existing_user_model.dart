import 'package:ark/bean/user_data.dart';
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/provider/view_state_refresh_list_model.dart';
import 'package:ark/service/ark_repository.dart';

class ExistingUsersModel extends ViewStateModel {
  UserData _userData;

  UserData get userData => _userData;

  Future<UserData> getExistingUsers() async {
    setBusy();
    _userData = await ArkRepository.getExistingUsers();
    setIdle();
    return _userData;
  }
}
