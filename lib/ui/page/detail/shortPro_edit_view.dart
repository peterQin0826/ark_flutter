import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/short_pro_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/short_pro_item_edit_view.dart';
import 'package:ark/utils/toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ShortProEditView extends StatefulWidget {
  String objKey;

  ShortProEditView({this.objKey});

  @override
  ShortProEditViewState createState() => new ShortProEditViewState();
}

TextStyle keyStyle = TextStyle(color: MyColors.color_697796, fontSize: 16);
TextStyle valueStyle = TextStyle(color: MyColors.color_black, fontSize: 16);

class ShortProEditViewState extends State<ShortProEditView> {
  bool isAdd = false;
  DetailProModel detailProModel;
  List<ShortProperty> shortProperties = List();

  @override
  void initState() {
    detailProModel = Provider.of<DetailProModel>(context, listen: false);
    List<PropertyListBean> propertyList = detailProModel.propertyList;
    if (propertyList.isNotEmpty && propertyList[0].itemType == 0) {
      shortProperties.addAll(propertyList[0].shortProperties);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('====build====');
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('短标签'),
      ),
      body: ProviderWidget<ShortProModel>(
        model: ShortProModel(),
        onModelReady: (model) {},
        builder: (context, model, chile) {
          return Scaffold(
            body: ListView.separated(
              itemCount: shortProperties.length,
              itemBuilder: (context, position) {
                return ListItem(
                  shortProperties: shortProperties,
                  position: position,
                  objKey: widget.objKey,
                  detailProModel: detailProModel,
                );
              },
              separatorBuilder: (context, position) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 10,
                  decoration: BoxDecoration(color: MyColors.color_F4F5F6),
                );
              },
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(right: 10, bottom: 10),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: MyColors.color_1246FF),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    shortProperties.add(new ShortProperty());
                    setState(() {
                      print('添加数据 ${shortProperties.length}');
                    });
                  },
                  child: Center(
                      child: Text(
                    '添加',
                    style: TextStyle(color: MyColors.white, fontSize: 16),
                  ))),
            ),
          );
        },
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  List<ShortProperty> shortProperties;
  int position;
  String objKey;

  ListItem(
      {this.shortProperties, this.position, this.objKey, this.detailProModel});

  DetailProModel detailProModel;

  @override
  ListItemState createState() => new ListItemState();
}

class ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    print('刷新： ${widget.position} ===> 总数为：${widget.shortProperties.length}');
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: MyColors.white,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShortProItemEdit(
                          objKey: widget.objKey,
                          short: widget.shortProperties[widget.position],
                        ))).then((value) {
              ShortProperty shortProperty = value; // 上个页面传回来的值
              ShortProperty editShort =
                  widget.shortProperties[widget.position]; // 当前页面被编辑的item
              setState(() {
                editShort.key = shortProperty.key;
                editShort.value = shortProperty.value;
              });
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Text(
                      '键',
                      style: keyStyle,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          widget.shortProperties[widget.position].key != null
                              ? widget.shortProperties[widget.position].key
                              : '',
                          style: valueStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 10),
                child: Divider(
                  color: MyColors.color_EAEBEF,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Text(
                      '值',
                      style: keyStyle,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          widget.shortProperties[widget.position].value != null
                              ? widget.shortProperties[widget.position].value
                              : '',
                          style: valueStyle,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: MyColors.color_FE3B30,
          icon: Icons.delete,
          onTap: () {
            ShortProModel shortModel =
                Provider.of<ShortProModel>(context, listen: false);
            if (widget.shortProperties[widget.position].key != null) {
              shortModel
                  .shortProDelete(widget.objKey,
                      widget.shortProperties[widget.position].key)
                  .then((value) {
                Toast.show('删除成功');
                widget.detailProModel.deleteShortProItem(widget.position);
              });
            }

            ///todo  空数据的删除还没解决 bug
            setState(() {
              widget.shortProperties.removeAt(widget.position);
            });
          },
        )
      ],
    );
  }
}
