import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:ark/bean/conceptRelationList.dart';
import 'package:ark/bean/eventbus/event_bus.dart';
import 'package:ark/bean/eventbus/event_obj.dart';
import 'package:ark/bean/page_bean.dart';
import 'package:ark/bean/relation_all_bean.dart';
import 'package:ark/bean/search_result_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_model.dart';
import 'package:ark/model/relation_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/muliti_select_choice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DetailRelationTab extends StatefulWidget {
  String objKey;
  String objName;

  DetailRelationTab(this.objKey, this.objName);

  @override
  DetailRelationTabState createState() => new DetailRelationTabState();
}

class DetailRelationTabState extends State<DetailRelationTab>
    with AutomaticKeepAliveClientMixin {
  List<RelationTabData> _selectedList = List();
  StreamSubscription _streamSubscription;
  RelationModel _model;

  String _type = '清空';
  bool _isClear = false;
  String _groupByRule = 'concept_and_type';
  String _groupString = '按照概念分组';
  Map<String, Object> _map;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ProviderWidget<RelationModel>(
        model: RelationModel(widget.objKey),
        onModelReady: (model) {
          model.getAllRelation();
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!_isClear) {
            _selectedList.addAll(model.allBean.data);
          }
          _model = model;
//          print('获取标签=================>${_selectedList.length}');
          return Column(
//            direction: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print('切换分组');
                        if (_groupByRule == 'concept_and_type') {
                          _groupByRule = 'img_relation_type';
                          _groupString = '按照关联分组';
                        } else {
                          _groupByRule = 'concept_and_type';
                          _groupString = '按照概念分组';
                        }
                        setState(() {});
                        requestData(model);
                      },
                      child: Container(
                        height: 24,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.white),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                Utils.getImgPath('img_relation_type'),
                                width: 9,
                                height: 11,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                  _groupString,
                                  style: TextStyle(
                                      color: MyColors.color_697796,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('新增关联');
                        Navigator.pushNamed(
                            context, RouteName.single_add_relation,
                            arguments: [widget.objName]).then((value) {
                          if (value) {
                            model.getAllRelation();
                          }
                        });
                      },
                      child: Container(
                        height: 24,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.white),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                Utils.getImgPath('relation_add_blue'),
                                width: 14,
                                height: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  '新增关联',
                                  style: TextStyle(
                                      color: MyColors.color_697796,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('搜索关联');
                        Navigator.pushNamed(context, RouteName.smart_Search,
                            arguments: [
                              '',
                              widget.objKey,
                              Constant.add_relation
                            ]);
                      },
                      child: Container(
                        height: 24,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.white),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                Utils.getImgPath('relation_search_blue'),
                                width: 14,
                                height: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  '搜索关联',
                                  style: TextStyle(
                                      color: MyColors.color_697796,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                          onTap: () async {
                            if (_type == '清空') {
                              _isClear = true;
                              _selectedList.clear();
                              _type = '全选';
                            } else if (_type == '全选') {
                              _type = '清空';
//                              _isClear = false;
                              _selectedList.addAll(model.allBean.data);
                            }
                            setState(() {});

                            requestData(model);
                          },
                          child: Text(
                            _type,
                            style: TextStyle(
                                fontSize: 16, color: MyColors.color_1246FF),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: MultiSelectChip(
                  model.allBean.data,
                  selectList: _selectedList,
                  onSelectionChanged: (selectedList) {
//                    print('点击查看 ${json.encode(selectedList)}');
                    print(
                        '点击查看 ${_selectedList.length}  ===> ${selectedList.length}');
                    requestData(model);
                  },
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.conceptRelationList.data.length,
                  itemBuilder: (context, index) {
                    Data relation = model.conceptRelationList.data[index];

                    Map<String, PageBean> map = Map();
                    String target = '';
                    if (_groupByRule == 'img_relation_type') {
                      if (_selectedList != null && _selectedList.length > 0) {
                        for (var select in _selectedList) {
                          PageBean page = PageBean();
                          page.pn = 1;
                          page.rn = 100;
                          map[select.conceptName] = page;
                        }
                      }
                      target = json.encode(_selectedList);
                    } else {
                      List<RelationTabData> targets = List();
                      RelationTabData data = RelationTabData();
                      data.conceptName = relation.targetConceptName;
                      data.projectName = relation.targetProjectName;
                      data.number = 0;
                      targets.add(data);
                      PageBean page = PageBean();
                      page.pn = 1;
                      page.rn = 100;
                      map[data.conceptName] = page;
                      target = json.encode(targets);
                    }

                    return RelationItem(relation, model, widget.objKey, target,
                        _groupByRule, json.encode(map));
                  })
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription = eventBus.on<EventObj>().listen((event) {
      setState(() {
        switch (event.event) {
          case Event.add_relation:
            print('刷新关联页面');

            SearchResultData _data = event.data;
            if (_data != null && _model != null) {
              _model.getAllRelation();
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

  void requestData(RelationModel model) {
    List<RelationTabData> tabDatas = List();
    _map = Map();
    print('清空${_selectedList.length}');
    if (_selectedList != null && _selectedList.length > 0) {
      for (var bean in _selectedList) {
        tabDatas.add(bean);
        PageBean pageBean = PageBean();
        pageBean.pn = 1;
        pageBean.rn = 15;
        _map[bean.conceptName] = pageBean;
      }
    } else {
      _map['pn'] = 1;
      _map['rn'] = 15;
    }

    model.objectRelated(
        json.encode(_selectedList), _groupByRule, json.encode(_map));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class RelationItem extends StatefulWidget {
  Data relation;
  RelationModel model;
  String objKey;
  String targetConcepts;
  String groupByRule;
  String pageRules;

  RelationItem(this.relation, this.model, this.objKey, this.targetConcepts,
      this.groupByRule, this.pageRules);

  @override
  RelationItemState createState() => new RelationItemState();
}

class RelationItemState extends State<RelationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      color: MyColors.white,
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Image.asset(
                Utils.getImgPath('pro_title'),
                width: 3,
                height: 25,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    StringUtils.isNotEmpty(widget.relation.targetConceptName)
                        ? widget.relation.targetConceptName +
                            '(' +
                            widget.relation.targetProjectName +
                            ')' +
                            widget.relation.total.toString()
                        : '',
                    style: TextStyle(color: MyColors.color_black, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.relation_edit,
                      arguments: [
                        widget.objKey,
                        widget.targetConcepts,
                        widget.groupByRule,
                        widget.pageRules
                      ]);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '编辑',
                    style:
                        TextStyle(color: MyColors.color_697796, fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Image.asset(
                  Utils.getImgPath('click_in_grey'),
                  width: 8,
                  height: 14,
                ),
              )
            ],
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.relation.group.length,
              itemBuilder: (context, index) {
                Group group = widget.relation.group[index];

                return GroupItem(group, widget.model);
              }),
        ],
      ),
    );
  }
}

class GroupItem extends StatefulWidget {
  Group group;
  RelationModel model;

  GroupItem(this.group, this.model);

  @override
  GroupItemState createState() => new GroupItemState();
}

class GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.group.objects.length,
            itemBuilder: (context, index) {
              Objects objects = widget.group.objects[index];
              return GroupItemItem(objects);
            }),
        Offstage(
          offstage: widget.group.total < 15,
          child: GestureDetector(
            onTap: () {
              print('请求更多数据');
            },
            child: Container(
              height: 30,
              child: Center(
                child: Image.asset(
                  Utils.getImgPath('realtion_loadmore'),
                  width: 35,
                  height: 29,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class GroupItemItem extends StatefulWidget {
  Objects object;

  GroupItemItem(this.object);

  @override
  GroupItemItemState createState() => new GroupItemItemState();
}

class GroupItemItemState extends State<GroupItemItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.object.basicData.objName,
            style: TextStyle(
                color: MyColors.color_black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.object.basicData.objKey,
                    style:
                        TextStyle(color: MyColors.color_106AFF, fontSize: 12),
                  ),
                ),
                Text(
                  '强度：${widget.object.relatedData.score}',
                  style: TextStyle(color: MyColors.color_697796, fontSize: 12),
                ),
                Text('类型：${widget.object.relatedData.relNumber}'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Offstage(
                    offstage:
                        StringUtils.isEmpty(widget.object.basicData.summary),
                    child: Text(
                      widget.object.basicData.summary,
                      style: TextStyle(
                        color: MyColors.color_6E757C,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
                Offstage(
                  offstage: StringUtils.isEmpty(widget.object.basicData.image),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      placeholder: (context, img) {
                        return Image.asset(
                          Utils.getImgPath(Constant.empty_view),
                          width: 70,
                          height: 70,
                        );
                      },
                      width: 70,
                      height: 70,
                      imageUrl:
                          ImageUtils.getImgUrl(widget.object.basicData.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '更：${widget.object.basicData.updateTime}',
                  style: TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                ),
                Text('修：${widget.object.basicData.mtime}',
                    style:
                        TextStyle(color: MyColors.color_989CB6, fontSize: 10))
              ],
            ),
          )
        ],
      ),
    );
  }
}
