

import 'package:ark/bean/basic_detail_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/popup.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_tabbar_view.dart';
import 'dart:math' as math;

/// 对象详情页
class ObjectDetailView extends StatefulWidget {
  final String objKey;

  const ObjectDetailView({this.objKey});

  @override
  ObjectDetailViewState createState() => new ObjectDetailViewState();
}

class ObjectDetailViewState extends State<ObjectDetailView>
    with SingleTickerProviderStateMixin {
  var tabBar;
  DetailModel _detailModel;

  @override
  void initState() {
    tabBar = _DetailPageTabBarState();
    tabList = _getTabList();
    _tabController = TabController(vsync: this, length: tabTxt.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                NavigatorUtils.goBack(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: MyColors.white,
              )),
          title: Text(
            '概念详情',
            style: TextStyle(color: MyColors.white, fontSize: 18),
          ),
          actions: <Widget>[
            IconButton(
              icon: Text(
                '新增',
                style: TextStyle(color: MyColors.white, fontSize: 16),
              ),
              onPressed: () {
                String objKey = _detailModel.basicDetailBean.basicDict.objKey;
                List<String> list = List();
                list.add('短标签');
                list.add('文本列表');
                list.add('数值映射表');
                list.add('文本映射表');
                list.add('引用列表');
                list.add('视频列表');
                list.add('图片列表');
                list.add('时间列表');
                list.add('文件列表');
                Navigator.push(
                    context,
                    PopRoute(
                      child: Popup(
                        data: list,
                        right: 15,
                        top: 40,
                        onClick: (name) {
                          _clickPosName(name);
                        },
                      ),
                    ));
              },
            )
          ],
        ),
        body: ProviderWidget<DetailModel>(
          model: DetailModel(objKey: widget.objKey),
          onModelReady: (model) => model.getBasicInfo(),
          builder: (context, model, child) {
            _detailModel = model;
            if (model.isBusy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              child: SafeArea(
                child: DefaultTabController(
                  length: tabTxt.length,
                  child: _getNestScrollView(model),
                ),
              ),
            );
          },
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _getTabList() {
    return tabTxt
        .map((item) => Text(
              '$item',
              style: TextStyle(fontSize: 15),
            ))
        .toList();
  }

  _getNestScrollView(DetailModel model) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: _basicInfoView(model),
          ),
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: _SliverAppBarDelegate(
                maxHeight: 50,
                minHeight: 50,
                child: Container(
                  color: MyColors.white,
                  child: tabBar,
                )),
          )
        ];
      },
      body: DetailTabBarView(
        tabController: _tabController,
        objKey: model.basicDetailBean.basicDict.objKey,
        conceptName: model.basicDetailBean.basicDict.conceptName,
        objName: model.basicDetailBean.basicDict.objName,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _clickPosName(String name) {
    switch (name) {
      case '短标签':
        Navigator.pushNamed(context, RouteName.short_pro_edit,
            arguments: [widget.objKey]);
        break;
      case '文本列表':
        Navigator.pushNamed(context, RouteName.text_list_edit_view,
            arguments: [widget.objKey, '', '']);
        break;
      case '数值映射表':
        Navigator.pushNamed(context, RouteName.bf_edit_view,
            arguments: [widget.objKey, '', '']);
        break;
      case '文本映射表':
        Navigator.pushNamed(context, RouteName.bm_edit_view,
            arguments: [widget.objKey, '', '']);
        break;
      case '引用列表':
        break;
      case '视频列表':
        Navigator.pushNamed(context, RouteName.img_video_edit,
            arguments: [widget.objKey, '', '', Constant.video]);
        break;
      case '图片列表':
        Navigator.pushNamed(context, RouteName.img_video_edit,
            arguments: [widget.objKey, '', '', Constant.image]);
        break;
      case '时间列表':
        Navigator.pushNamed(context, RouteName.time_edit,
            arguments: [widget.objKey, '', '']);
        break;
      case '文件列表':
        Navigator.pushNamed(context, RouteName.file_edit_view,
            arguments: [widget.objKey, '', '']);
        break;
    }
  }
}

/// 构建头部信息
_basicInfoView(DetailModel model) {
  return Container(
    color: MyColors.white,
    padding: EdgeInsets.only(top: 23, left: 15, right: 15),
    child: Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              CachedNetworkImage(
                placeholder: (context, img) {
                  return Image.asset(
                    Utils.getImgPath('app_icon'),
                    width: 100,
                    height: 100,
                  );
                },
                errorWidget: (context,img,obj){
                  return Image.asset(
                    Utils.getImgPath('app_icon'),
                    width: 100,
                    height: 100,
                  );
                },
                imageUrl: ImageUtils.getImgUrl(
                    model.basicDetailBean.basicDict.image),
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
              Positioned(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: 20,
                    width: 100,
                    color: MyColors.color_black,
                    child: Center(
                      child: Text(
                        model.basicDetailBean.basicDict.objKey,
                        style: TextStyle(color: MyColors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      model.basicDetailBean.basicDict.objName,
                      style: TextStyle(
                          fontSize: 18,
                          color: MyColors.color_black,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Image(
                      image: ImageUtils.getAssetImage('edit_img'),
                      width: 18,
                      height: 18,
                    )
                  ],
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      model.basicDetailBean.basicDict.aka,
                      style: TextStyle(
                        color: MyColors.color_black,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    model.basicDetailBean.basicDict.summary,
                    style:
                        TextStyle(color: MyColors.color_6E757C, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max((minHeight ?? kToolbarHeight), minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

final List<String> tabTxt = [' 属性 ', '关联对象'];
List<Widget> tabList;
TabController _tabController;

class _DetailPageTabBarState extends StatefulWidget {
  @override
  _DetailPageTabBarStateState createState() =>
      new _DetailPageTabBarStateState();
}

class _DetailPageTabBarStateState extends State<_DetailPageTabBarState> {
  Color selectColor, unselectedColor;
  TextStyle selectStyle, unselectedStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: TabBar(
                  tabs: tabList,
                  isScrollable: false,
                  labelPadding: EdgeInsets.all(10),
                  controller: _tabController,
                  indicatorColor: MyColors.color_1246FF,
                  indicatorWeight: 1,
                  labelColor: selectColor,
                  labelStyle: selectStyle,
//                  indicator: const BoxDecoration(),/// 如果不显示indicator  添加此行代码
                  unselectedLabelColor: unselectedColor,
                  unselectedLabelStyle: unselectedStyle,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectColor = MyColors.text;
    unselectedColor = MyColors.text_gray;
    selectStyle = TextStyle(
        fontSize: 22, color: selectColor, fontWeight: FontWeight.bold);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
  }

  @override
  void dispose() {
    super.dispose();
  }
}