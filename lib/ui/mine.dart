

import 'package:ark/common/sp_constant.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/app_bar.dart';
import 'package:flustars/flustars.dart';

import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  @override
  MineState createState() => new MineState();
}

class MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MyLogin(),
      backgroundColor: MyColors.white,
    );
  }
}

class MyLogin extends StatefulWidget {
  @override
  MyLoginState createState() => new MyLoginState();
}

class MyLoginState extends State<MyLogin> {
  String userName = SpUtil.getString(SpConstants.user_name);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: 20,
            color: MyColors.color_1246FF,
          ),
        ),
        Positioned(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: double.infinity,
            ),
            child: Image.asset(
              Utils.getImgPath('personal_back_view'),
              height: 200,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 130),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  NavigatorUtils.push(context, Routers.login);
                },
                child: ClipRect(
                  child: Image.asset(
                    Utils.getImgPath('logout_avatar'),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                TextUtil.isEmpty(userName) ? '用户名' : userName,
                style: TextStyle(
                    fontSize: 18,
                    color: MyColors.color_090909,
                    fontWeight: FontWeight.w700),
              ),
              _addItem(context, 1, '创建新用户', 'create_user'),
              _addItem(context, 2, '已创建用户', 'user_list'),
              _addItem(context, 3, '待上传文件', 'upload_img'),
              _addItem(context, 4, '已下载文件', 'download'),
              _addItem(context, 5, '退出登录', 'logout'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addItem(BuildContext context, int pos, String name, String imgPath) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: GestureDetector(
        onTap: () {
          switch (pos) {
            case 1:
              print('点击了+${pos}');
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
            case 5:
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
//                      title: Text('提示'),
                      content: Text('您要退出应用吗？'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('取消'),
                        ),
                        FlatButton(
                          onPressed: () {
                            DioUtils.instance
                                .request(HttpMethod.GET, HttpApi.logout,
                                success: (data) {
                                  Navigator.of(context).pop(true);
                                  SpUtil.clear();
                                  NavigatorUtils.push(
                                      context, Routers.login, replace: true,
                                      clearStack: true);
                                }, error: (e) {
                                  LogUtil.e('xioapeng,异常${e.toString()}');
                                });
                          },
                          child: Text('确定'),
                        )
                      ],
                    );
                  });
              break;
          }
        },
        child: Padding(
          padding:
          EdgeInsets.only(left: 15, right: 15, top: pos == 1 ? 30 : 20),
          child: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Image.asset(
                    Utils.getImgPath(imgPath),
                    width: 16,
                    height: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 13,
                            color: MyColors.color_414962,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Image.asset(Utils.getImgPath('fanhui'), width: 6, height: 10)
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Divider(
                  height: 1,
                  color: MyColors.color_F5F5F5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
