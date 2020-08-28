import 'dart:convert';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/image_video_list_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/confirmDialog.dart';
import 'package:ark/widgets/detail/object_item.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ObjectListEditView extends StatefulWidget {
  String objKey;
  String proName;
  String na;

  ObjectListEditView(this.objKey, this.proName, this.na);

  @override
  ObjectListEditViewState createState() => new ObjectListEditViewState();
}

class ObjectListEditViewState extends State<ObjectListEditView> {
  TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);
  TextEditingController proController = TextEditingController();
  TextEditingController naController = TextEditingController();
  TextEditingController posController = TextEditingController();
  DetailProModel _detailProModel;

  @override
  Widget build(BuildContext context) {
    String title = null != widget.proName ? '引用列表编辑' : '引用列表创建';
    _detailProModel = Provider.of<DetailProModel>(context, listen: false);
    CommonProListModel _currentModel;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {
              if (widget.proName.isNotEmpty) {
                print('编辑');
                _currentModel
                    .propertyEdit(
                        naController.text, StringUtils.isNotEmpty(posController.text)
                    ? int.parse(posController.text)
                    : -1)
                    .then((value) {
                  if (value) {
                    Toast.show('属性编辑成功');
                    _detailProModel.updateListProNa(widget.proName,
                        naController.text, StringUtils.isNotEmpty(posController.text)
                            ? int.parse(posController.text)
                            : -1);
                  }
                });
              } else {
                print('新建');
                _currentModel
                    .createListPro(proController.text, naController.text,
                        Constant.txt_ctp, json.encode(_currentModel.list))
                    .then((value) {
                  if (value) {
                    Toast.show('创建成功');
                    NavigatorUtils.goBackWithParams(context, true);
                  }
                });
              }
            },
          )
        ],
      ),
      body: ProviderWidget<CommonProListModel>(
        model: CommonProListModel(widget.objKey, widget.proName),
        onModelReady: (model) {
          if (StringUtils.isNotEmpty(widget.proName)) {
            model.initData();
          }
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
              onPressed: () {
                model.initData();
              },
            );
          }
          _currentModel = model;
          return Flex(
            direction: Axis.vertical,
            children: <Widget>[
              _topTitle(),
              Expanded(flex: 1, child: _listView(model))
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: GestureDetector(
          onTap: () {
            _showDialog(context, _currentModel);
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 40, right: 40,bottom: 10,top: 10),
            decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyColors.color_1246FF, width: 1)),
            child: Center(
              child: Text(
                '删除',
                style: TextStyle(fontSize: 16, color: MyColors.color_1246FF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    proController.text=widget.proName;
    naController.text=widget.na;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _topTitle() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              controller: proController,
              decoration: InputDecoration(
                  hintText: '区域名称',
                  enabled: widget.proName.isEmpty ? true : false),
              style: style,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: naController,
                style: style,
                decoration: InputDecoration(
                  hintText: '别称',
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            child: TextField(
              controller: posController,
              decoration: InputDecoration(
                hintText: '位置',
              ),
              style: style,
            ),
          )
        ],
      ),
    );
  }

  _listView(CommonProListModel model) {
    return SmartRefresher(
      controller: model.refreshController,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: RefresherFooter(),
      onRefresh: model.refresh,
      onLoading: () {
        model.loadMore(total: model.propertyListBean.total);
      },
      child: ListView.builder(
          itemBuilder: (context, index) {
            Dt object = model.list[index];
            return Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 0.25,
              child: ObjectItem(object, widget.objKey, widget.proName),
              secondaryActions: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 50,
                    height: 100,
                    color: MyColors.color_FE3B30,
                    child: Center(
                      child: Text(
                        '删除',
                        style: TextStyle(color: MyColors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    List<num> idLis = List();
                    idLis.add(object.id);
                    model.deleteItem(json.encode(idLis)).then((value) {
                      if (value) {
                        model.list.removeAt(index);
                        _detailProModel.deleteListItem(
                            object.id, widget.proName);
                      }
                    });

                    setState(() {});
                  },
                )
              ],
            );
          },
          itemCount: model.list.length),
    );
  }

  void _showDialog(BuildContext context, CommonProListModel currentModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('确定删除当前属性？'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('取消'),
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  currentModel.deletePro().then((value) {
                    if (value) {
                      Toast.show('删除属性成功');
                      _detailProModel.deleteListPro(widget.proName);
                      NavigatorUtils.goBack(context);
                    }
                  });
                },
              )
            ],
          );
        });
  }
}
