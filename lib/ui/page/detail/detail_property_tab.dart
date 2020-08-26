import 'dart:ui';

import 'package:ark/bean/number_key_value_bean.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/generated/l10n.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/page/detail/shortPro_edit_view.dart';
import 'package:ark/ui/page/test_video.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/detail/horizontal_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'bftable_edit_view.dart';
import 'bmtable_edit_view.dart';

class DetailPropertyTab extends StatefulWidget {
  String objKey;
  String conceptName;

  DetailPropertyTab({@required this.objKey, @required this.conceptName});

  @override
  DetailPropertyTabState createState() => new DetailPropertyTabState();
}

DetailProModel model;

class DetailPropertyTabState extends State<DetailPropertyTab>
    with AutomaticKeepAliveClientMixin {
  Divider divider = Divider(
    height: 1,
    color: MyColors.color_c5c6ca,
  );

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetailProModel model = Provider.of<DetailProModel>(context, listen: false);
//    model.getProList(widget.objKey, widget.conceptName);
//    return ProviderWidget<DetailProModel>(
//      model: Provider.of<DetailProModel>(context, listen: false),
//      onModelReady: (model) {
////        model.getProList(widget.objKey, widget.conceptName);
//      },
//      builder: (context, model, child) {
    if (model.isBusy) {
      return ViewStateBusyWidget();
    } else if (model.isError) {
      return ViewStateErrorWidget(error: model.viewStateError);
    } else if (model.propertyList.length == 0) {
      return ViewStateEmptyWidget(
        onPressed: () async {
          await model.getProList(widget.objKey, widget.conceptName);
          setState(() {});
        },
      );
    }
    print('详情页==》${model.propertyList.length}  ${model.key}');
    return CustomScrollView(
      shrinkWrap: true,
      slivers: _ScrollItem(model),
    );
//      },
//    );
  }

  List<Widget> _ScrollItem(DetailProModel model) {
    List<Widget> list = List();
    if (model.propertyList.isNotEmpty) {
      for (var property in model.propertyList) {
        switch (property.itemType) {
          case 0:
            list.add(_ShortProItem(property));
            break;
          case 1:
            list.add(_BmTableProItem(property));
            break;
          case 2:
            list.add(_BfTableProItem(property));
            break;
          case 3:
            list.add(_TxtProItem(property));
            break;
          case 4:
            list.add(_ImageProItem(property));
            break;
          case 5:
            list.add(_VideoProItem(property));
            break;
          case 6:
            list.add(_ObjectProItem(property));
            break;
          case 7:
            list.add(_TimeProItem(property));
            break;
          case 8:
            list.add(_FileProItem(property));
            break;
        }
      }
    }
    return list;
  }

  /// 短属性区
  _ShortProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            TitleRow(
              title: '短文本区',
              type: 0,
              objKey: widget.objKey,
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: property.shortProperties.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 13, right: 15, top: 5, bottom: 5),
                    child: KeyValue(
                      shortProperty: property.shortProperties[index],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  /// BmTable 区域
  Widget _BmTableProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.bmTableBean.propertyName,
                    type: 1,
                    total: property.bmTableBean.total,
                    objKey: widget.objKey,
                    property: property,
                  ),

                  /// 这两个可以合为一个组件
                  AkaEditWidget(
                    aka: property.bmTableBean.na,
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: property.bmTableBean.bmDatas.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 15,
                    ),
                    child: KeyValue(
                      shortProperty: property.bmTableBean.bmDatas[position],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  /// BfTable 区域
  Widget _BfTableProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.bfTableBean.propertyName,
                    type: 2,
                    total: property.bfTableBean.total,
                    objKey: widget.objKey,
                    property: property,
                  ),
                  AkaEditWidget(
                    aka: property.bfTableBean.na,
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: property.bfTableBean.bfDatas.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 15,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: KeyNumberValue(
                        numberKeyValueBean:
                            property.bfTableBean.bfDatas[position],
                      ),
                    ),
                  );
                }),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: divider,
            ),
          ],
        ),
      ),
    );
  }

  /// 文本区域
  Widget _TxtProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.propertyName,
                    type: 3,
                    total: property.total,
                    objKey: widget.objKey,
                    property: property,
                  ),
                  AkaEditWidget(
                    aka: ((null != property.data) ? property.data.na : ""),
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: property.data.dt.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 15,
                    ),
                    child: TxtListWidget(
                      dt: property.data.dt[position],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  /// 图片区域
  Widget _ImageProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.propertyName,
                    type: 4,
                    total: property.total,
                    objKey: widget.objKey,
                    property: property,
                  ),
                  AkaEditWidget(
                    aka: ((null != property.data) ? property.data.na : ""),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: property.data.dt.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: <Widget>[_ImageItem(property.data.dt[index])],
                ),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 图片list的布局
  Widget _ImageItem(Dt dt) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: MyColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: ImageUtils.getImgUrl(dt.content),
                fit: BoxFit.cover,
                placeholder: (context, img) => CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Offstage(
                  offstage: null != dt.title,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      dt.title,
                      style: TextStyle(
                        color: MyColors.color_040404,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),

                Utils.getIndexName(dt.info, 3).isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          Utils.getIndexName(dt.info, 3),
                          style: TextStyle(
                              color: MyColors.color_585D7B, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ))
                    : Container(
                        width: 0,
                        height: 0,
                      ),

                /// 时间没有格式化
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    DateUtils.formatDateMsByYMDHM(dt.time),
                    style:
                        TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 视频  区域
  Widget _VideoProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: MyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10, top: 15),
                    child: Column(
                      children: <Widget>[
                        TitleRow(
                          title: property.propertyName,
                          type: 5,
                          total: property.total,
                          objKey: widget.objKey,
                          property: property,
                        ),
                        AkaEditWidget(
                          aka:
                              ((null != property.data) ? property.data.na : ""),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: property.data.dt.length,
                      itemBuilder: (context, position) {
                        Dt video = property.data.dt[position];
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    child: Hero(
                                      tag: video,
                                      child: CachedNetworkImage(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          imageUrl: ImageUtils.getImgUrl(
                                              video.content +
                                                  Constant.videoCover),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                Utils.getImgPath('img_empty'),
                                                fit: BoxFit.cover,
                                              )),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  Positioned(
                                    left:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    top: 80,
                                    width: 45,
                                    height: 45,
                                    child: Image.asset(
                                        Utils.getImgPath('jz_play_normal')),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    null != property.data.dt[position].title
                                        ? Text(
                                            property.data.dt[position].title,
                                            style: TextStyle(
                                                color: MyColors.color_040404,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container(
                                            width: 0,
                                            height: 0,
                                          ),
                                    Image.asset(
                                      Utils.getImgPath('img_file_download'),
                                      width: 18,
                                      height: 19,
                                    )
                                  ],
                                ),
                              ),
                              Utils.getIndexName(
                                          property.data.dt[position].info, 3)
                                      .isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        Utils.getIndexName(
                                            property.data.dt[position].info, 3),
                                        style: TextStyle(
                                            color: MyColors.color_585D7B,
                                            fontSize: 12),
                                      ),
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 10),
                                child: Text(
                                  DateUtils.formatDateMsByYMDHM(
                                      property.data.dt[position].time),
                                  style:
                                      TextStyle(color: MyColors.color_B2B5C0),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, posirion) {
                        return divider;
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 引用列表类型 区域
  Widget _ObjectProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: MyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.propertyName,
                    type: 6,
                    total: property.total,
                    objKey: widget.objKey,
                    property: property,
                  ),
                  AkaEditWidget(
                    aka: ((null != property.data) ? property.data.na : ""),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: property.data.dt.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                return ObjectItem(property.data.dt[position]);
              },
              separatorBuilder: (context, position) {
                return divider;
              },
            )
          ],
        ),
      ),
    );
  }

  /// 时间列表类型 区域
  Widget _TimeProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: MyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.propertyName,
                    type: 7,
                    total: property.total,
                    objKey: widget.objKey,
                    property: property,
                  ),
                  AkaEditWidget(
                    aka: ((null != property.data) ? property.data.na : ""),
                  ),
                ],
              ),
            ),
            getHoizontalChart(property)
          ],
        ),
      ),
    );
  }

  /// 文件列表类型 区域
  Widget _FileProItem(PropertyListBean property) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: MyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: property.propertyName,
                    type: 8,
                    total: property.total,
                    objKey: widget.objKey,
                    property: property,
                  ),
                  AkaEditWidget(
                    aka: ((null != property.data) ? property.data.na : ""),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: property.data.dt.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                return _fileItem(property.data.dt[position]);
              },
              separatorBuilder: (context, position) {
                return divider;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget ObjectItem(Dt dt) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dt.title.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    dt.title,
                    style:
                        TextStyle(color: MyColors.color_040404, fontSize: 14),
                  ),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          dt.infos.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 11),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dt.infos.length,
                      itemBuilder: (context, position) {
                        return KeyValue(shortProperty: dt.infos[position]);
                      }),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          Container(
            color: MyColors.color_f5f5f5,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 5),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/img_empty.png',
                    image: ImageUtils.getImgUrl(dt.expandedDataBean.image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dt.expandedDataBean.objName,
                          style: TextStyle(
                              color: MyColors.color_090909, fontSize: 14),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            dt.expandedDataBean.summary,
                            style: TextStyle(
                                color: MyColors.color_585D7B, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateUtils.formatDateMsByYMDHM(dt.time),
                  style: TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: MyColors.color_f5f5f5),
                  child: Text(
                    dt.expandedDataBean.conceptName,
                    style:
                        TextStyle(color: MyColors.color_989CB6, fontSize: 11),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getHoizontalChart(PropertyListBean property) {
    return HorizontalChart(
      property: property,
    );
  }

  Widget _fileItem(Dt dt) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: ImageUtils.getAssetImage(
                ImageUtils.getFileResource(Utils.getIndexName(dt.info, 1))),
            width: 19,
            height: 19,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      dt.title + '.' + Utils.getIndexName(dt.info, 1),
                      style:
                          TextStyle(color: MyColors.color_black, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      Utils.getIndexName(dt.info, 3),
                      style:
                          TextStyle(color: MyColors.color_6E757C, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateUtils.formatDateMsByYMDHM(dt.time),
                          style: TextStyle(
                              color: MyColors.color_6E757C, fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            Utils.getIndexName(dt.info, 2),
                            style: TextStyle(
                                color: MyColors.color_6E757C, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<Widget> getData() async {
   await Provider.of<DetailProModel>(context, listen: false)
        .getProList(widget.objKey, widget.conceptName);
   setState(() {

   });
  }
}

class TxtListWidget extends StatelessWidget {
  Dt dt;

  TxtListWidget({@required this.dt});

  @override
  Widget build(BuildContext context) {
    print(' time --> ${dt.time}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            dt.title,
            style: TextStyle(
                color: MyColors.color_black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: dt.infos.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, position) {
              return KeyValue(shortProperty: dt.infos[position]);
            }),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            dt.content,
            style: TextStyle(color: MyColors.color_6E757C, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            DateUtils.formatDateMsByYMDHM(dt.time),
            style: TextStyle(color: MyColors.color_697796, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class TitleRow extends StatelessWidget {
  String title;
  int total;
  int type;
  String objKey;
  String na;
  PropertyListBean property;

  TitleRow(
      {@required this.title,
      this.total,
      this.type,
      @required this.objKey,
      @required this.property});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Image.asset(
                Utils.getImgPath('pro_title'),
                width: 3,
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: TextStyle(
                      color: MyColors.color_black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              print('点击位置 $type');
              switch (type) {
                case 0:
                  NavigatorUtils.gotoShortProEdit(context, objKey);
                  break;
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BmTableEditView(
                      objKey: objKey,
                      proName: title,
                      na: property.bmTableBean.na,
                    );
                  }));
                  break;
                case 2:
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BfTableEditView(
                        objKey, property.bfTableBean.na, title);
                  }));
                  break;
                case 3:
                  Navigator.pushNamed(context, RouteName.text_list_edit_view,
                      arguments: [objKey, title, property.data.na]);
                  break;
                case 4:
                  Navigator.pushNamed(context, RouteName.img_video_edit,
                      arguments: [
                        objKey,
                        title,
                        property.data.na,
                        Constant.image
                      ]);
                  break;
                case 5:
                  Navigator.pushNamed(context, RouteName.img_video_edit,
                      arguments: [
                        objKey,
                        title,
                        property.data.na,
                        Constant.video
                      ]);
                  break;
                case 8:
                  Navigator.pushNamed(context, RouteName.file_edit_view,
                      arguments: [objKey, title, property.data.na]);
                  break;
              }
            },
            child: Row(
              children: <Widget>[
                _showTotal(),
                Text(
                  '编辑',
                  style: TextStyle(color: MyColors.color_697796, fontSize: 14),
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
          ),
        ),
      ],
    );
  }

  Widget _showTotal() {
    String _totalString;
    switch (type) {
      case 1:
        _totalString = '文本映射';
        break;
      case 2:
        _totalString = '数值映射';
        break;
      case 3:
        _totalString = '文本列表';
        break;
      case 4:
        _totalString = '图片列表';
        break;
      case 5:
        _totalString = '视频列表';
        break;
      case 6:
        _totalString = '引用列表';
        break;
      case 7:
        _totalString = '时间列表';
        break;
      case 8:
        _totalString = '文件列表';
        break;
    }
    return type > 0
        ? Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '${_totalString + '\t\t' + total.toString()}',
              style: TextStyle(color: MyColors.color_697796, fontSize: 14),
            ),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }
}

class KeyValue extends StatelessWidget {
  ShortProperty shortProperty;
  NumberKeyValueBean numberKeyValueBean;

  KeyValue({@required this.shortProperty, this.numberKeyValueBean});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Container(
          width: 84,
          child: Text(
            (null != shortProperty)
                ? shortProperty.key
                : numberKeyValueBean.key,
            style: TextStyle(color: MyColors.color_black, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              (null != shortProperty)
                  ? shortProperty.value
                  : numberKeyValueBean.value.toString(),
              style: TextStyle(color: MyColors.color_6E757C, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}

class KeyNumberValue extends StatelessWidget {
  NumberKeyValueBean numberKeyValueBean;

  KeyNumberValue({this.numberKeyValueBean});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            numberKeyValueBean.key,
            style: TextStyle(color: MyColors.color_black, fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Container(
          width: 84,
          margin: EdgeInsets.only(left: 10),
          child: Text(
            numberKeyValueBean.value.toString(),
            style: TextStyle(color: MyColors.color_6E757C, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class AkaEditWidget extends StatelessWidget {
  String aka;

  ///别称
  AkaEditWidget({@required this.aka});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 13, top: 4, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            '别称：' + aka,
            style: TextStyle(color: MyColors.color_2E333C, fontSize: 14),
          ),
          Spacer(
            flex: 1,
          ),
          Text(
            '筛选',
            style: TextStyle(color: MyColors.color_1246FF, fontSize: 14),
          )
        ],
      ),
    );
  }
}
