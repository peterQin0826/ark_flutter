import 'dart:async';

import 'package:ark/common/sp_constant.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/utils/utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Timer cutdownTimer;
  int seconds = 3;

  bool isLogin = !TextUtil.isEmpty(SpUtil.getString(SpConstants.is_Login));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 15),
                    child: FlatButton(
                      color: MyColors.text_gray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('跳过 ${seconds}',style: TextStyle(color: MyColors.white),),
                      onPressed: () {
                        NavigatorUtils.push(context, Routers.main,replace: true,clearStack: true);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Utils.getImgPath('app_icon'),
                  width: 50,
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    Utils.getImgPath('splash_text'),
                    width: 123,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    timecutdown();
    super.initState();
  }

  @override
  void dispose() {
    disposeTime();
    super.dispose();
  }

  void timecutdown() {
    if (cutdownTimer != null) {
      return;
    }
    cutdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      print('计时器开始工作 ${timer.tick}');
      setState(() {
        seconds --;
      });
      if (timer.tick >= 3) {
        disposeTime();
        NavigatorUtils.push(context, Routers.main,replace: true,clearStack: true);
      }
    });
  }

  void disposeTime() {
    cutdownTimer?.cancel();
    cutdownTimer = null;
  }
}
