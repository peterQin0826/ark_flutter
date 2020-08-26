import 'package:ark/bean/project_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/net/net.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/res/dimens.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectListPage extends StatefulWidget {
  @override
  ProjectListPageState createState() => new ProjectListPageState();
}

class ProjectListPageState extends State<ProjectListPage> {
  List<ProjectModel> mDatas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.keyboard_voice),
        title: Container(
          height: 34,
          decoration: BoxDecoration(
              color: MyColors.white, borderRadius: BorderRadius.circular(17)),
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
                      width: 12,
                      height: 12,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      '请输入需要搜索的内容',
                      style:
                          TextStyle(fontSize: 11, color: MyColors.color_C6CAD7),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: mDatas == null ? 0 : mDatas.length,
          itemBuilder: (BuildContext context, int index) {
            return ProjectListView(context, index);
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    request(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget ProjectListView(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: GestureDetector(
        onTap: () {},
        child: GestureDetector(
          onTap: () {
            print('object 点击了');
            NavigatorUtils.gotoProjectCatalog(context, mDatas[index].project);
          },
          child: ListBody(
            mainAxis: Axis.vertical,
            reverse: false,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding:
                    EdgeInsets.only(left: 16, top: 18, right: 16, bottom: 16),
                decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: MyColors.color_0DCCCCCC,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(mDatas[index].project,
                            style: TextStyle(
                                color: MyColors.color_010A29,
                                fontSize: Dimens.font_sp16,
                                fontWeight: FontWeight.w700)),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          height: 22,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.color_DFE6FD),
                          padding:
                              EdgeInsets.only(left: 12, right: 12, top: 3.5),
                          child: Text(
                            '总概念${mDatas[index].total}',
                            style: TextStyle(
                                color: MyColors.color_1246FF, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        alignment: WrapAlignment.start,
                        children: _getProjectGridItem(context, index),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getProjectGridItem(BuildContext context, int index) {
    List<Widget> list = new List();
    for (var value in mDatas[index].conceptLi) {
      list.add(Text(value.conceptName,
          style: TextStyle(
              color: MyColors.color_585D7B, fontSize: Dimens.font_sp12)));
    }
    return list;
  }

  void request(BuildContext context) {
    DioUtils.instance.homeRequest(HttpMethod.POST, HttpApi.projectList,context,
        params: {"project_li": ""}, isList: true, successList: (data) {
      List<ProjectModel> mData = List();
      data.forEach((json) {
        mData.add(ProjectModel.fromJson(json));
      });
      setState(() {
        mDatas = mData;
      });
    });
  }
}
