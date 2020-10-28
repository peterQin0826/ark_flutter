import 'dart:ui';

import 'package:ark/bean/common_permission.dart';
import 'package:ark/res/colors.dart';
import 'package:flutter/material.dart';

class ProPermissionView extends StatefulWidget {
  String userKey;
  String projectName;
  bool isCreate;
  String permission;
  bool isProject;

  ProPermissionView(this.userKey, this.projectName, this.isCreate,
      this.permission, this.isProject);

  @override
  ProPermissionViewState createState() => new ProPermissionViewState();
}

class ProPermissionViewState extends State<ProPermissionView> {
  List<CommonPermission> conceptList = List();
  List<CommonPermission> objectList = List();
  bool _create;

  @override
  Widget build(BuildContext context) {
    //概念权限数据
    CommonPermission _permission1 = CommonPermission();
    _permission1.name = "能够看见概念的存在";
    _permission1.code = "A";
    conceptList.add(_permission1);

    CommonPermission permission2 = new CommonPermission();
    permission2.name = "读取概念下的对象列表";
    permission2.code = "R";
    conceptList.add(permission2);

    CommonPermission permission3 = new CommonPermission();
    permission3.name = "可移动概念位置";
    permission3.code = "C";
    conceptList.add(permission3);

    CommonPermission permission4 = new CommonPermission();
    permission4.name = "可删除概念及概念下所有信息";
    permission4.code = "D";
    conceptList.add(permission4);

    CommonPermission permission5 = new CommonPermission();
    permission5.name = "可在概念中创建新对象";
    permission5.code = "P";
    conceptList.add(permission5);

    CommonPermission permission6 = new CommonPermission();
    permission6.name = "拥有全部概念权限";
    permission6.code = "F";
    conceptList.add(permission6);

    //对象权限数据
    CommonPermission object1 = new CommonPermission();
    object1.name = "可查看对象列表信息";
    object1.code = "Q";
    objectList.add(object1);

    CommonPermission object2 = new CommonPermission();
    object2.name = "可读取对象非系统属性";
    object2.code = "X";
    objectList.add(object2);

    CommonPermission object3 = new CommonPermission();
    object3.name = "可读取对象系统属性";
    object3.code = "Y";
    objectList.add(object3);

    CommonPermission object4 = new CommonPermission();
    object4.name = "可增加对象非系统属性";
    object4.code = "Z";
    objectList.add(object4);

    CommonPermission object5 = new CommonPermission();
    object5.name = "可增加对象系统属性";
    object5.code = "M";
    objectList.add(object5);

    CommonPermission object6 = new CommonPermission();
    object6.name = "可修改对象非系统属性";
    object6.code = "T";
    objectList.add(object6);

    CommonPermission object7 = new CommonPermission();
    object7.name = "可修改对象系统属性";
    object7.code = "H";
    objectList.add(object7);

    CommonPermission object8 = new CommonPermission();
    object8.name = "可删除对象非系统属性";
    object8.code = "E";
    objectList.add(object8);

    CommonPermission object9 = new CommonPermission();
    object9.name = "可删除对象系统属性";
    object9.code = "B";
    objectList.add(object9);

    CommonPermission object10 = new CommonPermission();
    object10.name = "可修改对象关联信息";
    object10.code = "L";
    objectList.add(object10);

    CommonPermission object11 = new CommonPermission();
    object11.name = "可删除对象";
    object11.code = "G";
    objectList.add(object11);

    CommonPermission object12 = new CommonPermission();
    object12.name = "拥有全部对象权限";
    object12.code = "W";
    objectList.add(object12);



    return new Scaffold(
      appBar: new AppBar(
        title: new Text('项目权限设置'),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              child: Row(
                children: <Widget>[
                  Switch(
                    value: _create,
                    activeColor: MyColors.app_main,
                    onChanged: (vale) {
                      setState(() {
                        _create = _create;
                      });
                    },
                  ),
                  Text('可在项目下创建新概念',style: TextStyle(color: MyColors.color_040404,fontSize: 12),)
                ],
              ),
            ),
            Divider(
              height: 1,
              color: MyColors.color_EAEBEF,
            ),
            Row(
              children: <Widget>[
                Text(
                  '概念权限设置',
                  style: TextStyle(
                      color: MyColors.color_040404,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
