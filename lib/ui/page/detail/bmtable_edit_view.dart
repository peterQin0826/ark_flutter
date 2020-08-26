import 'dart:convert';

import 'package:ark/bean/short_property.dart';
import 'package:ark/model/bmtable_model.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bmtable_item_edit_view.dart';
import 'detail_template_view.dart';

class BmTableEditView extends StatefulWidget {
  String objKey;
  String na;
  String proName;

  BmTableEditView({this.objKey, this.na, this.proName});

  @override
  BmTableEditViewState createState() => new BmTableEditViewState();
}

TextEditingController proNameController, naController, posController;


class BmTableEditViewState extends State<BmTableEditView> {
  TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    DetailProModel detailProModel = Provider.of<DetailProModel>(context, listen: false);
    print('object');
    return ProviderWidget<BmTableModel>(
      model: BmTableModel(objKey: widget.objKey, proName: widget.proName),
      onModelReady: (model) => model.initData(),
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

        return Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: new Text(
                widget.proName.isNotEmpty ? 'BmTable编辑页' : 'BmTable新建页'),
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '确定',
                  style: TextStyle(color: MyColors.white, fontSize: 16),
                ),
                onPressed: () {
                  if (widget.proName.isNotEmpty) {
                    print('编辑');
                  } else {
                    print('新建');
                  }
                },
              )
            ],
          ),
          body: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                height: 40,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: proNameController,
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
              ),
              Flexible(
                flex: 1,
                child: SmartRefresher(
                  controller: model.refreshController,
                  header: WaterDropHeader(),
                  footer: RefresherFooter(),
                  onRefresh: model.refresh,
                  onLoading: () {
                    model.loadMore(total: model.bmTableBean.total);
                  },
                  enablePullUp: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: model.list.length,
                    itemBuilder: (context, position) {
                      ShortProperty short = model.list[position];

                      return Slidable(
                        actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.25,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BmTableItemEdit(
                                objKey: widget.objKey,
                                proName: widget.proName,
                                short: short,
                              );
                            })).then((value) {
                              if (null != value) {
                                short.key = value.key;
                                short.value = value.value;
                                setState(() {});
                              }
                            });
                          },
                          child: Container(
                            color: MyColors.white,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Container(
                                    width: 84,
                                    child: Text(
                                      short.key,
                                      style: TextStyle(
                                          color: MyColors.color_black,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10),
                                      child: Text(
                                        short.value,
                                        style: TextStyle(
                                            color: MyColors.color_black,
                                            fontSize: 16),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 50,
                              color: MyColors.color_FE3B30,
                              child: Center(
                                child: Text(
                                  '删除',
                                  style: TextStyle(
                                      color: MyColors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (short.key.isNotEmpty) {
                                List<String> list = List();
                                list.add(short.key);
                                print('===>${json.encode(list)}');
                                model
                                    .deleteItem(json.encode(list))
                                    .then((value) {
                                  if (value) {
                                    model.list.removeAt(position);
                                    detailProModel.deleteBmTableProItem(
                                        widget.proName, short.key);
                                    setState(() {});
                                  }
                                });
                              } else {
                                model.list.removeAt(position);
                                setState(() {});
                              }
                              Toast.show('删除成功');
                            },
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, position) {
                      return Divider(
                        color: MyColors.color_c5c6ca,
                        height: 1,
                      );
                    },
                  ),
                ),
              ),
            ],
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
                              return DetailTemplate(type: 'bm');
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
                  widget.proName.isNotEmpty
                      ? Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Container(
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
                                      color: MyColors.color_1246FF,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 0,
                          height: 0,
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
                                      model.deletePro().then((value) {
                                        if (true) {
                                          Toast.show('属性删除成功');
                                          Navigator.of(context).pop(true);
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
                            border: Border.all(
                                color: MyColors.color_1246FF, width: 1),
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
                          model.list.add(ShortProperty(key: '', value: ''));
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
                              style: TextStyle(
                                  color: MyColors.white, fontSize: 18),
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
      },
    );
  }

  @override
  void initState() {
    proNameController = TextEditingController();
    proNameController.text = widget.proName;

    naController = TextEditingController();
    naController.text = widget.na;
    super.initState();
  }

  @override
  void dispose() {
    proNameController.dispose();
    naController.dispose();
    posController.dispose();
    super.dispose();
  }
}
