import 'package:ark/res/colors.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ProjectListPage extends StatefulWidget {
  @override
  ProjectListPageState createState() => new ProjectListPageState();
}

class ProjectListPageState extends State<ProjectListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.keyboard_voice),
        backgroundColor: MyColors.color_1246FF,
        title: Container(
          height: 34,
          decoration: BoxDecoration(
              color: MyColors.material_bg,
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('创建项目j  hh');
            },
            icon: Image.asset(
              Utils.getImgPath('main_filter'),
              width: 18,
              height: 18,
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[

          Container(
            height: 20,
            color: MyColors.color_1246FF,
          ),

          Positioned(
            child: Image.asset(
              Utils.getImgPath('main_background'),
              height: 140,
              fit: BoxFit.fitWidth,
            ),
          )

        ],
      ),
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
}
