import 'package:ark/bean/short_property.dart';
import 'package:ark/model/detail_model.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/short_pro_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class ShortProItemEdit extends StatefulWidget {
  String objKey;
  ShortProperty short;

  ShortProItemEdit({@required this.short, this.objKey});

  @override
  ShortProItemEditState createState() => new ShortProItemEditState();
}

TextStyle keyStyle = TextStyle(color: MyColors.color_697796, fontSize: 16);
TextStyle valueStyle = TextStyle(color: MyColors.color_black, fontSize: 16);

class ShortProItemEditState extends State<ShortProItemEdit> {
  TextEditingController keyController;
  TextEditingController valueController;


  @override
  Widget build(BuildContext context) {
    DetailProModel detailProModel = Provider.of<DetailProModel>(
        context, listen: false);

    return ProviderWidget<ShortProModel>(
      model: ShortProModel(),
      onModelReady: (model) => {},
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.color_page_background,
          appBar: AppBar(
            title: Text(null != widget.short ? '短标签编辑' : '添加短标签'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {
                  print('短标签${widget.key}');
                  null != widget.short.key
                      ? model
                          .shortProEdit(widget.objKey, keyController.text,
                              valueController.text)
                          .then((value) {
                          if (value) {
                            detailProModel.updateShortPro(keyController.text,valueController.text, false);
                            Toast.show('更新成功');
                            ShortProperty short=new ShortProperty();
                            short.key=keyController.text;
                            short.value=valueController.text;
                            NavigatorUtils.goBackWithParams(context, short);
                          }
                        })
                      : model
                          .shortProAdd(widget.objKey, keyController.text,
                              valueController.text)
                          .then((value) {
                          if (value) {
                            detailProModel.updateShortPro(keyController.text,valueController.text, true);
                            Toast.show('添加成功');
                            ShortProperty short=new ShortProperty();
                            short.key=keyController.text;
                            short.value=valueController.text;
                            NavigatorUtils.goBackWithParams(context, short);
                          }
                        });
                },
              ),
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
                                enabled: null != widget.short && widget.short.key!=null ? false : true),
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
    keyController = TextEditingController();
    keyController.text = widget.short.key;
    valueController = TextEditingController();
    valueController.text = widget.short.value;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    keyController.dispose();
    valueController.dispose();
    super.dispose();
  }
}
