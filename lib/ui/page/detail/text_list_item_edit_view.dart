import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:ark/bean/eventbus/event_bus.dart';
import 'package:ark/bean/eventbus/event_obj.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/search_result_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/common/api_constant.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/text_list_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class TextListItemEditView extends StatefulWidget {
  String objKey, proName;
  Dt dt;

  TextListItemEditView(this.objKey, this.proName, this.dt);

  @override
  TextListItemEditViewState createState() => new TextListItemEditViewState();
}

TextEditingController titleController = new TextEditingController();
TextEditingController contentController = new TextEditingController();

class TextListItemEditViewState extends State<TextListItemEditView> {
  StreamSubscription _streamSubscription;
  int _searchPos = -1;
  String _clickKey;

  DetailProModel detailProModel;

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TextListModel>(
      model: TextListModel(widget.objKey, widget.proName),
      onModelReady: (model) {},
      builder: (context, model, position) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('编辑'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {
                  _request(model);
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 15, right: 15),
              color: MyColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Text(
                          '标题',
                          style: TextStyle(
                              color: MyColors.color_697796, fontSize: 16),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: titleController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: MyColors.color_EAEBEF,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Text(
                          '时间',
                          style: TextStyle(
                              color: MyColors.color_697796, fontSize: 16),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              DateUtils.formatDateMsByYMDHM(widget.dt.time),
                              style: TextStyle(
                                  color: MyColors.color_7b7878, fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: MyColors.color_EAEBEF,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            '简介',
                            style: TextStyle(
                                color: MyColors.color_697796, fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.dt.infos == null) {
                              List<ShortProperty> infos = List();
                              widget.dt.infos = infos;
                            }
                            widget.dt.infos
                                .add(ShortProperty(key: '', value: ''));

                            ///刷新
                            setState(() {});
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyColors.color_1246FF),
                            child: Center(
                              child: Text(
                                '添加',
                                style: TextStyle(
                                    color: MyColors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.dt.infos != null ? widget.dt.infos.length : 0,
                      itemBuilder: (context, position) {
                        ShortProperty short = widget.dt.infos[position];
                        TextEditingController keyController =
                            new TextEditingController();
                        keyController.text = short.key;
                        TextEditingController valueController =
                            new TextEditingController();
                        valueController.text = short.value;

                        return Container(
                          color: MyColors.white,
                          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    '键',
                                    style: TextStyle(
                                        color: MyColors.color_697796,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                        controller: keyController,
                                        enabled:
                                            short.key.isEmpty ? true : false,
                                        onChanged: (text) {
                                          short.key = text.toString();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text('值',
                                      style: TextStyle(
                                          color: MyColors.color_697796,
                                          fontSize: 16)),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TextField(
                                        controller: valueController,
                                        onChanged: (text) {
                                          short.value = text.toString();
                                        },
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _searchPos = position;
                                      _clickKey = keyController.text;
                                      Navigator.pushNamed(
                                          context, RouteName.smart_Search,
                                          arguments: [
                                            valueController.text,
                                            model,
                                            null,
                                            Constant.text_replace_value
                                          ]);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 40,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: MyColors.color_1246FF),
                                      child: Center(
                                        child: Text(
                                          '搜索',
                                          style:
                                              TextStyle(color: MyColors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                  Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        '内容',
                        style: TextStyle(
                            color: MyColors.color_697796, fontSize: 16),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 5),
                          child: TextField(
                            controller: contentController,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    titleController.text = widget.dt.title;
    contentController.text = widget.dt.content;
    detailProModel = Provider.of<DetailProModel>(context, listen: false);
    super.initState();
    _streamSubscription = eventBus.on<EventObj>().listen((event) {
      setState(() {
        print('========eventbus==========');
        switch (event.event) {
          case Event.search_key:
            SearchResultData _data = event.data;
            String objKey = _data.basicData.objKey;
            print('eventbus 接收到的消息：$objKey  ==>  点击的位置:$_searchPos');
            if (_searchPos > 0) {
              ShortProperty short = widget.dt.infos[_searchPos];
              short.value = objKey;
              short.key = _clickKey;
            }

            break;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  void _request(TextListModel model) {
    if (contentController.text.isEmpty) {
      Toast.show('内容不能为空');
      return;
    }
    Map<String, String> map = new Map();

    if (widget.dt.infos != null && widget.dt.infos.length > 0) {
      for (var short in widget.dt.infos) {
        map[short.key] = short.value;
      }
    }
    print(
        '组装数据 ${json.encode(widget.dt.infos)}');
    String _info = json.encode(map);


    if (widget.proName.isNotEmpty) {

      if (widget.dt.content.isNotEmpty) {

        widget.dt.content = contentController.text;
        widget.dt.title = titleController.text;
        widget.dt.info = _info;


        print('==========更新===========');

        /// 更新
        List<Dt> list = List();
        list.add(widget.dt);
        model.propertyUnitEdit(json.encode(list)).then((value) {
          if (value) {
            Toast.show('更新成功');
            detailProModel.updateProListItem(widget.dt, widget.proName, false);
            NavigatorUtils.goBackWithParams(context, widget.dt);
          }
        });
      } else {
        widget.dt.content = contentController.text;
        widget.dt.title = titleController.text;
        widget.dt.info = _info;

        /// 添加
        print('==========添加===========');
        model
            .propertyUnitAdd(contentController.text, titleController.text,
                _info, widget.dt.time)
            .then((value) {
          print('添加成功之后返回的id 为 $value');
          Toast.show('添加成功');
          widget.dt.id = value;
          detailProModel.updateProListItem(widget.dt, widget.proName, true);
          NavigatorUtils.goBackWithParams(context, widget.dt);
        });
      }
    } else {
      /// 新建属性    eventbus 传递到上个页面

    }
  }
}
