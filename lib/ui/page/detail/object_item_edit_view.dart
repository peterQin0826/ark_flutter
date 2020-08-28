import 'dart:async';
import 'dart:convert';

import 'package:ark/bean/eventbus/event_bus.dart';
import 'package:ark/bean/eventbus/event_obj.dart';
import 'package:ark/bean/expanded_data_bean.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/search_result_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/image_video_list_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/detail/info_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObjectItemEditView extends StatefulWidget {
  String objKey, proName;
  Dt dt;

  ObjectItemEditView(this.objKey, this.proName, this.dt);

  @override
  ObjectItemEditViewState createState() => new ObjectItemEditViewState();
}

class ObjectItemEditViewState extends State<ObjectItemEditView> {
  TextEditingController titleController = new TextEditingController();
  TextStyle style = TextStyle(color: MyColors.color_697796, fontSize: 16);
  int _searchPos = -1;
  StreamSubscription _streamSubscription;
  CommonProListModel _currentModel;

  @override
  Widget build(BuildContext context) {
    DetailProModel detailProModel =
        Provider.of<DetailProModel>(context, listen: false);

    return ProviderWidget<CommonProListModel>(
      model: CommonProListModel(widget.objKey, widget.proName),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('编辑'),
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {
                  _request(model, detailProModel);
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: MyColors.white,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        '标题',
                        style: style,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: titleController,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '简介',
                          style: style,
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        ShortProperty short = widget.dt.infos[index];
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
                                      _searchPos = index;
                                      Navigator.pushNamed(
                                          context, RouteName.smart_Search,
                                          arguments: [
                                            valueController.text,
                                            null,
                                            Constant.object_replace_value
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
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.dt.infos.length,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: MyColors.color_F1F2F6,
                          borderRadius: BorderRadius.circular(5)),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            width: 100,
                            height: 100,
                            child: CachedNetworkImage(
                              imageUrl: widget.dt.expandedDataBean.image,
                              fit: BoxFit.cover,
                              placeholder: (context, img) {
                                return Image.asset(
                                    Utils.getImgPath(Constant.empty_view));
                              },
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
                                    widget.dt.expandedDataBean.objName,
                                    style: TextStyle(
                                        color: MyColors.color_black,
                                        fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.dt.expandedDataBean.summary,
                                    style:
                                        TextStyle(color: MyColors.color_8F9091),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateUtils.formatDateMsByYMDHM(widget.dt.time),
                          style: TextStyle(
                              color: MyColors.color_AEAEAE, fontSize: 10),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: MyColors.white,
                              border: Border.all(
                                  color: MyColors.color_f5f5f5, width: 1)),
                          child: Center(
                            child: Text(widget.dt.expandedDataBean.conceptName),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(
                    context, RouteName.smart_Search,
                    arguments: [
                      null,
                      null,
                      Constant.object_replace_object
                    ]);
              },
              child: Container(
                height: 40,
                margin:
                    EdgeInsets.only(left: 40, right: 40, bottom: 10, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyColors.color_1246FF),
                child: Center(
                  child: Text(
                    '替换引用对象',
                    style: TextStyle(fontSize: 16, color: MyColors.white),
                  ),
                ),
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
    super.initState();
    _streamSubscription = eventBus.on<EventObj>().listen((event) {
      setState(() {
        print('替换引用对象');
        switch (event.event) {
          case Event.search_key:
            SearchResultData _data = event.data;
            String objKey = _data.basicData.objKey;
//            print('eventbus 接收到的消息：$objKey  ==>  点击的位置:${_searchPos>=0}');
            if (_searchPos >= 0) {
              ShortProperty short = widget.dt.infos[_searchPos];
              short.value = objKey;
            }
            break;
          case Event.replace_object:

            SearchResultData addData = event.data;
            widget.dt.expandedDataBean.objName = addData.basicData.objName;
            widget.dt.expandedDataBean.image = addData.basicData.image;
            widget.dt.expandedDataBean.summary = addData.basicData.summary;
            widget.dt.expandedDataBean.conceptName =
                addData.basicData.conceptName;
            widget.dt.content = addData.basicData.objKey;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _request(CommonProListModel model, DetailProModel detailProModel) {
    Map<String, String> map = new Map();

    if (widget.dt.infos != null && widget.dt.infos.length > 0) {
      for (var short in widget.dt.infos) {
        if (short.key.isNotEmpty) map[short.key] = short.value;
      }
    }
    print('组装数据 ${json.encode(widget.dt.infos)}');
    String _info = json.encode(map);

    if (widget.proName.isNotEmpty) {
      widget.dt.title = titleController.text;
      widget.dt.info = _info;
      widget.dt.time = DateUtils.currentTimeMillis();
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
      /// 新建属性    eventbus 传递到上个页面

    }
  }
}
