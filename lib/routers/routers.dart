import 'package:ark/routers/router_init.dart';
import 'package:ark/views/login.dart';
import 'package:ark/views/mian_project.dart';
import 'package:ark/views/mine.dart';
import 'package:ark/views/project_list.dart';
import 'package:ark/views/splash_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '404.dart';

class Routers {
  static String webViewPage = '/webview';
  static String splashPage = '/splash';
  static String project = "/project";
  static String login = "/login";
  static String mine = "/mine";
  static const String main = "/main_project";

  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(FluroRouter router) {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      debugPrint('未找到目标页');
      return WidgetNotFound();
    });

    router.define(splashPage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SplashPage();
    }));

    router.define(project, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ProjectListPage();
    }));

    router.define(mine, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return Mine();
    }));

    router.define(main, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MainProject();
    }));

    router.define(login, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return Login();
    }));
//
//    _listRouter.clear();
//
//    /// 各自路由由各自模块管理，统一在此添加初始化
//    _listRouter.add(WalletRouter());
//
//    /// 初始化路由
//    _listRouter.forEach((routerProvider) {
//      routerProvider.initRouter(router);
//    });
  }
}
