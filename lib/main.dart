import 'dart:async';
import 'dart:io';
import 'package:ark/base/nav_key.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/base/application.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/utils/log_utils.dart';
import 'package:ark/views/project_list.dart';
import 'package:ark/views/splash_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  runApp(MyApp());

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  MyApp() {
    Log.init();
    final router = Router();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    String login = SpUtil.getString(SpConstants.is_Login);
    print('未登录 ${login}');
    bool notLogin = TextUtil.isEmpty(login);
    return OKToast(
        child: MaterialApp(
          title: '方舟2.0',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorKey: NavKey.navKey,
          home: notLogin ? SplashPage() : ProjectListPage(),
        ),

        /// Toast 配置
        backgroundColor: Colors.black54,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom);
  }
}
