
import 'dart:convert';

import 'package:ark/bean/number_key_value_bean.dart';
import 'package:ark/model/bftable_model.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BfTableItemEditView extends StatefulWidget {

  String objKey, proName;
  NumberKeyValueBean numberKeyValueBean;


  BfTableItemEditView(this.objKey, this.proName, this.numberKeyValueBean);

  @override
  BfTableItemEditViewState createState() => new BfTableItemEditViewState();
}

TextStyle keyStyle = TextStyle(color: MyColors.color_697796, fontSize: 16);
TextStyle valueStyle = TextStyle(color: MyColors.color_black, fontSize: 16);
TextEditingController keyController = TextEditingController();
TextEditingController valueController = TextEditingController();

class BfTableItemEditViewState extends State<BfTableItemEditView> {
  @override
  Widget build(BuildContext context) {

    DetailProModel detailProModel =
    Provider.of<DetailProModel>(context, listen: false);

    return ProviderWidget<BfTableModel>(
      model: BfTableModel(widget.objKey,widget.proName),
      onModelReady: (model){},
      builder: (context,model,child){
        return Scaffold(
          appBar: new AppBar(
            title: new Text('BfTable编辑页'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {

                    if (keyController.text.isEmpty) {
                      Toast.show('key值不能为空');
                      return;
                    }
                    Map<String, num> map = new Map();
                    map[keyController.text] = num.parse(valueController.text);

                    model.editItem(json.encode(map)).then((value) {
                      if (value) {
                        if (widget.numberKeyValueBean.key.isNotEmpty) {
                          Toast.show('更新成功');
                          detailProModel.updateBfTableItem(widget.proName,
                              keyController.text, num.parse(valueController.text), false);
                        } else {
                          Toast.show('添加成功');
                          detailProModel.updateBfTableItem(widget.proName,
                              keyController.text, num.parse(valueController.text), true);
                        }

                        NumberKeyValueBean numKeyValue = new NumberKeyValueBean();
                        numKeyValue.key = keyController.text;
                        numKeyValue.value = num.parse(valueController.text);
                        NavigatorUtils.goBackWithParams(context, numKeyValue);
                      } else {
                        Toast.show('更新失败');
                      }
                    });

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
                                widget.numberKeyValueBean.key.isNotEmpty
                                    ? false
                                    : true),
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
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
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
    if (widget.numberKeyValueBean != null) {
      keyController.text = widget.numberKeyValueBean.key;
      valueController.text = widget.numberKeyValueBean.value.toString();
    }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

}