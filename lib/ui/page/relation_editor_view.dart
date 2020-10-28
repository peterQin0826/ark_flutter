import 'dart:convert';

import 'package:ark/bean/conceptRelationList.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/common/common.dart';
import 'package:ark/model/relation_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/confirmDialog.dart';
import 'package:ark/widgets/detail/image_video_item.dart';
import 'package:ark/widgets/input_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RelationEditView extends StatefulWidget {
  final String objKey;
  final String target_concepts;
  final String type;
  final String page_rules;

  const RelationEditView(
      {Key key, this.objKey, this.target_concepts, this.type, this.page_rules})
      : super(key: key);

  @override
  RelationEditViewState createState() => new RelationEditViewState();
}

class RelationEditViewState extends State<RelationEditView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('关联编辑页'),
        centerTitle: true,
      ),
      body: ProviderWidget<RelationModel>(
        model: RelationModel(widget.objKey),
        onModelReady: (model) {
          model.objectRelated(
              widget.target_concepts, widget.type, widget.page_rules,
              hasLabel: true);
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: model.conceptRelationList.data.length,
              itemBuilder: (context, index) {
                Data data = model.conceptRelationList.data[index];
                return RelationEditItem(data);
              });
        },
      ),
    );
  }
}

class RelationEditItem extends StatefulWidget {
  Data relation;

  RelationEditItem(this.relation);

  @override
  RelationEditItemState createState() => new RelationEditItemState();
}

class RelationEditItemState extends State<RelationEditItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      color: MyColors.white,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.relation.group.length,
          itemBuilder: (context, index) {
            Group group = widget.relation.group[index];

            return GroupItem(group);
          }),
    );
  }
}

class GroupItem extends StatefulWidget {
  Group group;

  GroupItem(this.group);

  @override
  GroupItemState createState() => new GroupItemState();
}

class GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.group.objects.length,
        itemBuilder: (context, index) {
          Objects objects = widget.group.objects[index];
          return GroupItemItem(objects);
        });
  }
}

class GroupItemItem extends StatefulWidget {
  Objects object;

  GroupItemItem(this.object);

  @override
  GroupItemItemState createState() => new GroupItemItemState();
}

class GroupItemItemState extends State<GroupItemItem> {
  @override
  Widget build(BuildContext context) {
//    print('图片地址：======》${ImageUtils.getImgUrl(widget.object.basicData.image)}');
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  widget.object.basicData.objName,
                  style: TextStyle(
                      color: MyColors.color_black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('删除当前？');
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    Utils.getImgPath('delete_relation'),
                    width: 14,
                    height: 14,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.object.basicData.objKey,
                    style:
                        TextStyle(color: MyColors.color_106AFF, fontSize: 12),
                  ),
                ),
                Container(
                  height: 20,
                  padding: EdgeInsets.only(left: 9, right: 9),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.color_f5f5f5),
                  child: Center(
                    child: Text(
                      '强度：${widget.object.relatedData.score}',
                      style:
                          TextStyle(color: MyColors.color_697796, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                    height: 20,
                    padding: EdgeInsets.only(left: 9, right: 9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.color_f5f5f5),
                    child: Center(
                        child:
                            Text('类型：${widget.object.relatedData.relNumber}'))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Offstage(
                    offstage:
                        StringUtils.isEmpty(widget.object.basicData.summary),
                    child: Text(
                      widget.object.basicData.summary,
                      style: TextStyle(
                        color: MyColors.color_6E757C,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    ImageUtils.getImgUrl(widget.object.basicData.image),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, img, object) {
                      return Image.asset(
                        Utils.getImgPath(Constant.empty_view),
                        width: 70,
                        height: 70,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '更：${widget.object.basicData.updateTime}',
                  style: TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                ),
                Text('修：${widget.object.basicData.mtime}',
                    style:
                        TextStyle(color: MyColors.color_989CB6, fontSize: 10))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: RelationLabel(
                widget.object.labels, widget.object.basicData.objKey),
          )
        ],
      ),
    );
  }
}

class RelationLabel extends StatefulWidget {
  List<ShortProperty> labels;
  String objKey;

  RelationLabel(this.labels, this.objKey);

  @override
  RelationLabelState createState() => new RelationLabelState();
}

class RelationLabelState extends State<RelationLabel> {
  RelationModel model;

  @override
  Widget build(BuildContext context) {
    print('object===>${widget.labels.length}');
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      children: _labelWidgets(widget.labels),
    );
  }

  @override
  void initState() {
    model = Provider.of(context, listen: false);
    super.initState();
  }

  List<Widget> _labelWidgets(List<ShortProperty> labels) {
    List<Widget> widgets = List();
    if (labels != null && labels.length > 0) {
      for (var label in labels) {
        widgets.add(Chip(
          label: Text(
            '${label.key} ：${label.value}',
            style: TextStyle(color: MyColors.color_7B81A9, fontSize: 11),
          ),
          deleteIcon: Image.asset(
            Utils.getImgPath('delete_relation'),
            width: 15,
            height: 15,
          ),
          onDeleted: () {
            print('删除标签');

            showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    content: '是否要删除关联标签？',
                    confirmClicked: () {
                      List<String> removeList = List();
                      removeList.add(label.key);

                      model
                          .removeRelLabel(
                              widget.objKey, json.encode(removeList))
                          .then((value) {
                        if (value) {
                          Toast.show('删除成功');
                          widget.labels.remove(label);
                          setState(() {});
                        }
                      });
                    },
                  );
                });
          },
        ));
      }
    }

    widgets.add(Chip(
      label: Text('添加'),
      deleteIcon: Image.asset(
        Utils.getImgPath('relation_add'),
        width: 15,
        height: 15,
      ),
      onDeleted: () {
        print('添加标签');
        showDialog(
            context: context,
            builder: (context) {
              return InputTitleDialog('属性名称', '简介',
                  onConfirm: (String title, String content) {
                print('属性名称:$title ,内容：$content');
                Map<String, String> map = Map();
                map[title] = content;
                model
                    .addRelLabel(widget.objKey, json.encode(map))
                    .then((value) {
                  if (value) {
                    Toast.show('添加关联标签成功');
                    ShortProperty label = ShortProperty();
                    label.key = title;
                    label.value = content;
                    widget.labels.add(label);
                    setState(() {});
                  }
                });
              });
            });
      },
    ));
    return widgets;
  }
}
