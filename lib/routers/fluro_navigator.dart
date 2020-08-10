import 'package:ark/routers/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../base/application.dart';

class NavigatorUtils {
  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).unfocus();
    Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.native);
  }

  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).unfocus();
    Application.router
        .navigateTo(context, path,
            replace: replace,
            clearStack: clearStack,
            transition: TransitionType.native)
        .then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print('$error');
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }

  /// 跳到WebView页
  static goWebViewPage(BuildContext context, String title, String url) {
    //fluro 不支持传中文,需转换
    push(context,
        '${Routers.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }

  static goProjectList(BuildContext context) {
    push(context, Routers.project, replace: true, clearStack: true);
  }

  static gotoProjectCatalog(BuildContext context, String proName) {
    push(context,
        '${Routers.project_catalog}?proName=${Uri.encodeComponent(proName)}');
  }

  static gotoObjectListView(BuildContext context, String code) {
    push(context,
        '${Routers.object_list_view}?code=${Uri.encodeComponent(code)}');
  }

  static gotoConceptDetail(BuildContext context, String code) {
    push(context,
        '${Routers.concept_detail}?code=${Uri.encodeComponent(code)}');
  }

  static gotoObjectDetail(BuildContext context,String objKey){
    push(context, '${Routers.object_detail}?obj_key=${Uri.encodeComponent(objKey)}');
  }

  static gotoShortProEdit(BuildContext context,String objKey){
    push(context, '${Routers.short_pro_edit}?obj_key=${Uri.decodeComponent(objKey)}');
  }
}
