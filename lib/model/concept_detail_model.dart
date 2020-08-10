

import 'package:ark/bean/concept_detail_bean.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/view_state_model.dart';

class ConceptDetailModel extends ViewStateModel{
  String code;


  ConceptDetailModel({this.code});

  ConceptDetailBean _conceptDetailBean;

  ConceptDetailBean get conceptDetailBean =>_conceptDetailBean;

  getConceptDetail() async{
    setBusy();
    try{
      await DioUtils.instance.request(HttpMethod.POST, HttpApi.concept_detail,params: {"concept_code":code},isList: false,
          success: (json){
            _conceptDetailBean=ConceptDetailBean.fromJson(json);
          });
      setIdle();
    }catch(e,s){
      setError(e,s);
    }
  }
}

class DeleteConceptModel extends ViewStateModel{

  deleteConcept () async{

  }
}