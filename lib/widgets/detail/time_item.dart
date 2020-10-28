import 'dart:ui';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/text_list_item_edit_view.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/widgets/detail/info_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TimeItem extends StatefulWidget {
  Dt time;
  String objKey;
  String proName;

  TimeItem(this.time, this.objKey, this.proName);

  @override
  TimeItemState createState() => new TimeItemState();
}

class TimeItemState extends State<TimeItem> {
  TextStyle style = TextStyle(color: MyColors.color_697796, fontSize: 16);
  TextStyle style1 = TextStyle(color: MyColors.color_697796, fontSize: 14);
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        /// 可以删除栈中的多个路由
        Navigator.push(
            context,
            CupertinoPageRoute(
                settings:
                    RouteSettings(name: RouteName.text_list_item_edit_view),
                builder: (context) => TextListItemEditView(widget.objKey,
                    widget.proName, widget.time, Constant.time))).then((value) {
          if (value != null) {
            Dt data = value;
            widget.time.title = data.title;
            widget.time.content = data.content;
            widget.time.infos = data.infos;
            widget.time.info = data.info;
            widget.time.time = data.time;
            setState(() {});
          }
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '时间',
                  style: style,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    DateUtils.formatDateMsByYMDHM(widget.time.time),
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.color_black,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  _title(),
                  SizedBox(
                    width: 10,
                  ),
                  _content(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '简介',
                    style: style,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InfoItem(widget.time.infos[index]);
                    },
                    itemCount: widget.time.infos != null
                        ? widget.time.infos.length
                        : 0,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    titleController.text = widget.time.title;
    contentController.text = widget.time.content;
    super.initState();
  }

  _title() {
    return Expanded(
      flex: 1,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Text(
            '标题',
            style: style1,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              widget.time.title,
              style: TextStyle(color: MyColors.color_7b7878, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  _content() {
    return Expanded(
      flex: 1,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Text(
            '内容',
            style: style1,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              widget.time.content,
              style: style1,
            ),
          )
        ],
      ),
    );
  }
}
