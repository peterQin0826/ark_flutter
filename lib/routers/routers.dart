import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/short_property.dart';
import 'package:ark/routers/router_init.dart';
import 'package:ark/ui/concept_object_listview.dart';
import 'package:ark/ui/login.dart';
import 'package:ark/ui/mian_project.dart';
import 'package:ark/ui/mine.dart';
import 'package:ark/ui/page/concept_detail_view.dart';
import 'package:ark/ui/page/detail/shortPro_edit_view.dart';
import 'package:ark/ui/page/object_detail_view.dart';
import 'package:ark/ui/project_catalog.dart';
import 'package:ark/ui/project_list.dart';
import 'package:ark/ui/splash_page.dart';

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
  static const String project_catalog = "/project_catalog";
  static const String object_list_view = "/object_list_view";
  static const String concept_detail = "/concept_detail";
  static const String object_detail = '/object_detail';
  static const String short_pro_edit = '/short_pro_edit';
  static const String text_list_item = 'text_list_item_edit_view';

  static void configureRoutes(Router router) {
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
        handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return Login();
    }));

    router.define(project_catalog, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String proName = params['proName'].first;
      return ProjectCatalog(proName: proName);
    }));

    router.define(object_list_view, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String code = params['code'].first;
      return ConceptObjectListView(code: code);
    }));

    router.define(concept_detail, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String code = params['code'].first;
      return ConceptDetailView(code: code);
    }));

    router.define(object_detail, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String objKey = params['obj_key'].first;
      return ObjectDetailView(objKey: objKey);
    }));

    router.define(short_pro_edit, handler: Handler(handlerFunc:
        (BuildContext context, Map<String, List<String>> parameters) {
      String objKey = parameters['obj_key'].first;
      return ShortProEditView(objKey: objKey);
    }));

//    router.define(text_list_item, handler: Handler(
//      handlerFunc: (BuildContext context, Map<String, List<String>> parameters){
//        String objKey = parameters['objKey'].first;
//        String proName = parameters['proName'].first;
//        String dtJson=parameters['dt_json'].first;
//        Dt dt = Dt.fromJson(dtJson);
//
//
//
//      }
//    ));
  }
}
