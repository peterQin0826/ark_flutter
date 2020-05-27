import 'dart:collection';

import 'package:ark/bean/login_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/utils.dart';
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
        backgroundColor: MyColors.material_bg,
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
                        DioUtils.instance.asyncRequestNetwork<LoginModel>(
                            Method.post, HttpApi.login, params: {
                          "username": userName.text,
                          "password": password.text
                        }, onSuccess: (data) {
                          print('登录请求成功');
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
                                fontSize: 14, color: MyColors.material_bg),
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
      backgroundColor: MyColors.material_bg,
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
