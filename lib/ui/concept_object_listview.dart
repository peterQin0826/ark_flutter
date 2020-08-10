import 'package:ark/bean/object_list_bean.dart';
import 'package:ark/model/object_list_new_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/theme_utils.dart';
import 'package:ark/utils/time_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'helper/refresh_helper.dart';

class ConceptObjectListView extends StatefulWidget {
  String code;

  ConceptObjectListView({this.code});

  @override
  ConceptObjectListViewState createState() => new ConceptObjectListViewState();
}

class ConceptObjectListViewState extends State<ConceptObjectListView> with AutomaticKeepAliveClientMixin{
  TextStyle titleStyle = TextStyle(color: MyColors.white, fontSize: 16);
  TextStyle topStyle = TextStyle(color: MyColors.color_black, fontSize: 16);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return
      ProviderWidget<ObjectListNewModel>(
        model: ObjectListNewModel(code: widget.code, rn: 30),
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
              automaticallyImplyLeading: false,
              title: Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Container(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.arrow_back_ios,color: MyColors.white,),
                          onTap: () {
                            NavigatorUtils.goBack(context);
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Container(
                              height: 34,
                              decoration: BoxDecoration(
                                  color: MyColors.white,
                                  borderRadius: BorderRadius.circular(17)),
                              child: GestureDetector(
                                onTap: () {
                                  print('点击了');
                                },
                                child: Container(
                                  height: 34,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Image.asset(
                                          Utils.getImgPath('main_search'),
                                          width: 15,
                                          height: 15,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(left: 5, right: 15),
                                        child: Text(
                                          '输入需要搜索的内容',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: MyColors.color_C6CAD7),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: GestureDetector(
                              onTap: () {
                                print('进入概念详情页面');
                                NavigatorUtils.gotoConceptDetail(context,model.objectListBean.code);
                              },
                              child: Text(
                                '概念',
                                style: titleStyle,
                              )),
                        ),
                        GestureDetector(
                            onTap: () {
                              print('新建的poppupWindow弹窗');
                            },
                            child: Text(
                              '新建',
                              style: titleStyle,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: SmartRefresher(
              controller: model.refreshController,
              header: WaterDropHeader(),
              footer: RefresherFooter(),
              onRefresh: model.refresh,
              onLoading: () {
                model.loadMore(total: model.objectListBean.numPages);
              },
              enablePullUp: true,
              child: ListView.builder(
                  itemCount: model.list.length,
                  itemBuilder: (context, index) {
                    Data data = model.list[index];
                    return _item(data);
                  }),
            ),
          );
        },
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _item(Data data) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        NavigatorUtils.gotoObjectDetail(context, data.objKey);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(right: 15, left: 15, top: 20),
        child: Column(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data.objName,
                          style: TextStyle(
                              color: MyColors.color_040404, fontSize: 15),
                        ),
                        Container(
                          padding:  EdgeInsets.only(top: 8),
                          child: Text(
                            data.aka,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.color_585D7B, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            data.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.color_989CB6, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      image: ImageUtils.getImgUrl(data.image),
                      placeholder: 'assets/images/img_empty.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 15, bottom: 12),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      data.objKey,
                      style:
                      TextStyle(color: MyColors.color_1246FF, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '更：${TimeUtils.getFromHourToSecondString(data.updateTime)}',
                      style:
                      TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '修：${TimeUtils.getFromHourToSecondString(data.mtime)}',
                      style:
                      TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '更：${TimeUtils.getFromHourToSecondString(data.ctime)}',
                      style:
                      TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
