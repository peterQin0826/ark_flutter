

import 'package:ark/bean/concept_detail_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_model.dart';
import 'package:ark/service/ark_repository.dart';

class ConceptDetailModel extends ViewStateModel{
  String code;


  ConceptDetailModel({this.code});

  ConceptDetailBean _conceptDetailBean;

  ConceptDetailBean get conceptDetailBean =>_conceptDetailBean;

 Future<ConceptDetailBean> getConceptDetail() async{
    setBusy();
//    List<Future> futures=List();
    _conceptDetailBean= await ArkRepository.getConceptDetail(code);
    setIdle();
    return conceptDetailBean;
  }
}
