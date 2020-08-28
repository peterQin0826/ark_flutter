import 'dart:ui';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/object_item_edit_view.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'info_item.dart';

class ObjectItem extends StatefulWidget {
  Dt object;
  String objKey;
  String proName;

  ObjectItem(this.object, this.objKey, this.proName);

  @override
  ObjectItemState createState() => new ObjectItemState();
}

class ObjectItemState extends State<ObjectItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                settings: RouteSettings(
                  name: RouteName.object_item_edit_view,
                ),
                builder: (context) {
                  return ObjectItemEditView(
                      widget.objKey, widget.proName, widget.object);
                })).then((value) {
          if (value != null) {
            Dt data = value;
            widget.object.title = data.title;
            widget.object.content = data.content;
            widget.object.infos = data.infos;
            widget.object.info = data.info;
            widget.object.time = data.time;
            widget.object.expandedDataBean = data.expandedDataBean;
            setState(() {});
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: MyColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.object.title,
              style: TextStyle(
                  color: MyColors.color_black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Offstage(
              offstage: widget.object.infos.length == 0,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '简介：',
                      style:
                          TextStyle(color: MyColors.color_black, fontSize: 14),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.object.infos != null
                            ? widget.object.infos.length
                            : 0,
                        itemBuilder: (context, index) {
                          return InfoItem(widget.object.infos[index]);
                        })
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MyColors.color_F1F2F6),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: ImageUtils.getImgUrl(
                            widget.object.expandedDataBean.image),
                        placeholder: (context, img) {
                          return Image.asset(
                              Utils.getImgPath(Constant.empty_view));
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.object.expandedDataBean.objName,
                              style: TextStyle(
                                  color: MyColors.color_black, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.object.expandedDataBean.summary,
                              style: TextStyle(color: MyColors.color_8F9091),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateUtils.formatDateMsByYMDHM(widget.object.time),
                  style: TextStyle(color: MyColors.color_AEAEAE, fontSize: 10),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: MyColors.white,
                      border:
                          Border.all(color: MyColors.color_f5f5f5, width: 1)),
                  child: Center(
                    child: Text(widget.object.expandedDataBean.conceptName),
                  ),
                )
              ],
            )
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
}
