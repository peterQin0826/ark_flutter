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
import 'package:ark/widgets/detail/detail_tab/bftable_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/bmtable_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/file_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/image_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/object_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/time_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/txt_pro_tab.dart';
import 'package:ark/widgets/detail/detail_tab/video_pro_tab.dart';
import 'package:ark/widgets/detail/horizontal_chart.dart';
import 'package:ark/widgets/detail/detail_tab/short_pro_tab.dart';
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

    print('详情页更新====> ${model.propertyList.length}');

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
    return CustomScrollView(
      shrinkWrap: true,
      slivers: _ScrollItem(model),
    );
  }

  List<Widget> _ScrollItem(DetailProModel model) {
    List<Widget> list = List();
    if (model.propertyList.isNotEmpty) {
      for (var property in model.propertyList) {
        switch (property.itemType) {
          case 0:
            list.add(ShortProTab(property, widget.objKey));
            break;
          case 1:
            list.add(BmTableProTab(property, widget.objKey));
            break;
          case 2:
            list.add(BfTableProTab(property, widget.objKey));
            break;
          case 3:
            list.add(TxtProTab(property, widget.objKey));
            break;
          case 4:
            list.add(ImageProTab(property, widget.objKey));
            break;
          case 5:
            list.add(VideoProTab(property, widget.objKey));
            break;
          case 6:
            list.add(ObjectProTab(property, widget.objKey));
            break;
          case 7:
            list.add(TimeProTab(property, widget.objKey));
            break;
          case 8:
            list.add(FileProTab(property, widget.objKey));
            break;
        }
      }
    }
    return list;
  }

  @override
  bool get wantKeepAlive => true;

  Future<Widget> getData() async {
    await Provider.of<DetailProModel>(context, listen: false)
        .getProList(widget.objKey, widget.conceptName);
    setState(() {});
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
//                  Navigator.push(context, MaterialPageRoute(builder: (context) {
//                    return BmTableEditView(
//                      objKey: objKey,
//                      proName: title,
//                      na: property.bmTableBean.na,
//                    );
//                  }));
                  Navigator.pushNamed(context, RouteName.bm_edit_view,
                      arguments: [objKey, title, property.bmTableBean.na]);

                  break;
                case 2:
                  Navigator.pushNamed(context, RouteName.bf_edit_view,
                      arguments: [objKey, property.bfTableBean.na, title]);
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
                case 6:
                  Navigator.pushNamed(context, RouteName.object_edit,
                      arguments: [objKey, title, property.data.na]);
                  break;
                case 7:
                  Navigator.pushNamed(context, RouteName.time_edit,
                      arguments: [objKey, title, property.data.na]);
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
