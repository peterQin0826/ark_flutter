

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/bean/user_data.dart';
import 'package:ark/model/text_list_model.dart';
import 'package:ark/ui/concept_object_listview.dart';
import 'package:ark/ui/page/add_relation_page.dart';
import 'package:ark/ui/page/create_user_view.dart';
import 'package:ark/ui/page/detail/bftable_edit_view.dart';
import 'package:ark/ui/page/detail/bmtable_edit_view.dart';
import 'package:ark/ui/page/detail/file_item_edit_view.dart';
import 'package:ark/ui/page/detail/file_list_edit_view.dart';
import 'package:ark/ui/page/detail/image_video_edit_view.dart';
import 'package:ark/ui/page/detail/image_video_item_edit.dart';
import 'package:ark/ui/page/detail/object_item_edit_view.dart';
import 'package:ark/ui/page/detail/object_list_edit_view.dart';
import 'package:ark/ui/page/detail/shortPro_edit_view.dart';
import 'package:ark/ui/page/detail/text_list_edit_view.dart';
import 'package:ark/ui/page/detail/text_list_item_edit_view.dart';
import 'package:ark/ui/page/detail/time_list_edit_view.dart';
import 'package:ark/ui/page/existing_users_view.dart';
import 'package:ark/ui/page/file_upload_view.dart';
import 'package:ark/ui/page/object_detail_view.dart';
import 'package:ark/ui/page/relation_editor_view.dart';
import 'package:ark/ui/page/search_result_view.dart';
import 'package:ark/ui/page/search_single_view.dart';
import 'package:ark/ui/page/test_checkboxlisttitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String object_list_view = "object_list_view";
  static const String object_detail = 'object_detail';
  static const String text_list_edit_view = 'text_list_edit_view';
  static const String bf_edit_view = 'bf_edit_view';
  static const String bm_edit_view = 'bm_edit_view';
  static const String text_list_item_edit_view = 'text_list_item_edit_view';
  static const String smart_Search = 'smart_search';
  static const String search_result = 'search_result';
  static const String checkbox = 'checkbox';
  static const String img_video_edit = 'img_video_edit';
  static const String img_video_item_edit = 'img_video_item_edit';
  static const String file_edit_view = 'file_edit_view';
  static const String file_item_edit_view = 'file_item_edit_view';
  static const String file_upload = 'file_upload';
  static const String time_edit = 'time_edit';
  static const String object_edit = 'object_edit';
  static const String object_item_edit_view = 'object_item_edit_view';
  static const String short_pro_edit = 'short_pro_edit';
  static const String relation_edit = 'relation_edit';
  static const String single_add_relation = 'single_add_relation';
  static const String existing_users = 'existing_users';
  static const String create_user = 'create_user';
}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var settingList = settings.arguments as List;
    switch (settings.name) {
      case RouteName.object_list_view:
        var list = settings.arguments as List;
        String code = list[0];
        return CupertinoPageRoute(
            builder: (context) => ConceptObjectListView(code: code));
        break;
      case RouteName.object_detail:
        var list = settings.arguments as List;
        String objKey = list[0];
        return CupertinoPageRoute(
            builder: (context) => ObjectDetailView(
                  objKey: objKey,
                ));
        break;
      case RouteName.bf_edit_view:
        return MaterialPageRoute(
            builder: (context) => BfTableEditView(
                settingList[0], settingList[1], settingList[2]));
        break;
      case RouteName.bm_edit_view:
        return MaterialPageRoute(
            builder: (context) => BmTableEditView(
                  objKey: settingList[0],
                  proName: settingList[1],
                  na: settingList[2],
                ));
        break;
      case RouteName.text_list_edit_view:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        String na = list[2];

        return CupertinoPageRoute(
            builder: (context) => TextListEditView(objKey, proName, na));
        break;
      case RouteName.text_list_item_edit_view:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        Dt dt = list[2];
        String type = list[3];
        return CupertinoPageRoute(
            builder: (context) =>
                TextListItemEditView(objKey, proName, dt, type));
        break;
      case RouteName.smart_Search:
        var list = settings.arguments as List;
        if (list != null) {
          String key = list[0];
          String objkey = list[1];
          String from = list[2];
          return CupertinoPageRoute(
              builder: (context) => SingleSearchView(key, objkey, from));
        } else {
          return CupertinoPageRoute(
              builder: (context) => SingleSearchView(null, null, null));
        }
        break;
      case RouteName.checkbox:
        return CupertinoPageRoute(builder: (context) => CheckboxListTitle());
        break;
      case RouteName.search_result:
        var list = settings.arguments as List;
        String text = list[0];
        String keyName = list[1];
        String objKey = list[2];
        String from = list[3];
        return CupertinoPageRoute(
            builder: (context) =>
                SearchResultView(text, from, objKey, keyName));
        break;
      case RouteName.img_video_edit:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        String na = list[2];
        String type = list[3];
        return CupertinoPageRoute(
            builder: (context) =>
                ImageVideoEditView(objKey, proName, na, type));
        break;
      case RouteName.img_video_item_edit:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        Dt dt = list[2];
        String type = list[3];
        return MaterialPageRoute(
            builder: (context) =>
                ImageVideoItemEditView(objKey, proName, dt, type));
        break;

      case RouteName.file_edit_view:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        String na = list[2];
        return CupertinoPageRoute(
            builder: (context) => FileListEditView(objKey, proName, na));
        break;
      case RouteName.file_item_edit_view:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        Dt dt = list[2];
        return MaterialPageRoute(
            builder: (context) => FileListItemEdit(objKey, proName, dt));
        break;
      case RouteName.file_upload:
        return MaterialPageRoute(builder: (context) => FileUploadView());
        break;
      case RouteName.time_edit:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        String na = list[2];
        return CupertinoPageRoute(
            builder: (context) => TimeListEditView(objKey, proName, na));

        break;
      case RouteName.object_edit:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        String na = list[2];
        return CupertinoPageRoute(
            builder: (context) => ObjectListEditView(objKey, proName, na));
        break;
      case RouteName.object_item_edit_view:
        var list = settings.arguments as List;
        String objKey = list[0];
        String proName = list[1];
        Dt dt = list[2];
        return CupertinoPageRoute(
            builder: (context) => ObjectItemEditView(objKey, proName, dt));
        break;

      /// 短标签编辑页面
      case RouteName.short_pro_edit:
        String objKey = settingList[0];
        return MaterialPageRoute(
            builder: (context) => ShortProEditView(
                  objKey: objKey,
                ));
        break;
      case RouteName.relation_edit:
        String objKey = settingList[0];
        String targetConcepts = settingList[1];
        String type = settingList[2];
        String pageRules = settingList[3];
        return CupertinoPageRoute(
            builder: (context) => RelationEditView(
                  objKey: objKey,
                  target_concepts: targetConcepts,
                  type: type,
                  page_rules: pageRules,
                ));
        break;
      case RouteName.single_add_relation:
        String objName = settingList[0];
        return MaterialPageRoute(
            builder: (context) => AddRelationPage(objName));
        break;
      case RouteName.existing_users:
        return CupertinoPageRoute(builder: (context) => ExistingUsers());
        break;
      case RouteName.create_user:
        UserBean userBean = settingList[0];
        return CupertinoPageRoute(
            builder: (context) => CreateUserView(
                  userBean: userBean,
                ));
        break;
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
