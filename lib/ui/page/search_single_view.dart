import 'dart:convert';

import 'package:ark/bean/search_result_bean.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/smart_search_model.dart';
import 'package:ark/model/text_list_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SingleSearchView extends StatefulWidget {
  String keyName;
  String objKey;
  String from;

  /// todo 构造函数需要改进
  SingleSearchView(this.keyName, this.objKey, this.from);

  @override
  SingleSearchViewState createState() => new SingleSearchViewState();
}

class SingleSearchViewState extends State<SingleSearchView> {
  int _total = 0;
  SearchResultData _data;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('模糊搜索'),
        centerTitle: true,
      ),
      body: ProviderWidget<SmartSearchModel>(
        model: SmartSearchModel(),
        onModelReady: (model) {},
        builder: (context, model, child) {
          if (model.searchBean != null) {
            _total += model.searchBean.data.length;
            print('列表的长度 $_total');
          }
          return Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: MyColors.color_F0F3FE),
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    autofocus: true,
                    onChanged: (text) {
                      print('object==>$text');
                      model.setText(text);
                      model.initData();
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SmartRefresher(
                  controller: model.refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: RefresherFooter(),
                  onLoading: () {
                    model.loadMore(
                        total: model.searchBean != null ? _total : 0);
                  },
                  child: ListView.separated(
                      itemBuilder: (context, position) {
                        String name = model.list[position];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteName.search_result, arguments: [
                              name,
                              widget.keyName,
                              widget.objKey,
                              widget.from
                            ]).then((value) {
                              if (value != null) {
                                print('接收到的数据${json.encode(value)}');
                              }
                              _data = value;
                            });

//                            Navigator.pushNamed(context, RouteName.checkbox);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
                            child: Text(
                              name,
                              style: TextStyle(
                                  color: MyColors.color_black, fontSize: 16),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, position) {
                        return Divider(
                          height: 1,
                          color: MyColors.color_EAEBEF,
                        );
                      },
                      itemCount: model.list.length),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
