import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:flutter/material.dart';

class BfTableProTab extends StatefulWidget {
  PropertyListBean property;
  String objKey;

  BfTableProTab(this.property, this.objKey);

  @override
  BfTableProTabState createState() => new BfTableProTabState();
}

class BfTableProTabState extends State<BfTableProTab> {
  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: widget.property.bfTableBean.propertyName,
                    type: 2,
                    total: widget.property.bfTableBean.total,
                    objKey: widget.objKey,
                    property: widget.property,
                  ),
                  AkaEditWidget(
                    aka: widget.property.bfTableBean.na,
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.property.bfTableBean.bfDatas.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 15,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: KeyNumberValue(
                        numberKeyValueBean:
                            widget.property.bfTableBean.bfDatas[position],
                      ),
                    ),
                  );
                }),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Divider(
                height: 1,
                color: MyColors.color_c5c6ca,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
