import 'dart:convert';

import 'package:ark/bean/short_property.dart';
import 'package:ark/model/relation_add_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/page/relation_editor_view.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/confirmDialog.dart';
import 'package:ark/widgets/detail/image_video_item.dart';
import 'package:ark/widgets/input_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRelationPage extends StatefulWidget {
  String objName;

  AddRelationPage(this.objName);

  @override
  AddRelationPageState createState() => new AddRelationPageState();
}

class AddRelationPageState extends State<AddRelationPage> {
  TextEditingController standNameCon = TextEditingController();
  TextEditingController conceptNameCon = TextEditingController();
  TextEditingController relTypeCon = TextEditingController();
  TextEditingController relStrongCon = TextEditingController();
  bool flag = false;
  AddRelationModel _model;
  List<ShortProperty> list = List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.color_F4F5F6,
      appBar: new AppBar(
        title: new Text('添加关联'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {
              print('添加成功');
              if (StringUtils.isEmpty(standNameCon.text)) {
                Toast.show('标准名不能为空');
                return;
              }
              if (StringUtils.isEmpty(relStrongCon.text)) {
                Toast.show('关联强度不能为空');
                return;
              } else {
                if (int.parse(relStrongCon.text) > 100) {
                  Toast.show('关联强度不能大于100');
                  return;
                }
              }
              Map<String, String> map = Map();
              if (list.length > 0) {
                for (var label in list) {
                  map[label.key] = label.value;
                }
              }

              int relNum = StringUtils.isNotEmpty(relTypeCon.text)
                  ? int.parse(relTypeCon.text)
                  : 0;
              int relStrong = StringUtils.isNotEmpty(relStrongCon.text)
                  ? int.parse(relStrongCon.text)
                  : 0;

              _model
                  .createRelation(standNameCon.text,
                      create_mode: flag,
                      target_concept_name: conceptNameCon.text,
                      rel_number: relNum,
                      score: relStrong,
                      data: json.encode(map))
                  .then((value) {
                if (value) {
                  Toast.show('创建关联成功');
                  NavigatorUtils.goBackWithParams(context, true);
                }
              });
            },
          )
        ],
      ),
      body: ProviderWidget<AddRelationModel>(
        model: AddRelationModel(widget.objName),
        onModelReady: (model) {},
        builder: (context, model, child) {
          _model = model;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                titleText('标准名'),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  color: MyColors.white,
                  height: 46,
                  child: TextField(
                    controller: standNameCon,
                    decoration: InputDecoration(
                        hintText: '输入标准名', border: InputBorder.none),
                  ),
                ),
                titleText('概念名'),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  color: MyColors.white,
                  height: 46,
                  child: TextField(
                    controller: conceptNameCon,
                    decoration: InputDecoration(
                        hintText: '输入概念名称', border: InputBorder.none),
                  ),
                ),
                titleText('关联类型'),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  color: MyColors.white,
                  height: 46,
                  child: TextField(
                      controller: relTypeCon,
                      decoration: InputDecoration(
                          hintText: '输入值', border: InputBorder.none),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ]),
                ),
                titleText('关联强度'),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  color: MyColors.white,
                  height: 46,
                  child: TextField(
                      controller: relStrongCon,
                      decoration: InputDecoration(
                          hintText: '输入值', border: InputBorder.none),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Text(
                                '是否双向关联',
                                style: TextStyle(
                                    color: MyColors.color_black, fontSize: 16),
                              ),
                              Text(
                                '(默认双向关联为否)',
                                style: TextStyle(
                                    color: MyColors.color_697796, fontSize: 16),
                              )
                            ],
                          )),
                      Switch(
                        value: flag,
                        activeColor: MyColors.app_main,
                        onChanged: (value) {
                          setState(() {
                            flag = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: AddRelationLabel(list: list),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('添加关联标签');
          showDialog(
              context: context,
              builder: (context) {
                return InputTitleDialog(
                  '属性名称',
                  '简介',
                  onConfirm: (title, content) {
                    list.add(ShortProperty(key: title, value: content));
                    setState(() {});
                  },
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  titleText(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
      child: Text(title),
    );
  }
}

class AddRelationLabel extends StatefulWidget {
  List<ShortProperty> list;

  AddRelationLabel({this.list});

  @override
  AddRelationLabelState createState() => new AddRelationLabelState();
}

class AddRelationLabelState extends State<AddRelationLabel> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      children: _labelWidgets(widget.list),
    );
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

                      widget.list.remove(label);
                      setState(() {});
                    },
                  );
                });
          },
        ));
      }
    }
    return widgets;
  }
}
