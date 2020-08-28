import 'dart:convert';
import 'dart:ui';

import 'package:ark/base/application.dart';
import 'package:ark/bean/coin_market_model.dart';
import 'package:ark/bean/eventbus/event_bus.dart';
import 'package:ark/bean/eventbus/event_obj.dart';
import 'package:ark/bean/search_result_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/search_result_model.dart';
import 'package:ark/model/text_list_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchResultView extends StatefulWidget {
  String _text;
  String keyName;

  String objKey;
  String from;

  SearchResultView(this._text, this.from, this.objKey, this.keyName);

  @override
  SearchResultViewState createState() => new SearchResultViewState();
}

class SearchResultViewState extends State<SearchResultView> {
  SearchResultData _data;
  EventBus _eventBus;

  @override
  Widget build(BuildContext context) {
    String popPage;
    Event _event;
    if (widget.from == Constant.text_replace_value) {
      popPage = RouteName.text_list_item_edit_view;
      _event = Event.search_key;
    } else if (widget.from == Constant.object_replace_object) {
      popPage = RouteName.object_item_edit_view;
      _event = Event.replace_object;
    } else if (widget.from == Constant.object_replace_value) {
      popPage = RouteName.object_item_edit_view;
      _event = Event.search_key;
    }

    return ProviderWidget<SearchResultModel>(
      model: new SearchResultModel(widget._text),
      onModelReady: (model) {
        model.initData();
      },
      builder: (context, model, child) {
        if (model.isBusy) {
          return SkeletonList(
            builder: (context, index) => ArkSkeletonItem(),
          );
        } else if (model.isError && model.list.isEmpty) {
          return ViewStateErrorWidget(
            error: model.viewStateError,
            onPressed: model.initData(),
          );
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(
            onPressed: model.initData(),
          );
        }
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('搜索结果页面'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {
                  if (_data == null) {
                    Toast.show('请先选择');
                    return;
                  }
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('是否添加所选内容？'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('取消'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                Navigator.of(context).pop('好的');
                                EventObj eventObj = EventObj(_event, _data);
                                eventBus.fire(eventObj);
                                print(
                                    'eventbus 发送数据:${json.encode(eventObj.data)}');
                                Navigator.popUntil(
                                    context, ModalRoute.withName(popPage));
                              },
                            )
                          ],
                        );
                      });
                },
              )
            ],
          ),
          body: SmartRefresher(
            enablePullUp: true,
            footer: RefresherFooter(),
            controller: model.refreshController,
            onLoading: () {
              model.loadMore(total: model.resultBean.total);
            },
            child: ListView.separated(
                itemBuilder: (context, position) {
                  if (model.list != null && model.list.length > 0) {
                    SearchResultData data = model.list[position];
                    return Container(
                      padding: EdgeInsets.only(top: 13, bottom: 9),
                      color: MyColors.white,
                      child: CheckboxListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.basicData.objName,
                              style: TextStyle(
                                  color: MyColors.color_black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '主键：',
                                  style: TextStyle(
                                      color: MyColors.color_585D7B,
                                      fontSize: 12),
                                ),
                                Text(
                                  data.basicData.objKey,
                                  style: TextStyle(
                                      color: MyColors.color_1246FF,
                                      fontSize: 12),
                                ),
                                Expanded(
                                  child: SizedBox.shrink(),
                                ),
                                Container(
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyColors.color_f5f5f5),
                                  child: Center(
                                    child: Text(
                                      data.basicData.conceptName,
                                      style: TextStyle(
                                          color: MyColors.color_585D7B,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        data.basicData.summary,
                                        style: TextStyle(
                                            color: MyColors.color_989CB6,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: data.basicData.image,
                                      fit: BoxFit.cover,
                                      placeholder: (context, img) {
                                        return Image.asset(
                                            Utils.getImgPath('img_empty'));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '更：${data.basicData.updateTime}',
                                    style: TextStyle(
                                        color: MyColors.color_989CB6,
                                        fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '修：${data.basicData.mtime}',
                                    style: TextStyle(
                                        color: MyColors.color_989CB6,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        isThreeLine: false,
                        dense: true,
                        selected: true,
                        value: data.basicData.isSelected,
                        controlAffinity: ListTileControlAffinity.platform,
                        activeColor: Colors.greenAccent,
                        onChanged: (value) {
                          model.updateCheckState(data.basicData.objKey, value);
                          if (value) {
                            _data = data;
                          } else {
                            _data = null;
                          }
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('暂无数据'),
                    );
                  }
                },
                separatorBuilder: (context, position) {
                  return Divider(
                    height: 1,
                    color: MyColors.color_EAEBEF,
                  );
                },
                itemCount: model.list.length),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _eventBus = new EventBus();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
