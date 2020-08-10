
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DetailProShortProvider extends InheritedWidget{

  List<ShortProperty> shortProperties ;

  DetailProShortProvider({Widget child,this.shortProperties}):super(child:child);

  @override
  bool updateShouldNotify(DetailProShortProvider oldWidget) {

    return shortProperties!=oldWidget.shortProperties;
  }

  static DetailProShortProvider of(BuildContext context){

    DetailProModel detailProModel = Provider.of<DetailProModel>(context, listen: false);
    List<PropertyListBean> propertyList = detailProModel.propertyList;
    List<ShortProperty> shorts =List();
    if (propertyList.isNotEmpty && propertyList[0].itemType == 0) {
      shorts.addAll(propertyList[0].shortProperties);
    }

    return context.dependOnInheritedWidgetOfExactType<DetailProShortProvider>();
  }



}