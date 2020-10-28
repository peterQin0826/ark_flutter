
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/service/ark_repository.dart';
import 'package:ark/utils/string_utils.dart';

class AddRelationModel extends ViewStateModel{

  String objName;


  AddRelationModel(this.objName);

  /// 创建关联
  Future<bool> createRelation(String target_obj_name,
      {bool create_mode,
        String target_concept_name,
        int rel_number,
        int score,
        String data}) async {
    return await ArkRepository.createRelation(objName, target_obj_name,
        create_mode: create_mode,
        target_concept_name: target_concept_name,
        rel_number: rel_number,
        score: score,
        data: data);
  }
  
  
  
}