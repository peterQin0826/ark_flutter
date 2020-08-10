import 'dart:collection';

import 'package:ark/bean/login_model.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/utils/utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  //定义一个controller
  TextEditingController userName = TextEditingController();

  //定义一个controller
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(''),
        backgroundColor: MyColors.white,
        elevation: 0,
        brightness: Brightness.light, //状态栏颜色设置
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            Image.asset(
              Utils.getImgPath('login_logo'),
              width: 102,
              height: 27,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  hintColor: MyColors.color_CDD1DD,
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.grey),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: userName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: '用户名',
                          prefixIcon: IconButton(
                            icon: Image.asset(
                              Utils.getImgPath('account'),
                              width: 16,
                              height: 16,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: password,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: '输入密码',
                          prefixIcon: IconButton(
                            icon: Image.asset(
                              Utils.getImgPath('lock'),
                              width: 14,
                              height: 16,
                            ),
                          )),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50, left: 35, right: 35),
                    child: GestureDetector(
                      onTap: () {
                        print('打印参数：${userName.text} ==>${password.text}');
                        DioUtils.instance.request(
                            HttpMethod.POST, HttpApi.login, params: {
                          "username": userName.text,
                          "password": password.text
                        }, success: (data) {
                          LoginModel login = LoginModel.fromJson(data);
                          print('请求成功：${"sessionid=" + login.sessionId}');
                          SpUtil.putString(SpConstants.cookie,
                              "sessionid=" + login.sessionId);
                          SpUtil.putString(
                              SpConstants.user_name, login.userName);
                          SpUtil.putString(SpConstants.user_img, login.image);
                          SpUtil.putString(SpConstants.user_key, login.userKey);
                          SpUtil.putBool(SpConstants.is_Login, true);
                          NavigatorUtils.push(context, Routers.main,
                              replace: true, clearStack: true);
                        }, error: (e) {
                          print('请求失败：${e.toString()}');
                        });
                      },
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: MyColors.color_1246FF),
                          child: Text(
                            '登录',
                            style: TextStyle(
                                fontSize: 14, color: MyColors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: MyColors.white,
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
