
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:flutter/material.dart';

class ObjectProTab extends StatefulWidget {

  PropertyListBean property;
  String objKey;


  ObjectProTab(this.property, this.objKey);

  @override
  ObjectProTabState createState() => new ObjectProTabState();
}

class ObjectProTabState extends State<ObjectProTab>  with AutomaticKeepAliveClientMixin{


  Divider divider = Divider(
    height: 1,
    color: MyColors.color_c5c6ca,
  );

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
                    type: 6,
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
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.property.data.dt.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                return ObjectItem(widget.property.data.dt[position]);
              },
              separatorBuilder: (context, position) {
                return divider;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget ObjectItem(Dt dt) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dt.title.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              dt.title,
              style:
              TextStyle(color: MyColors.color_040404, fontSize: 14),
            ),
          )
              : Container(
            width: 0,
            height: 0,
          ),
          dt.infos.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(top: 11),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dt.infos.length,
                itemBuilder: (context, position) {
                  return KeyValue(shortProperty: dt.infos[position]);
                }),
          )
              : Container(
            width: 0,
            height: 0,
          ),
          Container(
            color: MyColors.color_f5f5f5,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 5),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/img_empty.png',
                    image: ImageUtils.getImgUrl(dt.expandedDataBean.image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dt.expandedDataBean.objName,
                          style: TextStyle(
                              color: MyColors.color_090909, fontSize: 14),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            dt.expandedDataBean.summary,
                            style: TextStyle(
                                color: MyColors.color_585D7B, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateUtils.formatDateMsByYMDHM(dt.time),
                  style: TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                ),
                Container(
                  padding:
                  EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: MyColors.color_f5f5f5),
                  child: Text(
                    dt.expandedDataBean.conceptName,
                    style:
                    TextStyle(color: MyColors.color_989CB6, fontSize: 11),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}