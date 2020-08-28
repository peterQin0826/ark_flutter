
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:ark/widgets/detail/horizontal_chart.dart';
import 'package:flutter/material.dart';

class TimeProTab extends StatefulWidget {

  PropertyListBean property;
  String objKey;


  TimeProTab(this.property, this.objKey);

  @override
  TimeProTabState createState() => new TimeProTabState();
}

class TimeProTabState extends State<TimeProTab> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: MyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: widget.property.propertyName,
                    type: 7,
                    total: widget.property.total,
                    objKey: widget.objKey,
                    property: widget.property,
                  ),
                  AkaEditWidget(
                    aka: ((null != widget.property.data) ? widget.property.data.na : ""),
                  ),
                ],
              ),
            ),
            getHoizontalChart(widget.property)
          ],
        ),
      ),
    );
  }

  getHoizontalChart(PropertyListBean property) {
    return HorizontalChart(
      property: property,
    );
  }

}