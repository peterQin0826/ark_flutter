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
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/detail/time_item.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'detail_template_view.dart';

class TimeListEditView extends StatefulWidget {
  String objKey;
  String proName;
  String na;

  TimeListEditView(this.objKey, this.proName, this.na);

  @override
  TimeListState createState() => new TimeListState();
}

class TimeListState extends State<TimeListEditView> {
  TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);
  TextEditingController proController = TextEditingController();
  TextEditingController naController = TextEditingController();
  TextEditingController posController = TextEditingController();
  DetailProModel _detailProModel;

  @override
  Widget build(BuildContext context) {
    String title = null != widget.proName ? '时间列表编辑' : '时间列表创建';
    _detailProModel = Provider.of<DetailProModel>(context, listen: false);
    CommonProListModel _currentModel;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        centerTitle: true,
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
                    .createListPro(
                    proController.text,
                    naController.text,
                    Constant.txt_ctp,
                    json.encode(_currentModel.list))
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
          if (StringUtils.isNotEmpty(widget.proName)) model.initData();
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
              onPressed: ()  {
                model.initData();
              },
            );
          }
          _currentModel = model;
          return Flex(
            direction: Axis.vertical,
            children: <Widget>[_topTitle(), _listView(model)],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 60,
          padding: EdgeInsets.all(10),
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              widget.proName.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailTemplate(type: 'time');
                        }));
                      },
                      child: Image.asset(
                        Utils.getImgPath('unknow'),
                        width: 30,
                        height: 30,
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),

              ///控制显示的控件
              Offstage(
                offstage: widget.proName == null,
                child: Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 38,
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: MyColors.color_1246FF, width: 1)),
                      child: Center(
                        child: Text(
                          '上传文件',
                          style: TextStyle(
                              color: MyColors.color_1246FF, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
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
                                  _currentModel.deletePro().then((value) {
                                    if (value) {
                                      Toast.show('删除属性成功');
                                      _detailProModel
                                          .deleteListPro(widget.proName);
                                      NavigatorUtils.goBack(context);
                                    }
                                  });
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: MyColors.white,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: MyColors.color_1246FF, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          '删除',
                          style: TextStyle(
                              color: MyColors.color_1246FF, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () {
                      print('添加');
                      _currentModel.list.add(Dt(
                          time: DateUtils.currentTimeMillis(),
                          content: '',
                          info: '',
                          title: ''));
                      setState(() {});
                    },
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: MyColors.color_1246FF,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          '添加',
                          style: TextStyle(color: MyColors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    proController.text = widget.proName;
    naController.text = widget.na;
    super.initState();
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
    return Expanded(
      flex: 1,
      child: SmartRefresher(
        controller: model.refreshController,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: RefresherFooter(),
        onRefresh: model.refresh,
        onLoading: () {
          model.loadMore(total: model.propertyListBean.total);
        },
        child: ListView.separated(
          itemCount: model.list.length,
          itemBuilder: (context, index) {
            Dt time = model.list[index];
            return Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 0.25,
              child: TimeItem(time, widget.objKey, widget.proName),
              secondaryActions: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 50,
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
                    idLis.add(time.id);
                    model.deleteItem(json.encode(idLis)).then((value) {
                      if (value) {
                        model.list.removeAt(index);
                        _detailProModel.deleteListItem(time.id, widget.proName);
                      }
                    });

                    setState(() {});
                  },
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 10,
              color: MyColors.color_EAEBEF,
            );
          },
        ),
      ),
    );
  }
}
