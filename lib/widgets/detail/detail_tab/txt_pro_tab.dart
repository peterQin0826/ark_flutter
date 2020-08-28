import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:ark/utils/date_utils.dart';

import 'package:flutter/material.dart';

class TxtProTab extends StatefulWidget {
  PropertyListBean property;
  String objKey;

  TxtProTab(this.property, this.objKey);

  @override
  TxtProTabState createState() => new TxtProTabState();
}

class TxtProTabState extends State<TxtProTab>
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
                    title: widget.property.propertyName,
                    type: 3,
                    total: widget.property.total,
                    objKey: widget.objKey,
                    property: widget.property,
                  ),
                  AkaEditWidget(
                    aka: (null != widget.property.data)
                        ? widget.property.data.na
                        : "",
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.property.data.dt.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 15,
                    ),
                    child: TxtListWidget(
                      dt: widget.property.data.dt[position],
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

class TxtListWidget extends StatelessWidget {
  Dt dt;

  TxtListWidget({@required this.dt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            dt.title,
            style: TextStyle(
                color: MyColors.color_black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: dt.infos.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, position) {
              return KeyValue(shortProperty: dt.infos[position]);
            }),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            dt.content,
            style: TextStyle(color: MyColors.color_6E757C, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            DateUtils.formatDateMsByYMDHM(dt.time),
            style: TextStyle(color: MyColors.color_697796, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
