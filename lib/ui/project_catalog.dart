import 'dart:convert';

import 'package:ark/bean/catalog_list_bean.dart';
import 'package:ark/model/catalog_model.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/provider/appinfo_provider.dart';
import 'package:ark/provider_setup.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/utils/theme_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/app_bar.dart';
import 'package:ark/widgets/directory_widget_new.dart';

//import 'package:ark/widgets/directory_widget.dart';
import 'package:ark/widgets/file_widget.dart';
import 'package:ark/widgets/provider_widget.dart';
import 'package:ark/widgets/tree_view.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

class ProjectCatalog extends StatefulWidget {
  String proName;

  ProjectCatalog({this.proName});

  @override
  ProjectCatalogState createState() => new ProjectCatalogState();
}

class ProjectCatalogState extends State<ProjectCatalog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/ic_back_white.png',
                      color: ThemeUtils.getIconColor(context),
                      width: 10,
                      height: 17,
                    ),
                    onTap: () {
                      NavigatorUtils.goBack(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.proName,
                      style: TextStyle(fontSize: 18, color: MyColors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(17)),
                      child: GestureDetector(
                        onTap: () {
                          print('点击了');
                        },
                        child: Container(
                          height: 34,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Image.asset(
                                  Utils.getImgPath('main_search'),
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, right: 15),
                                child: Text(
                                  '输入需要搜索的内容',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: MyColors.color_C6CAD7),
                                ),
                              )
                            ],
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ProviderWidget<CatalogModel>(
          onReady: (model) => model.getCatalog(widget.proName),
          model: CatalogModel(),
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return TreeView(
                startExpanded: true,
                children: _getChildWidget(getTreeDatas(model.catalogs)),
              );
              print('层级目录:${model.catalogs.length}');
            }
          },
        ),
      ),
    );
  }

  List<CatalogListBean> getTreeDatas(List<CatalogListBean> catalogs) {
    List<CatalogListBean> list = List();

    for (var value in catalogs) {
      if (TextUtil.isEmpty(value.parent)) {
        CatalogListBean parent = new CatalogListBean();
        parent.project = value.project;
        parent.code = value.code;
        parent.objectsNumber = value.objectsNumber;
        parent.childrenNumber = value.childrenNumber;
        parent.conceptName = value.conceptName;
        parent.isFile = false;

        List<CatalogListBean> list1 = List();
        if (judgeHasChildren(value.children)) {
          value.children.forEach((elementChild) {
            catalogs.forEach((element) {
              if (elementChild == element.conceptName) {
//                element.isFile = false;
                CatalogListBean parent1 = new CatalogListBean();
                parent1.conceptName = element.conceptName;
                parent1.parent = element.parent;
                parent1.code = element.code;
                parent1.childrenNumber = element.childrenNumber;
                parent1.objectsNumber = element.objectsNumber;
                parent1.isFile = false;
                List<CatalogListBean> list2 = List();

                if (judgeHasChildren(element.children)) {
                  for (var string in element.children) {
                    for (var catalog in catalogs) {
                      if (string == catalog.conceptName) {
                        CatalogListBean parent2 = new CatalogListBean();
                        parent2.conceptName = catalog.conceptName;
                        parent2.parent = catalog.parent;
                        parent2.code = catalog.code;
                        parent2.childrenNumber = catalog.childrenNumber;
                        parent2.objectsNumber = catalog.objectsNumber;
                        parent2.isFile = false;
                        list2.add(parent2);
                        parent1.childrenData = list2;
                      }
                    }
                  }
                } else {
                  parent1.isFile = true;
                }
                list1.add(parent1);
              }
            });
          });
        }
        parent.childrenData = list1;
        list.add(parent);
      }
    }
    return list;
  }

  List<Widget> _getChildWidget(List<CatalogListBean> catalogs) {
    List<Widget> list = List();
    if (catalogs != null && catalogs.length > 0) {
      for (var catalog in catalogs) {
        if (!catalog.isFile) {
          list.add(Container(
            margin: EdgeInsets.only(left: 8),
            child: TreeViewChild(
              startExpanded: true,
              parent: _getDocumentWidget(catalog),
              children: _getChildWidget(catalog.childrenData),
            ),
          ));
        } else {
          list.add(Container(
            margin: const EdgeInsets.only(left: 4.0),
            child: _getDocumentWidget(catalog),
          ));
        }
      }
    }
    return list;
  }

  bool judgeHasChildren(List<String> children) {
    if (children != null && children.length > 0) {
      return true;
    }
    return false;
  }

  Widget _getDocumentWidget(CatalogListBean catalogListBean) =>
      catalogListBean.isFile
          ? _getFileWidget(catalogListBean)
          : _getDirectoryWidget(catalogListBean);

  FileWidget _getFileWidget(CatalogListBean catalogListBean) => FileWidget(
        concept: catalogListBean,
        onPressedNext: () {
          print('文件点击了');
//        NavigatorUtils.gotoObjectListView(context, catalogListBean.code);
          Navigator.pushNamed(context, RouteName.object_list_view,
              arguments: [catalogListBean.code]);
        },
      );

  DirectoryWidget _getDirectoryWidget(CatalogListBean catalogListBean) =>
      DirectoryWidget(
        concept: catalogListBean,
        onPressedNext: () {
          print('文件夹关闭按钮点击');
          NavigatorUtils.gotoObjectListView(context, catalogListBean.code);
        },
      );
}
