import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:flutter/material.dart';

class BmTableProTab extends StatefulWidget {
  PropertyListBean property;
  String objKey;

  BmTableProTab(this.property, this.objKey);

  @override
  BmTableProTabState createState() => new BmTableProTabState();
}

class BmTableProTabState extends State<BmTableProTab>
    with AutomaticKeepAliveClientMixin {
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
                    title: widget.property.bmTableBean.propertyName,
                    type: 1,
                    total: widget.property.bmTableBean.total,
                    objKey: widget.objKey,
                    property: widget.property,
                  ),

                  /// 这两个可以合为一个组件
                  AkaEditWidget(
                    aka: widget.property.bmTableBean.na,
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.property.bmTableBean.bmDatas.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 15,
                    ),
                    child: KeyValue(
                      shortProperty:
                          widget.property.bmTableBean.bmDatas[position],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
