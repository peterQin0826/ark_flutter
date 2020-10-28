import 'dart:convert';
import 'dart:ui';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/text_list_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:ark/ui/page/detail/text_list_item_edit_view.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/detail/image_video_item.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'detail_template_view.dart';

class TextListEditView extends StatefulWidget {
  String objKey;
  String proName;
  String na;

  TextListEditView(this.objKey, this.proName, this.na);

  @override
  ListTextEditViewState createState() => new ListTextEditViewState();
}

TextEditingController proNameController, naController, posController;
DetailProModel detailProModel;

class ListTextEditViewState extends State<TextListEditView> {
  TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);

  TextListModel textListModel;

  @override
  Widget build(BuildContext context) {
    print('文本列表：==》${widget.proName.isNotEmpty}');
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(widget.proName.isNotEmpty ? '文本列表编辑' : '文本列表添加'),
          actions: <Widget>[
            IconButton(
              icon: Text(
                '确定',
                style: TextStyle(color: MyColors.white, fontSize: 16),
              ),
              onPressed: () {
                if (widget.proName.isNotEmpty) {
//                      print(
//                          '编辑========= ${StringUtils.isNotEmpty(posController.text) ? int.parse(posController.text) : -1}');
                  textListModel
                      .propertyEdit(
                          naController.text,
                          StringUtils.isNotEmpty(posController.text)
                              ? int.parse(posController.text)
                              : -1)
                      .then((value) {
                    if (value) {
                      Toast.show('属性编辑成功');
                      detailProModel.updateListProNa(
                          widget.proName,
                          naController.text,
                          StringUtils.isNotEmpty(posController.text)
                              ? int.parse(posController.text)
                              : -1);
                    }
                  });
                } else {
                  print('新建');
                  String data = json.encode(textListModel.list);
                  print('===========> ${data}');
                  textListModel
                      .createListPro(proNameController.text, naController.text,
                          Constant.txt_ctp, data)
                      .then((value) {
                    if (value) {
                      Toast.show('创建成功');
                      detailProModel.addListPro(proNameController.text,naController.text,Constant.txt_list_pro,list: textListModel.list);
                      NavigatorUtils.goBackWithParams(context, true);
                    }
                  });
                }
              },
            )
          ],
        ),
        body: ProviderWidget<TextListModel>(
          model: TextListModel(widget.objKey, widget.proName),
          onModelReady: (model) {
            if (widget.proName.isNotEmpty) {
              model.initData();
            }
          },
          builder: (context, model, position) {
            textListModel = model;
            return Flex(
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          style: style,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SmartRefresher(
                    controller: model.refreshController,
                    header: WaterDropHeader(),
                    footer: RefresherFooter(),
                    onRefresh: () {
                      if (StringUtils.isNotEmpty(widget.proName)) {
                        model.refresh();
                      }
                    },
                    onLoading: () {
                      model.loadMore(total: model.propertyListBean.total);
                    },
                    enablePullUp: true,
                    child: ListView.builder(
                        itemCount: model.list.length,
                        itemBuilder: (context, position) {
                          Dt textContent = model.list[position];
                          return Slidable(
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.25,
                            child: GestureDetector(
                              onTap: () {
                                /// 可以删除栈中的多个路由
                                Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            settings: RouteSettings(
                                                name: RouteName
                                                    .text_list_item_edit_view),
                                            builder: (context) =>
                                                TextListItemEditView(
                                                    widget.objKey,
                                                    widget.proName,
                                                    textContent,
                                                    Constant.txt_ctp)))
                                    .then((value) {
                                  if (value != null) {
                                    Dt data = value;
                                    textContent.title = data.title;
                                    textContent.content = data.content;
                                    textContent.infos = data.infos;
                                    textContent.info = data.info;
                                    textContent.time = data.time;
                                    setState(() {});
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: MyColors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      textContent.title,
                                      style: TextStyle(
                                          color: MyColors.color_black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        DateUtils.formatDateMsByYMDHM(
                                            textContent.time),
                                        style: TextStyle(
                                            color: MyColors.color_C6CAD7),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '简介',
                                        style: TextStyle(
                                            color: MyColors.color_black,
                                            fontSize: 14),
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: textContent.infos != null
                                            ? textContent.infos.length
                                            : 0,
                                        itemBuilder: (context, position) {
                                          ShortProperty property =
                                              textContent.infos[position];
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                Container(
                                                  width: 84,
                                                  child: Text(
                                                    property.key,
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .color_black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      property.value,
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .color_6E757C,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        textContent.content,
                                        style: TextStyle(
                                            color: MyColors.color_black,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
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
                                  if (textContent.content.isNotEmpty) {
                                    List<num> idLis = List();
                                    idLis.add(textContent.id);
                                    model
                                        .deleteItem(json.encode(idLis))
                                        .then((value) {
                                      if (value) {
                                        model.list.removeAt(position);
                                        detailProModel.deleteListItem(
                                            textContent.id, widget.proName);
                                      }
                                    });
                                  } else {
                                    model.list.removeAt(position);
                                  }
                                  setState(() {});
                                },
                              )
                            ],
                          );
                        }),
                  ),
                ),
              ],
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
                            return DetailTemplate(type: 'txt');
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
                  offstage: widget.proName.isNotEmpty,
                  child: Expanded(
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
                                    textListModel.deletePro().then((value) {
                                      if (value) {
                                        Toast.show('删除属性成功');
                                        detailProModel
                                            .deleteListPro(widget.proName);
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
                        print('添加');
                        textListModel.list.add(Dt(
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
                            style:
                                TextStyle(color: MyColors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    proNameController = TextEditingController();
    proNameController.text = widget.proName;

    naController = TextEditingController();
    naController.text = widget.na;
    posController = TextEditingController();

    detailProModel = Provider.of<DetailProModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
