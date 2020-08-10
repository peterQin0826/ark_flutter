import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_model.dart';

class ShortProModel extends ViewStateModel {


  Future<bool> shortProAdd(String objKey,String proName, String proValue) async {
    setBusy();
    try {
      await DioUtils.instance.request(HttpMethod.POST, HttpApi.short_pro_add,
          params: {
            'obj_key': objKey,
            'property_name': proName,
            'property_value': proValue
          },
          isList: false,
          success: (json) {});
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  Future<bool> shortProEdit(String objKey,String proName, String proValue) async {
    setBusy();
    try {
      await DioUtils.instance.request(HttpMethod.POST, HttpApi.short_pro_edit,
          params: {
            'obj_key': objKey,
            'property_name': proName,
            'property_value': proValue
          },
          isList: false,
          success: (json) {});
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  Future<bool> shortProDelete(String objKey,String property_name) async {
    setBusy();
    try {
      await DioUtils.instance.request(HttpMethod.POST, HttpApi.short_pro_delete,
          params: {'obj_key': objKey, 'property_name': property_name},
          success: (json) {});
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }
}
