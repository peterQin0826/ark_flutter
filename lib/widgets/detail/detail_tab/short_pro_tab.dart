import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShortProTab extends StatefulWidget {

  PropertyListBean property;
  String objKey;


  ShortProTab(this.property,this.objKey);

  @override
  ShortProTabState createState() => new ShortProTabState();
}

class ShortProTabState extends State<ShortProTab> {
  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            TitleRow(
              title: '短文本区',
              type: 0,
              objKey: widget.objKey,
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.property.shortProperties.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                    EdgeInsets.only(left: 13, right: 15, top: 5, bottom: 5),
                    child: KeyValue(
                      shortProperty: widget.property.shortProperties[index],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}