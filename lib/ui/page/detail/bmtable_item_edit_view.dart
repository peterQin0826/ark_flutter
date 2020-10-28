import 'dart:convert';

import 'package:ark/bean/number_key_value_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/model/bmtable_model.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmTableItemEdit extends StatefulWidget {
  String objKey, proName;
  NumberKeyValueBean numberKeyValueBean;
  ShortProperty short;

  BmTableItemEdit(
      {@required this.objKey,
      this.proName,
      this.numberKeyValueBean,
      this.short});

  @override
  BmTableItemEditState createState() => new BmTableItemEditState();
}

TextStyle keyStyle = TextStyle(color: MyColors.color_697796, fontSize: 16);
TextStyle valueStyle = TextStyle(color: MyColors.color_black, fontSize: 16);

TextEditingController keyController = TextEditingController();
TextEditingController valueController = TextEditingController();

class BmTableItemEditState extends State<BmTableItemEdit> {
  @override
  Widget build(BuildContext context) {
    DetailProModel detailProModel =
        Provider.of<DetailProModel>(context, listen: false);

    return ProviderWidget<BmTableModel>(
      model: BmTableModel(objKey: widget.objKey, proName: widget.proName),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text('BmTable编辑页'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {
                  if (widget.numberKeyValueBean != null) {
                    Map<String, String> map = new Map();
                    if (keyController.text.isEmpty) {
                      Toast.show('key值不能为空');
                      return;
                    }
                  } else {
                    if (keyController.text.isEmpty) {
                      Toast.show('key值不能为空');
                      return;
                    }
                    Map<String, String> map = new Map();
                    map[keyController.text] = valueController.text;

                    if (StringUtils.isNotEmpty(widget.proName)) {
                      model.editItem(json.encode(map)).then((value) {
                        if (value) {
                          if (widget.short.key.isNotEmpty) {
                            Toast.show('更新成功');
                            detailProModel.updateBmtableItem(
                                widget.proName,
                                keyController.text,
                                valueController.text,
                                false);
                          } else {
                            Toast.show('添加成功');
                            detailProModel.updateBmtableItem(widget.proName,
                                keyController.text, valueController.text, true);
                          }

                          ShortProperty short = new ShortProperty();
                          short.key = keyController.text;
                          short.value = valueController.text;
                          NavigatorUtils.goBackWithParams(context, short);
                        } else {
                          Toast.show('更新失败');
                        }
                      });
                    } else {
                      ShortProperty short = new ShortProperty();
                      short.key = keyController.text;
                      short.value = valueController.text;
                      NavigatorUtils.goBackWithParams(context, short);
                    }
                  }
                },
              )
            ],
          ),
          body: Container(
            color: MyColors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
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
                          child: TextField(
                            autofocus: true,
                            controller: keyController,
                            decoration: InputDecoration(
                                labelStyle: valueStyle,
                                enabled:
                                    widget.short.key.isNotEmpty ? false : true),
                          ),
                        ),
                      )
                    ],
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
                          child: TextField(
                            controller: valueController,
                            decoration: InputDecoration(labelStyle: valueStyle),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.short != null) {
      keyController.text = widget.short.key;
      valueController.text = widget.short.value;
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
