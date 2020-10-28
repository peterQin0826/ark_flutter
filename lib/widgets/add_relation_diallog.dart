import 'dart:convert';

import 'package:ark/bean/short_property.dart';
import 'package:ark/model/search_result_model.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/add_relation_page.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRelationDialog extends StatefulWidget {
  Function(int relNum, int score, bool createMode, String data) onConfirm;

  AddRelationDialog({this.onConfirm});

  @override
  AddRelationDialogState createState() => new AddRelationDialogState();
}

class AddRelationDialogState extends State<AddRelationDialog> {
  TextEditingController typeController = TextEditingController();
  TextEditingController strongController = TextEditingController();
  bool _flag = false;
  List<ShortProperty> list = List();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        alignment: Alignment.centerLeft,
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 30,
                child: Flex(
                  direction: Axis.horizontal,
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '关联类型',
                        style: TextStyle(
                            color: MyColors.color_black, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: MyColors.color_black, width: 0.5)),
                        child: TextField(
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                                hintText: '输入值',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 12)),
                            controller: typeController,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        '关联强度',
                        style: TextStyle(
                            color: MyColors.color_black, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: MyColors.color_black, width: 0.5)),
                        child: TextField(
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                                hintText: '输入值',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 12)),
                            controller: strongController,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
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
                                  color: MyColors.color_black, fontSize: 10),
                            ),
                            Text(
                              '(默认双向关联为否)',
                              style: TextStyle(
                                  color: MyColors.color_697796, fontSize: 10),
                            )
                          ],
                        )),
                    Switch(
                      value: _flag,
                      activeColor: MyColors.app_main,
                      onChanged: (value) {
                        setState(() {
                          _flag = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: LabelWidget(
                  list: list,
                  isAdd: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('确定'),
          onPressed: () {
            if (StringUtils.isEmpty(strongController.text)) {
              Toast.show('关联强度不能为空');
              return;
            } else {
              if (int.parse(strongController.text) > 100) {
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

            int relNum = StringUtils.isNotEmpty(typeController.text)
                ? int.parse(typeController.text)
                : 0;
            int relStrong = StringUtils.isNotEmpty(strongController.text)
                ? int.parse(strongController.text)
                : 0;
            if (widget.onConfirm != null) {
              widget.onConfirm(relNum, relStrong, _flag, json.encode(map));
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
